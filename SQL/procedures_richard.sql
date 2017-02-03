USE BarProject

--------------------LOCATIONS--------------------
-- ADD
go
create procedure addLocation
(	@name nvarchar(40),
	@address nvarchar(60),
	@city nvarchar(15),
	@postal_code nvarchar(10),
	@country nvarchar(15),
	@phone nvarchar(25)
)
as
begin 
	insert into Locations(name, address, city, postal_code, country, phone)
	values (@name, @address, @city, @postal_code, @country, @phone)

end
-- REMOVE
go
create procedure removeLocation
(	@id int
)
as
begin 
	delete from Locations 
	where id=@id
end
-- UPDATE
go
create procedure updateLocation
(	@id int,
	@new_name nvarchar(40),
	@new_address nvarchar(60),
	@new_city nvarchar(15),
	@new_postal_code nvarchar(10),
	@new_country nvarchar(15),
	@new_phone nvarchar(25)
)
as
begin 
	if @new_name != ''
		update Locations
		set name = @new_name
		WHERE id=@id
	if @new_address != ''
		update Locations
		set address = @new_address
		WHERE id=@id
	if @new_city != ''
		update Locations
		set city = @new_city
		WHERE id=@id
	if @new_postal_code != ''
		update Locations
		set postal_code = @new_postal_code
		WHERE id=@id
	if @new_country != ''
		update Locations
		set country = @new_country
		WHERE id=@id
	if @new_phone != ''
		update Locations
		set phone = @new_phone
		WHERE id=@id
end

--------------------SUPPLIERS--------------------
-- ADD
go
create procedure addSupplier
(	
	@name nvarchar(40),
	@address nvarchar(60),
	@city nvarchar(15),
	@postal_code nvarchar(10),
	@country nvarchar(15),
	@contact_name nvarchar(30),
	@phone nvarchar(25),
	@fax nvarchar(25),
	@website nvarchar(max)
)
as
begin 
	insert into Suppliers(name, address, city, postal_code, country, contact_name, phone, fax, website)
	values (@name, @address, @city, @postal_code, @country, @contact_name, @phone, @fax, @website)
end
-- REMOVE
go
create procedure removeSupplier
(	@id int
)
as
begin 
	delete from Suppliers
	where id=@id
end
-- UPDATE
go
create procedure updateSupplier
(	@id int,
	@new_name nvarchar(40),
	@new_address nvarchar(60),
	@new_city nvarchar(15),
	@new_postal_code nvarchar(10),
	@new_country nvarchar(15),
	@new_contact_name nvarchar(30),
	@new_phone nvarchar(25),
	@new_fax nvarchar(25),
	@new_website nvarchar(max)
)
as
begin 
	if @new_name != ''
		update Suppliers
		set name = @new_name
		WHERE id=@id
	if @new_address != ''
		update Suppliers
		set address = @new_address
		WHERE id=@id
	if @new_city != ''
		update Suppliers
		set city = @new_city
		WHERE id=@id
	if @new_postal_code != ''
		update Suppliers
		set postal_code = @new_postal_code
		WHERE id=@id
	if @new_country != ''
		update Suppliers
		set country = @new_country
		WHERE id=@id
	if @new_contact_name != ''
		update Suppliers
		set contact_name = @new_contact_name
		WHERE id=@id
	if @new_phone != ''
		update Suppliers
		set phone = @new_phone
		WHERE id=@id
	if @new_fax != ''
		update Suppliers
		set fax = @new_fax
		WHERE id=@id
	if @new_website != ''
		update Suppliers
		set website = @new_website
		WHERE id=@id
end

--------------------SPOTS--------------------
-- ADD
go
create procedure addSpot
(	
	@name nvarchar(40)
)
as
begin 
	insert into Spots(name)
	values (@name)
end
-- REMOVE
go
create procedure removeSpot
(	@id int
)
as
begin 
	delete from Spots
	where id=@id
end
-- UPDATE
go
create procedure updateSpot
(	@id int,
	@new_name nvarchar(40)
)
as
begin 
	if @new_name != ''
		update Spots
		set name = @new_name
		WHERE id=@id
end
--------------------WORKSTATIONS--------------------
-- ADD
go
create procedure addWorkstation
(	
	@name nvarchar(40)
)
as
begin 
	insert into Workstations(name)
	values (@name)
end
-- REMOVE
go
create procedure removeWorkstation
(	@id int
)
as
begin 
	delete from Workstation
	where id=@id
end
-- UPDATE
go
create procedure updateWorkstation
(	@id int,
	@new_name nvarchar(40)
)
as
begin 
	if @new_name != ''
		update Workstations
		set name = @new_name
		WHERE id=@id
end
--------------------WAREHOUSE--------------------
-- ADD to
/*
	location_id int not null,
	product_in_stock_id int not null,
	quantity smallint not null,
	primary key (location_id, product_in_stock_id),
	foreign key (location_id) references Locations(id), 
	foreign key (product_in_stock_id) references Products(id) -- Products = tabela Bartka (artykuly spozywcze; spr. zgodnoœæ nazwy)
	on delete cascade
*/
go
create procedure addToWarehouse
(	
	@location_id int,
	@product_in_stock_id int,
	@quantity smallint
)
as
begin 
	insert into Warehouse(location_id, product_in_stock_id, quantity)
	values (@location_id, @product_in_stock_id, @quantity)
end
-- REMOVE from
go
create procedure removeFromWarehouse -- usuwa caly wierz, a NIE zmniejsza o 1
(	@location_id int,
	@product_in_stock_id int
)
as
begin 
	delete from Warehouse
	where	location_id=@location_id
			and product_in_stock_id = @product_in_stock_id
end
-- UPDATE quantity
go
create procedure updateQuantityInWarehouse -- argument mowi o ile zwiekszyc/zmniejszyc quantity produktu w magazynie
(	
	@location_id int,
	@product_in_stock_id int,
	@quantity_change smallint
)
as
begin 
	update Warehouse
	set quantity = quantity + @quantity_change 
	where	location_id=@location_id
			and product_in_stock_id = @product_in_stock_id

			--pasowa³by tutaj trigger, który po updacie sprawdza czy quantity jest = 0 i jeœli tak to usuwa dany wiersz
end
