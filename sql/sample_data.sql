INSERT INTO customers (customer_id, full_name, email, city, region, signup_date) VALUES
(1, 'Juan Pérez',        'juan.perez@example.com',        'Concepción',  'Biobío',     '2022-01-05'),
(2, 'María López',       'maria.lopez@example.com',       'Santiago',    'RM',         '2021-12-18'),
(3, 'Carlos Martínez',   'carlos.martinez@example.com',   'Talca',       'Maule',      '2023-03-12'),
(4, 'Ana Torres',        'ana.torres@example.com',        'Concepción',  'Biobío',     '2022-11-07'),
(5, 'Pedro Salinas',     'pedro.salinas@example.com',     'Valdivia',    'Los Ríos',   '2023-02-20');



INSERT INTO products (product_id, product_name, category, unit_price, active) VALUES
(1, 'Audífonos Bluetooth',     'Electrónica', 19990, TRUE),
(2, 'Teclado Mecánico',        'Electrónica', 45990, TRUE),
(3, 'Polera Hombre',           'Ropa',        9990,  TRUE),
(4, 'Zapatillas Running',      'Calzado',     54990, TRUE),
(5, 'Jockey Unisex',           'Accesorios',  6990,  TRUE),
(6, 'Mouse Gamer',             'Electrónica', 15990, FALSE); -- producto descontinuado


INSERT INTO orders (order_id, customer_id, order_date, status, channel) VALUES
(1, 1, '2023-04-01', 'completed', 'web'),
(2, 1, '2023-04-15', 'completed', 'app'),
(3, 2, '2023-05-03', 'cancelled', 'web'),
(4, 3, '2023-06-10', 'completed', 'store'),
(5, 4, '2023-06-25', 'completed', 'web'),
(6, 5, '2023-07-05', 'completed', 'app'),
(7, 2, '2023-07-15', 'completed', 'web');


INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
-- Pedido 1
(1, 1, 1, 1, 19990),
(2, 1, 3, 2, 9990),

-- Pedido 2
(3, 2, 4, 1, 54990),

-- Pedido 3 (cancelado)
(4, 3, 5, 1, 6990),

-- Pedido 4
(5, 4, 2, 1, 45990),
(6, 4, 5, 1, 6990),

-- Pedido 5
(7, 5, 3, 3, 9990),

-- Pedido 6
(8, 6, 1, 2, 19990),

-- Pedido 7
(9, 7, 4, 1, 54990),
(10, 7, 2, 1, 45990);



INSERT INTO payments (payment_id, order_id, payment_date, amount, method) VALUES
(1, 1, '2023-04-01', 39970,  'credit_card'),
(2, 2, '2023-04-15', 54990,  'debit'),
(3, 4, '2023-06-10', 52980,  'credit_card'),
(4, 5, '2023-06-25', 29970,  'cash'),
(5, 6, '2023-07-05', 39980,  'credit_card'),
(6, 7, '2023-07-15', 100980, 'credit_card');
