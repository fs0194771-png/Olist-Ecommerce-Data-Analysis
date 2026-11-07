-- ============================================================
-- OLIST E-COMMERCE SQL PROJECT
-- Database: Olist_Ecommerce
--
-- Project Goals:
-- 1. Data Cleaning
-- 2. Data Validation
-- 3. Exploratory Data Analysis (EDA)
-- 4. Business Analysis
-- 5. Generate Business Insights & Recommendations
--
-- Tools:
-- SQL Server
-- Power BI
-- GitHub
-- ============================================================


USE Olist_Ecommerce;
GO


-- ============================================================
-- 1. INITIAL DATA EXPLORATION
-- ============================================================

-- The first step is to understand the size of each table
-- before performing any cleaning or transformations.
--
-- This query returns the number of records in each table
-- and provides an initial overview of the Olist database.

SELECT 'olist_customers' AS table_name, COUNT(*) AS row_count
FROM olist_customers

UNION ALL

SELECT 'olist_orders', COUNT(*)
FROM olist_orders

UNION ALL

SELECT 'olist_order_items', COUNT(*)
FROM olist_order_items

UNION ALL

SELECT 'olist_products', COUNT(*)
FROM olist_products

UNION ALL

SELECT 'olist_sellers', COUNT(*)
FROM olist_sellers

UNION ALL

SELECT 'olist_order_payments', COUNT(*)
FROM olist_order_payments

UNION ALL

SELECT 'olist_order_reviews', COUNT(*)
FROM olist_order_reviews

UNION ALL

SELECT 'olist_geolocation', COUNT(*)
FROM olist_geolocation

UNION ALL

SELECT 'product_category_translation', COUNT(*)
FROM product_category_name_translation;


-- ============================================================
-- 2. CREATE STAGING TABLES
-- ============================================================

-- Create staging copies of all raw tables.
-- The original raw data will remain unchanged.
-- All cleaning operations will be performed on the staging tables.


-- ------------------------------------------------------------
-- 2.1 Customers
-- ------------------------------------------------------------

SELECT *
INTO olist_customers_staging
FROM olist_customers;


-- ------------------------------------------------------------
-- 2.2 Orders
-- ------------------------------------------------------------

SELECT *
INTO olist_orders_staging
FROM olist_orders;


-- ------------------------------------------------------------
-- 2.3 Order Items
-- ------------------------------------------------------------

SELECT *
INTO olist_order_items_staging
FROM olist_order_items;


-- ------------------------------------------------------------
-- 2.4 Products
-- ------------------------------------------------------------

SELECT *
INTO olist_products_staging
FROM olist_products;


-- ------------------------------------------------------------
-- 2.5 Sellers
-- ------------------------------------------------------------

SELECT *
INTO olist_sellers_staging
FROM olist_sellers;


-- ------------------------------------------------------------
-- 2.6 Order Payments
-- ------------------------------------------------------------

SELECT *
INTO olist_order_payments_staging
FROM olist_order_payments;


-- ------------------------------------------------------------
-- 2.7 Order Reviews
-- ------------------------------------------------------------

SELECT *
INTO olist_order_reviews_staging
FROM olist_order_reviews;


-- ------------------------------------------------------------
-- 2.8 Geolocation
-- ------------------------------------------------------------

SELECT *
INTO olist_geolocation_staging
FROM olist_geolocation;


-- ------------------------------------------------------------
-- 2.9 Product Category Translation
-- ------------------------------------------------------------

SELECT *
INTO product_category_name_translation_staging
FROM product_category_name_translation;


-- ============================================================
-- 2.10 VERIFY STAGING TABLES
-- ============================================================

-- Compare the row counts between the raw and staging tables.
-- The row counts should be identical at this stage.

SELECT 'olist_customers' AS table_name,
       (SELECT COUNT(*) FROM olist_customers) AS raw_rows,
       (SELECT COUNT(*) FROM olist_customers_staging) AS staging_rows

UNION ALL

SELECT 'olist_orders',
       (SELECT COUNT(*) FROM olist_orders),
       (SELECT COUNT(*) FROM olist_orders_staging)

UNION ALL

SELECT 'olist_order_items',
       (SELECT COUNT(*) FROM olist_order_items),
       (SELECT COUNT(*) FROM olist_order_items_staging)

UNION ALL

SELECT 'olist_products',
       (SELECT COUNT(*) FROM olist_products),
       (SELECT COUNT(*) FROM olist_products_staging)

