-- =============================================================
-- Sample Data Insert – E-Commerce Analysis
-- =============================================================
USE ecommerce_db;

-- -------------------------------------------------------------
-- Customers (30 rows)
-- -------------------------------------------------------------
INSERT INTO customers (first_name, last_name, email, phone, city, state, signup_date) VALUES
('Alice',   'Johnson',   'alice.johnson@email.com',   '555-1001', 'New York',    'NY', '2022-01-15'),
('Bob',     'Smith',     'bob.smith@email.com',       '555-1002', 'Los Angeles', 'CA', '2022-02-10'),
('Carol',   'Williams',  'carol.w@email.com',         '555-1003', 'Chicago',     'IL', '2022-02-20'),
('David',   'Brown',     'david.b@email.com',         '555-1004', 'Houston',     'TX', '2022-03-05'),
('Eve',     'Jones',     'eve.jones@email.com',       '555-1005', 'Phoenix',     'AZ', '2022-03-18'),
('Frank',   'Garcia',    'frank.g@email.com',         '555-1006', 'Philadelphia','PA', '2022-04-01'),
('Grace',   'Martinez',  'grace.m@email.com',         '555-1007', 'San Antonio', 'TX', '2022-04-22'),
('Hank',    'Davis',     'hank.d@email.com',          '555-1008', 'San Diego',   'CA', '2022-05-09'),
('Iris',    'Rodriguez', 'iris.r@email.com',          '555-1009', 'Dallas',      'TX', '2022-05-30'),
('Jake',    'Wilson',    'jake.w@email.com',          '555-1010', 'San Jose',    'CA', '2022-06-15'),
('Karen',   'Anderson',  'karen.a@email.com',         '555-1011', 'Austin',      'TX', '2022-07-01'),
('Leo',     'Thomas',    'leo.t@email.com',           '555-1012', 'Jacksonville','FL', '2022-07-20'),
('Mia',     'Jackson',   'mia.j@email.com',           '555-1013', 'Fort Worth',  'TX', '2022-08-04'),
('Nick',    'White',     'nick.w@email.com',          '555-1014', 'Columbus',    'OH', '2022-08-25'),
('Olivia',  'Harris',    'olivia.h@email.com',        '555-1015', 'Charlotte',   'NC', '2022-09-10'),
('Paul',    'Martin',    'paul.m@email.com',          '555-1016', 'Indianapolis','IN', '2022-09-28'),
('Quinn',   'Thompson',  'quinn.t@email.com',         '555-1017', 'Seattle',     'WA', '2022-10-14'),
('Rachel',  'Moore',     'rachel.mo@email.com',       '555-1018', 'Denver',      'CO', '2022-10-30'),
('Steve',   'Taylor',    'steve.t@email.com',         '555-1019', 'Nashville',   'TN', '2022-11-15'),
('Tina',    'Anderson',  'tina.a@email.com',          '555-1020', 'Oklahoma',    'OK', '2022-11-28'),
('Uma',     'Jackson',   'uma.j@email.com',           '555-1021', 'El Paso',     'TX', '2023-01-05'),
('Victor',  'Lee',       'victor.l@email.com',        '555-1022', 'Portland',    'OR', '2023-01-20'),
('Wendy',   'Clark',     'wendy.c@email.com',         '555-1023', 'Las Vegas',   'NV', '2023-02-08'),
('Xander',  'Lewis',     'xander.l@email.com',        '555-1024', 'Memphis',     'TN', '2023-02-25'),
('Yara',    'Robinson',  'yara.r@email.com',          '555-1025', 'Louisville',  'KY', '2023-03-15'),
('Zoe',     'Walker',    'zoe.w@email.com',           '555-1026', 'Baltimore',   'MD', '2023-04-01'),
('Aaron',   'Hall',      'aaron.h@email.com',         '555-1027', 'Milwaukee',   'WI', '2023-04-18'),
('Beth',    'Allen',     'beth.a@email.com',          '555-1028', 'Albuquerque', 'NM', '2023-05-05'),
('Chris',   'Young',     'chris.y@email.com',         '555-1029', 'Tucson',      'AZ', '2023-05-22'),
('Diana',   'King',      'diana.k@email.com',         '555-1030', 'Fresno',      'CA', '2023-06-10');

