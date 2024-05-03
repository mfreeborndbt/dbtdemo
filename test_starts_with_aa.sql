{% test starts_with_aa(model, column_name) %}

WITH source_data AS (
    SELECT
        {{ column_name }} AS order_id
    FROM {{ model }}
)

SELECT
    order_id
FROM source_data
WHERE order_id LIKE 'AA%'

{% endtest %}
