CREATE PROCEDURE UpdateOrderStatus
    @OrderID INT,
    @NewStatus NVARCHAR(20),
    @TrackingNumber NVARCHAR(50) = NULL,
    @Notes NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validate status value
    IF @NewStatus NOT IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')
    BEGIN
        RAISERROR('Invalid order status. Valid values are: Pending, Processing, Shipped, Delivered, Cancelled', 16, 1);
        RETURN;
    END
    
    -- Check if order exists
    IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderID = @OrderID)
    BEGIN
        RAISERROR('Order ID %d does not exist', 16, 1, @OrderID);
        RETURN;
    END
    
    -- Special handling for cancellation - restore inventory
    IF @NewStatus = 'Cancelled'
    BEGIN
        BEGIN TRANSACTION;
        
        -- Restore inventory for cancelled order
        UPDATE b
        SET b.InStock = b.InStock + oi.Quantity
        FROM Books b
        JOIN OrderItems oi ON b.BookID = oi.BookID
        WHERE oi.OrderID = @OrderID;
        
        -- Update order status
        UPDATE Orders
        SET OrderStatus = @NewStatus,
            TrackingNumber = @TrackingNumber,
            Notes = ISNULL(@Notes, Notes)
        WHERE OrderID = @OrderID;
        
        COMMIT TRANSACTION;
    END
    ELSE
    BEGIN
        -- For other status changes, just update the status
        UPDATE Orders
        SET OrderStatus = @NewStatus,
            TrackingNumber = CASE WHEN @NewStatus = 'Shipped' THEN ISNULL(@TrackingNumber, TrackingNumber) ELSE TrackingNumber END,
            Notes = ISNULL(@Notes, Notes)
        WHERE OrderID = @OrderID;
    END
    
    -- Return updated order
    SELECT OrderID, CustomerID, OrderDate, TotalAmount, OrderStatus, TrackingNumber
    FROM Orders
    WHERE OrderID = @OrderID;
END;
GO
