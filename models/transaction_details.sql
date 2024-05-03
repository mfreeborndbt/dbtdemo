WITH transactions AS (
    SELECT
        src.TRANSACTION_ID,
        src.ORDER_ID,
        src.CUSTOMER_ID,
        src.PRODUCT_ID,
        src.SALES,
        src.QUANTITY,
        src.DISCOUNT,
        src.PROFIT
    FROM {{ source('raw_data', 'TRANSACTIONS') }} AS src
),

orders AS (
    SELECT
        src.ORDER_ID,
        src.ORDER_DATE,
        src.SHIP_DATE,
        src.SHIP_MODE
    FROM {{ source('raw_data', 'ORDERS') }} AS src
),

customers AS (
    SELECT
        src.CUSTOMER_ID,
        src.CUSTOMER_NAME,
        src.CITY,
        src.STATE,
        src.POSTAL_CODE,
        src.COUNTRY,
        src.REGION,
        src.SEGMENT
    FROM {{ source('raw_data', 'CUSTOMERS') }} AS src
),

products AS (
    SELECT
        src.PRODUCT_ID,
        src.CATEGORY,
        src.SUB_CATEGORY,
        src.PRODUCT_NAME
    FROM {{ source('raw_data', 'PRODUCTS') }} AS src
)

SELECT
    t.TRANSACTION_ID,
    t.ORDER_ID,
    t.CUSTOMER_ID,
    t.PRODUCT_ID,
    t.SALES,
    t.QUANTITY,
    t.DISCOUNT,
    t.PROFIT,
    o.ORDER_DATE,
    o.SHIP_DATE,
    o.SHIP_MODE,
    c.CUSTOMER_NAME,
    c.CITY,
    c.STATE,
    c.POSTAL_CODE,
    c.COUNTRY,
    c.REGION,
    c.SEGMENT,
    p.CATEGORY,
    p.SUB_CATEGORY,
    p.PRODUCT_NAME
FROM transactions t
LEFT JOIN orders o ON t.ORDER_ID = o.ORDER_ID
LEFT JOIN customers c ON t.CUSTOMER_ID = c.CUSTOMER_ID
LEFT JOIN products p ON t.PRODUCT_ID = p.PRODUCT_ID