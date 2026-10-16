Data Warehouse Analysis — Olist Dataset

1. Source Tables

The analysis covers the following nine Olist source tables:

- "olist_orders"
- "olist_order_items"
- "olist_customers"
- "olist_products"
- "olist_sellers"
- "olist_order_payments"
- "olist_order_reviews"
- "olist_geolocation"
- "product_category_name_translation"

2. Fact Table

FACT_ORDER_ITEMS

Grain: One record per order item, identified by "order_id" and "order_item_id".

Measures:

- "price"
- "freight_value"
- "item_count"

The fact table supports sales, product performance, and shipping analysis.

3. Dimension Tables

- DIM_CUSTOMER: Customer information and location.
- DIM_PRODUCT: Product attributes and translated category names.
- DIM_SELLER: Seller information and location.
- DIM_DATE: Relevant order and delivery dates.
- DIM_ORDER: Order status and relevant order attributes.

Payment methods and customer reviews will be analyzed from their source tables without introducing additional fact tables.

4. Relationship Analysis

The fact table connects order items with customers, products, sellers, and relevant order dates.

Payment and review tables require careful analysis before joining because an order may contain multiple payment records or reviews. Direct joins may duplicate order-item records and inflate measures.

Order-level KPIs, including Average Order Value and delivery efficiency, must be calculated at the appropriate grain. Customer satisfaction must be calculated without duplicating review records.

5. Data Quality Considerations

- Check missing values and duplicate keys.
- Validate relationships between source tables.
- Investigate multiple payments and reviews per order.
- Validate order statuses and date consistency.
- Check missing product attributes and category translations.
- Reconcile sales calculations with eligible source records.

6. Conclusion

The proposed Data Warehouse uses one central fact table, "FACT_ORDER_ITEMS", supported by customer, product, seller, date, and order dimensions.

The design follows the Kimball Star Schema approach and supports the five defined business KPIs: Total Revenue, Average Order Value, Product Performance, Delivery Efficiency, and Customer Satisfaction, while minimizing duplication and incorrect aggregations.