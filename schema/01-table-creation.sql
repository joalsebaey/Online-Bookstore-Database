-- Authors table
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Biography NVARCHAR(MAX),
    BirthDate DATE,
    DateAdded DATETIME2 DEFAULT GETDATE()
);
GO

-- Publishers table
CREATE TABLE Publishers (
    PublisherID INT PRIMARY KEY IDENTITY(1,1),
    PublisherName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(255),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    WebsiteURL NVARCHAR(255)
);
GO

-- Categories table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(MAX)
);
GO

-- Books table
CREATE TABLE Books (
    BookID INT PRIMARY KEY IDENTITY(1,1),
    ISBN NVARCHAR(20) UNIQUE NOT NULL,
    Title NVARCHAR(255) NOT NULL,
    PublisherID INT,
    PublicationDate DATE,
    Price DECIMAL(10, 2) NOT NULL,
    Description NVARCHAR(MAX),
    CoverImageURL NVARCHAR(255),
    InStock INT DEFAULT 0,
    PageCount INT,
    LanguageCode NVARCHAR(5) DEFAULT 'en',
    DateAdded DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (PublisherID) REFERENCES Publishers(PublisherID)
);
GO

-- Book_Authors (Many-to-many relationship between Books and Authors)
CREATE TABLE Book_Authors (
    BookID INT,
    AuthorID INT,
    PRIMARY KEY (BookID, AuthorID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID) ON DELETE CASCADE
);
GO

-- Book_Categories (Many-to-many relationship between Books and Categories)
CREATE TABLE Book_Categories (
    BookID INT,
    CategoryID INT,
    PRIMARY KEY (BookID, CategoryID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) ON DELETE CASCADE
);
GO

-- Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    Phone NVARCHAR(20),
    RegistrationDate DATETIME2 DEFAULT GETDATE(),
    LastLoginDate DATETIME2
);
GO

-- Addresses table
CREATE TABLE Addresses (
    AddressID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    AddressType NVARCHAR(20) NOT NULL CHECK (AddressType IN ('Billing', 'Shipping')),
    Address1 NVARCHAR(255) NOT NULL,
    Address2 NVARCHAR(255),
    City NVARCHAR(100) NOT NULL,
    State NVARCHAR(100),
    PostalCode NVARCHAR(20) NOT NULL,
    Country NVARCHAR(100) NOT NULL,
    IsDefault BIT DEFAULT 0,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);
GO

-- Payment methods table
CREATE TABLE PaymentMethods (
    PaymentMethodID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    PaymentType NVARCHAR(20) NOT NULL CHECK (PaymentType IN ('Credit Card', 'PayPal', 'Bank Transfer')),
    Provider NVARCHAR(50),
    AccountNumber NVARCHAR(255),
    ExpiryDate DATE,
    IsDefault BIT DEFAULT 0,
    DateAdded DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);
GO

-- Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    OrderDate DATETIME2 DEFAULT GETDATE(),
    ShippingAddressID INT NOT NULL,
    BillingAddressID INT NOT NULL,
    PaymentMethodID INT NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    OrderStatus NVARCHAR(20) DEFAULT 'Pending' CHECK (OrderStatus IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')),
    TrackingNumber NVARCHAR(50),
    Notes NVARCHAR(MAX),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ShippingAddressID) REFERENCES Addresses(AddressID),
    FOREIGN KEY (BillingAddressID) REFERENCES Addresses(AddressID),
    FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethods(PaymentMethodID)
);
GO

-- Order items table
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    BookID INT NOT NULL,
    Quantity INT NOT NULL,
    PriceAtPurchase DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);
GO

-- Reviews table
CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY IDENTITY(1,1),
    BookID INT NOT NULL,
    CustomerID INT NOT NULL,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    ReviewText NVARCHAR(MAX),
    ReviewDate DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT UC_BookCustomer UNIQUE (BookID, CustomerID)
);
GO

-- Wishlist table
CREATE TABLE Wishlist (
    WishlistID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    BookID INT NOT NULL,
    DateAdded DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE,
    CONSTRAINT UC_CustomerBook UNIQUE (CustomerID, BookID)
);
GO

-- Promotions table
CREATE TABLE Promotions (
    PromotionID INT PRIMARY KEY IDENTITY(1,1),
    PromotionCode NVARCHAR(20) UNIQUE NOT NULL,
    Description NVARCHAR(MAX),
    DiscountPercent DECIMAL(5, 2),
    DiscountAmount DECIMAL(10, 2),
    StartDate DATETIME2 NOT NULL,
    EndDate DATETIME2 NOT NULL,
    IsActive BIT DEFAULT 1
);
GO

-- ShoppingCart table
CREATE TABLE ShoppingCart (
    CartID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    BookID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    DateAdded DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE,
    CONSTRAINT UC_CartCustomerBook UNIQUE (CustomerID, BookID)
);
GO

-- OrderStatusHistory table for tracking status changes
CREATE TABLE OrderStatusHistory (
    HistoryID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    OldStatus NVARCHAR(20),
    NewStatus NVARCHAR(20) NOT NULL,
    ChangeDate DATETIME2 DEFAULT GETDATE(),
    ChangedBy NVARCHAR(100) DEFAULT SYSTEM_USER,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
GO

-- Returns table for handling book returns
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
GO
