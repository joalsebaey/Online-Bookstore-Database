CREATE PROCEDURE ManageShoppingCart
    @CustomerID INT,
    @BookID INT,
    @Action NVARCHAR(10), -- 'Add', 'Update', 'Remove'
    @Quantity INT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validate action
    IF @Action NOT IN ('Add', 'Update', 'Remove')
    BEGIN
        RAISERROR('Invalid action. Valid values are: Add, Update, Remove', 16, 1);
        RETURN;
    END
    
    -- Check if book exists and is in stock
    DECLARE @InStock INT;
    SELECT @InStock = InStock FROM Books WHERE BookID = @BookID;
    
    IF @InStock IS NULL
    BEGIN
        RAISERROR('Book ID %d does not exist', 16, 1, @BookID);
        RETURN;
    END
    
    IF @Action IN ('Add', 'Update') AND @Quantity > @InStock
    BEGIN
        RAISERROR('Requested quantity (%d) exceeds available stock (%d)', 16, 1, @Quantity, @InStock);
        RETURN;
    END
    
    -- Handle cart actions
    IF @Action = 'Add'
    BEGIN
        -- Check if item already exists in cart
        IF EXISTS (SELECT 1 FROM ShoppingCart WHERE CustomerID = @CustomerID AND BookID = @BookID)
        BEGIN
            -- Update quantity instead
            UPDATE ShoppingCart
            SET Quantity = Quantity + @Quantity
            WHERE CustomerID = @CustomerID AND BookID = @BookID;
        END
        ELSE
        BEGIN
            -- Add new item to cart
            INSERT INTO ShoppingCart (CustomerID, BookID, Quantity)
            VALUES (@CustomerID, @BookID, @Quantity);
        END
    END
    ELSE IF @Action = 'Update'
    BEGIN
        -- Update quantity of existing item
        UPDATE ShoppingCart
        SET Quantity = @Quantity
        WHERE CustomerID = @CustomerID AND BookID = @BookID;
    END
    ELSE IF @Action = 'Remove'
    BEGIN
        -- Remove item from cart
        DELETE FROM ShoppingCart
        WHERE CustomerID = @CustomerID AND BookID = @BookID;
    END
    
    -- Return updated cart
    SELECT sc.CartID, sc.BookID, b.Title, b.ISBN, b.Price, 
           sc.Quantity, (b.Price * sc.Quantity) AS Subtotal
    FROM ShoppingCart sc
    JOIN Books b ON sc.BookID = b.BookID
    WHERE sc.CustomerID = @CustomerID
    ORDER BY sc.DateAdded;
END;
GO
