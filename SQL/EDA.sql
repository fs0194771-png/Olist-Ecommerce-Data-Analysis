USE Olist_Ecommerce;
GO

-- ============================================================
-- 3. Exploratory Data Analysis (EDA)
-- ============================================================


-- ============================================================
-- 3.1 Overall Sales Performance
-- ============================================================
-- Business Question:
-- What is the overall sales performance of the business?

SELECT 
    COUNT(DISTINCT order_id) AS Total_Orders,
    ROUND(SUM(price), 2) AS Total_Product_Sales,
    ROUND(SUM(freight_value), 2) AS Total_Freight,
    ROUND(SUM(price + freight_value), 2) AS Total_Order_Value
FROM olist_order_items_staging;

-- Result:
-- Total Orders       = 98,666
-- Total Product Sales = 13,591,643.70
-- Total Freight       = 2,251,909.54
-- Total Order Value   = 15,843,553.24

-- Insight:
-- The dataset contains 98,666 unique orders.
-- Total product sales reached approximately 13.59M,
-- while freight contributed approximately 2.25M,
-- resulting in a total order value of approximately 15.84M.

-- Note:
-- COUNT(DISTINCT order_id) is used because olist_order_items
-- contains one row per item, so the same order_id can appear
-- multiple times for orders containing multiple products.


-- ============================================================
-- 3.2 Sales Trend Over Time
-- ============================================================
-- Business Question:
-- How did the total order value change over the years?

SELECT 
    YEAR(os.order_purchase_timestamp) AS Year,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS Total_Order_Value
FROM olist_orders_staging os
JOIN olist_order_items_staging oi 
    ON os.order_id = oi.order_id
GROUP BY YEAR(os.order_purchase_timestamp)
ORDER BY Year DESC;

-- Result:
-- 2018 = 8,643,697.60
-- 2017 = 7,142,672.43
-- 2016 =    57,183.21

-- Insight:
-- Total order value increased strongly from 2017 to 2018.
-- 2018 recorded the highest total order value at approximately 8.64M.
-- 2016 had very low order value because it represents the early
-- period of the dataset and contains significantly fewer orders.

-- Note:
-- YEAR() is used here to extract the year from the original
-- purchase timestamp for analysis.
-- The original timestamp is kept unchanged in the source data
-- because extracting the year is an analytical transformation,
-- not a data-cleaning operation.


-- ============================================================
-- 3.3 Product Category Analysis
-- ============================================================
-- Business Question:
-- Which product categories generate the most product sales?

SELECT 
    op.product_category_name,
    ROUND(SUM(oi.price), 2) AS Total_Product_Sales
FROM olist_order_items_staging oi
JOIN olist_products_staging op
    ON op.product_id = oi.product_id
GROUP BY op.product_category_name
ORDER BY Total_Product_Sales DESC;

-- Top 10 Categories:
-- 1. beleza_saude          = 1,258,681.34
-- 2. relogios_presentes    = 1,205,005.68
-- 3. cama_mesa_banho       = 1,036,988.68
-- 4. esporte_lazer         =   988,048.97
-- 5. informatica_acessorios=   911,954.32
-- 6. moveis_decoracao      =   729,762.49
-- 7. cool_stuff            =   635,290.85
-- 8. utilidades_domesticas =   632,248.66
-- 9. automotivo            =   592,720.11
-- 10. ferramentas_jardim   =   485,256.46

-- Insight:
-- beleza_saude generated the highest product sales,
-- followed by relogios_presentes and cama_mesa_banho.
-- The top 5 categories each generated more than 900K in product sales.

-- Note:
-- Product sales are calculated using the product price only.
-- Freight is excluded because it represents shipping charges,
-- not product sales.


-- ============================================================
-- 3.4 Seller Analysis
-- ============================================================
-- Business Question:
-- Which sellers generate the highest product sales?

SELECT TOP 10
    os.seller_id,
    ROUND(SUM(oi.price), 2) AS Total_Product_Sales
FROM olist_order_items_staging oi
JOIN olist_sellers_staging os 
    ON oi.seller_id = os.seller_id
GROUP BY os.seller_id
ORDER BY Total_Product_Sales DESC;

-- Result:
-- The top seller generated approximately 229.47K in product sales.
-- The second highest seller generated approximately 222.78K.
-- The top 10 sellers generated between approximately 135K and 229K.

-- Insight:
-- Sales are distributed across multiple sellers,
-- with the top seller generating approximately 229K in product sales.
-- The difference between the top sellers is relatively moderate,
-- suggesting that sales are not dominated by a single seller.

-- ============================================================
-- 3.5 Customer Analysis
-- ============================================================
-- Business Question:
-- Which states have the largest number of customers?

SELECT 
    customer_state,
    COUNT(*) AS Total_Customers
