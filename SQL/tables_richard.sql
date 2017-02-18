--create database BarProject

USE BarProject

CREATE TABLE Locations -- OK
(
  id          INT IDENTITY (1, 1) NOT NULL,
  name        NVARCHAR(40)        NOT NULL,
  address     NVARCHAR(60),
  city        NVARCHAR(15),
  postal_code NVARCHAR(10),
  country     NVARCHAR(15),
  phone       NVARCHAR(25),
  PRIMARY KEY (id)
)

CREATE TABLE Warehouse -- OK
(
  location_id         INT      NOT NULL,
  product_in_stock_id INT      NOT NULL,
  quantity            SMALLINT NOT NULL,
  PRIMARY KEY (location_id, product_in_stock_id),
  CONSTRAINT check_quantity_positivity CHECK (quantity >=
                                              0), -- =0 ?eby umo?liwi? pobranie wszystkich element�w z magazynu + odpali? trigger?
  FOREIGN KEY (location_id) REFERENCES Locations (id),
  FOREIGN KEY (product_in_stock_id) REFERENCES Products (id) -- Products = tabela Bartka (artykuly spozywcze; spr. zgodno?? nazwy)
    ON DELETE CASCADE
)


CREATE TABLE Suppliers -- OK
(
  id           INT IDENTITY (1, 1) NOT NULL,
  name         NVARCHAR(40)        NOT NULL,
  address      NVARCHAR(60),
  city         NVARCHAR(15),
  postal_code  NVARCHAR(10),
  country      NVARCHAR(15),
  contact_name NVARCHAR(30),
  phone        NVARCHAR(25),
  fax          NVARCHAR(25),
  website      NVARCHAR(MAX),
  PRIMARY KEY (id)
)

CREATE TABLE Warehouse_orders -- OK
(
  id            INT IDENTITY (1, 1) NOT NULL,
  employee_id   INT                 NOT NULL, --odnosi sie do nie mojej tabeli-> ujednolicic, by 'Employees' oraz 'Users' mialy te sama nazwe (to te same byty)
  supplier_id   INT                 NOT NULL,
  location_id   INT                 NOT NULL,
  order_date    DATETIME,
  required_date DATETIME,
  delivery_date DATETIME, -- gdy ta wartosc nie jest nullem, powinien si? zwi?ksza? stan magazynu
  CONSTRAINT chk_DatesWO CHECK (order_date <= required_date AND order_date <= delivery_date),
  PRIMARY KEY (id),
  FOREIGN KEY (employee_id) REFERENCES Users (id), -- ujednolicona nazwa
  FOREIGN KEY (supplier_id) REFERENCES Suppliers (id),
  FOREIGN KEY (location_id) REFERENCES Locations (id)
)

CREATE TABLE Warehouse_order_details -- OK
(
  warehouse_order_id INT      NOT NULL,
  product_id         INT      NOT NULL,
  unit_price         MONEY    NOT NULL,
  quantity           SMALLINT NOT NULL,
  CONSTRAINT chk_MoneyWOD CHECK (unit_price >= 0),
  CONSTRAINT chk_QuantityWOD CHECK (quantity >= 0),
  PRIMARY KEY (warehouse_order_id, product_id),
  FOREIGN KEY (warehouse_order_id) REFERENCES Warehouse_orders (id),
  FOREIGN KEY (product_id) REFERENCES Products (id) -- Products = tabela Bartka (artykuly spozywcze; spr. zgodno?? nazwy)
)

CREATE TABLE Spots -- OK   -- miejsce zamowienia klienta, np. bar, stolik nr 1, czerwona kanapa etc.
(
  id          INT IDENTITY (1, 1) NOT NULL,
  location_id INT                 NOT NULL,
  name        NVARCHAR(40)        NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (location_id) REFERENCES Locations (id)
)

CREATE TABLE Client_orders -- OK
(
  id           INT IDENTITY (1, 1) NOT NULL,
  spot_id      INT                 NOT NULL, -- gdzie klient zam�wi?, np.: bar, czerwona sofa, czarna sofa etc.
  employee_id  INT                 NOT NULL,
  order_time   DATETIME,
  payment_time DATETIME,
  CONSTRAINT chk_DatesCO CHECK (order_time <= payment_time),
  PRIMARY KEY (id),
  FOREIGN KEY (spot_id) REFERENCES Spots (id),
  FOREIGN KEY (employee_id) REFERENCES Users (id) -- Employees = Users -> ujednolici?, je?li nie ujednolicone!
)

CREATE TABLE Client_order_details -- OK
(
  client_order_id  INT      NOT NULL,
  products_sold_id INT      NOT NULL,
  quantity         SMALLINT NOT NULL,
  CONSTRAINT chk_QuantityCOD CHECK (quantity >= 0),
  PRIMARY KEY (client_order_id, products_sold_id),
  FOREIGN KEY (client_order_id) REFERENCES Client_orders (id),
  FOREIGN KEY (products_sold_id) REFERENCES ProductsSold (id)
)


CREATE TABLE Workstations --OK   -- stanowiska pracy, np. bar, pizza etc.
(
  id          INT IDENTITY (1, 1) NOT NULL,
  location_id INT                 NOT NULL,
  name        NVARCHAR(40)        NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (location_id) REFERENCES Locations (id),
)

CREATE TABLE Workstation_rights -- OK
(
  workstation_id      INT     NOT NULL,
  employe_permissions TINYINT NOT NULL, -- Employees = Users -> ujednolici?! (zgodnie z tab Marcina)
  PRIMARY KEY (workstation_id, employe_permissions),
  FOREIGN KEY (workstation_id) REFERENCES Workstations (id),
  FOREIGN KEY (employe_permissions) REFERENCES EmployePermissions (id), -- typ pracownikow/userow to nie moja tab, ujednolicic nazwy
)