-- View for Book Details
CREATE VIEW vw_BookDetails AS
SELECT 
    b.BookID, b.ISBN, b.Title, b.Price, b.InStock,
    p.PublisherName,
    STRING_AGG(CONCAT(a.FirstName, ' ', a.LastName), ', ') AS Authors,
    STRING_AGG(c.CategoryName, ', ') AS Categories
FROM Books b
LEFT JOIN Publishers p ON b.PublisherID = p.PublisherID
LEFT JOIN Book_Authors ba ON b.BookID = ba.BookID
LEFT JOIN Authors a ON ba.AuthorID = a.AuthorID
LEFT JOIN Book_Categories bc ON b.BookID = bc.BookID
LEFT JOIN Categories c ON bc.CategoryID = c.CategoryID
GROUP BY b.BookID, b.ISBN, b.Title, b.Price, b.InStock, p.PublisherName;
GO

-- View for Order Summary
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

-- View for Customer Order Statistics
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