-- -------------------------------------------------------------
-- Products (20 rows)
-- -------------------------------------------------------------
INSERT INTO products (product_name, category, sub_category, brand, price, cost, stock_qty) VALUES
('Wireless Noise-Cancelling Headphones', 'Electronics', 'Audio',        'SoundMax',   149.99,  60.00, 200),
('Smart Watch Pro',                      'Electronics', 'Wearables',    'TechFit',    299.99, 110.00, 150),
('Bluetooth Speaker 360',                'Electronics', 'Audio',        'SoundMax',    79.99,  28.00, 300),
('USB-C Hub 7-in-1',                     'Electronics', 'Accessories',  'ConnectX',    49.99,  15.00, 500),
('Mechanical Keyboard RGB',              'Electronics', 'Peripherals',  'TypeForce',  129.99,  45.00, 180),
('Ergonomic Office Chair',               'Furniture',   'Seating',      'ComfortPlus',349.99, 140.00,  80),
('Standing Desk Adjustable',             'Furniture',   'Desks',        'DeskRise',   599.99, 230.00,  60),
('Yoga Mat Premium',                     'Sports',      'Fitness',      'FlexFit',     39.99,  12.00, 400),
('Running Shoes V3',                     'Apparel',     'Footwear',     'SpeedStep',   89.99,  32.00, 250),
('Protein Powder Chocolate 2lb',         'Health',      'Supplements',  'NutriBoost',  49.99,  18.00, 350),
('Coffee Maker Deluxe',                  'Kitchen',     'Appliances',   'BrewMaster', 119.99,  42.00, 120),
('Stainless Steel Water Bottle 32oz',    'Kitchen',     'Drinkware',    'HydroKing',   29.99,   8.00, 600),
('Laptop Stand Aluminum',                'Electronics', 'Accessories',  'ConnectX',    59.99,  20.00, 280),
('LED Desk Lamp Smart',                  'Electronics', 'Lighting',     'LumiTech',    44.99,  16.00, 220),
('Foam Roller Deep Tissue',              'Sports',      'Recovery',     'FlexFit',     24.99,   7.00, 450),
('Resistance Bands Set',                 'Sports',      'Fitness',      'FlexFit',     19.99,   5.00, 500),
('Wireless Charging Pad',                'Electronics', 'Accessories',  'PowerZap',    34.99,  10.00, 350),
('Air Purifier HEPA',                    'Home',        'Air Quality',  'CleanBreeze',199.99,  75.00, 100),
('Instant Pot 6Qt',                      'Kitchen',     'Appliances',   'BrewMaster', 89.99,   35.00, 130),
('Blue Light Glasses',                   'Health',      'Eyewear',      'ClearVue',    24.99,   7.00, 400);

