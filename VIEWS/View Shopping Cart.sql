-- Show the cart contents
SELECT 
    sc.CartID, 
    b.Title, 
    sc.Quantity, 
    b.Price, 
    (sc.Quantity * b.Price) AS Subtotal
FROM ShoppingCart sc
JOIN Books b ON sc.BookID = b.BookID
WHERE sc.CustomerID = 1;

-- Get cart total
SELECT dbo.GetCartTotal(1) AS CartTotal;