FROM olist_customers_staging
GROUP BY customer_state
ORDER BY Total_Customers DESC;

-- Result:
-- SP = 41,746
-- RJ = 12,852
-- MG = 11,635
-- RS = 5,466
-- PR = 5,045

-- Insight:
-- São Paulo (SP) has the largest customer base with 41,746 customers,
-- followed by Rio de Janeiro (RJ) and Minas Gerais (MG).
-- Customers are highly concentrated in a few states.


-- ============================================================
-- 3.5.1 Customer Drill-Down: São Paulo
-- ============================================================
-- Business Question:
-- Which cities in São Paulo have the most customers?

SELECT 
    customer_city,
    COUNT(*) AS Num_Of_Customers
FROM olist_customers_staging
WHERE customer_state = 'SP'
GROUP BY customer_city
ORDER BY Num_Of_Customers DESC;

-- Result:
-- São Paulo = 15,540
-- Campinas = 1,444
-- Guarulhos = 1,189
-- São Bernardo do Campo = 938
-- Santo André = 796

-- Insight:
-- Most customers within São Paulo state are concentrated
-- in São Paulo city, with 15,540 customers.
-- This shows a strong customer concentration within the state.
-- ============================================================
-- 3.6 Payment Analysis
-- ============================================================
-- Business Question:
-- What are the most commonly used payment methods?


-- ------------------------------------------------------------
-- 3.6.1 Payment Method Usage
-- ------------------------------------------------------------

SELECT 
    payment_type,
    COUNT(order_id) AS Number_Of_Payments
FROM olist_order_payments_staging
GROUP BY payment_type
ORDER BY Number_Of_Payments DESC;

-- Result:
-- credit_card = 76,795
-- boleto      = 19,784
-- voucher     = 5,775
-- debit_card  = 1,529
-- not_defined = 3

-- Insight:
-- Credit card is the most commonly used payment method
-- with 76,795 payment records, followed by boleto with 19,784.
-- Debit card and voucher are used less frequently.
-- Only 3 records have an undefined payment type.


-- ------------------------------------------------------------
-- 3.6.2 Average Payment Value by Payment Method
-- ------------------------------------------------------------

SELECT 
    payment_type,
    ROUND(AVG(payment_value), 2) AS Average_Payment_Value
FROM olist_order_payments_staging
GROUP BY payment_type
ORDER BY Average_Payment_Value DESC;

-- Result:
-- credit_card = 163.32
-- boleto      = 145.03
-- debit_card  = 142.57
-- voucher     = 65.70
-- not_defined = 0.00

-- Insight:
-- Credit card has the highest average payment value at 163.32,
-- while voucher has the lowest average payment value at 65.70.
-- This analysis provides additional context about the typical
-- payment value for each payment method.


-- ------------------------------------------------------------
-- 3.6.3 Total Payment Value by Payment Method
-- ------------------------------------------------------------

SELECT 
    payment_type,
    ROUND(SUM(payment_value), 2) AS Total_Payment_Value
FROM olist_order_payments_staging
GROUP BY payment_type
ORDER BY Total_Payment_Value DESC;

-- Result:
-- credit_card = 12,542,084.19
-- boleto      =  2,869,361.27
-- voucher     =    379,436.87
-- debit_card  =    217,989.79
-- not_defined =          0.00

-- Insight:
-- Credit card generated the highest total payment value
-- at approximately 12.54M, followed by boleto at 2.87M.
-- Credit card is therefore both the most frequently used
-- payment method and the largest contributor to total payment value.
-- The undefined payment type has no financial impact on the analysis.

-- ============================================================
-- 3.7 Review Analysis
-- ============================================================


-- ------------------------------------------------------------
-- 3.7.1 Review Score Distribution
-- ------------------------------------------------------------
-- Business Question:
-- What is the distribution of customer review scores?

SELECT 
    review_score,
    COUNT(review_id) AS Number_Of_Reviews
FROM olist_order_reviews_staging
GROUP BY review_score
ORDER BY Number_Of_Reviews DESC;


-- Results:
-- 5 Stars = 57,328 reviews
-- 4 Stars = 19,142 reviews
-- 1 Star  = 11,424 reviews
-- 3 Stars =  8,179 reviews
-- 2 Stars =  3,151 reviews


-- Insight:
-- 5-star reviews are the most common, followed by 4-star reviews.
-- Overall, positive reviews represent the majority of customer feedback.
-- However, 11,424 one-star reviews indicate a significant level
-- of customer dissatisfaction.


-- ------------------------------------------------------------
-- 3.7.2 Review Scores by Delivery Status
-- ------------------------------------------------------------
-- Business Question:
-- Are late orders associated with lower customer review scores?
SELECT 
    rs.review_score,
    CASE 
        WHEN os.order_delivered_customer_date IS NULL 
            THEN 'Not Delivered'
        WHEN os.order_delivered_customer_date > os.order_estimated_delivery_date 
            THEN 'Late'
        ELSE 'On Time'
    END AS Delivery_Status,
    COUNT(rs.review_id) AS Number_Of_Reviews
