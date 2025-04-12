CREATE FUNCTION GetCartTotal
(
    @CustomerID INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @Total DECIMAL(10, 2);
    
    SELECT @Total = SUM(b.Price * sc.Quantity)
    FROM ShoppingCart sc
    JOIN Books b ON sc.BookID = b.BookID
    WHERE sc.CustomerID = @CustomerID;
    
    RETURN ISNULL(@Total, 0);
END;
GO
