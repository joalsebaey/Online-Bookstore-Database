CREATE PROCEDURE AnalyzeOrderPatterns
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Peak order times
    SELECT 
        DATENAME(WEEKDAY, OrderDate) AS DayOfWeek,
        DATEPART(HOUR, OrderDate) AS HourOfDay,
        COUNT(*) AS OrderCount
    FROM Orders
    WHERE OrderDate >= DATEADD(MONTH, -3, GETDATE())
    GROUP BY DATENAME(WEEKDAY, OrderDate), DATEPART(HOUR, OrderDate)
    ORDER BY DayOfWeek, HourOfDay;
    
    -- Average time between orders for repeat customers
    WITH CustomerOrders AS (
        SELECT
            CustomerID,
            OrderDate,
            LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderDate
        FROM Orders
    )
    SELECT
        AVG(DATEDIFF(DAY, PreviousOrderDate, OrderDate)) AS AvgDaysBetweenOrders
    FROM CustomerOrders
    WHERE PreviousOrderDate IS NOT NULL;
    
    -- Seasonal trends (by month)
    SELECT
        YEAR(OrderDate) AS OrderYear,
        MONTH(OrderDate) AS OrderMonth,
        COUNT(*) AS OrderCount,
        SUM(TotalAmount) AS MonthlyRevenue
    FROM Orders
    WHERE OrderDate >= DATEADD(YEAR, -2, GETDATE())
      AND OrderStatus != 'Cancelled'
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
    ORDER BY OrderYear, OrderMonth;
    
    -- Cart abandonment analysis (if we track shopping carts)
    SELECT
        COUNT(*) AS ActiveCarts,
        AVG(DATEDIFF(DAY, sc.DateAdded, GETDATE())) AS AvgDaysInCart
    FROM ShoppingCart sc
    WHERE NOT EXISTS (
        SELECT 1 
        FROM Orders o 
        WHERE o.CustomerID = sc.CustomerID 
          AND o.OrderDate > sc.DateAdded
    );
END;
GO
