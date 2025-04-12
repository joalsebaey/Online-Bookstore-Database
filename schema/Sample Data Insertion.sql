-- Insert sample data into Authors
INSERT INTO Authors (FirstName, LastName, Biography) VALUES 
(N'J.K.', N'Rowling', N'British author best known for the Harry Potter series'),
(N'George R.R.', N'Martin', N'American novelist best known for A Song of Ice and Fire'),
(N'Stephen', N'King', N'American author of horror, supernatural fiction, and fantasy'),
(N'Jane', N'Austen', N'English novelist known for her six major novels'),
(N'Agatha', N'Christie', N'English writer known for her detective novels');
GO

-- Insert sample data into Publishers
INSERT INTO Publishers (PublisherName, Address, Phone, Email) VALUES 
(N'Bloomsbury Publishing', N'London, UK', N'+44-20-7631-5600', N'contact@bloomsbury.com'),
(N'Bantam Books', N'New York, USA', N'+1-212-782-9000', N'info@bantambooks.com'),
(N'Scribner', N'New York, USA', N'+1-212-698-7000', N'contact@scribner.com'),
(N'Penguin Classics', N'London, UK', N'+44-20-7139-3000', N'info@penguinclassics.com'),
(N'HarperCollins', N'New York, USA', N'+1-212-207-7000', N'contact@harpercollins.com');
GO

-- Insert sample data into Categories
INSERT INTO Categories (CategoryName, Description) VALUES 
(N'Fantasy', N'Books involving magic and supernatural phenomena'),
(N'Science Fiction', N'Fiction based on scientific discoveries or advanced technology'),
(N'Mystery', N'Fiction dealing with the solution of a crime or puzzle'),
(N'Romance', N'Stories about romantic love relationships'),
(N'Horror', N'Fiction meant to scare, unsettle, or horrify the audience'),
(N'Classic', N'Books that have stood the test of time');
GO

-- Insert sample data into Books
INSERT INTO Books (ISBN, Title, PublisherID, PublicationDate, Price, Description, InStock) VALUES 
(N'9780747532743', N'Harry Potter and the Philosopher''s Stone', 1, '1997-06-26', 12.99, N'The first book in the Harry Potter series', 150),
(N'9780553593716', N'A Game of Thrones', 2, '1996-08-01', 14.99, N'The first book in A Song of Ice and Fire series', 75),
(N'9781982127794', N'The Shining', 3, '1977-01-28', 9.99, N'A horror novel by Stephen King', 50),
(N'9780141439518', N'Pride and Prejudice', 4, '1813-01-28', 7.99, N'A classic novel by Jane Austen', 100),
(N'9780062073488', N'Murder on the Orient Express', 5, '1934-01-01', 8.99, N'A classic detective novel by Agatha Christie', 85);
GO

-- Connect Books with Authors
INSERT INTO Book_Authors (BookID, AuthorID) VALUES 
(1, 1), -- Harry Potter by J.K. Rowling
(2, 2), -- Game of Thrones by George R.R. Martin
(3, 3), -- The Shining by Stephen King
(4, 4), -- Pride and Prejudice by Jane Austen
(5, 5); -- Murder on the Orient Express by Agatha Christie
GO

-- Connect Books with Categories
INSERT INTO Book_Categories (BookID, CategoryID) VALUES 
(1, 1), -- Harry Potter: Fantasy
(2, 1), -- Game of Thrones: Fantasy
(3, 5), -- The Shining: Horror
(4, 4), -- Pride and Prejudice: Romance
(4, 6), -- Pride and Prejudice: Classic
(5, 3); -- Murder on the Orient Express: Mystery
GO

-- Insert sample data into Customers
INSERT INTO Customers (FirstName, LastName, Email, PasswordHash, Phone) VALUES 
(N'John', N'Doe', N'john.doe@example.com', N'hashed_password_1', N'+1-555-123-4567'),
(N'Jane', N'Smith', N'jane.smith@example.com', N'hashed_password_2', N'+1-555-987-6543'),
(N'Robert', N'Johnson', N'robert.j@example.com', N'hashed_password_3', N'+1-555-456-7890'),
(N'Emily', N'Wilson', N'emily.w@example.com', N'hashed_password_4', N'+1-555-789-0123'),
(N'Michael', N'Brown', N'michael.b@example.com', N'hashed_password_5', N'+1-555-234-5678');
GO

