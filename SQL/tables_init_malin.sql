USE BarProject


INSERT INTO EmployePermissions(name,value)
VALUES 
(N'admin',255), 
(N'Owner',127),  
(N'WarehouseAdministrator',16), 
(N'Cook',2), 
(N'Waitresss',1), 
(N'NoUser',0)

DECLARE	@return_value int

EXEC	@return_value = [dbo].[addUser]
		@password = N'qwerty',
		@username = N'malin',
		@name = N'marcin',
		@surname = N'malinowski',
		@permission = 255 


DECLARE	@return_value int
EXEC @return_value = checkCredentials
		@username = N'malin',
		@password = N'qwerty'
print @return_value
		
