-- Create a view to summarize order statistics
CREATE VIEW vw_CustomerOrderStatistics
AS
SELECT
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    c.Email,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(o.TotalAmount) AS TotalSpent,
    AVG(o.TotalAmount) AS AverageOrderValue,
    MIN(o.OrderDate) AS FirstOrderDate,
    MAX(o.OrderDate) AS MostRecentOrderDate,
    DATEDIFF(DAY, MAX(o.OrderDate), GETDATE()) AS DaysSinceLastOrder,
    SUM(oi.Quantity) AS TotalBooksPurchased,
    -- Top category (using STRING_AGG for SQL Server 2017+)
    (SELECT TOP 1 cat.CategoryName
     FROM Orders ord
     JOIN OrderItems itm ON ord.OrderID = itm.OrderID
     JOIN Books bk ON itm.BookID = bk.BookID
     JOIN Book_Categories bc ON bk.BookID = bc.BookID
     JOIN Categories cat ON bc.CategoryID = cat.CategoryID
     WHERE ord.CustomerID = c.CustomerID
     GROUP BY cat.CategoryID, cat.CategoryName
     ORDER BY COUNT(*) DESC) AS FavoriteCategory
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY c.CustomerID, c.FirstName, c.LastName, c.Email;
GO
