-- models/final_transaction_details.sql

WITH base AS (
    SELECT
        *,
        CASE
            WHEN profit > 0 THEN 'Profitable'
            ELSE 'Unprofitable'
        END AS profitability,
        CASE
            WHEN SHIP_MODE = 'Same Day' AND DATEDIFF(day, ORDER_DATE, SHIP_DATE) > 0 THEN 'Late'
            WHEN SHIP_MODE = 'First Class' AND DATEDIFF(day, ORDER_DATE, SHIP_DATE) > 1 THEN 'Late'
            WHEN SHIP_MODE = 'Second Class' AND DATEDIFF(day, ORDER_DATE, SHIP_DATE) > 3 THEN 'Late'
            WHEN SHIP_MODE = 'Standard Class' AND DATEDIFF(day, ORDER_DATE, SHIP_DATE) > 5 THEN 'Late'
            ELSE 'On Time'
        END AS shipping_status,
        CASE
            WHEN discount > 0.4 THEN 'Highly Discounted'
            WHEN discount > 0.2 THEN 'Modest Discount'
            ELSE 'Low or No Discount'
        END AS discount_level
    FROM {{ ref('transaction_details') }}
)
SELECT
    TRANSACTION_ID,
    ORDER_ID,
    CUSTOMER_ID,
    PRODUCT_ID,
    SALES,
    QUANTITY,
    DISCOUNT,
    PROFIT,
    ORDER_DATE,
    SHIP_DATE,
    SHIP_MODE,
    CUSTOMER_NAME,
    CITY,
    STATE,
    POSTAL_CODE,
    COUNTRY,
    REGION,
    SEGMENT,
    CATEGORY,
    SUB_CATEGORY,
    PRODUCT_NAME,
    profitability,
    shipping_status,
    discount_level
FROM base
