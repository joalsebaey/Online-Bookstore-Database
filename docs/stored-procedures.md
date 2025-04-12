# Stored Procedures Documentation

This document describes the stored procedures available in the Online Bookstore Database System, their parameters, and usage examples.

## Order Management Procedures

### CreateOrder

Creates a new order with the specified items.

**Parameters:**
- `@CustomerID` (INT): The ID of the customer placing the order
- `@ShippingAddressID` (INT): The ID of the shipping address
- `@BillingAddressID` (INT): The ID of the billing address
- `@PaymentMethodID` (INT): The ID of the payment method
- `@OrderItems` (OrderItemType): Table-valued parameter with book IDs and quantities
- `@PromotionCode` (NVARCHAR(20)): Optional promotion code
- `@OrderID` (INT, OUTPUT): Returns the newly created order ID

**Example Usage:**
```sql
DECLARE @CustomerID INT = 1;
DECLARE @ShippingAddressID INT = 2;
DECLARE @BillingAddressID INT = 1;
DECLARE @PaymentMethodID INT = 1;
DECLARE @NewOrderID INT;

DECLARE @Items OrderItemType;
INSERT INTO @Items (BookID, Quantity) VALUES (1, 1); -- Harry Potter
INSERT INTO @Items (BookID, Quantity) VALUES (3, 2); -- The Shining

EXEC CreateOrder 
    @CustomerID = @CustomerID,
    @ShippingAddressID = @ShippingAddressID,
    @BillingAddressID = @BillingAddressID,
    @PaymentMethodID = @PaymentMethodID,
    @OrderItems = @Items,
    @PromotionCode = NULL,
    @OrderID = @NewOrderID OUTPUT;
