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




-- Clientes activos (últimos 90 días)
WITH recent_orders AS (
    SELECT DISTINCT customer_id
    FROM orders
    WHERE status = 'completed'
      AND order_date >= CURRENT_DATE - INTERVAL '90 days'
)
SELECT
    c.customer_id,
    c.full_name,
    c.city,
    c.region
FROM customers c
JOIN recent_orders r ON c.customer_id = r.customer_id;



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
WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS total_units
    FROM products p
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
    LEFT JOIN orders o       ON oi.order_id = o.order_id
                              AND o.status = 'completed'
    GROUP BY p.product_id, p.product_name
)
SELECT *
FROM product_sales
WHERE total_units IS NULL OR total_units < 10
ORDER BY total_units NULLS FIRST;
