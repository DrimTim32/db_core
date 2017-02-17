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
-- TRIGGERS 
--T_01 usuwa wiersze, ktore po update maja quantity 0
create trigger checkQuantityAfterWarehouseUpdate 
after update 
on Warehouse
begin
	delete from Warehouse
	where quantity = 0
end

--------------------WORKSTATION RIGHTS--------------------
-- ADD
go
create procedure addWorkstationRights
(	@workstation_id int,
	@employe_permission tinyint
)
as
begin 
	insert into Workstation_rights(workstation_id, employe_permissions)
	values (@workstation_id, @employe_permission)
end

-- REMOVE
go
create procedure removeWorkstationRights
(	@workstation_id int,
	@employe_permission tinyint
)
as
begin 
	delete from Workstation_rights 
	where workstation_id=@workstation_id and employe_permissions=@employe_permission
end
--------------------WAREHOUSE ORDERS--------------------
-- ADD
go
create procedure addWarehouseOrder
(	@employee_id int,
	@supplier_id int,
	@location_id int,
	@order_date datetime,
	@required_date datetime,
	@delivery_date datetime
)
as
begin 
	insert into Warehouse_orders(employee_id, supplier_id, location_id, order_date, required_date, delivery_date)
	values (@employee_id, @supplier_id, @location_id, @order_date, @required_date, @delivery_date)

end
-- REMOVE
go
create procedure removeWarehouseOrder
(	@id int
)
as
begin 
	delete from Warehouse_orders 
	where id=@id
end
-- UPDATE
go
create procedure updateWarehouseOrder
(	@id int,
	@new_employee_id int,
	@new_supplier_id int,
	@new_location_id int,
	@new_order_date datetime,
	@new_required_date datetime,
	@new_delivery_date datetime
)
as
begin 
	if @new_employee_id > 0
		update Warehouse_orders
		set employee_id = @new_employee_id
		WHERE id=@id
	if @new_supplier_id > 0
		update Warehouse_orders
		set supplier_id = @new_supplier_id
		WHERE id=@id
	if @new_location_id > 0
		update Warehouse_orders
		set location_id = @new_location_id
		WHERE id=@id
	if @new_order_date is not null
		update Warehouse_orders
		set order_date = @new_order_date
		WHERE id=@id
	if @new_required_date is not null
		update Warehouse_orders
		set required_date = @new_required_date
		WHERE id=@id
	if @new_delivery_date is not null
		update Warehouse_orders
		set delivery_date = @new_delivery_date
		WHERE id=@id
end

-- TRIGGERS 
--T_01 
go
create trigger deleteWarehouseOrderDetailsWhenRemovingOrder  
on Warehouse_orders
instead of delete
as
begin
	declare @id int
	set @id = (select id from deleted)
	delete from Warehouse_order_details
	where warehouse_order_id = @id
	
	delete from Warehouse_orders
	where id=@id
end
--------------------CLIENT ORDERS--------------------
-- ADD
go
create procedure addClientOrder
(	@spot_id int,
	@employee_id int,
	@order_time datetime,
	@payment_time datetime
)
as
begin 
	insert into Client_orders(spot_id, employee_id, order_time, payment_time)
	values (@spot_id, @employee_id, @order_time, @payment_time)

end
-- REMOVE
go
create procedure removeClientOrder
(	@id int
)
as
begin 
	delete from Client_orders 
	where id=@id
end
-- UPDATE
go
create procedure updateClientOrder
(	@id int,
	@new_spot_id int,
	@new_employee_id int,
	@new_order_time datetime,
	@new_payment_time datetime
)
as
begin 
	if @new_spot_id > 0
		update Client_orders
		set spot_id = @new_spot_id
		WHERE id=@id
	if @new_employee_id > 0
		update Client_orders
		set employee_id = @new_employee_id
		WHERE id=@id
	if @new_order_time is not null
		update Client_orders
		set order_time = @new_order_time
		WHERE id=@id
	if @new_payment_time is not null
		update Client_orders
		set payment_time = @new_payment_time
		WHERE id=@id
end

-- TRIGGERS
-- T_01
go
create trigger deleteClientOrderDetailsWhenRemovingOrder 
on Client_orders
instead of delete
as
begin
	declare @id int
	set @id = (select id from deleted)
	delete from Client_orders_details
	where client_order_id = @id
	
	delete from Client_orders 
	where id=@id
end
--------------------WAREHOUSE ORDER DETAILS--------------------
-- ADD
go
create procedure addWarehouseOrderDetail -- OK
(	@warehouse_order_id int,
	@product_id int,
	@unit_price money,
	@quantity smallint
)
as
begin 
	insert into Warehouse_order_details(warehouse_order_id, product_id, unit_price, quantity)
	values (@warehouse_order_id, @product_id, @unit_price, @quantity)