-- Insert sample data into Addresses
INSERT INTO Addresses (CustomerID, AddressType, Address1, City, PostalCode, Country, IsDefault) VALUES 
(1, 'Billing', N'123 Main St', N'New York', N'10001', N'USA', 1),
(1, 'Shipping', N'123 Main St', N'New York', N'10001', N'USA', 1),
(2, 'Billing', N'456 Oak Ave', N'Los Angeles', N'90001', N'USA', 1),
(2, 'Shipping', N'456 Oak Ave', N'Los Angeles', N'90001', N'USA', 1),
(3, 'Billing', N'789 Pine Rd', N'Chicago', N'60007', N'USA', 1),
(3, 'Shipping', N'789 Pine Rd', N'Chicago', N'60007', N'USA', 1),
(4, 'Billing', N'101 Maple Dr', N'Boston', N'02108', N'USA', 1),
(4, 'Shipping', N'101 Maple Dr', N'Boston', N'02108', N'USA', 1),
(5, 'Billing', N'202 Cedar Ln', N'Seattle', N'98101', N'USA', 1),
(5, 'Shipping', N'202 Cedar Ln', N'Seattle', N'98101', N'USA', 1);
GO

-- Insert sample data into PaymentMethods
INSERT INTO PaymentMethods (CustomerID, PaymentType, Provider, AccountNumber, ExpiryDate, IsDefault) VALUES 
(1, 'Credit Card', N'Visa', N'XXXX-XXXX-XXXX-1234', '2025-12-31', 1),
(2, 'Credit Card', N'Mastercard', N'XXXX-XXXX-XXXX-5678', '2026-10-31', 1),
(3, 'PayPal', N'PayPal', N'robert.j@example.com', NULL, 1),
(4, 'Credit Card', N'American Express', N'XXXX-XXXX-XXXX-9012', '2024-06-30', 1),
(5, 'Bank Transfer', N'Chase Bank', N'XXXXXX5678', NULL, 1);
GO

-- Insert sample Orders
INSERT INTO Orders (CustomerID, OrderDate, ShippingAddressID, BillingAddressID, PaymentMethodID, TotalAmount, OrderStatus) 
VALUES 
(1, DATEADD(DAY, -30, GETDATE()), 2, 1, 1, 27.98, 'Delivered'),
(2, DATEADD(DAY, -14, GETDATE()), 4, 3, 2, 14.99, 'Shipped'),
(3, DATEADD(DAY, -7, GETDATE()), 6, 5, 3, 18.98, 'Processing'),
(4, DATEADD(DAY, -1, GETDATE()), 8, 7, 4, 12.99, 'Pending');
GO

-- Insert sample OrderItems
INSERT INTO OrderItems (OrderID, BookID, Quantity, PriceAtPurchase)
VALUES 
(1, 1, 1, 12.99),  -- Harry Potter
(1, 4, 1, 7.99),   -- Pride and Prejudice
(1, 5, 1, 7.00),   -- Murder on the Orient Express (discount applied)
(2, 2, 1, 14.99),  -- Game of Thrones
(3, 3, 1, 9.99),   -- The Shining
(3, 5, 1, 8.99),   -- Murder on the Orient Express
(4, 1, 1, 12.99);  -- Harry Potter
GO

-- Insert sample Reviews
INSERT INTO Reviews (BookID, CustomerID, Rating, ReviewText)
VALUES 
(1, 1, 5, N'Fantastic start to a magical series!'),
(2, 2, 4, N'Complex and engaging fantasy novel with rich world-building.'),
(3, 3, 5, N'One of the scariest books I''ve ever read. A true classic!'),
(4, 4, 4, N'A timeless romance that still resonates today.'),
(5, 5, 5, N'Christie at her best! The twist at the end was brilliant.');
GO

-- Insert sample Wishlist items
INSERT INTO Wishlist (CustomerID, BookID)
VALUES 
(1, 2), -- John wants Game of Thrones
(1, 3), -- John wants The Shining
(2, 1), -- Jane wants Harry Potter
(3, 4), -- Robert wants Pride and Prejudice
(4, 5); -- Emily wants Murder on the Orient Express
GO

-- Insert sample ShoppingCart items
INSERT INTO ShoppingCart (CustomerID, BookID, Quantity)
VALUES 
(1, 3, 1), -- John has The Shining in cart
(2, 5, 2), -- Jane has 2 copies of Murder on the Orient Express in cart
(5, 1, 1); -- Michael has Harry Potter in cart
GO
