# Data Warehouse Analysis (Phase 2)

This document records the initial design, made before profiling the data, and the changes that followed once the real data was examined.

## Source Tables

The analysis covers the nine Olist source tables: orders, order_items, customers, products, sellers, order_payments, order_reviews, geolocation, and product_category_name_translation.

## Initial Design (before profiling)

**Fact table:** `FACT_ORDER_ITEMS`

- Grain: one record per order item, identified by `order_id` and `order_item_id`.
- Measures: `price`, `freight_value`, and an item count.

**Dimensions**

| Dimension | Content |
|---|---|
| DIM_CUSTOMER | Customer information and location. |
| DIM_PRODUCT | Product attributes and translated category names. |
| DIM_SELLER | Seller information and location. |
| DIM_DATE | Relevant order and delivery dates. |
| DIM_ORDER | Order status and relevant order attributes. |

Payments and reviews were to be analyzed from their source tables without additional fact tables.

## Relationship Analysis

The fact table connects order items with customers, products, sellers, and dates. Payments and reviews are at the order level, and one order may have several payment records or reviews. Joining them directly to the order-item fact would duplicate rows and inflate measures.

## Data Quality Considerations (to be verified by profiling)

- Missing values and duplicate keys.
- Relationships between source tables.
- Multiple payments and reviews per order.
- Order status and date consistency.
- Missing product attributes and category translations.
- Reconciliation of sales calculations with eligible records.

## Changes After Profiling and Implementation

| Initial design | Final design | Reason |
|---|---|---|
| Customer key not specified | `DIM_CUSTOMER` is keyed on `customer_unique_id` | `customer_id` is generated per order (99,441 values), while there are only 96,096 real customers. |
| Separate `DIM_ORDER` | `order_status` is stored in the fact table as a degenerate dimension | Excluding canceled orders needs no extra join. |
| Item count as a measure | Count of rows | Each fact row is exactly one order item. |
| Delivery dates in `DIM_DATE` | `order_date_sk` links to `dim_date`; actual and estimated delivery dates are stored in the fact table | Delivery KPIs compare two dates on the same row. |
| Reviews analyzed from the source table | Deduplicated staging table `stg_order_reviews` | The source has 99,224 reviews for 98,673 orders. |
| Payments analyzed from the source table | Not loaded | No KPI requires payment data. |

The profiling evidence for each change is in `03-source-profiling-findings.md`, and the final schema is in `04-schema-design.md`.