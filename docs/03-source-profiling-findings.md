# Source Data Profiling Findings (Phase 3)

## Method

`profiler.py` contains a `DataProfiler` class that profiles each source table on its own, followed by a function that checks relationships between tables.

Checks per table:

- Row and column counts.
- Missing values and their percentage.
- Fully duplicated rows.
- Unique values per column, used to find primary key candidates.
- Descriptive statistics for numeric columns.
- Date columns stored as text.

Relationship checks compare the set of key values in a parent table with the set in a child table, and count the parent keys missing from the child (orphans).

## Table Profiles

| Table | Rows | Duplicate rows | Notable findings |
|---|---|---|---|
| customers | 99,441 | 0 | `customer_id` has 99,441 unique values, `customer_unique_id` only 96,096. |
| geolocation | 1,000,163 | 261,831 (about 26%) | Latitude and longitude contain values outside Brazil. |
| order_items | 112,650 | 0 | 98,666 distinct orders, at most 21 items per order. `shipping_limit_date` is text. |
| order_payments | 103,886 | 0 | `payment_value` and `payment_installments` have a minimum of 0. |
| order_reviews | 99,224 | 0 | 98,410 unique `review_id` and 98,673 unique `order_id`. Comment title is 88.3% empty and comment message 58.7% empty. |
| orders | 99,441 | 0 | Missing `order_approved_at` (160), carrier date (1,783) and customer delivery date (2,965). Dates are text. |
| products | 32,951 | 0 | 610 rows (1.85%) without a category. |
| sellers | 3,095 | 0 | No issues. |
| product_category_name_translation | 71 | 0 | No issues. |

## Relationship Checks

| Relationship | Parent keys | Child keys | Orphans | Explanation |
|---|---|---|---|---|
| orders to order_items | 99,441 | 98,666 | 775 | 603 unavailable, 164 canceled, and 8 in created, invoiced or shipped. |
| orders to order_payments | 99,441 | 99,440 | 1 | One order without a payment record. |
| orders to order_reviews | 99,441 | 98,673 | 768 | Not every order is reviewed. |
| order_items to products | 32,951 | 32,951 | 0 | Clean. |
| order_items to sellers | 3,095 | 3,095 | 0 | Clean. |
| orders to customers | 99,441 | 99,441 | 0 | Clean. |

## Issues and Treatment Decisions

| # | Issue | Decision | Status |
|---|---|---|---|
| 1 | `customer_id` identifies an order, not a person. | `dim_customer` is built on `customer_unique_id`. | Implemented |
| 2 | 610 products without a category. | Category set to `Unknown`. | Implemented |
| 3 | Reviews: more than one per order and repeated review ids. | Keep the latest review per order (by `review_answer_timestamp`) in `stg_order_reviews`. | Implemented (98,673 rows) |
| 4 | 775 orders without items. | Not an error. The fact table is built from `order_items`, so these orders are not loaded. 99% are canceled or unavailable. | Implemented |
| 5 | Date columns stored as text. | Converted to datetime in the ETL for every date that is used. | Implemented |
| 6 | 2,965 orders without a delivery date. | The date stays empty in the fact table. Delivery KPIs use delivered orders with a delivery date only. | Implemented |
| 7 | Geolocation: 26% duplicates and coordinates outside Brazil. | The table is not loaded because no KPI needs it. If it is used later, remove duplicates and keep coordinates inside Brazil (roughly latitude -34 to +5, longitude -74 to -34). | Deferred |
| 8 | Payments with a value of 0 or 0 installments. | The table is not loaded. If it is used later, inspect these rows first (for example, orders fully paid by voucher). | Deferred |
| 9 | 8 orders in created, invoiced or shipped status without items. | Documented as rare edge cases (0.008% of orders). They are not loaded. | Documented |