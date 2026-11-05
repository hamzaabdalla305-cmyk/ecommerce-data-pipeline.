# KPI Analysis and Validation (Phase 6)

The queries are in `sql/02_kpi_queries.sql`. They were run in pgAdmin on `olist_db` after the ETL load, and each result was checked against the rules in `01-business-requirements.md`.

## Results

| KPI | Result |
|---|---|
| Total Revenue (canceled orders excluded) | 13,496,408.43 |
| Average Order Value | 137.43 |
| Top category by revenue | health_beauty |
| Average delivery time | 12.4 days |
| Late deliveries | 7.91% |
| Average review score | 4.09 out of 5 |

## 1. Total Revenue

The sum of `price` over all order items whose status is not `canceled`. Freight is excluded, as the business rules require.

## 2. Average Order Value

Total revenue divided by `COUNT(DISTINCT order_id)`. Dividing by the number of rows would divide by items instead of orders and give a lower, wrong value.

## 3. Product Performance (top 10 categories)

| Category | Items sold | Revenue |
|---|---|---|
| health_beauty | 9,634 | 1,255,695.13 |
| watches_gifts | 5,970 | 1,198,185.21 |
| bed_bath_table | 11,097 | 1,035,964.06 |
| sports_leisure | 8,590 | 979,740.92 |
| computers_accessories | 7,781 | 904,322.02 |
| furniture_decor | 8,298 | 727,465.05 |
| housewares | 6,915 | 626,825.80 |
| cool_stuff | 3,780 | 620,835.39 |
| auto | 4,205 | 586,620.73 |
| garden_tools | 4,328 | 481,009.94 |

- `watches_gifts` sold about half as many items as `bed_bath_table` but earned more revenue, so its average item price is much higher.
- The `Unknown` category, created for products without a category, is not among the top 10.

## 4. Delivery Efficiency

Calculated over order items of orders with status `delivered` and a delivery date. Delivery time is the number of days from the purchase date to the actual delivery date.

- Average delivery time: 12.4 days.
- Items arriving after the estimated delivery date: 7.91%.

## 5. Customer Satisfaction

Calculated on `stg_order_reviews`, which holds one review per order.

| Score | Reviews | Share |
|---|---|---|
| 5 | 57,008 | 57.77% |
| 4 | 19,038 | 19.29% |
| 3 | 8,133 | 8.24% |
| 2 | 3,131 | 3.17% |
| 1 | 11,363 | 11.52% |

- 77.06% of the reviews are 4 or 5.
- Customers who are unhappy tend to give the lowest score: 1 star is much more common than 2 stars.
- The query was run on the staging table directly and not through the fact table, so reviews are not repeated by joins.

## Validation Checks

- The score distribution adds up to 98,673, the number of rows in `stg_order_reviews`.
- `fact_order_items` has 112,650 rows, the same as the source `order_items`.
- The average review score is consistent with the value seen when profiling the source table (4.09).
- AOV uses distinct orders, as the business rules require.

## Limitations

- The delivery KPIs count order items, so an order with several items is counted once per item. An optional order-level version of the query is in the SQL file.
- Revenue excludes canceled orders only, as the business rule states. Orders in other statuses that have items (for example shipped) are included.

## Next Step

Phase 7 presents these KPIs in a Power BI dashboard connected to `olist_db`. The Power BI numbers must match the results above.