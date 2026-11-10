-- Ventas totales y número de pedidos completados
SELECT
    SUM(oi.quantity * oi.unit_price) AS total_sales,
    COUNT(DISTINCT o.order_id)       AS total_orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'completed';


-- Ventas totales por categoría
SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS sales
FROM order_items oi
JOIN orders o   ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY p.category
ORDER BY sales DESC;






-- Ranking de clientes por ventas
WITH customer_sales AS (
    SELECT
        c.customer_id,
        c.full_name,
        SUM(oi.quantity * oi.unit_price) AS sales
    FROM customers c
    JOIN orders o      ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY c.customer_id, c.full_name
)
SELECT
    customer_id,
    full_name,
    sales,
    RANK() OVER (ORDER BY sales DESC) AS sales_rank
FROM customer_sales
ORDER BY sales_rank
LIMIT 5;



-- Ventas mensuales con promedio móvil de 3 meses
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_date) AS month,
        SUM(oi.quantity * oi.unit_price)  AS sales
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY DATE_TRUNC('month', o.order_date)
)
SELECT
    month,
    sales,
    AVG(sales) OVER (
        ORDER BY month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3m
FROM monthly_sales
ORDER BY month;




-- Clientes activos (con al menos un pedido completado en los 90 días previos
-- a la fecha de referencia)
-- Los datos de muestra van de abril a julio de 2023, así que se usa una fecha
-- de referencia fija (2023-07-31) en lugar de CURRENT_DATE; con la fecha
-- actual la consulta no devolvería filas.
WITH params AS (
    SELECT DATE '2023-07-31' AS reference_date
),
recent_orders AS (
    SELECT DISTINCT o.customer_id
    FROM orders o
    CROSS JOIN params
    WHERE o.status = 'completed'
      AND o.order_date >  params.reference_date - INTERVAL '90 days'
      AND o.order_date <= params.reference_date
)
SELECT
    c.customer_id,
    c.full_name,
    c.city,
    c.region
FROM customers c
JOIN recent_orders r ON c.customer_id = r.customer_id
ORDER BY c.customer_id;



-- Ticket promedio por pedido
SELECT
    AVG(order_total) AS avg_ticket
FROM (
    SELECT
        o.order_id,
        SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY o.order_id
) t;



-- Ventas por canal
SELECT
    channel,
    SUM(oi.quantity * oi.unit_price) AS sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY channel
ORDER BY sales DESC;



-- Tasa de cancelación
SELECT
    COUNT(CASE WHEN status = 'cancelled' THEN 1 END)::DECIMAL
    / COUNT(*) AS cancelled_rate
FROM orders;




-- Productos con pocas ventas
-- Solo cuenta unidades de pedidos completados. Los productos sin ventas
-- aparecen con 0. El umbral (menos de 3 unidades) es un ejemplo ajustado al
-- tamaño de los datos de muestra.
WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        COALESCE(SUM(oi.quantity) FILTER (WHERE o.status = 'completed'), 0) AS total_units
    FROM products p
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
    LEFT JOIN orders o       ON oi.order_id = o.order_id
    GROUP BY p.product_id, p.product_name
)
SELECT *
FROM product_sales
WHERE total_units < 3
ORDER BY total_units, product_id;