UNION ALL

SELECT 'olist_sellers',
       (SELECT COUNT(*) FROM olist_sellers),
       (SELECT COUNT(*) FROM olist_sellers_staging)

UNION ALL

SELECT 'olist_order_payments',
       (SELECT COUNT(*) FROM olist_order_payments),
       (SELECT COUNT(*) FROM olist_order_payments_staging)

UNION ALL

SELECT 'olist_order_reviews',
       (SELECT COUNT(*) FROM olist_order_reviews),
       (SELECT COUNT(*) FROM olist_order_reviews_staging)

UNION ALL

SELECT 'olist_geolocation',
       (SELECT COUNT(*) FROM olist_geolocation),
       (SELECT COUNT(*) FROM olist_geolocation_staging)

UNION ALL

SELECT 'product_category_translation',
       (SELECT COUNT(*) FROM product_category_name_translation),
       (SELECT COUNT(*) FROM product_category_name_translation_staging);


-- ============================================================
-- 3. DATA CLEANING
-- ============================================================

-- The data cleaning process includes:
-- 1. Removing duplicate records
-- 2. Standardizing data
-- 3. Handling NULL values
-- 4. Removing unnecessary or invalid data


-- ============================================================
-- 3.1 REMOVE DUPLICATES
-- ============================================================

-- Duplicate records can lead to incorrect analysis and
-- double-counting.
-- We will first identify duplicates before deleting anything.


-- ------------------------------------------------------------
-- 3.1.1 Customers - Check for Duplicates
-- ------------------------------------------------------------

-- customer_id should uniquely identify each customer record.
-- Check whether any customer_id appears more than once.

SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM olist_customers_staging
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- No duplicate customer_id values were found.
-- No records were removed from the customers staging table.


-- ------------------------------------------------------------
-- 3.1.2 Orders - Check for Duplicates
-- ------------------------------------------------------------

-- order_id should uniquely identify each order.
-- Check whether any order_id appears more than once.

SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM olist_orders_staging
GROUP BY order_id
HAVING COUNT(*) > 1;

-- No duplicate order_id values were found.
-- No records were removed from the orders staging table.


-- ------------------------------------------------------------
-- 3.1.3 Order Items - Check for Duplicates
-- ------------------------------------------------------------

-- An order can contain multiple items, so order_id alone
-- should not be treated as a unique key.
-- The combination of order_id and order_item_id should
-- uniquely identify each order item.

SELECT
    order_id,
    order_item_id,
    COUNT(*) AS duplicate_count
FROM olist_order_items_staging
GROUP BY
    order_id,
    order_item_id
HAVING COUNT(*) > 1;

-- No duplicate combinations of order_id and order_item_id
-- were found.
-- No records were removed from the order items staging table.

-- ------------------------------------------------------------
-- 3.1.4 Products - Check for Duplicates
-- ------------------------------------------------------------

-- product_id should uniquely identify each product.
-- Check whether any product_id appears more than once.

SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM olist_products_staging
GROUP BY product_id
HAVING COUNT(*) > 1;

-- No duplicate product_id values were found.
-- No records were removed from the products staging table.


-- ------------------------------------------------------------
-- 3.1.5 Sellers - Check for Duplicates
-- ------------------------------------------------------------

-- seller_id should uniquely identify each seller.
-- Check whether any seller_id appears more than once.

SELECT
    seller_id,
    COUNT(*) AS duplicate_count
FROM olist_sellers_staging
GROUP BY seller_id
HAVING COUNT(*) > 1;

-- No duplicate seller_id values were found.
-- No records were removed from the sellers staging table.


-- ------------------------------------------------------------
-- 3.1.6 Order Payments - Check for Duplicates
-- ------------------------------------------------------------

-- An order can have multiple payment records.
-- Therefore, order_id alone should not be treated as a unique key.
-- The combination of order_id and payment_sequential should
-- uniquely identify each payment record.

SELECT
    order_id,
    payment_sequential,
    COUNT(*) AS duplicate_count
FROM olist_order_payments_staging
GROUP BY
    order_id,
    payment_sequential
HAVING COUNT(*) > 1;

-- No duplicate combinations of order_id and payment_sequential
-- were found.
-- No records were removed from the order payments staging table.

-- ------------------------------------------------------------
-- 3.1.7 Order Reviews - Check for Duplicates
-- ------------------------------------------------------------

