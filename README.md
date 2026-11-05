# Olist E-Commerce ETL Pipeline and Data Warehouse

**Design and Implementation of an ETL Pipeline for Integrating E-Commerce Data into a Data Warehouse**

Graduation project, University of Gadarif, Faculty of Computer Science and Information Technology, Department of Information Technology.

## Overview

This project extracts the Olist Brazilian E-Commerce public dataset (nine related tables), profiles and cleans it, and loads it into a PostgreSQL data warehouse designed as a Kimball star schema. Five business KPIs are then calculated with SQL and checked against the business rules.

## Technology Stack

| Layer | Tools |
|---|---|
| Extraction and transformation | Python, Pandas |
| Loading | SQLAlchemy, psycopg2 |
| Data warehouse | PostgreSQL (database `olist_db`) |
| Analysis | SQL |
| Visualization (Phase 7) | Power BI |

## Architecture

CSV files → source profiling → Python ETL (extract, clean, transform) → PostgreSQL star schema → SQL KPIs → Power BI

- **Fact table:** `fact_order_items` (one row per order item)
- **Dimensions:** `dim_customer`, `dim_product`, `dim_seller`, `dim_date`
- **Staging:** `stg_order_reviews` (deduplicated reviews, kept outside the star schema to avoid inflating measures)

## Results (Phases 1 to 6)

| Table | Rows loaded |
|---|---|
| dim_date | 799 |
| dim_customer | 96,096 |
| dim_product | 32,951 |
| dim_seller | 3,095 |
| fact_order_items | 112,650 |
| stg_order_reviews | 98,673 |

| KPI | Result |
|---|---|
| Total Revenue (excluding canceled orders) | 13,496,408.43 |
| Average Order Value | 137.43 |
| Top category by revenue | health_beauty (1,255,695.13) |
| Average delivery time | 12.4 days |
| Late deliveries | 7.91% |
| Average review score | 4.09 / 5 |

## Project Roadmap

- [x] Phase 1: Business Requirements
- [x] Phase 2: Initial Data Warehouse Analysis
- [x] Phase 3: Source Data Profiling and Validation
- [x] Phase 4: Data Warehouse Schema Design
- [x] Phase 5: ETL Pipeline Implementation
- [x] Phase 6: Data Validation and KPI Analysis
- [ ] Phase 7: Analytical Reports (Power BI)

## Repository Structure

| Path | Description |
|---|---|
| `profiler.py` | Data profiling for the nine source tables and their relationships |
| `etl_pipeline.py` | ETL script that loads the star schema and the staging table |
| `sql/` | Schema creation script and KPI queries |
| `docs/` | Documentation for each phase |

## How to Run

1. Install Python 3 and PostgreSQL, then run `pip install pandas sqlalchemy psycopg2-binary`.
2. Download the Olist dataset from Kaggle and place the nine CSV files in a `data/` folder next to the scripts. The data is not stored in this repository.
3. Create a database named `olist_db` and run `sql/01_create_schema.sql`.
4. Set your PostgreSQL password in `DB_CONFIG` inside `etl_pipeline.py`. Never commit a real password.
5. Run `python profiler.py` for the profiling report, then `python etl_pipeline.py` to load the warehouse.
6. Run the queries in `sql/02_kpi_queries.sql` to reproduce the KPI results.

## Team

- Al-Fatih Bashir Abdalla Mohammed
- Abdullah Hamza Haroun Abdalla
- Ali Ahmed Babiker Al-Khazina
- Mohammed Khalid Al-Tayeb Othman
- Musab Babiker Abdalla Idris

Supervisor: Reem Nabulsi