# Data Warehouse Analysis — Phase 2

## Business Process
العملية التجارية الأساسية: الطلبات (Orders)

## Grain Definition
مستوى التفصيل: سطر منتج واحد داخل الطلب (Order Item Level)
السبب: لازم لحساب KPI "أداء المنتجات" بدقة

## Preliminary Dimensions

| Dimension | Source Table | Serves KPI |
|---|---|---|
| DIM_CUSTOMER | olist_customers | AOV, Geographic Distribution |
| DIM_PRODUCT | olist_products | Product Performance |
| DIM_SELLER | olist_sellers | Delivery Efficiency |
| DIM_DATE | olist_orders (dates) | Time Trends, Delivery Efficiency |
| DIM_PAYMENT | olist_order_payments | Payment Analysis |
| DIM_REVIEW | olist_order_reviews | Customer Satisfaction |

## Preliminary Facts (Measures)

- Price
- Freight Value
- Quantity
- Payment Value

## Source-to-Target Mapping (Preliminary)

| Target | Source Table(s) |
|---|---|
| FACT_ORDER_ITEMS | olist_order_items + olist_orders |
| DIM_CUSTOMER | olist_customers |
| DIM_PRODUCT | olist_products + product_category_name_translation |
| DIM_SELLER | olist_sellers |
| DIM_DATE | olist_orders |
| DIM_PAYMENT | olist_order_payments |
| DIM_REVIEW | olist_order_reviews |