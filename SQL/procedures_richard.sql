USE BarProject

--------------------LOCATIONS--------------------
-- ADD
GO
CREATE PROCEDURE addLocation
  (@name        NVARCHAR(40),
   @address     NVARCHAR(60),
   @city        NVARCHAR(15),
   @postal_code NVARCHAR(10),
   @country     NVARCHAR(15),
   @phone       NVARCHAR(25)
  )
AS
  BEGIN
    INSERT INTO Locations (name, address, city, postal_code, country, phone)
    VALUES (@name, @address, @city, @postal_code, @country, @phone)

  END
-- REMOVE
GO
CREATE PROCEDURE removeLocation
  (@id INT
  )
AS
  BEGIN
    DELETE FROM Locations
    WHERE id = @id
  END
-- UPDATE
GO
CREATE PROCEDURE updateLocation
  (@id              INT,
   @new_name        NVARCHAR(40),
   @new_address     NVARCHAR(60),
   @new_city        NVARCHAR(15),
   @new_postal_code NVARCHAR(10),
   @new_country     NVARCHAR(15),
   @new_phone       NVARCHAR(25)
  )
AS
  BEGIN
    IF @new_name != ''
      UPDATE Locations
      SET name = @new_name
      WHERE id = @id
    IF @new_address != ''
      UPDATE Locations
      SET address = @new_address
      WHERE id = @id
    IF @new_city != ''
      UPDATE Locations
      SET city = @new_city
      WHERE id = @id
    IF @new_postal_code != ''
      UPDATE Locations
      SET postal_code = @new_postal_code
      WHERE id = @id
    IF @new_country != ''
      UPDATE Locations
      SET country = @new_country
      WHERE id = @id
    IF @new_phone != ''
      UPDATE Locations
      SET phone = @new_phone
      WHERE id = @id
  END

--------------------SUPPLIERS--------------------
-- ADD
GO
CREATE PROCEDURE addSupplier
  (
    @name         NVARCHAR(40),
    @address      NVARCHAR(60),
    @city         NVARCHAR(15),
    @postal_code  NVARCHAR(10),
    @country      NVARCHAR(15),
    @contact_name NVARCHAR(30),
    @phone        NVARCHAR(25),
    @fax          NVARCHAR(25),
    @website      NVARCHAR(MAX)
  )
AS
  BEGIN
    INSERT INTO Suppliers (name, address, city, postal_code, country, contact_name, phone, fax, website)
    VALUES (@name, @address, @city, @postal_code, @country, @contact_name, @phone, @fax, @website)
  END
-- REMOVE
GO
CREATE PROCEDURE removeSupplier
  (@id INT
  )
AS
  BEGIN
    DELETE FROM Suppliers
    WHERE id = @id
  END
-- UPDATE
GO
CREATE PROCEDURE updateSupplier
  (@id               INT,
   @new_name         NVARCHAR(40),
   @new_address      NVARCHAR(60),
   @new_city         NVARCHAR(15),
   @new_postal_code  NVARCHAR(10),
   @new_country      NVARCHAR(15),
   @new_contact_name NVARCHAR(30),
   @new_phone        NVARCHAR(25),
   @new_fax          NVARCHAR(25),
   @new_website      NVARCHAR(MAX)
  )
AS
  BEGIN
    IF @new_name != ''
      UPDATE Suppliers
      SET name = @new_name
      WHERE id = @id
    IF @new_address != ''
      UPDATE Suppliers
      SET address = @new_address
      WHERE id = @id
    IF @new_city != ''
      UPDATE Suppliers
      SET city = @new_city
      WHERE id = @id
    IF @new_postal_code != ''
      UPDATE Suppliers
      SET postal_code = @new_postal_code
      WHERE id = @id
    IF @new_country != ''
      UPDATE Suppliers
      SET country = @new_country
      WHERE id = @id
    IF @new_contact_name != ''
      UPDATE Suppliers
      SET contact_name = @new_contact_name
      WHERE id = @id
    IF @new_phone != ''
      UPDATE Suppliers
      SET phone = @new_phone
      WHERE id = @id
    IF @new_fax != ''
      UPDATE Suppliers
      SET fax = @new_fax
      WHERE id = @id
    IF @new_website != ''
      UPDATE Suppliers
      SET website = @new_website
      WHERE id = @id
  END