-- review_id can be associated with multiple orders in this dataset.
-- Therefore, review_id alone is not considered a unique key.
-- We use the combination of review_id and order_id to identify
-- true duplicate review-order records.

SELECT
    review_id,
    order_id,
    COUNT(*) AS duplicate_count
FROM olist_order_reviews_staging
GROUP BY
    review_id,
    order_id
HAVING COUNT(*) > 1;

-- No duplicate combinations of review_id and order_id were found.
-- Therefore, no records were removed from the order reviews table.
--- ------------------------------------------------------------
-- 3.1.8 Geolocation - Check for Duplicates
-- ------------------------------------------------------------

-- A zip code prefix can appear multiple times because it may
-- represent multiple geographic points.
-- Therefore, geolocation_zip_code_prefix alone is not treated
-- as a unique key.
--
-- We will check whether the complete geographic record
-- is duplicated.

SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state,
    COUNT(*) AS duplicate_count
FROM olist_geolocation_staging
GROUP BY
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- If duplicate geographic records are found, we will investigate
-- them before deciding whether they should be removed.
-- ------------------------------------------------------------
-- Remove Exact Duplicate Geolocation Records
-- ------------------------------------------------------------

-- The geolocation table contains exact duplicate records.
-- These records have identical values across all columns.
-- We will keep one copy of each unique geographic record.

SELECT DISTINCT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
INTO olist_geolocation_clean
FROM olist_geolocation_staging;


-- Check the number of records after removing exact duplicates.

SELECT COUNT(*) AS clean_row_count
FROM olist_geolocation_clean;

-- ------------------------------------------------------------
-- Validate Geolocation Cleaning
-- ------------------------------------------------------------

-- Compare the original staging table with the cleaned table.

SELECT
    (SELECT COUNT(*) FROM olist_geolocation_staging) AS original_rows,
    (SELECT COUNT(*) FROM olist_geolocation_clean) AS clean_rows,
    (SELECT COUNT(*) FROM olist_geolocation_staging)
    - (SELECT COUNT(*) FROM olist_geolocation_clean) AS duplicates_removed;

-- ------------------------------------------------------------
-- 3.1.9 Product Category Translation - Check for Duplicates
-- ------------------------------------------------------------

-- column1 represents the original Portuguese category name,
-- while column2 represents the English category name.
-- Check whether the original category appears more than once.

SELECT
    column1,
    COUNT(*) AS duplicate_count
FROM product_category_name_translation_staging
GROUP BY column1
HAVING COUNT(*) > 1;

-- No duplicate category names should exist in the translation table.

-- ============================================================
-- 3.2 STANDARDIZE DATA
-- ============================================================

-- Standardization aims to identify inconsistent values,
-- extra spaces, and formatting differences in the data.
--
-- We will inspect the values first before making any changes.


-- ------------------------------------------------------------
-- 3.2.1 Customers - Check Text Values
-- ------------------------------------------------------------

-- Check the distinct customer states.
-- This helps us identify inconsistent values or unexpected formats.

SELECT DISTINCT
    customer_state
FROM olist_customers_staging
ORDER BY customer_state;


-- Check the distinct customer cities.
-- This helps us identify possible formatting inconsistencies.

SELECT DISTINCT
    customer_city
FROM olist_customers_staging
ORDER BY customer_city;
-- ------------------------------------------------------------
-- 3.2.1 Customers - Check City Formatting Variations
-- ------------------------------------------------------------

SELECT
    LOWER(LTRIM(RTRIM(customer_city))) AS normalized_city,
    COUNT(DISTINCT customer_city) AS different_versions
FROM olist_customers_staging
GROUP BY
    LOWER(LTRIM(RTRIM(customer_city)))
HAVING COUNT(DISTINCT customer_city) > 1
ORDER BY
    different_versions DESC,
    normalized_city;
    -- No formatting variations were found in customer_city.
-- After normalizing case and trimming leading/trailing spaces,
-- no city was found with multiple distinct representations.
-- Therefore, no cleaning or standardization was required.

-- ------------------------------------------------------------
-- 3.2.2 Customers - Check NULL Values
-- ------------------------------------------------------------

