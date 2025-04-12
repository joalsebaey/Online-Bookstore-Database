CREATE PROCEDURE ProcessBookReturn
    @OrderID INT,
    @BookID INT,
    @Quantity INT,
    @Reason NVARCHAR(MAX),
    @RefundAmount DECIMAL(10, 2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    DECLARE @OrderItemID INT;
    DECLARE @CurrentQuantity INT;
    DECLARE @PriceAtPurchase DECIMAL(10, 2);
    
    -- Check if order item exists
    SELECT @OrderItemID = oi.OrderItemID, 
           @CurrentQuantity = oi.Quantity,
           @PriceAtPurchase = oi.PriceAtPurchase
    FROM OrderItems oi
    WHERE oi.OrderID = @OrderID AND oi.BookID = @BookID;
    
    IF @OrderItemID IS NULL
    BEGIN
        RAISERROR('The specified book was not found in this order.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    -- Validate return quantity
    IF @Quantity > @CurrentQuantity
    BEGIN
        RAISERROR('Return quantity (%d) exceeds ordered quantity (%d).', 16, 1, @Quantity, @CurrentQuantity);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    -- Calculate refund amount
    SET @RefundAmount = @Quantity * @PriceAtPurchase;
    
    -- Update order item quantity or remove if all returned
    IF @Quantity = @CurrentQuantity
    BEGIN
        DELETE FROM OrderItems WHERE OrderItemID = @OrderItemID;
    END
    ELSE
    BEGIN
        UPDATE OrderItems
        SET Quantity = Quantity - @Quantity
        WHERE OrderItemID = @OrderItemID;
    END
    
    -- Adjust order total
    UPDATE Orders
    SET TotalAmount = TotalAmount - @RefundAmount
    WHERE OrderID = @OrderID;
    
    -- Add back to inventory
    UPDATE Books
    SET InStock = InStock + @Quantity
    WHERE BookID = @BookID;
    
    -- Create a record in a Returns table (we'll create this table now)
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Returns')
    BEGIN
        CREATE TABLE Returns (
            ReturnID INT PRIMARY KEY IDENTITY(1,1),
            OrderID INT NOT NULL,
            BookID INT NOT NULL,
            Quantity INT NOT NULL,
            RefundAmount DECIMAL(10, 2) NOT NULL,
            Reason NVARCHAR(MAX),
            ReturnDate DATETIME2 DEFAULT GETDATE(),
            ProcessedBy NVARCHAR(100),
            FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
            FOREIGN KEY (BookID) REFERENCES Books(BookID)
        );
    END
    
    INSERT INTO Returns (OrderID, BookID, Quantity, RefundAmount, Reason)
    VALUES (@OrderID, @BookID, @Quantity, @RefundAmount, @Reason);
    
    COMMIT TRANSACTION;
    
    -- Return updated order details
    SELECT 
        o.OrderID,
        o.OrderDate,
        o.TotalAmount AS NewOrderTotal,
        @RefundAmount AS RefundAmount,
        b.Title AS ReturnedBook,
        @Quantity AS ReturnedQuantity
    FROM Orders o
    JOIN Books b ON b.BookID = @BookID
    WHERE o.OrderID = @OrderID;
END;
GO
