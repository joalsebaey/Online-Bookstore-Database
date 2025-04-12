#### Creating a New Order

```sql
-- Declare variables for the CreateOrder stored procedure
DECLARE @CustomerID INT = 1;
DECLARE @ShippingAddressID INT = 2;
DECLARE @BillingAddressID INT = 1;
DECLARE @PaymentMethodID INT = 1;
DECLARE @NewOrderID INT;

-- Create a table variable for the order items
DECLARE @Items OrderItemType;

-- Add items to the order
INSERT INTO @Items (BookID, Quantity) VALUES (1, 1); -- Harry Potter
INSERT INTO @Items (BookID, Quantity) VALUES (3, 2); -- The Shining

-- Execute the stored procedure
EXEC CreateOrder 
 @CustomerID = @CustomerID,
 @ShippingAddressID = @ShippingAddressID,
 @BillingAddressID = @BillingAddressID,
 @PaymentMethodID = @PaymentMethodID,
 @OrderItems = @Items,
 @PromotionCode = NULL,
 @OrderID = @NewOrderID OUTPUT;
-- Get sales for the last 30 days
EXEC GetSalesDashboard
    @StartDate = DATEADD(DAY, -30, GETDATE()),
    @EndDate = GETDATE();