-- ------------------------------------------------------------
-- 3.2.2 Customers - Check NULL Values
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN customer_unique_id IS NULL THEN 1 ELSE 0 END) AS null_customer_unique_id,
    SUM(CASE WHEN customer_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS null_zip_code,
    SUM(CASE WHEN customer_city IS NULL THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN customer_state IS NULL THEN 1 ELSE 0 END) AS null_state
FROM olist_customers_staging;
-- ------------------------------------------------------------
-- 3.2.3 Customers - Check ID Formatting
-- ------------------------------------------------------------

-- Check for leading or trailing spaces in customer_id.

SELECT
    COUNT(*) AS rows_with_id_spaces
FROM olist_customers_staging
WHERE customer_id <> LTRIM(RTRIM(customer_id));


-- Check for leading or trailing spaces in customer_unique_id.

SELECT
    COUNT(*) AS rows_with_unique_id_spaces
FROM olist_customers_staging
WHERE customer_unique_id <> LTRIM(RTRIM(customer_unique_id));
-- No leading or trailing spaces were found in customer_id
-- or customer_unique_id.
-- Therefore, no ID standardization was required.
-- ------------------------------------------------------------
-- 3.2.4 Customers - Check State Formatting
-- ------------------------------------------------------------

-- Customer state codes should contain exactly 2 uppercase characters.
-- This query checks for unexpected state formats.

SELECT DISTINCT
    customer_state
FROM olist_customers_staging
WHERE customer_state <> UPPER(customer_state)
   OR LEN(customer_state) <> 2
ORDER BY customer_state;
-- ------------------------------------------------------------
-- 3.2.5 Customers - Check ZIP Code Formatting
-- ------------------------------------------------------------

-- Customer ZIP code prefixes should contain valid values.
-- Check for values outside the expected 5-digit range.

SELECT DISTINCT
    customer_zip_code_prefix
FROM olist_customers_staging
WHERE customer_zip_code_prefix IS NOT NULL
  AND (
        customer_zip_code_prefix < 0
        OR customer_zip_code_prefix > 99999
      )
ORDER BY customer_zip_code_prefix;


-- ============================================================
-- 3.2.2 Orders - Check NULL Values
-- ============================================================

-- Check the number of NULL values in important columns.
-- This helps us understand which fields contain missing data
-- before deciding whether any cleaning is required.

SELECT
    COUNT(*) AS total_row,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS null_order_status,
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS null_order_purchase_timestamp,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS null_order_delivered_carrier_date,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS null_delivered_customer_date,
    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS null_order_approved_at,
    SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) AS null_estimated_delivery_date
FROM olist_orders_staging;


-- ============================================================
-- 3.2.3 Orders - Check Order Status Values
-- ============================================================

-- Check the different order status values in the dataset.
-- This helps identify unexpected or inconsistent status values.

SELECT DISTINCT
    order_status
FROM olist_orders_staging;


-- Check the timestamps of orders with an "unavailable" status.
-- This helps us understand whether the NULL delivery dates
-- are expected for this type of order.

SELECT DISTINCT
    order_status,
    order_purchase_timestamp,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_approved_at,
    order_estimated_delivery_date
FROM olist_orders_staging
WHERE order_status = 'unavailable';


-- ============================================================
-- 3.2.4 Orders - Analyze NULL Values by Order Status
-- ============================================================

-- Compare NULL values across different order statuses.
-- This helps determine whether missing dates are expected
-- depending on the current status of the order.

SELECT
    COUNT(*) AS total_row,
    order_status,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END)
        AS null_order_delivered_carrier_date,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END)
        AS null_delivered_customer_date,
    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END)
        AS null_order_approved_at
FROM olist_orders_staging
GROUP BY order_status;


-- ============================================================
-- 3.2.5 Orders - Validate Delivered Orders
-- ============================================================

-- Delivered orders are expected to have approval,
-- carrier delivery, and customer delivery timestamps.
-- Check whether any delivered orders are missing these values.

SELECT *
FROM olist_orders_staging
WHERE order_status = 'delivered'
  AND (
      order_approved_at IS NULL
      OR order_delivered_carrier_date IS NULL
      OR order_delivered_customer_date IS NULL
  );


-- ============================================================
-- 3.2.6 Orders - Check Delivery Date Consistency
-- ============================================================

-- The customer delivery date should not be earlier than
-- the carrier delivery date.
-- Check for inconsistent delivery timestamps.

SELECT *
FROM olist_orders_staging
WHERE order_delivered_carrier_date >
      order_delivered_customer_date;


-- 23 orders have inconsistent delivery timestamps,
-- where the customer delivery date is earlier than
-- the carrier delivery date.
-- The records were kept unchanged because the correct
-- timestamp cannot be determined from the available data.