end
-- REMOVE
go
create procedure removeWarehouseOrderDetail --trigger do usuwania ordera jak nie ma order detailsów -- OK
(	@warehouse_order_id int,
	@product_id int
)
as
begin 
	delete from Warehouse_order_details 
	where warehouse_order_id=@warehouse_order_id and product_id=@product_id 
end
-- UPDATE
go
create procedure updateWarehouseOrderDetail
(	@warehouse_order_id int,
	@product_id int,
	@new_unit_price money,
	@new_quantity smallint
)
as
begin 
	if @new_unit_price > 0
		update Warehouse_order_details
		set unit_price = @new_unit_price
		WHERE warehouse_order_id=@warehouse_order_id and product_id=@product_id 
	if @new_quantity > 0
		update Warehouse_order_details
		set quantity = @new_quantity
		WHERE warehouse_order_id=@warehouse_order_id and product_id=@product_id 
end

-- TRIGGERS
-- T_01
go
create trigger checkNumberOfWarehouseOrderDetails 
on Warehouse_order_details
after delete 
as
begin
	declare @warehouse_order_id int
	declare @product_id int
	set @warehouse_order_id = (select warehouse_order_id from deleted)
	set @product_id = (select product_id from deleted)
	
	if not exists(select * from Warehouse_order_details where warehouse_order_id=@warehouse_order_id and product_id=@product_id )
		delete from Warehouse_orders
		where id=@warehouse_order_id
end
--------------------CLIENT ORDER DETAILS--------------------
-- ADD
go
create procedure addClientOrderDetail --trigger do pobierania aktualnej ceny produktu -- OK
(	@client_order_id int,
	@products_sold_id int,
	@unit_price money,
	@quantity smallint,
	@spot_id int
)
as
begin 
	insert into Client_order_details(client_order_id, products_sold_id, unit_price, quantity, spot_id)
	values (@client_order_id, @products_sold_id, @unit_price, @quantity, @spot_id)

end
-- REMOVE
go
create procedure removeClientOrderDetail --trigger do usuwania ordera jak nie ma order detailsów -- OK
(	@client_order_id int,
	@products_sold_id int
)
as
begin 
	delete from Client_order_details 
	where client_order_id=@client_order_id and products_sold_id=@products_sold_id 
end
-- UPDATE
go
create procedure updateClientOrderDetail
(	@client_order_id int,
	@products_sold_id int,
	@new_unit_price money,
	@new_quantity smallint,
	@new_spot_id int
)
as
begin 
	if @new_unit_price > 0
		update Client_order_details
		set unit_price = @new_unit_price
		WHERE client_order_id=@client_order_id and products_sold_id=@products_sold_id 
	if @new_quantity > 0
		update Client_order_details
		set quantity = @new_quantity
		WHERE client_order_id=@client_order_id and products_sold_id=@products_sold_id 
	if @new_spot_id > 0
		update Client_order_details
		set spot_id = @new_spot_id
		WHERE client_order_id=@client_order_id and products_sold_id=@products_sold_id 
end

-- TRIGGERS
-- T_01
go
create trigger checkNumberOfClientOrderDetails 
on Client_order_details
after delete 
as
begin
	declare @client_order_id int
	declare @products_sold_id int
	set @client_order_id = (select client_order_id from deleted)
	set @products_sold_id = (select products_sold_id from deleted)
	
	if not exists(select * from Client_order_details where client_order_id=@client_order_id and products_sold_id=@products_sold_id )
		delete from Client_orders
		where id=@client_order_id
end
-- T_02
go
create trigger insertClientOrderDetailWithPrice 
on Client_order_details
instead of insert
as
begin
	declare @product_id int
	set @product_id = (select products_sold_id from inserted)
	declare @recent_change_date date
	set @recent_change_date = (select period_start from Prices where product_id = @product_id)
	declare @price money
	set @price = (select price from Prices where product_id = @product_id and period_start = @recent_change_date)
  insert into Client_order_details
       select client_order_id, @product_id, @price, quantity, spot_id
       from inserted
end
-- T_03
go
create trigger updateClientOrderDetailWithPrice 
on Client_order_details
after update
as
begin
	declare @product_id int
	set @product_id = (select products_sold_id from inserted)
	declare @recent_change_date date
	set @recent_change_date = (select period_start from Prices where product_id = @product_id)
	declare @old_price money
	set @old_price = (select price from Prices where product_id = @product_id and period_start = @recent_change_date)
	declare @new_price money
	set @new_price = (select unit_price from inserted)
	
	if @old_price != @new_price
		exec dbo.updatePrice @product_id, @new_price
end


