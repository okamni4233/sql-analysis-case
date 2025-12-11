-- CLIENTES
CREATE TABLE customers (
    customer_id      SERIAL PRIMARY KEY,
    full_name        VARCHAR(100) NOT NULL,
    email            VARCHAR(100) UNIQUE NOT NULL,
    city             VARCHAR(50),
    region           VARCHAR(50),
    signup_date      DATE NOT NULL
);

-- PRODUCTOS
CREATE TABLE products (
    product_id       SERIAL PRIMARY KEY,
    product_name     VARCHAR(100) NOT NULL,
    category         VARCHAR(50) NOT NULL,
    unit_price       NUMERIC(10,2) NOT NULL,
    active           BOOLEAN DEFAULT TRUE
);

-- PEDIDOS
CREATE TABLE orders (
    order_id         SERIAL PRIMARY KEY,
    customer_id      INT NOT NULL REFERENCES customers(customer_id),
    order_date       DATE NOT NULL,
    status           VARCHAR(20) NOT NULL, -- 'completed', 'cancelled', etc.
    channel          VARCHAR(20) NOT NULL  -- 'web', 'app', 'store'
);

-- DETALLE DE PEDIDO
CREATE TABLE order_items (
    order_item_id    SERIAL PRIMARY KEY,
    order_id         INT NOT NULL REFERENCES orders(order_id),
    product_id       INT NOT NULL REFERENCES products(product_id),
    quantity         INT NOT NULL,
    unit_price       NUMERIC(10,2) NOT NULL
);

-- PAGOS
CREATE TABLE payments (
    payment_id       SERIAL PRIMARY KEY,
    order_id         INT NOT NULL REFERENCES orders(order_id),
    payment_date     DATE NOT NULL,
    amount           NUMERIC(10,2) NOT NULL,
    method           VARCHAR(20) NOT NULL -- 'credit_card', 'debit', 'cash'
);

