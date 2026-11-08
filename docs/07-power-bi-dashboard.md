# Power BI Dashboard (Phase 7)

The dashboard connects to `olist_db` in Import mode. It reads the star schema (`fact_order_items`, `dim_customer`, `dim_product`, `dim_seller`, `dim_date`) and the staging table `stg_order_reviews`.

## Data Model

- Four many-to-one relationships, all active and single direction: `fact_order_items` to `dim_customer` (customer_sk), `dim_product` (product_sk), `dim_seller` (seller_sk) and `dim_date` (order_date_sk to date_sk).
- `stg_order_reviews` has no relationship. Reviews are therefore never repeated by joins, and the satisfaction measures are calculated from it alone.

## Measures

| Measure | Definition |
|---|---|
| Total Revenue | Sum of `price`, canceled orders excluded. |
| AOV | Total Revenue divided by distinct orders, canceled orders excluded. |
| Avg Delivery Days | Average days from purchase date to delivery date, for delivered items with a delivery date. |
| Late % | Delivered items arriving after the estimated date, divided by delivered items with a delivery date. |
| Avg Review | Average review score in `stg_order_reviews`. |

## Report Pages

| Page | Content |
|---|---|
| Overview | Five KPI cards, top 10 categories by revenue, review score distribution. |
| Sales Analysis | Top 10 states by revenue, monthly revenue trend. |
| Delivery & Customer Satisfaction | Review counts by score, average delivery days by year and month. |

## Validation Against the SQL Results

| Measure | SQL | Power BI |
|---|---|---|
| Total Revenue | 13,496,408.43 | 13.50M |
| AOV | 137.43 | 137.43 |
| Avg Delivery Days | 12.4 | 12.41 |
| Late % | 7.91% | 7.91% |
| Avg Review | 4.09 | 4.09 |
| Review counts (5, 4, 3, 2, 1 stars) | 57,008 / 19,038 / 8,133 / 3,131 / 11,363 | 57.01K / 19.04K / 8.13K / 3.13K / 11.36K |

The top 10 categories appear in the same order with the same revenue as the SQL query. The delivery average differs only by rounding.

## Reading Notes

- The monthly revenue line has no point for November 2016 and drops sharply in the last month (September 2018). Revenue is very low in the first months, and the delivery-time chart is volatile there, so trends are best read from 2017 to mid 2018.
- The state chart uses `customer_state` from `dim_customer`, which keeps the first address of each customer.
- The review visuals do not respond to the date slicer, because `stg_order_reviews` has no relationship with `dim_date`.

## Files

Screenshots are in `docs/images/`. The `.pbix` file is not committed because it stores a copy of the data.