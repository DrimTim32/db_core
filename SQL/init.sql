EXEC sp_who2
GO


DBCC CHECKIDENT (Client_orders, RESEED, 0);
GO


EXEC markDelivered 1

EXEC markPaid 1

EXEC markPaid 2

PRINT IDENT_CURRENT('Products')
GO


SELECT *
FROM Client_order_details_pretty

SELECT *
FROM Client_orders_pretty

SELECT *
FROM Warehouse_orders_pretty

SELECT *
FROM Client_order_details COD
  CROSS APPLY productsHistoryPrices('2017-02-18') AS PLP
WHERE COD.products_sold_id = PLP.product_id


SELECT *
FROM soldProductDetails(7)


EXEC updatePrice 6, 14
GO

DECLARE @dd MONEY
SET @dd = (SELECT price
           FROM productsLastPrices
           WHERE product_id = 6)
IF @dd IS NULL
  BEGIN
    PRINT 'dd'
  END
GO

EXEC addProduct NULL, NULL, NULL, 'hhhhhhh'

SELECT *
FROM productDetails(6)


SELECT *
FROM recipeDetails(1)


