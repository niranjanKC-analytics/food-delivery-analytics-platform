USE food_delivery;

-- 1. Customers (our team)
INSERT INTO Customer (Email, Name, Phone, Address, AccountStatus) VALUES
('niranjan.kc@tu.edu',       'Niranjan K C',              '410-555-1101', 'Towson, MD',      'active'),
('damilola.bright@tu.edu',   'Oluwadamilola Bright',      '410-555-1102', 'Baltimore, MD',   'active'),
('carrington.taylor@tu.edu', 'Carrington Taylor',         '410-555-1103', 'Catonsville, MD', 'active'),
('jivitesh.marken@tu.edu',   'Jivitesh Marken',           '410-555-1104', 'Parkville, MD',   'active');

-- extra customers
INSERT INTO Customer (Email, Name, Phone, Address, AccountStatus) VALUES
('maya.kc@example.com',    'Maya KC',    '410-555-1201', 'Downtown Baltimore', 'active'),
('ram.sharma@example.com', 'Ram Sharma', '410-555-1202', 'Towson University',  'active');

-- 2. Restaurants
INSERT INTO Restaurant (Name, Location, CuisineType, Phone, Status) VALUES
('Everest Momo House', 'Towson, MD',    'Nepali', '410-555-2001', 'open'),
('Charm City Pizza',   'Baltimore, MD', 'Pizza',  '410-555-2002', 'open');

-- 3. Drivers
INSERT INTO Driver (Name, VehicleType, Phone, Status, CommissionRate) VALUES
('Niranjan K C',      'Car',  '410-555-3001', 'active', 15.00),
('Carrington Taylor', 'Bike', '410-555-3002', 'active', 12.50),
('Campus Driver 1',   'Car',  '410-555-3003', 'active', 14.00);

-- 4. Menu items
INSERT INTO MenuItem (RestaurantID, ItemName, Description, Price, Availability) VALUES
(1, 'Chicken Momo',        'Steamed dumplings',       11.99, TRUE),
(1, 'Veg Momo',            'Vegetable dumplings',      9.99, TRUE),
(2, 'Pepperoni Pizza (M)', 'Classic pepperoni pizza', 14.50, TRUE),
(2, 'Cheese Pizza (M)',    'Mozzarella cheese pizza', 12.00, TRUE);

-- 5. Orders
-- (CustomerIDs 1–4 exist; RestaurantIDs 1–2 exist; DriverIDs 1–3 exist)
INSERT INTO `Order` (CustomerID, RestaurantID, DriverID, Status, DeliveryAddress)
VALUES
(1, 1, 3, 'delivered',        'Towson, MD'),
(2, 2, 1, 'out_for_delivery', 'Baltimore, MD'),
(3, 1, NULL, 'preparing',     'Catonsville, MD'),
(4, 2, 2, 'delivered',        'Parkville, MD');

-- 6. OrderDetail
INSERT INTO OrderDetail (OrderID, ItemID, Quantity, ItemPrice) VALUES
(1, 1, 2, 11.99),   -- Niranjan, 2 chicken momo
(2, 3, 1, 14.50),   -- Damilola, 1 pepperoni pizza
(3, 2, 3, 9.99),    -- Carrington, 3 veg momo
(4, 4, 1, 12.00);   -- Jivitesh, 1 cheese pizza

-- 7. Payment (adjusted to his enums!)
INSERT INTO Payment (OrderID, Amount, PaymentMethod, Status) VALUES
(1, 23.98, 'card',  'captured'),
(2, 14.50, 'cash',  'captured'),
(3, 29.97, 'card',  'authorized'),   -- like pending
(4, 12.00, 'card',  'captured');

-- 8. Reviews
INSERT INTO Review (CustomerID, RestaurantID, DriverID, Rating, Comment) VALUES
(1, 1, 3, 5, 'Momos were great and delivery was quick.'),
(2, 2, 1, 4, 'Pizza was good, driver friendly.'),
(3, 1, NULL, 5, 'Everest Momo House is my favorite.'),
(4, 2, 2, 5, 'Fast and hot delivery!');

-- 9. Basic DML / testing
-- update an order status
UPDATE `Order`
SET Status = 'delivered'
WHERE OrderID = 3;

-- show joined data
SELECT o.OrderID,
       c.Name AS Customer,
       r.Name AS Restaurant,
       o.Status
FROM `Order` o
JOIN Customer c   ON o.CustomerID = c.CustomerID
JOIN Restaurant r ON o.RestaurantID = r.RestaurantID
ORDER BY o.OrderID;