-- ============================================================
-- 3.2.7 Orders - Check Approval Date Consistency
-- ============================================================

-- The approval date should not be earlier than
-- the purchase date.
-- Check for invalid approval timestamps.

SELECT
    order_id,
    order_purchase_timestamp,
    order_approved_at
FROM olist_orders_staging
WHERE order_approved_at < order_purchase_timestamp;


-- No inconsistent approval timestamps were found.


-- ============================================================
-- 3.2.8 Orders - Check Carrier Date Consistency
-- ============================================================

-- The carrier delivery date should not be earlier than
-- the approval date.
-- Check for inconsistent carrier timestamps.

SELECT
    order_id,
    order_approved_at,
    order_delivered_carrier_date
FROM olist_orders_staging
WHERE order_delivered_carrier_date < order_approved_at;


-- Inconsistent carrier timestamps were found.
-- A sample of 20 records is displayed below for investigation.


-- Display a sample of the inconsistent records
-- instead of reviewing all records.

SELECT TOP 20
    order_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date
FROM olist_orders_staging
WHERE order_delivered_carrier_date < order_approved_at
ORDER BY order_approved_at;


-- These inconsistent timestamps will be kept unchanged
-- because the correct values cannot be determined
-- from the available data.


-- ============================================================
-- 3.2.3 Order Items - Check NULL Values
-- ============================================================

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_null,
    SUM(CASE WHEN order_item_id IS NULL THEN 1 ELSE 0 END) AS order_item_id_null,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id_null,
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS seller_id_null,
    SUM(CASE WHEN shipping_limit_date IS NULL THEN 1 ELSE 0 END) AS shipping_limit_date_null,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS price_null,
    SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) AS freight_value_null
FROM olist_order_items_staging;

-- No NULL values were found in the Order Items table.
-- All columns contain complete data and require no NULL handling.


-- ============================================================
-- 3.2.4 Order Items - Check Negative Values
-- ============================================================

SELECT 
    price,
    freight_value
FROM olist_order_items_staging
WHERE price < 0
   OR freight_value < 0;

-- No negative values were found in price or freight_value.
-- Both columns contain valid non-negative financial values.
-- ============================================================
-- 3.2.5 Products - Check NULL Values
-- ============================================================

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN product_description_lenght IS NULL THEN 1 ELSE 0 END) AS product_description_lenght_null,
    SUM(CASE WHEN product_name_lenght IS NULL THEN 1 ELSE 0 END) AS product_name_lenght_null,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id_null,
    SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END) AS product_photos_qty_null,
    SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END) AS product_weight_g_null,
    SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END) AS product_length_cm_null,
    SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END) AS product_height_cm_null,
    SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END) AS product_width_cm_null,
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS product_category_name_null
FROM olist_products_staging;

-- NULL values were found in several product attributes.
-- Most NULLs (610 rows) are related to product descriptive information,
-- while only 2 rows have missing physical product dimensions and weight.


-- ============================================================
-- 3.2.6 Products - Inspect Missing Physical Attributes
-- ============================================================

SELECT *
FROM olist_products_staging
WHERE product_weight_g IS NULL
   OR product_length_cm IS NULL
   OR product_width_cm IS NULL
   OR product_height_cm IS NULL;

-- Only 2 products have missing physical attributes.
-- The records were kept unchanged because the missing values
-- cannot be reliably determined from the available data.
-- ============================================================
-- 3.2.7 Products - Check Negative Values
-- ============================================================

SELECT
    product_id,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM olist_products_staging
WHERE product_weight_g < 0
   OR product_length_cm < 0
   OR product_height_cm < 0
   OR product_width_cm < 0;

-- No negative values were found in product weight or dimensions.
-- All available physical measurements contain valid non-negative values.

-- ============================================================
-- 3.2.8 Sellers - Check NULL Values
-- ============================================================

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS seller_id_null,
    SUM(CASE WHEN seller_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS seller_zip_code_prefix_null,
    SUM(CASE WHEN seller_city IS NULL THEN 1 ELSE 0 END) AS seller_city_null,
    SUM(CASE WHEN seller_state IS NULL THEN 1 ELSE 0 END) AS seller_state_null
FROM olist_sellers_staging;

-- No NULL values were found in the Sellers table.
-- All seller records contain complete information.


-- ============================================================
-- 3.2.9 Sellers - Check Invalid ZIP Code Values
-- ============================================================

SELECT 
    seller_zip_code_prefix
FROM olist_sellers_staging
WHERE seller_zip_code_prefix < 0;

-- No negative ZIP code values were found.
-- All seller ZIP code prefixes contain valid non-negative values.

-- ============================================================
-- 3.2.10 Order Payments - Check NULL Values
-- ============================================================

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_null,
    SUM(CASE WHEN payment_sequential IS NULL THEN 1 ELSE 0 END) AS payment_sequential_null,
    SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) AS payment_type_null,
    SUM(CASE WHEN payment_installments IS NULL THEN 1 ELSE 0 END) AS payment_installments_null,
    SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END) AS payment_value_null
