Business Requirements — Olist ELT Data Warehouse

1. Project Overview

The objective of this project is to design an ELT Data Warehouse using the Olist Brazilian E-Commerce dataset. The warehouse will support business analysis and reporting using the Kimball methodology and a Star Schema design.

2. Business Objectives

The project aims to:

- Analyze sales performance and revenue.
- Measure Average Order Value (AOV).
- Identify high-performing products.
- Evaluate delivery efficiency and delays.
- Analyze customer satisfaction using review scores.

3. Key Performance Indicators (KPIs)

KPI| Description| Business Purpose
Total Revenue| Total product sales value, calculated as the sum of item prices for eligible orders. Shipping charges are reported separately.| Monitor sales performance.
Average Order Value (AOV)| Total product sales value divided by the number of eligible distinct orders.| Measure average spending per order.
Product Performance| Product-level sales, item quantities, and sales value.| Identify top-performing products and categories.
Delivery Efficiency| Delivery time and the percentage of delivered orders arriving after the estimated delivery date.| Evaluate logistics performance.
Customer Satisfaction| Average review score and review score distribution.| Understand customer experience.

KPI Calculation Rules

- Revenue and AOV will exclude canceled orders.
- AOV will be calculated using distinct eligible orders, not individual order items.
- Product performance will be analyzed at the product and order-item levels.
- Delivery efficiency will be calculated using valid delivery timestamps for delivered orders.
- Customer satisfaction will be calculated from valid review records at the review or order level, without multiplying reviews through joins.
- Missing or invalid dates will be handled explicitly during data preparation.

The exact treatment of unavailable, canceled, or otherwise ineligible records will be documented during data profiling.

4. Source Dataset

The project uses the following Olist source tables:

Source Table| Description
"olist_customers"| Customer identifiers and location information.
"olist_orders"| Order status and order-related timestamps.
"olist_order_items"| Products, sellers, prices, and freight charges for each order item.
"olist_products"| Product attributes and category identifiers.
"olist_sellers"| Seller identifiers and location information.
"olist_order_payments"| Payment methods, installments, and payment values.
"olist_order_reviews"| Customer review scores and review information.
"olist_geolocation"| Geographic coordinates associated with Brazilian locations.
"product_category_name_translation"| English translations of product category names.

5. Data Warehouse Requirements

The Data Warehouse should:

- Use one central fact table at the order-item level.
- Support product, customer, seller, order, and date analysis.
- Provide the data required to calculate the defined KPIs.
- Preserve valid relationships between source entities.
- Prevent duplicate records and inflated measures caused by one-to-many joins.
- Support reliable and reproducible analytical reporting.

6. Project Scope

In Scope

- Source data analysis and profiling.
- Data quality assessment.
- Fact and dimension design.
- ELT pipeline development.
- Analytical queries and KPI validation.

Planned Extension

- Power BI dashboards for business reporting.

7. Initial Project Tasks

- Review the nine source tables.
- Understand the relationships between source entities.
- Validate the business definitions of the KPIs.
- Define the fact table grain and proposed dimensions.
- Identify data quality issues and potential join duplication.
- Document the proposed Data Warehouse design before implementation.