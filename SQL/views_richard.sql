USE BarProject

--WAREHOUSE
GO
CREATE VIEW Warehouse_pretty
AS
  SELECT
    P.id          product_id,
    P.name,
    P.category_name,
    W.quantity,
    L.id          location_id,
    L.name        location_name,
    L.address     location_address,
    L.city        location_city,
    L.postal_code location_postal_code,
    L.country     location_country,
    L.phone       location_phone
  FROM Warehouse AS W
    JOIN Locations AS L ON W.location_id = L.id
    JOIN productSimple AS P ON W.product_in_stock_id = P.id

--WAREHOUSE_ORDERS	
GO
CREATE VIEW Warehouse_orders_pretty
AS
  SELECT
    W.id,
    W.order_date,
    W.required_date,
    W.delivery_date,
    (SELECT sum(WOD.unit_price * WOD.quantity)
     FROM Warehouse_order_details WOD
     WHERE WOD.warehouse_order_id = W.id
    )              value,
    U.username     employee_username,
    U.name         employee_name,
    U.surname      employee_surname,
    S.name         supplier_name,
    S.address      supplier_address,
    S.city         supplier_city,
    S.postal_code  supplier_postal_code,
    S.country      supplier_country,
    S.contact_name supplier_contact_name,
    S.phone        supplier_phone,
    S.fax          supplier_fax,
    S.website      supplier_website,
    L.name         location_name,
    L.address      location_address,
    L.city         location_city,
    L.postal_code  location_postal_code,
    L.country      location_country,
    L.phone        location_phone
  FROM Warehouse_orders AS W
    JOIN Users AS U ON W.employee_id = U.id
    JOIN Suppliers AS S ON W.supplier_id = S.id
    JOIN Locations AS L ON W.location_id = L.id

--WAREHOUSE_ORDER_DETAILS
GO
CREATE VIEW Warehouse_order_details_pretty
AS
  SELECT
    WO.id,
    WO.order_date,
    WO.required_date,
    WO.delivery_date,
    WO.employee_username,
    WO.supplier_name,
    WO.location_name,
    P.name,
    P.category_name,
    WOD.unit_price purchase_price,
    WOD.quantity
  FROM Warehouse_order_details AS WOD
    JOIN Warehouse_orders_pretty AS WO ON WOD.warehouse_order_id = WO.id
    JOIN productSimple AS P ON WOD.product_id = P.id
GO

--WORKSTATIONS, WORKSTATIONS_RIGHTS AND LOCATIONS
CREATE VIEW Workstations_with_rights_pretty
AS
  SELECT
    W.id   workstation_id,
    W.name workstation_name,
    WR.employe_permissions,
    L.id,
    L.name location_name,
    L.city
  FROM Workstations AS W
    JOIN Workstation_rights AS WR ON W.id = WR.workstation_id
    JOIN Locations AS L ON L.id = W.location_id
GO

--CLIENT_ORDERS
CREATE VIEW Client_orders_pretty
AS
  SELECT
    CO.id,
    CO.order_time,
    CO.payment_time,
    (SELECT sum(PLP.price * COD.quantity)
     FROM Client_order_details COD
       CROSS APPLY productsHistoryPrices(CO.order_time) AS PLP
     WHERE COD.products_sold_id = PLP.product_id AND COD.client_order_id = CO.id
    )      value,
    CO.spot_id,
    S.name spot_name,
    S.location_id,
    L.name location_name,
    L.address,
    CO.employee_id,
    U.username,
    U.name user_name,
    U.surname
  FROM Client_orders AS CO
    JOIN Spots AS S ON CO.spot_id = S.id
    JOIN Users AS U ON CO.employee_id = U.id
    JOIN Locations AS L ON S.location_id = L.id
GO

--CLIENT_ORDER_DETAILS
CREATE VIEW Client_order_details_pretty
AS
  SELECT
    CO.id,
    COD.products_sold_id,
    P.name product_name,
    P.category_name,
    PLP.price,
    COD.quantity,
    CO.order_time,
    CO.payment_time,
    CO.spot_id,
    CO.spot_name,
    CO.location_id,
    CO.location_name,
    CO.address,
    CO.employee_id,
    CO.username,
    CO.user_name,
    CO.surname
  FROM Client_order_details AS COD
    JOIN Client_orders_pretty AS CO ON COD.client_order_id = CO.id
    JOIN productSimple AS P ON COD.products_sold_id = P.id
    CROSS APPLY productsHistoryPrices(CO.order_time) AS PLP
  WHERE P.id = PLP.product_id