FROM olist_order_payments_staging;

-- No NULL values were found in the Order Payments table.
-- All payment records contain complete information.

-- ============================================================
-- 3.2.11 Order Payments - Check Invalid Values
-- ============================================================

SELECT
    order_id,
    payment_value,
    payment_installments
FROM olist_order_payments_staging
WHERE payment_value < 0
   OR payment_installments < 1;

-- Two payment records have an invalid payment_installments value of 0.
-- The records were kept unchanged because the correct value cannot be determined.

-- ============================================================
-- 3.2.12 Order Reviews - Check NULL Values
-- ============================================================

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN review_id IS NULL THEN 1 ELSE 0 END) AS review_id_null,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_null,
    SUM(CASE WHEN review_score IS NULL THEN 1 ELSE 0 END) AS review_score_null,
    SUM(CASE WHEN review_comment_title IS NULL THEN 1 ELSE 0 END) AS review_comment_title_null,
    SUM(CASE WHEN review_comment_message IS NULL THEN 1 ELSE 0 END) AS review_comment_message_null,
    SUM(CASE WHEN review_creation_date IS NULL THEN 1 ELSE 0 END) AS review_creation_date_null,
    SUM(CASE WHEN review_answer_timestamp IS NULL THEN 1 ELSE 0 END) AS review_answer_timestamp_null
FROM olist_order_reviews_staging;

-- NULL values were found only in optional review comment fields.
-- Missing review comments are considered valid and require no cleaning.
-- ============================================================
-- 3.2.13 Order Reviews - Check Invalid Review Scores
-- ============================================================

SELECT 
    review_id,
    review_score
FROM olist_order_reviews_staging
WHERE review_score < 1
   OR review_score > 5;

-- No invalid review scores were found.
-- All review scores are within the valid range of 1 to 5.
-- ============================================================
-- 3.2.14 Geolocation - Check NULL Values
-- ============================================================

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN geolocation_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS zip_code_null,
    SUM(CASE WHEN geolocation_lat IS NULL THEN 1 ELSE 0 END) AS latitude_null,
    SUM(CASE WHEN geolocation_lng IS NULL THEN 1 ELSE 0 END) AS longitude_null,
    SUM(CASE WHEN geolocation_city IS NULL THEN 1 ELSE 0 END) AS city_null,
    SUM(CASE WHEN geolocation_state IS NULL THEN 1 ELSE 0 END) AS state_null
FROM olist_geolocation_clean;
-- Missing values were found in latitude and longitude.
-- These records were kept unchanged because the missing coordinates
-- cannot be reliably determined from the available data.
-- ============================================================
-- 3.2.15 Geolocation - Check Invalid Coordinates
-- ============================================================

SELECT 
    geolocation_lat,
    geolocation_lng
FROM olist_geolocation_clean
WHERE geolocation_lat NOT BETWEEN -90 AND 90
   OR geolocation_lng NOT BETWEEN -180 AND 180;

-- No invalid latitude or longitude values were found.
-- All geographic coordinates are within valid ranges.
-- ============================================================
-- 3.2.16 Product Category Translation - Check NULL Values
-- ============================================================

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN column1 IS NULL THEN 1 ELSE 0 END) AS category_name_null,
    SUM(CASE WHEN column2 IS NULL THEN 1 ELSE 0 END) AS category_name_english_null
FROM product_category_name_translation_staging;

-- No NULL values were found in the Product Category Translation table.
-- All category mappings contain complete information.
-- ============================================================
-- 3.2.17 Product Category Translation - Check Empty Values
-- ============================================================

SELECT *
FROM product_category_name_translation_staging
WHERE LTRIM(RTRIM(column1)) = ''
   OR LTRIM(RTRIM(column2)) = '';

-- No empty category values were found.
-- All category mappings contain valid text values.