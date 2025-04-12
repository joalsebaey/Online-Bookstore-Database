CREATE PROCEDURE GenerateInvoice
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if order exists
    IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderID = @OrderID)
    BEGIN
        RAISERROR('Order ID %d does not exist', 16, 1, @OrderID);
        RETURN;
    END
    
    -- Get order and customer details
    SELECT
        o.OrderID,
        o.OrderDate,
        o.TotalAmount,
        o.OrderStatus,
        CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
        c.Email,
        c.Phone,
        -- Billing Address
        ba.Address1 AS BillingAddress1,
        ba.Address2 AS BillingAddress2,
        ba.City AS BillingCity,
        ba.State AS BillingState,
        ba.PostalCode AS BillingPostalCode,
        ba.Country AS BillingCountry,
        -- Shipping Address
        sa.Address1 AS ShippingAddress1,
        sa.Address2 AS ShippingAddress2,
        sa.City AS ShippingCity,
        sa.State AS ShippingState,
        sa.PostalCode AS ShippingPostalCode,
        sa.Country AS ShippingCountry,
        -- Payment method
        pm.PaymentType,
        pm.Provider AS PaymentProvider
    FROM Orders o
    JOIN Customers c ON o.CustomerID = c.CustomerID
    JOIN Addresses ba ON o.BillingAddressID = ba.AddressID
    JOIN Addresses sa ON o.ShippingAddressID = sa.AddressID
    JOIN PaymentMethods pm ON o.PaymentMethodID = pm.PaymentMethodID
    WHERE o.OrderID = @OrderID;
    
    -- Get order items details
    SELECT
        b.Title,
        b.ISBN,
        oi.Quantity,
        oi.PriceAtPurchase AS UnitPrice,
        (oi.Quantity * oi.PriceAtPurchase) AS SubTotal,
        b.BookID,
        CONCAT(a.FirstName, ' ', a.LastName) AS Author
    FROM OrderItems oi
    JOIN Books b ON oi.BookID = b.BookID
    JOIN Book_Authors ba ON b.BookID = ba.BookID
    JOIN Authors a ON ba.AuthorID = a.AuthorID
    WHERE oi.OrderID = @OrderID
    ORDER BY b.Title;
    
    -- Calculate summary
    SELECT
        COUNT(oi.OrderItemID) AS TotalItems,
        SUM(oi.Quantity) AS TotalQuantity,
        SUM(oi.Quantity * oi.PriceAtPurchase) AS SubTotal,
        o.TotalAmount -- This may include discounts
    FROM OrderItems oi
    JOIN Orders o ON oi.OrderID = o.OrderID
    WHERE oi.OrderID = @OrderID
    GROUP BY o.TotalAmount;
END;
GO