--------------------SPOTS--------------------
-- ADD
GO
CREATE PROCEDURE addSpot
  (
    @name        NVARCHAR(40),
    @location_id INT
  )
AS
  BEGIN
    INSERT INTO Spots (name, location_id)
    VALUES (@name, @location_id)
  END
-- REMOVE
GO
CREATE PROCEDURE removeSpot
  (@id INT
  )
AS
  BEGIN
    DELETE FROM Spots
    WHERE id = @id
  END
-- UPDATE
GO
CREATE PROCEDURE updateSpot
  (@id       INT,
   @new_name NVARCHAR(40)
  )
AS
  BEGIN
    IF @new_name != ''
      UPDATE Spots
      SET name = @new_name
      WHERE id = @id
  END
--------------------WORKSTATIONS--------------------
-- ADD
GO
CREATE PROCEDURE addWorkstation
  (
    @name        NVARCHAR(40),
    @location_id INT
  )
AS
  BEGIN
    INSERT INTO Workstations (name, location_id)
    VALUES (@name, @location_id)
  END
-- REMOVE
GO
CREATE PROCEDURE removeWorkstation
  (@id INT
  )
AS
  BEGIN
    DELETE FROM Workstation
    WHERE id = @id
  END
-- UPDATE
GO
CREATE PROCEDURE updateWorkstation
  (@id       INT,
   @new_name NVARCHAR(40)
  )
AS
  BEGIN
    IF @new_name != ''
      UPDATE Workstations
      SET name = @new_name
      WHERE id = @id
  END
--------------------WAREHOUSE--------------------
-- ADD to

GO
CREATE PROCEDURE addToWarehouse
  (
    @location_id         INT,
    @product_in_stock_id INT,
    @quantity            SMALLINT
  )
AS
  BEGIN
    INSERT INTO Warehouse (location_id, product_in_stock_id, quantity)
    VALUES (@location_id, @product_in_stock_id, @quantity)
  END
-- REMOVE from
GO
CREATE PROCEDURE removeFromWarehouse -- usuwa caly wierz, a NIE zmniejsza o 1
  (@location_id         INT,
   @product_in_stock_id INT
  )
AS
  BEGIN
    DELETE FROM Warehouse
    WHERE location_id = @location_id
          AND product_in_stock_id = @product_in_stock_id
  END
-- UPDATE quantity
GO
CREATE PROCEDURE updateQuantityInWarehouse -- argument mowi o ile zwiekszyc/zmniejszyc quantity produktu w magazynie
  (
    @location_id         INT,
    @product_in_stock_id INT,
    @quantity_change     SMALLINT
  )
AS
  BEGIN
    UPDATE Warehouse
    SET quantity = quantity + @quantity_change
    WHERE location_id = @location_id
          AND product_in_stock_id = @product_in_stock_id

    --pasowa?by tutaj trigger, kt�ry po updacie sprawdza czy quantity jest = 0 i je?li tak to usuwa dany wiersz
  END
GO
-- TRIGGERS 
--T_01 usuwa wiersze, ktore po update maja quantity 0
CREATE TRIGGER checkQuantityAfterWarehouseUpdate
  ON Warehouse
AFTER UPDATE
AS
  BEGIN
    DELETE FROM Warehouse
    WHERE quantity = 0
  END

--------------------WORKSTATION RIGHTS--------------------
-- ADD
GO
CREATE PROCEDURE addWorkstationRights
  (@workstation_id     INT,
   @employe_permission TINYINT
  )