-- -------------------------------------------------------------
-- Orders (50 rows spanning 2022-01 to 2023-12)
-- -------------------------------------------------------------
INSERT INTO orders (customer_id, order_date, status, shipping_city, shipping_state, shipping_cost, discount_amt, total_amount) VALUES
( 1,'2022-02-01','delivered','New York',    'NY', 0,   0,   149.99),
( 2,'2022-03-15','delivered','Los Angeles', 'CA', 5.99,10,  334.97),
( 3,'2022-04-10','delivered','Chicago',     'IL', 0,   0,    79.99),
( 4,'2022-05-22','delivered','Houston',     'TX', 5.99,0,   349.99),
( 5,'2022-06-01','delivered','Phoenix',     'AZ', 0,   5,   164.97),
( 1,'2022-06-18','delivered','New York',    'NY', 0,   0,   299.99),
( 6,'2022-07-04','delivered','Philadelphia','PA', 5.99,0,   129.99),
( 7,'2022-07-20','delivered','San Antonio', 'TX', 0,   0,    49.99),
( 8,'2022-08-05','delivered','San Diego',   'CA', 0,  20,   579.99),
( 9,'2022-08-30','delivered','Dallas',      'TX', 5.99,0,   149.99),
(10,'2022-09-14','delivered','San Jose',    'CA', 0,   0,    89.99),
(11,'2022-09-29','delivered','Austin',      'TX', 0,  10,   109.99),
(12,'2022-10-10','delivered','Jacksonville','FL', 5.99,0,    39.99),
(13,'2022-10-25','delivered','Fort Worth',  'TX', 0,   0,   119.99),
(14,'2022-11-01','delivered','Columbus',    'OH', 0,   0,    79.99),
( 2,'2022-11-15','delivered','Los Angeles', 'CA', 0,  15,   284.97),
(15,'2022-11-28','delivered','Charlotte',   'NC', 5.99,0,    44.99),
(16,'2022-12-05','delivered','Indianapolis','IN', 0,   0,   199.99),
( 1,'2022-12-20','delivered','New York',    'NY', 0,  20,   449.97),
(17,'2023-01-08','delivered','Seattle',     'WA', 0,   0,    59.99),
(18,'2023-01-22','delivered','Denver',      'CO', 5.99,0,   129.99),
(19,'2023-02-05','delivered','Nashville',   'TN', 0,   0,    89.99),
(20,'2023-02-18','delivered','Oklahoma',    'OK', 0,   0,    49.99),
( 3,'2023-03-01','delivered','Chicago',     'IL', 0,   0,   349.99),
(21,'2023-03-15','delivered','El Paso',     'TX', 5.99,0,   149.99),
(22,'2023-03-28','delivered','Portland',    'OR', 0,  10,    69.99),
(23,'2023-04-10','delivered','Las Vegas',   'NV', 0,   0,   299.99),
(24,'2023-04-24','delivered','Memphis',     'TN', 5.99,0,    39.99),
(25,'2023-05-07','shipped',  'Louisville',  'KY', 0,   0,   119.99),
(26,'2023-05-20','shipped',  'Baltimore',   'MD', 0,   0,    29.99),
( 4,'2023-06-01','delivered','Houston',     'TX', 0,  25,   574.97),
(27,'2023-06-14','delivered','Milwaukee',   'WI', 0,   0,    89.99),
(28,'2023-06-27','delivered','Albuquerque', 'NM', 5.99,0,   199.99),
( 5,'2023-07-10','delivered','Phoenix',     'AZ', 0,   0,    49.99),
(29,'2023-07-23','delivered','Tucson',      'AZ', 0,   0,   129.99),
(30,'2023-08-05','delivered','Fresno',      'CA', 0,  10,   139.97),
( 2,'2023-08-18','delivered','Los Angeles', 'CA', 0,   0,   599.99),
(10,'2023-09-01','delivered','San Jose',    'CA', 5.99,0,   149.99),
(11,'2023-09-14','delivered','Austin',      'TX', 0,   0,    24.99),
(12,'2023-09-27','delivered','Jacksonville','FL', 0,   0,    19.99),
( 1,'2023-10-10','delivered','New York',    'NY', 0,  30,   549.96),
(13,'2023-10-23','delivered','Fort Worth',  'TX', 5.99,0,    89.99),
(15,'2023-11-05','delivered','Charlotte',   'NC', 0,   0,   349.99),
(17,'2023-11-18','delivered','Seattle',     'WA', 0,  10,   119.97),
( 6,'2023-11-28','cancelled','Philadelphia','PA', 0,   0,   299.99),
(18,'2023-12-05','delivered','Denver',      'CO', 0,   0,    44.99),
(20,'2023-12-12','delivered','Oklahoma',    'OK', 5.99,0,   149.99),
(22,'2023-12-19','processing','Portland',  'OR', 0,   0,    89.99),
(25,'2023-12-26','pending',  'Louisville',  'KY', 0,   0,    59.99),
(30,'2023-12-30','pending',  'Fresno',      'CA', 0,   0,    29.99);

