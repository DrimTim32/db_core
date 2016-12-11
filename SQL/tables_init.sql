USE BAR

INSERT INTO UnitTypes (type_name) VALUES
  ('vol'),
  ('mass')

INSERT INTO Units (unit_name, convert_factor, unit_type) VALUES
  ('kilogram', 1, 2),
  ('dekagram', 100, 2),
  ('litr', 1, 1),
  ('mililitr', 1000, 1)
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