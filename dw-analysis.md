# Data Warehouse Analysis — Phase 2 

## Business Process
العملية التجارية الأساسية: الطلبات (Orders) — تحليل المبيعات

## Grain Definition
FACT_ORDER_ITEMS: سطر منتج واحد داخل الطلب (Order Item Level)

## Preliminary Dimensions

| Dimension | Source | Note |
|---|---|---|
| DIM_CUSTOMER | olist_customers | تحديد الاستخدام: customer_id أو customer_unique_id |
| DIM_PRODUCT | olist_products + product_category_name_translation | ربط عبر product_category_name |
| DIM_SELLER | olist_sellers | — |
| DIM_DATE | olist_orders.order_purchase_timestamp | التاريخ الأساسي للمبيعات؛ تواريخ التسليم منفصلة لقياس الأداء |
| DIM_PAYMENT | olist_order_payments | ⚠️ يحتاج تجميع على مستوى الطلب قبل الربط لمنع التكرار |
| DIM_REVIEW | olist_order_reviews | يُربط بشكل منفصل ومُتحكم فيه، ليس مباشرة بـ FACT_ORDER_ITEMS |

## Revised Facts (Measures)

| Measure | Source | Grain Level | Note |
|---|---|---|---|
| Price | olist_order_items | Order Item | ✅ صحيح |
| Freight Value | olist_order_items | Order Item | ✅ صحيح |
| ~~Quantity~~ Item Count | مُشتق (عدد السجلات) | Order Item | ❌ لا يوجد عمود Quantity أصلي |
| Payment Value | olist_order_payments | Order/Payment Level | ⚠️ يُعالج بشكل منفصل لمنع التكرار |

## Key Relationships to Verify
- olist_orders ↔ olist_order_items (order_id)
- olist_order_items ↔ olist_products (product_id)
- olist_order_items ↔ olist_sellers (seller_id)
- olist_orders ↔ olist_customers (customer_id)
- olist_order_payments ↔ olist_orders (order_id) — تحقق من التكرار
- olist_products ↔ product_category_name_translation (product_category_name)

## Open Decisions Before Phase 3
1. هل Payment Value هيتحط في FACT_ORDER_ITEMS (بعد التجميع) أو جدول حقائق منفصل؟
2. هل DIM_REVIEW هتتضاف فعلياً في النسخة الأولى، ولا تُأجل؟