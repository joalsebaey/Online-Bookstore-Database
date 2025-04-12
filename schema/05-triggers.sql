-- Trigger for order status changes
CREATE TRIGGER trg_OrderStatusChange
ON Orders
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if OrderStatus was changed
    IF UPDATE(OrderStatus)
    BEGIN
        INSERT INTO OrderStatusHistory (OrderID, OldStatus, NewStatus)
        SELECT 
            i.OrderID,
            d.OrderStatus,
            i.OrderStatus
        FROM inserted i
        JOIN deleted d ON i.OrderID = d.OrderID
        WHERE i.OrderStatus <> d.OrderStatus;
        
        -- Send notification (placeholder for demonstration)
        -- In a real system, you might call a stored procedure here that sends emails
        -- or integrates with a notification service
        
        -- Example: If an order is marked as shipped, update tracking information
        IF EXISTS (SELECT 1 FROM inserted WHERE OrderStatus = 'Shipped' AND TrackingNumber IS NOT NULL)
        BEGIN
            -- Placeholder for shipping notification logic
            PRINT 'Order shipped notification would be sent here';
        END
    END
END;
GO

-- Trigger to update book inventory when order status changes to cancelled
CREATE TRIGGER trg_OrderCancellation
ON Orders
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- If order is being cancelled, restore inventory
    IF EXISTS (SELECT 1 FROM inserted i JOIN deleted d ON i.OrderID = d.OrderID 
               WHERE i.OrderStatus = 'Cancelled' AND d.OrderStatus != 'Cancelled')
    BEGIN
        -- Restore inventory quantities
        UPDATE b
        SET b.InStock = b.InStock + oi.Quantity
        FROM Books b
        JOIN OrderItems oi ON b.BookID = oi.BookID
        JOIN inserted i ON oi.OrderID = i.OrderID
        WHERE i.OrderStatus = 'Cancelled';
    END
END;
GO