AS
  BEGIN
    INSERT INTO Workstation_rights (workstation_id, employe_permissions)
    VALUES (@workstation_id, @employe_permission)
  END

-- REMOVE
GO
CREATE PROCEDURE removeWorkstationRights
  (@workstation_id     INT,
   @employe_permission TINYINT
  )
AS
  BEGIN
    DELETE FROM Workstation_rights
    WHERE workstation_id = @workstation_id AND employe_permissions = @employe_permission
  END
--------------------WAREHOUSE ORDERS--------------------
-- ADD
GO
CREATE PROCEDURE addWarehouseOrder
  (@employee_id   INT,
   @supplier_id   INT,
   @location_id   INT,
   @order_date    DATETIME,
   @required_date DATETIME,
   @delivery_date DATETIME
  )
AS
  BEGIN
    INSERT INTO Warehouse_orders (employee_id, supplier_id, location_id, order_date, required_date, delivery_date)
    VALUES (@employee_id, @supplier_id, @location_id, @order_date, @required_date, @delivery_date)

  END
-- REMOVE
GO
CREATE PROCEDURE removeWarehouseOrder
  (@id INT
  )
AS
  BEGIN
    DELETE FROM Warehouse_orders
    WHERE id = @id
  END
-- UPDATE
GO
CREATE PROCEDURE updateWarehouseOrder
  (@id                INT,
   @new_employee_id   INT,
   @new_supplier_id   INT,
   @new_location_id   INT,
   @new_order_date    DATETIME,
   @new_required_date DATETIME,
   @new_delivery_date DATETIME
  )
AS
  BEGIN
    IF @new_employee_id > 0
      UPDATE Warehouse_orders
      SET employee_id = @new_employee_id
      WHERE id = @id
    IF @new_supplier_id > 0
      UPDATE Warehouse_orders
      SET supplier_id = @new_supplier_id
      WHERE id = @id
    IF @new_location_id > 0
      UPDATE Warehouse_orders
      SET location_id = @new_location_id
      WHERE id = @id
    IF @new_order_date IS NOT NULL
      UPDATE Warehouse_orders
      SET order_date = @new_order_date
      WHERE id = @id
    IF @new_required_date IS NOT NULL
      UPDATE Warehouse_orders
      SET required_date = @new_required_date
      WHERE id = @id
    IF @new_delivery_date IS NOT NULL
      UPDATE Warehouse_orders
      SET delivery_date = @new_delivery_date
      WHERE id = @id
  END

--------------------CLIENT ORDERS--------------------
-- ADD
GO
CREATE PROCEDURE addClientOrder
  (@spot_id      INT,
   @employee_id  INT,
   @order_time   DATETIME,
   @payment_time DATETIME
  )
AS
  BEGIN
    INSERT INTO Client_orders (spot_id, employee_id, order_time, payment_time)
    VALUES (@spot_id, @employee_id, @order_time, @payment_time)

  END
-- REMOVE
GO
CREATE PROCEDURE removeClientOrder
  (@id INT
  )
AS
  BEGIN
    DELETE FROM Client_orders
    WHERE id = @id
  END
-- UPDATE
GO
CREATE PROCEDURE updateClientOrder
  (@id               INT,
   @new_spot_id      INT,
   @new_employee_id  INT,
   @new_order_time   DATETIME,
   @new_payment_time DATETIME
  )
AS
  BEGIN
    IF @new_spot_id > 0
      UPDATE Client_orders
      SET spot_id = @new_spot_id
      WHERE id = @id
    IF @new_employee_id > 0
      UPDATE Client_orders
      SET employee_id = @new_employee_id
      WHERE id = @id
    IF @new_order_time IS NOT NULL
      UPDATE Client_orders
      SET order_time = @new_order_time
      WHERE id = @id
    IF @new_payment_time IS NOT NULL
      UPDATE Client_orders
      SET payment_time = @new_payment_time
      WHERE id = @id
  END