FROM olist_order_reviews_staging AS rs
JOIN olist_orders_staging AS os
    ON rs.order_id = os.order_id
GROUP BY 
    rs.review_score,
    CASE 
        WHEN os.order_delivered_customer_date IS NULL 
            THEN 'Not Delivered'
        WHEN os.order_delivered_customer_date > os.order_estimated_delivery_date 
            THEN 'Late'
        ELSE 'On Time'
    END
ORDER BY Number_Of_Reviews DESC;


-- Results:
-- 5 Stars | On Time       = 55,349
-- 4 Stars | On Time       = 18,033
-- 3 Stars | On Time       =  7,086
-- 1 Star  | On Time       =  5,855
-- 1 Star  | Late          =  3,554
-- 2 Stars | On Time       =  2,335
-- 1 Star  | Not Delivered =  2,015
-- 5 Stars | Late          =  1,711
-- 4 Stars | Late          =    954
-- 3 Stars | Late          =    876
-- 2 Stars | Late          =    606
-- 5 Stars | Not Delivered =    268
-- 3 Stars | Not Delivered =    217
-- 2 Stars | Not Delivered =    210
-- 4 Stars | Not Delivered =    155


-- Insight:
-- Late orders show a noticeably higher concentration of low review scores,
-- especially 1-star reviews.
-- 1-star reviews represent the largest share of reviews among late orders.
-- This suggests a strong association between delivery delays
-- and lower customer satisfaction.
-- This analysis indicates association, not causation.

-- ------------------------------------------------------------
-- 3.7.3 Review Score Distribution Among Late Orders
-- ------------------------------------------------------------
-- Business Question:
-- What percentage of reviews for late orders belong to each review score?

WITH Late_Reviews AS
(
    SELECT 
        rs.review_score
    FROM olist_order_reviews_staging AS rs
    JOIN olist_orders_staging AS os
        ON rs.order_id = os.order_id
    WHERE os.order_delivered_customer_date > os.order_estimated_delivery_date
)

SELECT 
    review_score,
    COUNT(*) AS Number_Of_Reviews,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Late_Reviews),
        2
    ) AS Percentage_Of_Late_Reviews
FROM Late_Reviews
GROUP BY review_score
ORDER BY review_score;


-- Results:
-- 1 Star  = 3,554 reviews | 46.15%
-- 2 Stars =   606 reviews |  7.87%
-- 3 Stars =   876 reviews | 11.38%
-- 4 Stars =   954 reviews | 12.39%
-- 5 Stars = 1,711 reviews | 22.22%


-- Insight:
-- 1-star reviews account for 46.15% of all reviews associated with late orders.
-- This is the largest review-score group among late orders.
-- Only 22.22% of late-order reviews are 5-star.
-- These results indicate a strong relationship between delivery delays
-- and negative customer feedback.

-- ============================================================
-- 3.8 Delivery Analysis
-- ============================================================

-- 3.8.1 Delivery Status
-- Business Question:
-- How many orders were delivered late versus on time?

SELECT 
    COUNT(*) AS Count,
    CASE 
        WHEN order_delivered_customer_date > order_estimated_delivery_date
            THEN 'Late'
        ELSE 'On Time'
    END AS Delivery_Status
FROM olist_orders_staging
GROUP BY 
    CASE 
        WHEN order_delivered_customer_date > order_estimated_delivery_date
            THEN 'Late'
        ELSE 'On Time'
    END;

-- Results:
-- Late = 7,827 orders
-- On Time = 91,614 orders
-- Total = 99,441 orders


-- 3.8.2 Late Orders Percentage
-- Business Question:
-- What percentage of orders were delivered late?

WITH late_orders AS
(
    SELECT 
        COUNT(*) AS Number_Of_Late_Orders
    FROM olist_orders_staging
    WHERE order_delivered_customer_date > order_estimated_delivery_date
)

SELECT 
    Number_Of_Late_Orders,
    CAST(
        ROUND(
            Number_Of_Late_Orders * 100.0 
            / (SELECT COUNT(*) FROM olist_orders_staging),
            2
        ) AS DECIMAL(5,2)
    ) AS Percentage_Of_Late_Orders
FROM late_orders;

-- Results:
-- Number Of Late Orders = 7,827
-- Percentage Of Late Orders = 7.87%
-- On-Time Delivery Rate = 92.13%

-- Insight:
-- 7,827 orders were delivered late, representing 7.87%
-- of all orders.
-- The majority of orders (92.13%) were delivered on time.


-- 3.8.3 Average Delivery Time
-- Business Question:
-- What is the average delivery time from carrier handover
-- to customer delivery?

