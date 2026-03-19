USE food_delivery;

-- View 1: Customer performance view
CREATE OR REPLACE VIEW v_CustomerOrderSummary AS
SELECT
    c.CustomerID,
    c.Name AS CustomerName,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    COALESCE(SUM(p.Amount), 0) AS TotalSpent,
    CASE
        WHEN COUNT(DISTINCT o.OrderID) > 0
        THEN ROUND(SUM(p.Amount) / COUNT(DISTINCT o.OrderID), 2)
        ELSE NULL
    END AS AvgOrderValue
FROM Customer c
LEFT JOIN `Order` o ON o.CustomerID = c.CustomerID
LEFT JOIN Payment p ON p.OrderID = o.OrderID
GROUP BY c.CustomerID, c.Name;

-- View 2: Restaurant performance view
CREATE OR REPLACE VIEW v_RestaurantPerformance AS
SELECT
    r.RestaurantID,
    r.Name AS RestaurantName,
    r.CuisineType,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    COALESCE(SUM(p.Amount), 0) AS TotalRevenue,
    COUNT(DISTINCT rv.ReviewID) AS ReviewCount,
    AVG(rv.Rating) AS AvgRating
FROM Restaurant r
LEFT JOIN `Order` o ON o.RestaurantID = r.RestaurantID
LEFT JOIN Payment p ON p.OrderID = o.OrderID
LEFT JOIN Review rv ON rv.RestaurantID = r.RestaurantID
GROUP BY r.RestaurantID, r.Name, r.CuisineType;