# Data Warehouse Schema Design (Phase 4)

The warehouse follows the Kimball methodology and is implemented in PostgreSQL (database `olist_db`). The full script is in `sql/01_create_schema.sql`.

## Star Schema

```
                 dim_customer
                      |
 dim_product --- fact_order_items --- dim_date
                      |
                 dim_seller
```

## Tables

**fact_order_items** (grain: one row per order item)

| Column | Type | Role |
|---|---|---|
| order_item_sk | SERIAL | Surrogate key |
| order_id | VARCHAR(50) | Degenerate dimension |
| order_item_id | INT | Degenerate dimension |
| order_status | VARCHAR(20) | Degenerate dimension |
| customer_sk | INT | Foreign key to dim_customer |
| product_sk | INT | Foreign key to dim_product |
| seller_sk | INT | Foreign key to dim_seller |
| order_date_sk | INT | Foreign key to dim_date (purchase date) |
| price | NUMERIC(10,2) | Measure |
| freight_value | NUMERIC(10,2) | Measure |
| order_delivered_customer_date | TIMESTAMP | Actual delivery date |
| order_estimated_delivery_date | TIMESTAMP | Estimated delivery date |

**dim_customer:** `customer_sk`, `customer_unique_id` (business key, unique), `customer_city`, `customer_state`, `customer_zip_code_prefix`.

**dim_product:** `product_sk`, `product_id` (business key, unique), `product_category_name_english`, `product_weight_g`, `product_length_cm`, `product_height_cm`, `product_width_cm`.

**dim_seller:** `seller_sk`, `seller_id` (business key, unique), `seller_city`, `seller_state`.

**dim_date:** `date_sk` (YYYYMMDD), `full_date`, `year`, `month`, `day`, `month_name`, `day_of_week`, `quarter`, `is_weekend`. It is generated, not loaded from a source table, and covers every day from the earliest purchase date to the latest estimated delivery date (2016-09-04 to 2018-11-12, 799 days).

**stg_order_reviews** (staging, outside the star): `review_id`, `order_id`, `review_score`, `review_creation_date`, `review_answer_timestamp`.

## Design Decisions

| Decision | Reason |
|---|---|
| `dim_customer` is keyed on `customer_unique_id`. | `customer_id` is generated per order. Using it would count one person several times. If a customer appears with different addresses, the first one in the source file is kept. |
| `order_status` is stored in the fact table. | Excluding canceled orders needs no extra join. This is a degenerate dimension, a standard Kimball pattern. |
| Delivery dates are stored in the fact table. | The delivery KPIs compare two dates on the same row. |
| Surrogate keys on all dimensions. | Facts are independent of source identifiers. |
| Foreign keys on the fact table. | The database rejects fact rows that point to a missing customer, product, seller or date. |
| `stg_order_reviews` has no foreign key to the fact. | Reviews are one per order, while the fact has one row per item. Joining them would repeat each review once per item and distort the satisfaction KPI. |
| Payments and geolocation are not loaded. | No KPI requires them. |

## Load Order

Dimensions first, fact table last, because the fact table reads the surrogate keys from the dimensions. Each load step empties its own table first (`TRUNCATE ... CASCADE`), so the pipeline can be re-run safely.