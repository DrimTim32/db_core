use BarProject

--LOCATIONS
go
create function getLocation (
	@id int
)
returns table
as
	return (select name, address, city, postal_code, country, phone from Locations
			where id = @id)


--WAREHOUSE
go
create function getWarehouseProductQuantity (
	@location_id int,
	@product_in_stock_id int
)
returns smallint
as
begin
	declare @quantity smallint
	set @quantity = (select quantity from Warehouse
			where location_id = @location_id and product_in_stock_id = @product_in_stock_id)
	return @quantity
end


go
create function getWarehouseProduct (
	@product_in_stock_id int
)
returns table
as
	return (select * from Warehouse_pretty
			where product_id = @product_in_stock_id)



--SUPPLIERS
go
create function getSupplier (
	@id int
)
returns table
as
	return (select name, address, city, postal_code, country, contact_name, phone, fax, website from Suppliers
			where id = @id)


--WAREHOUSE_ORDERS
go
create function getWarehouseOrder (
	@id int
)
returns table
as
	return (select employee_id, supplier_id, location_id, order_date, required_date, delivery_date from Warehouse_orders
			where id = @id)

go
create function getWarehouseOrderPretty (
	@id int
)
returns table
as
	return (select * from Warehouse_orders_pretty
			where id = @id)


--WAREHOUSE_ORDER_DETAILS
go
create function getWarehouseOrderDetails (
	@warehouse_order_id int
)
returns table
as
	return (select product_id, unit_price, quantity from Warehouse_order_details
			where warehouse_order_id = @warehouse_order_id)

go
create function getWarehouseOrderDetailsPretty (
	@warehouse_order_id int
)
returns table
as
	return (select name, category_name, unit_price, quantity from Warehouse_order_details_pretty
			where id = @warehouse_order_id)



go
create function getWarehouseOrderValue(
	@warehouse_order_id int
)
returns money
as
begin
	declare @result money
	set @result = (select sum(unit_price * quantity) value from Warehouse_order_details
			where warehouse_order_id = @warehouse_order_id)
	return @result
end

--SPOTS
go
create function getSpot (
	@id int
)
returns NVARCHAR(40)
as
begin
	declare @name NVARCHAR(40)
	set @name = (select name from Spots
			where id = @id)
	return @name
end


--CLIENT_ORDERS
go
create function getClientOrder (
	@id int
)
returns table
as
	return (select spot_id, employee_id, order_time, payment_time from Client_orders
			where id = @id)


--CLIENT_ORDER_DETAILS
go
create function getClientOrderDetails (
	@client_order_id int
)
returns table
as
	return (select products_sold_id, unit_price, quantity, spot_id from Client_order_details
			where client_order_id = @client_order_id)

go
create function getClientOrderValue(
	@client_order_id int
)
returns money
as
begin
	declare @result money
	set @result =  (select sum(unit_price * quantity) value from Client_order_details
			where client_order_id = @client_order_id)
	return @result
end

--WORKSTATIONS
go
create function getWorkstation (
	@id int
)
returns NVARCHAR(40)
as
begin
	declare @name NVARCHAR(40)
	set @name = (select name from Workstations
			where id = @id)
	return @name
end

--WORKSTATION_RIGHTS
go
create function getWorkstationRights (
	@workstation_id  int
)
returns table
as

	return (select employe_permissions from Workstation_rights
			where workstation_id = @workstation_id)