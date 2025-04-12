CREATE VIEW vw_OrderSummary
AS
SELECT 
    o.OrderID,
    o.OrderDate,
    o.OrderStatus,
    o.TotalAmount,
    o.TrackingNumber,
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    c.Email,
    COUNT(oi.OrderItemID) AS TotalItems,
    SUM(oi.Quantity) AS TotalQuantity,
    STRING_AGG(b.Title, ', ') WITHIN GROUP (ORDER BY b.Title) AS BookList
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Books b ON oi.BookID = b.BookID
GROUP BY 
    o.OrderID,
    o.OrderDate,
    o.OrderStatus,
    o.TotalAmount,
    o.TrackingNumber,
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName),
    c.Email;
GO
