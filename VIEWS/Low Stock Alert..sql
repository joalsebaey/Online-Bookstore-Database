-- Find books with low inventory
SELECT 
    BookID, 
    Title, 
    InStock,
    CASE 
        WHEN InStock < 10 THEN 'Critical'
        WHEN InStock < 30 THEN 'Low'
        ELSE 'Adequate'
    END AS StockStatus
FROM Books
WHERE InStock < 30
ORDER BY InStock;
