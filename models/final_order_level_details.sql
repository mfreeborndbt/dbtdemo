WITH order_details AS (
    SELECT *
    FROM {{ ref('order_level_aggregates') }}
),
returns_data AS (
    SELECT
        ORDER_ID,
        'Yes' AS returned
    FROM {{ source('raw_data', 'RETURNS') }}
)
SELECT
    o.ORDER_ID,
    o.CUSTOMER_ID,
    o.ORDER_DATE,
    o.SHIP_DATE,
    o.SHIP_MODE,
    o.CUSTOMER_NAME,
    o.CITY,
    o.STATE,
    o.POSTAL_CODE,
    o.COUNTRY,
    o.REGION,
    o.SEGMENT,
    o.total_sales,
    o.total_profit,
    o.total_quantity,
    o.average_discount,
    o.shipping_status,
    o.profitability,
    o.discount_status,
    COALESCE(r.returned, 'No') AS returned
FROM order_details o
LEFT JOIN returns_data r ON o.ORDER_ID = r.ORDER_ID
