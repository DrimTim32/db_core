use BarProject

--WAREHOUSE
go
CREATE VIEW Warehouse_pretty
AS
	SELECT 	P.id product_id, P.name, P.category_name,
			W.quantity, 
			L.id location_id, L.name location_name, L.address location_address, L.city location_city, L.postal_code location_postal_code, L.country location_country, L.phone location_phone 
	FROM Warehouse W, Locations L, productSimple P
	WHERE W.location_id = L.id AND W.product_in_stock_id = P.id

--WAREHOUSE_ORDERS	
go	
CREATE VIEW Warehouse_orders_pretty
AS
	SELECT	W.id, W.order_date, W.required_date, W.delivery_date,
			U.username employee_username, U.name employee_name, U.surname employee_surname,
			S.name supplier_name, S. address supplier_address, S.city supplier_city, S.postal_code supplier_postal_code, S.country supplier_country, S.contact_name supplier_contact_name, S.phone supplier_phone, S.fax supplier_fax, S.website supplier_website,
			L.name location_name, L.address location_address, L.city location_city, L.postal_code location_postal_code, L.country location_country, L.phone location_phone 
	FROM Warehouse_orders W, Users U, Suppliers S, Locations L
	WHERE W.employee_id = U.id AND W.supplier_id = S.id AND W.location_id = L.id
	
--WAREHOUSE_ORDER_DETAILS
go
CREATE VIEW Warehouse_order_details_pretty
AS
	SELECT	WO.id, WO.order_date, WO.required_date, WO.delivery_date, WO.employee_username, WO.supplier_name, WO.location_name,
			P.name, P.category_name,
			WOD.unit_price, WOD.quantity
	FROM Warehouse_order_details WOD, Warehouse_orders_pretty WO, productSimple P
	WHERE WOD.warehouse_order_id = WO.id AND WOD.product_id = P.id