SELECT 
    ROUND(
        AVG(
            CAST(
                DATEDIFF(
                    DAY,
                    order_delivered_carrier_date,
                    order_delivered_customer_date
                ) AS FLOAT
            )
        ),
        2
    ) AS Average_Delivery_Days
FROM olist_orders_staging
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL;

-- Results:
-- Average Delivery Time = 9.28 days

-- Insight:
-- Orders took an average of 9.28 days to be delivered
-- from the carrier handover date to the customer delivery date.


-- 3.8.4 Average Delivery Time by Year
-- Business Question:
-- How did average delivery time change over the years?

SELECT 
    YEAR(order_purchase_timestamp) AS Year,
    ROUND(
        AVG(
            CAST(
                DATEDIFF(
                    DAY,
                    order_delivered_carrier_date,
                    order_delivered_customer_date
                ) AS FLOAT
            )
        ),
        2
    ) AS Average_Delivery_Days
FROM olist_orders_staging
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY Year;

-- Results:
-- 2016 = 5.75 days
-- 2017 = 9.58 days
-- 2018 = 9.06 days

-- Insight:
-- Average delivery time increased from 5.75 days in 2016
-- to 9.58 days in 2017.
-- Delivery performance improved slightly in 2018,
-- decreasing to 9.06 days.
-- However, the average delivery time in 2018 remained
-- higher than in 2016.
-- ============================================================
-- 3.9 Monthly Sales Trend
-- ============================================================

-- 3.9.1 Monthly Revenue Across All Years
-- Business Question:
-- Which months generate the highest revenue overall?

SELECT 
    ROUND(SUM(oi.price + oi.freight_value), 2) AS Total_Revenue,
    MONTH(os.order_purchase_timestamp) AS Month
FROM olist_orders_staging os
JOIN olist_order_items_staging oi
    ON os.order_id = oi.order_id
GROUP BY MONTH(os.order_purchase_timestamp)
ORDER BY Total_Revenue DESC;

-- Results:
-- May       = 1,735,972.77
-- August    = 1,671,513.07
-- July      = 1,643,699.65
-- March     = 1,587,175.41
-- April     = 1,572,120.28
-- June      = 1,525,640.15
-- February  = 1,273,189.58
-- January   = 1,244,490.38
-- November  = 1,179,143.77
-- December  =   863,566.85
-- October   =   826,121.21
-- September =   720,920.12

-- Insight:
-- May generated the highest total revenue at approximately 1.74M,
-- followed by August and July at approximately 1.67M and 1.64M.
-- Overall, May, August, and July were the strongest months
-- based on total revenue across the available years.


-- 3.9.2 Monthly Sales Trend by Year
-- Business Question:
-- How do sales change month by month over time?

SELECT 
    ROUND(SUM(oi.price + oi.freight_value), 2) AS Total_Revenue,
    MONTH(os.order_purchase_timestamp) AS Month,
    YEAR(os.order_purchase_timestamp) AS Year
FROM olist_orders_staging os
JOIN olist_order_items_staging oi
    ON os.order_id = oi.order_id
GROUP BY 
    YEAR(os.order_purchase_timestamp),
    MONTH(os.order_purchase_timestamp)
ORDER BY 
    Year,
    Month;

-- Results:
-- 2016:
-- September  = 354.75
-- October    = 56,808.84
-- December   = 19.62
--
-- 2017:
-- January    = 137,188.49
-- February   = 286,280.62
-- March      = 432,048.59
-- April      = 412,422.24
-- May        = 586,190.95
-- June       = 502,963.04
-- July       = 584,971.62
-- August     = 668,204.60
-- September  = 720,398.91
-- October    = 769,312.37
-- November   = 1,179,143.77
-- December   = 863,547.23
--
-- 2018:
-- January    = 1,107,301.89
-- February   = 986,908.96
-- March      = 1,155,126.82
-- April      = 1,159,698.04
-- May        = 1,149,781.82
-- June       = 1,022,677.11
-- July       = 1,058,728.03
-- August     = 1,003,308.47
-- September  = 166.46

-- Insight:
-- Sales increased substantially from 2017 to 2018.
-- In 2017, revenue generally increased throughout the year,
-- reaching its highest point in November at approximately 1.18M.
--
-- In 2018, monthly revenue remained above 1M
-- from January through August.
-- April 2018 recorded the highest monthly revenue
-- at approximately 1.16M.
--
-- The very low revenue in September 2018 (166.46)
-- should not be interpreted as a sudden sales decline,
-- because the available data for that month is incomplete.
--
-- Overall, the business showed strong growth over time,
-- with 2018 generating substantially higher monthly revenue
-- than 2017.

-- ============================================================
-- END Exploratory Data Analysis (EDA)
-- ============================================================