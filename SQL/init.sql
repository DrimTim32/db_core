EXEC sp_who2
GO


DBCC CHECKIDENT (Warehouse_orders, RESEED, 0);
GO


