# Business Requirements — Olist ELT Data Warehouse Project

## Phase 1: Business Requirements Definition

### Key Performance Indicators (KPIs)

| KPI | Description |
|---|---|
| Total Revenue | إجمالي الإيرادات من جميع الطلبات |
| Average Order Value (AOV) | متوسط قيمة الطلب الواحد |
| Product Performance | أداء المنتجات من حيث المبيعات والإيرادات |
| Delivery Efficiency | كفاءة التوصيل ونسبة التأخير |
| Customer Satisfaction | رضا العملاء بناءً على تقييماتهم (Reviews) |

### Source Dataset: Olist Brazilian E-Commerce

| Table | Description |
|---|---|
| olist_customers | بيانات العملاء (المدينة، الولاية) |
| olist_orders | بيانات الطلبات (الحالة، التواريخ) |
| olist_order_items | عناصر كل طلب (المنتج، السعر، البائع) |
| olist_products | بيانات المنتجات (الفئة، الأبعاد) |
| olist_sellers | بيانات البائعين |
| olist_order_payments | طرق الدفع والأقساط |
| olist_order_reviews | تقييمات العملاء |
| olist_geolocation | بيانات جغرافية |
| product_category_name_translation | ترجمة فئات المنتجات |

## Week 1 Tasks

1. تحديد مؤشرات الأداء الرئيسية (KPIs) المذكورة أعلاه
2. دراسة وتحليل جداول مجموعة بيانات Olist التسعة
3. فهم العلاقات بين الجداول (ER Diagram مبدئي)
4. تحديد احتياجات مستودع البيانات بناءً على كل KPI
5. توثيق متطلبات التحليل في هذا المستند