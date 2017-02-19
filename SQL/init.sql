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

