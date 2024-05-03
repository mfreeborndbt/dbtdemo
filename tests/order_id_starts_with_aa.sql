-- tests/order_id_starts_with_aa.sql

WITH source_data AS (

    SELECT
        ORDER_ID
    FROM {{ ref('final_order_level_details') }}

)

SELECT
    ORDER_ID
FROM source_data
WHERE ORDER_ID LIKE 'AA%'
