Data Warehouse Analysis — Olist Dataset

1. Source Tables

The analysis is based on the following Olist tables:

- "olist_orders"
- "olist_order_items"
- "olist_customers"
- "olist_products"
- "olist_sellers"
- "olist_order_payments"
- "olist_order_reviews"

2. Fact Table

FACT_ORDER_ITEMS

Grain: One record per order item ("order_id" + "order_item_id").

Measures:

- "price"
- "freight_value"
- Item count

3. Dimension Tables

- DIM_CUSTOMER: Customer information and location.
- DIM_PRODUCT: Product attributes and category.
- DIM_SELLER: Seller information and location.
- DIM_DATE: Order-related dates.
- DIM_ORDER: Order status and relevant order attributes.
- DIM_PAYMENT_TYPE: Payment method, if required.

4. Relationship Analysis

The fact table connects order items with customers, products, sellers, and relevant order dates.

Payment and review tables require careful analysis before joining, because an order may contain multiple payment records or reviews. Direct joins may duplicate order-item records and inflate measures.

5. Data Quality Considerations

- Check missing values and duplicate keys.
- Validate relationships between source tables.
- Investigate multiple payments and reviews per order.
- Check date consistency and missing product attributes.

6. Conclusion

The proposed Data Warehouse uses one central fact table, "FACT_ORDER_ITEMS", supported by dimensions for customers, products, sellers, dates, and orders.

The model focuses on product-level sales analysis while avoiding duplicate records caused by one-to-many relationships.