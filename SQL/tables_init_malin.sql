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


DECLARE	@return_value int,
		@tmp_credentials smallint

EXEC	@return_value = [dbo].[checkCredentials]
		@username = N'malin',
		@password = N'qwerty',
		@tmp_credentials = @tmp_credentials OUTPUT

SELECT	@tmp_credentials as N'@tmp_credentials'
