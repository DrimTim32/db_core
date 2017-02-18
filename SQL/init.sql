EXEC sp_who2
GO


DBCC CHECKIDENT (Client_orders, RESEED, 0);
GO


EXEC markDelivered 1

EXEC markPaid 1

EXEC markPaid 2