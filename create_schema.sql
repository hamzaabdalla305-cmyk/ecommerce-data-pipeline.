-- Olist data warehouse: star schema and staging table
-- Run once in the database olist_db, before etl_pipeline.py

CREATE TABLE IF NOT EXISTS dim_date (
    date_sk INT PRIMARY KEY,
    full_date DATE,
    year INT,
    month INT,
    day INT,
    month_name VARCHAR(20),
    day_of_week VARCHAR(20),
    quarter INT,
    is_weekend BOOLEAN
);

CREATE TABLE IF NOT EXISTS dim_customer (
    customer_sk SERIAL PRIMARY KEY,
    customer_unique_id VARCHAR(50) UNIQUE NOT NULL,
    customer_city VARCHAR(100),
    customer_state VARCHAR(5),
    customer_zip_code_prefix INT
);

CREATE TABLE IF NOT EXISTS dim_product (
    product_sk SERIAL PRIMARY KEY,
    product_id VARCHAR(50) UNIQUE NOT NULL,
    product_category_name_english VARCHAR(100),
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

CREATE TABLE IF NOT EXISTS dim_seller (
    seller_sk SERIAL PRIMARY KEY,
    seller_id VARCHAR(50) UNIQUE NOT NULL,
    seller_city VARCHAR(100),
    seller_state VARCHAR(5)
);

CREATE TABLE IF NOT EXISTS fact_order_items (
    order_item_sk SERIAL PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    order_item_id INT NOT NULL,
    order_status VARCHAR(20),
    customer_sk INT REFERENCES dim_customer(customer_sk),
    product_sk INT REFERENCES dim_product(product_sk),
    seller_sk INT REFERENCES dim_seller(seller_sk),
    order_date_sk INT REFERENCES dim_date(date_sk),
    price NUMERIC(10,2),
    freight_value NUMERIC(10,2),
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE IF NOT EXISTS stg_order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);