-- =============================================================
-- E-Commerce Analysis Database Schema
-- =============================================================

CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- -------------------------------------------------------------
-- Customers
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS customers (
    customer_id   INT          PRIMARY KEY AUTO_INCREMENT,
    first_name    VARCHAR(100) NOT NULL,
    last_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(255) UNIQUE NOT NULL,
    phone         VARCHAR(20),
    city          VARCHAR(100),
    state         VARCHAR(100),
    country       VARCHAR(100) DEFAULT 'US',
    signup_date   DATE         NOT NULL,
    is_active     BOOLEAN      DEFAULT TRUE,
    created_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------------------------------------------
-- Products
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS products (
    product_id    INT            PRIMARY KEY AUTO_INCREMENT,
    product_name  VARCHAR(255)   NOT NULL,
    category      VARCHAR(100)   NOT NULL,
    sub_category  VARCHAR(100),
    brand         VARCHAR(100),
    price         DECIMAL(10,2)  NOT NULL,
    cost          DECIMAL(10,2)  NOT NULL,
    stock_qty     INT            DEFAULT 0,
    is_active     BOOLEAN        DEFAULT TRUE,
    created_at    TIMESTAMP      DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------------------------------------------
-- Orders
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS orders (
    order_id      INT           PRIMARY KEY AUTO_INCREMENT,
    customer_id   INT           NOT NULL,
    order_date    DATE          NOT NULL,
    status        ENUM('pending','processing','shipped','delivered','cancelled','returned')
                                DEFAULT 'pending',
    shipping_city VARCHAR(100),
    shipping_state VARCHAR(100),
    shipping_cost DECIMAL(8,2)  DEFAULT 0,
    discount_amt  DECIMAL(8,2)  DEFAULT 0,
    total_amount  DECIMAL(12,2) NOT NULL,
    created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- -------------------------------------------------------------
-- Order Items
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS order_items (
    item_id       INT           PRIMARY KEY AUTO_INCREMENT,
    order_id      INT           NOT NULL,
    product_id    INT           NOT NULL,
    quantity      INT           NOT NULL DEFAULT 1,
    unit_price    DECIMAL(10,2) NOT NULL,
    discount_pct  DECIMAL(5,2)  DEFAULT 0,
    line_total    DECIMAL(12,2) GENERATED ALWAYS AS
                    (quantity * unit_price * (1 - discount_pct/100)) STORED,
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- -------------------------------------------------------------
-- Reviews
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS reviews (
    review_id     INT           PRIMARY KEY AUTO_INCREMENT,
    product_id    INT           NOT NULL,
    customer_id   INT           NOT NULL,
    rating        TINYINT       NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text   TEXT,
    review_date   DATE          NOT NULL,
    FOREIGN KEY (product_id)  REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- -------------------------------------------------------------
-- Indexes
-- -------------------------------------------------------------
CREATE INDEX idx_orders_customer   ON orders(customer_id);
CREATE INDEX idx_orders_date       ON orders(order_date);
CREATE INDEX idx_orders_status     ON orders(status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_prod  ON order_items(product_id);
CREATE INDEX idx_reviews_product   ON reviews(product_id);