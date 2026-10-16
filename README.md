Ecommerce Data Pipeline — Olist Data Warehouse

Project Overview

This project aims to build an ELT Data Warehouse using the Olist Brazilian E-Commerce dataset.

The project follows Kimball methodology and a Star Schema design to support sales analysis, product performance reporting, delivery efficiency analysis, and customer satisfaction measurement.

Business Objectives

The planned Data Warehouse will support the following KPIs:

- Total Revenue.
- Average Order Value (AOV).
- Product Performance.
- Delivery Efficiency.
- Customer Satisfaction.

Dataset

The project uses nine source tables from the Olist dataset, covering orders, order items, customers, products, sellers, payments, reviews, geolocation, and product category translations.

Technology Stack

- Database: PostgreSQL
- Programming Language: Python
- Data Processing: Pandas and NumPy
- Query Language: SQL
- Visualization: Power BI (optional extension)

Methodology

The project follows the Kimball Bottom-Up approach.

The proposed analytical model uses a Star Schema with one central fact table:

- "FACT_ORDER_ITEMS"

Supporting dimensions are planned for customers, products, sellers, dates, and orders.

Documentation

Document| Description
"business-requirements.md"| Business objectives, KPIs, source tables, and project scope.
"dw-analysis.md"| Source data analysis, proposed fact and dimension tables, relationships, and data quality considerations.

Project Roadmap

- [✔️] Phase 1: Business Requirements.
- [✔️] Phase 2: Initial Data Warehouse Analysis.
- [ ] Phase 3: Source Data Profiling and Validation.
- [ ] Phase 4: Finalize the Data Warehouse Schema.
- [ ] Phase 5: Develop the ELT Pipeline.
- [ ] Phase 6: Validate Data and KPI Calculations.
- [ ] Phase 7: Develop Analytical Reports.

The checkmarks indicate documentation milestones only. Pipeline development and subsequent implementation phases remain planned until completed and validated.

Team

- عبدالله حمزة
- الفاتح بشير
- علي أحمد بابكر
- محمد خالد الطيب
- مصعب بابكر

Supervisor

Miss Reem