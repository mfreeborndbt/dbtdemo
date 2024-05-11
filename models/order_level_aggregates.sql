WITH aggregated_transactions AS (
    SELECT
        ORDER_ID,
        CUSTOMER_ID,
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
        SUM(SALES) AS total_sales,
        SUM(PROFIT) AS total_profit,
        SUM(QUANTITY) AS total_quantity,
        AVG(DISCOUNT) AS average_discount,
        MAX(CASE WHEN SHIP_MODE = 'Same Day' AND DATEDIFF(day, ORDER_DATE, SHIP_DATE) > 0 THEN 'Late'
                 WHEN SHIP_MODE = 'First Class' AND DATEDIFF(day, ORDER_DATE, SHIP_DATE) > 1 THEN 'Late'
                 WHEN SHIP_MODE = 'Second Class' AND DATEDIFF(day, ORDER_DATE, SHIP_DATE) > 3 THEN 'Late'
                 WHEN SHIP_MODE = 'Standard Class' AND DATEDIFF(day, ORDER_DATE, SHIP_DATE) > 5 THEN 'Late'
                 ELSE 'On Time'
            END) AS shipping_status
    FROM {{ ref('transaction_details') }}
    GROUP BY ORDER_ID, CUSTOMER_ID, ORDER_DATE, SHIP_DATE, SHIP_MODE, CUSTOMER_NAME, CITY, STATE, POSTAL_CODE, COUNTRY, REGION, SEGMENT
)
SELECT
    *,
    CASE
        WHEN total_profit > 0 THEN 'Profitable'
        ELSE 'Unprofitable'
    END AS profitability,
    CASE
        WHEN average_discount > 0.4 THEN 'Highly Discounted'
        WHEN average_discount > 0.2 THEN 'Modest Discount'
        ELSE 'Low or No Discount'
    END AS discount_status
FROM aggregated_transactions
