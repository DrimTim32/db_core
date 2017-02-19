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