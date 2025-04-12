CREATE FUNCTION GetBookRecommendations
(
    @CustomerID INT,
    @MaxRecommendations INT = 5
)
RETURNS TABLE
AS
RETURN
(
    WITH CustomerCategories AS (
        -- Find categories this customer has purchased from
        SELECT DISTINCT bc.CategoryID
        FROM Orders o
        JOIN OrderItems oi ON o.OrderID = oi.OrderID
        JOIN Books b ON oi.BookID = b.BookID
        JOIN Book_Categories bc ON b.BookID = bc.BookID
        WHERE o.CustomerID = @CustomerID
    ),
    CustomerBooks AS (
        -- Books the customer has already purchased
        SELECT DISTINCT oi.BookID
        FROM Orders o
        JOIN OrderItems oi ON o.OrderID = oi.OrderID
        WHERE o.CustomerID = @CustomerID
    ),
    PopularBooksInCategories AS (
        -- Popular books from the same categories that customer hasn't purchased yet
        SELECT 
            b.BookID,
            b.Title,
            CONCAT(a.FirstName, ' ', a.LastName) AS Author,
            b.Price,
            COUNT(DISTINCT oi.OrderID) AS OrderCount,
            AVG(ISNULL(r.Rating, 0)) AS AvgRating,
            ROW_NUMBER() OVER (PARTITION BY bc.CategoryID ORDER BY COUNT(DISTINCT oi.OrderID) DESC) AS RankInCategory
        FROM Books b
        JOIN Book_Categories bc ON b.BookID = bc.BookID
        JOIN Book_Authors ba ON b.BookID = ba.BookID
        JOIN Authors a ON ba.AuthorID = a.AuthorID
        JOIN OrderItems oi ON b.BookID = oi.BookID
        LEFT JOIN Reviews r ON b.BookID = r.BookID
        WHERE bc.CategoryID IN (SELECT CategoryID FROM CustomerCategories)
          AND b.BookID NOT IN (SELECT BookID FROM CustomerBooks)
          AND b.InStock > 0
        GROUP BY b.BookID, b.Title, CONCAT(a.FirstName, ' ', a.LastName), b.Price, bc.CategoryID
    )
    SELECT TOP (@MaxRecommendations)
        BookID,
        Title,
        Author,
        Price,
        AvgRating
    FROM PopularBooksInCategories
    WHERE RankInCategory <= 3
    ORDER BY OrderCount DESC, AvgRating DESC
);
GO
