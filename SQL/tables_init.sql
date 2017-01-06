USE BarProject


  -- dodawanie administratora 
EXEC	[dbo].[AddEmployee]
		@name = N'Marcin',
		@surname = N'Malinowski',
		@phone = N'+48123123123',
		@position = 255
		 

exec  [dbo].[AddUserByInfo]
		@password = N'qwerty',
		@username = N'malin',
		@name = 'Marcin',
		@surname = 'Malinowski'
