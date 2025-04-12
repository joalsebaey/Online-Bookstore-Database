CREATE PROCEDURE ProcessOrderFulfillment
    @BatchSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    DECLARE @OrdersToProcess TABLE (
        OrderID INT,
        RowNum INT
    );
    
    -- Select orders ready for processing
    INSERT INTO @OrdersToProcess (OrderID, RowNum)
    SELECT OrderID, ROW_NUMBER() OVER (ORDER BY OrderDate)
    FROM Orders
    WHERE OrderStatus = 'Pending'
    ORDER BY OrderDate
    OFFSET 0 ROWS
    FETCH NEXT @BatchSize ROWS ONLY;
    
    -- Update orders to processing status
    UPDATE o
    SET OrderStatus = 'Processing'
    FROM Orders o
    JOIN @OrdersToProcess p ON o.OrderID = p.OrderID;
    
    -- Log status changes (handled by the trigger we created earlier)
    
    -- Return processed orders
    SELECT
        o.OrderID,
        o.OrderDate,
        o.TotalAmount,
        CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
        c.Email,
        a.Address1,
        a.Address2,
        a.City,
        a.State,
        a.PostalCode,
        a.Country,
        -- Books to fulfill
        (SELECT 
            STRING_AGG(CONCAT(b.Title, ' (', oi.Quantity, ')'), ', ')
            FROM OrderItems oi
            JOIN Books b ON oi.BookID = b.BookID
            WHERE oi.OrderID = o.OrderID
        ) AS ItemsToPick
    FROM Orders o
    JOIN Customers c ON o.CustomerID = c.CustomerID
    JOIN Addresses a ON o.ShippingAddressID = a.AddressID
    JOIN @OrdersToProcess p ON o.OrderID = p.OrderID
    ORDER BY p.RowNum;
    
    COMMIT TRANSACTION;
END;
GO
