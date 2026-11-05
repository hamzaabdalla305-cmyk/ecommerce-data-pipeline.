# ETL Pipeline Implementation (Phase 5)

`etl_pipeline.py` reads the CSV files with Pandas, transforms them in memory, and loads them into PostgreSQL with SQLAlchemy. The transformations run in Python before loading, which makes this an ETL design.

## Execution Order

| Step | Function | Source | Transformation | Rows loaded |
|---|---|---|---|---|
| 1 | `load_dim_date` | `olist_orders` (dates only) | One row per day, starting at the earliest purchase date. Year, month, day, month name, weekday name, quarter and weekend flag are derived. | 799 |
| 2 | `load_dim_customer` | `olist_customers` | Keep four columns and drop duplicates on `customer_unique_id`. | 96,096 |
| 3 | `load_dim_product` | `olist_products`, translation table | Left join on the category name. A missing English category becomes `Unknown`. | 32,951 |
| 4 | `load_dim_seller` | `olist_sellers` | Select the needed columns. | 3,095 |
| 5 | `load_fact_order_items` | order_items, orders, customers, and the dimensions in the database | See below. | 112,650 |
| 6 | `load_stg_order_reviews` | `olist_order_reviews` | Convert dates and keep the latest review per order. | 98,673 |

Dimensions load first and the fact table after them, because the fact table reads the surrogate keys from the dimensions.

## Fact Table Construction

1. Build `order_date_sk` (YYYYMMDD) from the purchase timestamp and convert the delivered and estimated dates to datetime.
2. Join `order_items` with `orders` on `order_id` to get the status, the date key, the `customer_id` and the delivery dates.
3. Join with `customers` on `customer_id` to get `customer_unique_id`.
4. Read the surrogate keys of `dim_customer`, `dim_product` and `dim_seller` from the database.
5. Join on the business keys to attach `customer_sk`, `product_sk` and `seller_sk`.
6. Select the final columns and load.

All joins are inner joins, so a row without a match would be dropped. The fact table has exactly the 112,650 rows of the source `order_items`, so no row was lost.

## Repeatability

Each load function starts with `TRUNCATE TABLE ... CASCADE`, so the script can be run again without duplicate key errors. CASCADE also empties tables that reference the truncated one, so emptying any dimension also empties the fact table. For this reason, always run the whole script and never a single load function.

## Configuration

Connection settings are in `DB_CONFIG` at the top of the script. The repository contains a placeholder password. Put the real one locally and never commit it. The script expects a `data/` folder next to it with the nine CSV files.

## Row Count Validation

| Check | Expected | Loaded |
|---|---|---|
| `dim_customer` vs distinct `customer_unique_id` in the source | 96,096 | 96,096 |
| `dim_product` vs rows in `olist_products` | 32,951 | 32,951 |
| `dim_seller` vs rows in `olist_sellers` | 3,095 | 3,095 |
| `fact_order_items` vs rows in `olist_order_items` | 112,650 | 112,650 |
| `stg_order_reviews` vs distinct `order_id` in `olist_order_reviews` | 98,673 | 98,673 |