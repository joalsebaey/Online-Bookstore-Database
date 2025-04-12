-- Create indexes to improve query performance, especially for order operations

-- Indexes for Books table
CREATE INDEX IX_Books_Price ON Books(Price);
CREATE INDEX IX_Books_PublicationDate ON Books(PublicationDate);
CREATE INDEX IX_Books_InStock ON Books(InStock);

-- Indexes for Orders table
CREATE INDEX IX_Orders_CustomerID ON Orders(CustomerID);
CREATE INDEX IX_Orders_OrderDate ON Orders(OrderDate);
CREATE INDEX IX_Orders_OrderStatus ON Orders(OrderStatus);
CREATE INDEX IX_Orders_OrderDateStatus ON Orders(OrderDate, OrderStatus);

-- Indexes for OrderItems table
CREATE INDEX IX_OrderItems_BookID ON OrderItems(BookID);
CREATE INDEX IX_OrderItems_OrderID_BookID ON OrderItems(OrderID, BookID);

-- Indexes for ShoppingCart table
CREATE INDEX IX_ShoppingCart_CustomerID ON ShoppingCart(CustomerID);
CREATE INDEX IX_ShoppingCart_DateAdded ON ShoppingCart(DateAdded);

-- Indexes for Book relationships
CREATE INDEX IX_BookCategories_CategoryID ON Book_Categories(CategoryID);
CREATE INDEX IX_BookAuthors_AuthorID ON Book_Authors(AuthorID);

-- Indexes for Reviews
CREATE INDEX IX_Reviews_Rating ON Reviews(Rating);
CREATE INDEX IX_Reviews_BookID_Rating ON Reviews(BookID, Rating);
GO
