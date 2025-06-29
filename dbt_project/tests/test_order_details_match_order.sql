{# This config is optional, as we've already set the default severity to warn #}
{{ config(severity='warn') }}

/*
    Checks that, for any order, that the number of line items in the order_items table
	matches the num_items_ordered column in the orders table.
    Returns all of the rows where we don't get a match
    We could run multiple checks here (e.g. check only 1 user_id per order, or that the shipped_at timestamps
	are all the same for a given order), but this is just an example of a custom test.


	Перевіряє, чи для будь-якого замовлення кількість позицій у таблиці order_items
	відповідає стовпцю num_items_ordered у таблиці orders.

	Повертає всі рядки, де немає збігу.

	Ми могли б виконати кілька перевірок тут (наприклад, перевірити лише 1 user_id на замовлення або чи однакові часові позначки shipped_at для даного замовлення),
	але це лише приклад користувацького тесту.

*/

WITH order_details AS (
    SELECT
        order_id,
        COUNT(*) AS num_of_items_in_order

    FROM {{ ref('stg_ecommerce__order_items') }}
    GROUP BY 1
)

SELECT
    o.*,
    od.*

FROM {{ ref('stg_ecommerce__orders') }} AS o
FULL OUTER JOIN order_details AS od USING(order_id)
WHERE
    -- All orders should have at least 1 item, and every item should tie to an order
    o.order_id IS NULL
    OR od.order_id IS NULL
    -- Number of items doesn't match
    OR o.num_of_item != od.num_of_items_in_order