USE Olist_Ecommerce;
GO

-- ============================================================
-- 4.5 Validate Relationships Between Tables
-- ============================================================

-- ============================================================
-- 4.5.1 Orders → Customers
-- ============================================================

SELECT *
FROM olist_orders_staging Os
LEFT JOIN olist_customers_staging Cs
    ON Os.customer_id = Cs.customer_id
WHERE Cs.customer_id IS NULL;

-- No unmatched customer_id values were found.
-- All orders are associated with existing customers.


-- ============================================================
-- 4.5.2 Order Items → Orders
-- ============================================================

SELECT *
FROM olist_order_items_staging Oi
LEFT JOIN olist_orders_staging Os
    ON Oi.order_id = Os.order_id
WHERE Os.order_id IS NULL;

-- No unmatched order_id values were found.
-- All order items are associated with existing orders.


-- ============================================================
-- 4.5.3 Order Items → Products
-- ============================================================

SELECT *
FROM olist_order_items_staging Oi
LEFT JOIN olist_products_staging Op
    ON Oi.product_id = Op.product_id
WHERE Op.product_id IS NULL;

-- No unmatched product_id values were found.
-- All order items are associated with existing products.


-- ============================================================
-- 4.5.4 Order Items → Sellers
-- ============================================================

SELECT *
FROM olist_order_items_staging Oi
LEFT JOIN olist_sellers_staging S
    ON Oi.seller_id = S.seller_id
WHERE S.seller_id IS NULL;

-- No unmatched seller_id values were found.
-- All order items are associated with existing sellers.


-- ============================================================
-- 4.5.5 Order Payments → Orders
-- ============================================================

SELECT *
FROM olist_order_payments_staging P
LEFT JOIN olist_orders_staging O
    ON P.order_id = O.order_id
WHERE O.order_id IS NULL;

-- No unmatched order_id values were found.
-- All payment records are associated with existing orders.


-- ============================================================
-- 4.6 Order Reviews → Orders
-- ============================================================

SELECT *
FROM olist_order_reviews_staging R
LEFT JOIN olist_orders_staging O
    ON R.order_id = O.order_id
WHERE O.order_id IS NULL;

-- No unmatched order_id values were found.
-- All reviews are associated with existing orders.


-- ============================================================
-- 4.7 Orders → Order Items
-- Check Orders Without Order Items
-- ============================================================

SELECT O.order_id
FROM olist_orders_staging O
LEFT JOIN olist_order_items_staging OI
    ON O.order_id = OI.order_id
WHERE OI.order_id IS NULL;


-- Check the status of orders without order items

SELECT 
    O.order_status,
    COUNT(*) AS orders_without_items
FROM olist_orders_staging O
LEFT JOIN olist_order_items_staging OI
    ON O.order_id = OI.order_id
WHERE OI.order_id IS NULL
GROUP BY O.order_status
ORDER BY orders_without_items DESC;

-- Orders without order items were mainly associated with
-- unavailable and canceled orders.
-- These records were kept unchanged because the absence of
-- order items is consistent with their order status.


-- ============================================================
-- 4.8 Orders → Payments
-- Check Orders Without Payment Records
-- ============================================================

SELECT O.order_id
FROM olist_orders_staging O
LEFT JOIN olist_order_payments_staging P
    ON O.order_id = P.order_id
WHERE P.order_id IS NULL;


-- Check the status of orders without payment records

SELECT 
    O.order_id,
    O.order_status
FROM olist_orders_staging O
LEFT JOIN olist_order_payments_staging P
    ON O.order_id = P.order_id
WHERE P.order_id IS NULL;

-- One delivered order was found without a payment record.
-- The record was kept unchanged because the missing payment
-- information cannot be reliably determined from the available data.


-- ============================================================
-- End of Data Validation
-- ============================================================