--------------------WAREHOUSE ORDER DETAILS--------------------
-- ADD
GO
CREATE PROCEDURE addWarehouseOrderDetail -- OK
  (@warehouse_order_id INT,
   @product_id         INT,
   @quantity           SMALLINT
  )
AS
  BEGIN
    INSERT INTO Warehouse_order_details (warehouse_order_id, product_id, quantity)
    VALUES (@warehouse_order_id, @product_id, @quantity)

  END
-- REMOVE
GO
CREATE PROCEDURE removeWarehouseOrderDetail --trigger do usuwania ordera jak nie ma order details�w -- OK
  (@warehouse_order_id INT,
   @product_id         INT
  )
AS
  BEGIN
    DELETE FROM Warehouse_order_details
    WHERE warehouse_order_id = @warehouse_order_id AND product_id = @product_id
  END
-- UPDATE
GO
CREATE PROCEDURE updateWarehouseOrderDetail
  (@warehouse_order_id INT,
   @product_id         INT,
   @new_quantity       SMALLINT
  )
AS
  BEGIN
    IF @new_quantity > 0
      UPDATE Warehouse_order_details
      SET quantity = @new_quantity
      WHERE warehouse_order_id = @warehouse_order_id AND product_id = @product_id
  END

-- TRIGGERS
-- T_01
GO
CREATE TRIGGER checkNumberOfWarehouseOrderDetails
  ON Warehouse_order_details
AFTER DELETE
AS
  BEGIN
    DECLARE @warehouse_order_id INT
    DECLARE @product_id INT
    SET @warehouse_order_id = (SELECT warehouse_order_id
                               FROM deleted)
    SET @product_id = (SELECT product_id
                       FROM deleted)

    IF NOT exists(SELECT *
                  FROM Warehouse_order_details
                  WHERE warehouse_order_id = @warehouse_order_id AND product_id = @product_id)
      DELETE FROM Warehouse_orders
      WHERE id = @warehouse_order_id
  END
--------------------CLIENT ORDER DETAILS--------------------
-- ADD
GO
CREATE PROCEDURE addClientOrderDetail --trigger do pobierania aktualnej ceny produktu -- OK
  (@client_order_id  INT,
   @products_sold_id INT,
   @quantity         SMALLINT
  )
AS
  BEGIN
    INSERT INTO Client_order_details (client_order_id, products_sold_id, quantity)
    VALUES (@client_order_id, @products_sold_id, @quantity)

  END
-- REMOVE
GO
CREATE PROCEDURE removeClientOrderDetail --trigger do usuwania ordera jak nie ma order details�w -- OK
  (@client_order_id  INT,
   @products_sold_id INT
  )
AS
  BEGIN
    DELETE FROM Client_order_details
    WHERE client_order_id = @client_order_id AND products_sold_id = @products_sold_id
  END
-- UPDATE
GO
CREATE PROCEDURE updateClientOrderDetail
  (@client_order_id  INT,
   @products_sold_id INT,
   @new_quantity     SMALLINT
  )
AS
  BEGIN
    IF @new_quantity > 0
      UPDATE Client_order_details
      SET quantity = @new_quantity
      WHERE client_order_id = @client_order_id AND products_sold_id = @products_sold_id
  END

-- TRIGGERS
-- T_01
GO
CREATE TRIGGER checkNumberOfClientOrderDetails
  ON Client_order_details
AFTER DELETE
AS
  BEGIN
    DECLARE @client_order_id INT
    DECLARE @products_sold_id INT
    SET @client_order_id = (SELECT client_order_id
                            FROM deleted)
    SET @products_sold_id = (SELECT products_sold_id
                             FROM deleted)

    IF NOT exists(SELECT *
                  FROM Client_order_details
                  WHERE client_order_id = @client_order_id AND products_sold_id = @products_sold_id)
      DELETE FROM Client_orders
      WHERE id = @client_order_id
  END
