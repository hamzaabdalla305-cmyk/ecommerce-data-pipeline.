# Business Requirements (Phase 1)

## Project Overview

The objective of this project is to design and implement an ETL pipeline that integrates the Olist Brazilian E-Commerce data into a PostgreSQL data warehouse. The warehouse follows the Kimball methodology and a star schema design, and supports business analysis and KPI reporting.

## Business Objectives

- Analyze sales performance and revenue.
- Measure the average order value.
- Identify high-performing products and categories.
- Evaluate delivery efficiency and delays.
- Analyze customer satisfaction using review scores.

## Pipeline Objectives

- Extract data from the nine Olist source tables using Python and Pandas.
- Clean, transform, standardize, integrate, and validate the data according to documented data quality rules.
- Load the processed data into a PostgreSQL star schema.
- Keep the pipeline repeatable: running it again must not duplicate or corrupt data.

## Key Performance Indicators

| KPI | Description | Purpose |
|---|---|---|
| Total Revenue | Sum of item prices for eligible orders. Shipping charges are reported separately. | Monitor sales performance. |
| Average Order Value (AOV) | Total product sales value divided by the number of distinct eligible orders. | Measure average spending per order. |
| Product Performance | Item quantities and sales value by product category. | Identify top-performing categories. |
| Delivery Efficiency | Average delivery time and the percentage of delivered orders arriving after the estimated delivery date. | Evaluate logistics performance. |
| Customer Satisfaction | Average review score and review score distribution. | Understand customer experience. |

## KPI Calculation Rules

- Revenue and AOV exclude canceled orders.
- AOV is calculated on distinct eligible orders, not on individual order items.
- Product performance is analyzed at the product category level.
- Delivery efficiency uses delivered orders with a valid delivery date. Delivery time is measured from the purchase date to the actual delivery date.
- Customer satisfaction uses one review per order. Reviews must not be multiplied by joins.
- Missing or invalid dates are handled explicitly during data preparation.
- The treatment of canceled, unavailable, and other ineligible records is documented in the profiling findings (`03-source-profiling-findings.md`).

## Source Dataset

| Source Table | Description |
|---|---|
| `olist_customers` | Customer identifiers and location information. |
| `olist_orders` | Order status and order-related timestamps. |
| `olist_order_items` | Products, sellers, prices, and freight charges for each order item. |
| `olist_products` | Product attributes and category identifiers. |
| `olist_sellers` | Seller identifiers and location information. |
| `olist_order_payments` | Payment methods, installments, and payment values. |
| `olist_order_reviews` | Customer review scores and review information. |
| `olist_geolocation` | Geographic coordinates associated with Brazilian zip code prefixes. |
| `product_category_name_translation` | English translations of product category names. |

## Data Warehouse Requirements

- Use one central fact table at the order-item level.
- Support product, customer, seller, and date analysis.
- Provide the data required to calculate the five KPIs.
- Preserve valid relationships between entities using foreign keys.
- Prevent duplicate records and inflated measures caused by one-to-many joins.
- Support reliable and reproducible analytical reporting.

## Project Scope

**In scope**

- Source data profiling and data quality assessment.
- Fact and dimension design.
- ETL pipeline development (Python and Pandas to PostgreSQL).
- KPI queries and validation.
- Power BI dashboard (Phase 7).

**Profiled but not loaded**

- `olist_order_payments` and `olist_geolocation` are profiled, but not loaded into the warehouse, because none of the five KPIs requires them.