-- -------------------------------------------------------------
-- Order Items
-- -------------------------------------------------------------
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_pct) VALUES
-- order 1
( 1,  1, 1, 149.99, 0),
-- order 2
( 2,  2, 1, 299.99, 0),( 2,  3, 1,  79.99, 0),
-- order 3
( 3,  3, 1,  79.99, 0),
-- order 4
( 4,  6, 1, 349.99, 0),
-- order 5
( 5,  1, 1, 149.99, 0),( 5, 20, 1,  24.99, 0),
-- order 6
( 6,  2, 1, 299.99, 0),
-- order 7
( 7,  6, 1, 349.99,25),( 7,  4, 1,  49.99, 0),
-- order 8
( 8,  5, 1, 129.99, 0),
-- order 9
( 9,  7, 1, 599.99, 0),
-- order 10
(10,  1, 1, 149.99, 0),
-- order 11
(11,  9, 1,  89.99, 0),( 11, 10,2,  49.99, 0),
-- order 12
(12,  1, 1, 149.99, 0),
-- order 13
(13,  8, 1,  39.99, 0),
-- order 14
(14, 11, 1, 119.99, 0),
-- order 15
(15,  3, 1,  79.99, 0),
-- order 16
(16,  2, 1, 299.99, 0),( 16,  3, 1,  79.99, 0),
-- order 17
(17, 14, 1,  44.99, 0),
-- order 18
(18, 18, 1, 199.99, 0),
-- order 19
(19,  1, 1, 149.99, 0),( 19, 13, 2,  59.99, 0),( 19, 17, 1,  34.99, 0),
-- order 20
(20, 13, 1,  59.99, 0),
-- order 21
(21,  5, 1, 129.99, 0),
-- order 22
(22,  9, 1,  89.99, 0),
-- order 23
(23, 10, 1,  49.99, 0),
-- order 24
(24,  3, 1,  79.99, 0),( 24, 12, 1,  29.99, 0),
-- order 25
(25,  2, 1, 299.99, 0),
-- order 26
(26, 11, 1, 119.99, 0),
-- order 27
(27, 17, 1,  34.99, 0),
-- order 28
(28,  6, 1, 349.99, 0),
-- order 29
(29, 15, 2,  24.99, 0),
-- order 30
(30, 12, 1,  29.99, 0),
-- order 31
(31,  4, 1,  49.99, 0),( 31,  7, 1, 599.99, 0),
-- order 32
(32,  9, 1,  89.99, 0),
-- order 33
(33, 18, 1, 199.99, 0),
-- order 34
(34, 10, 1,  49.99, 0),
-- order 35
(35,  5, 1, 129.99, 0),
-- order 36
(36, 19, 1,  89.99, 0),( 36, 10, 1,  49.99, 0),
-- order 37
(37,  7, 1, 599.99, 0),
-- order 38
(38,  1, 1, 149.99, 0),
-- order 39
(39, 15, 1,  24.99, 0),
-- order 40
(40, 16, 1,  19.99, 0),
-- order 41
(41,  2, 1, 299.99, 0),( 41,  1, 1, 149.99, 0),( 41, 13, 1,  59.99, 0),( 41, 17, 1,  34.99, 0),
-- order 42
(42,  9, 1,  89.99, 0),
-- order 43
(43,  6, 1, 349.99, 0),
-- order 44
(44,  5, 1, 129.99, 0),( 44, 17, 1,  34.99, 0),
-- order 45
(45,  2, 1, 299.99, 0),
-- order 46
(46, 14, 1,  44.99, 0),
-- order 47
(47,  1, 1, 149.99, 0),
-- order 48
(48,  9, 1,  89.99, 0),
-- order 49
(49, 13, 1,  59.99, 0),
-- order 50
(50, 12, 1,  29.99, 0);

-- -------------------------------------------------------------
-- Reviews
-- -------------------------------------------------------------
INSERT INTO reviews (product_id, customer_id, rating, review_text, review_date) VALUES
( 1,  1, 5, 'Excellent sound quality, comfortable fit.',         '2022-02-10'),
( 2,  2, 4, 'Great features but battery could be better.',       '2022-04-01'),
( 3,  3, 5, 'Clear audio, perfect for home use.',                '2022-04-20'),
( 6,  4, 5, 'Very comfortable, worth every penny.',              '2022-06-05'),
( 1,  5, 4, 'Good noise cancellation, slightly heavy.',          '2022-06-15'),
( 5,  6, 5, 'Typing on this is a joy.',                          '2022-07-20'),
( 9, 10, 4, 'Comfortable and durable.',                          '2022-09-25'),
(11, 13, 5, 'Makes perfect coffee every time.',                  '2022-11-05'),
( 3, 14, 3, 'Decent speaker but lacks bass.',                    '2022-11-10'),
(18, 16, 5, 'Air quality improved noticeably.',                  '2022-12-20'),
( 2,  1, 5, 'Best smartwatch I have owned.',                     '2023-01-05'),
(13, 17, 4, 'Sturdy and well-designed.',                         '2023-01-25'),
( 7,  9, 5, 'Love the adjustable height, back pain gone!',       '2023-03-20'),
( 1, 21, 5, 'Outstanding noise cancellation.',                   '2023-04-01'),
(15, 25, 4, 'Good density, does the job.',                       '2023-05-20');