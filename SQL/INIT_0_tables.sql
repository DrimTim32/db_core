--CREATE DATABASE BarProject

CREATE TABLE EmployePermissions (
  id    TINYINT PRIMARY KEY IDENTITY (1, 1),
  value TINYINT UNIQUE,
  name  NVARCHAR(64) NOT NULL,
);

CREATE TABLE Users (
  id            INT PRIMARY KEY IDENTITY (1, 1),
  username      NVARCHAR(64) UNIQUE NOT NULL,
  password      VARBINARY(20)       NOT NULL,
  password_salt CHAR(25)            NOT NULL,
  name          NVARCHAR(64)        NOT NULL,
  surname       NVARCHAR(64)        NOT NULL,
  permission    TINYINT FOREIGN KEY REFERENCES EmployePermissions (id)
);

CREATE TABLE InternalErrors (
  id            INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
  error_name    NVARCHAR(64)        NOT NULL,
  error_time    DATETIME            NOT NULL,
  message       NVARCHAR(3000),
  stack_trace   NVARCHAR(1000)      NOT NULL,
  context       NVARCHAR(900)       NOT NULL,
  inner_message NVARCHAR(400),
)


CREATE TABLE UnitTypes (
  id        INT PRIMARY KEY IDENTITY (1, 1),
  type_name NVARCHAR(8) UNIQUE NOT NULL
)

CREATE TABLE Units (
  id             INT PRIMARY KEY IDENTITY (1, 1),
  unit_name      NVARCHAR(32) UNIQUE NOT NULL,
  convert_factor FLOAT               NOT NULL CHECK (convert_factor >= 0),
  unit_type      INT FOREIGN KEY REFERENCES UnitTypes (id)
)

CREATE TABLE Taxes (
  id        INT PRIMARY KEY IDENTITY (1, 1),
  tax_name  NVARCHAR(32) UNIQUE NOT NULL,
  tax_value FLOAT               NOT NULL CHECK (tax_value >= 0 AND tax_value <= 1)
)

CREATE TABLE Categories (
  id                  INT PRIMARY KEY IDENTITY (1, 1),
  slug                NVARCHAR(32) UNIQUE NOT NULL,
  category_name       NVARCHAR(64) UNIQUE NOT NULL,
  overriding_category INT FOREIGN KEY REFERENCES Categories (id)
)

CREATE TABLE Products (
  id          INT PRIMARY KEY IDENTITY (1, 1),
  category_id INT                  NOT NULL FOREIGN KEY REFERENCES Categories (id),
  unit_id     INT                  NOT NULL FOREIGN KEY REFERENCES Units (id),
  tax_id      INT                  NOT NULL FOREIGN KEY REFERENCES Taxes (id),
  name        NVARCHAR(128) UNIQUE NOT NULL,
)

CREATE TABLE ProductsStored (
  id INT PRIMARY KEY FOREIGN KEY REFERENCES Products (id),
  CONSTRAINT fk_stored_base_prod
  FOREIGN KEY (id) REFERENCES Products (id)
    ON DELETE CASCADE
)

CREATE TABLE Recipes (
  id          INT PRIMARY KEY IDENTITY (1, 1),
  description NVARCHAR(512)
)

CREATE TABLE ProductsSold (
  id        INT PRIMARY KEY,
  recipe_id INT FOREIGN KEY REFERENCES Recipes (id),
  CONSTRAINT fk_sold_base_prod
  FOREIGN KEY (id) REFERENCES Products (id)
    ON DELETE CASCADE
)

CREATE TABLE Ingredients (
  recipe_id     INT FOREIGN KEY REFERENCES Recipes (id),
  ingredient_id INT FOREIGN KEY REFERENCES ProductsStored (id),
  quantity      FLOAT NOT NULL CHECK (quantity >= 0),
  PRIMARY KEY (recipe_id, ingredient_id)
)

CREATE TABLE Prices (
  product_id   INT FOREIGN KEY REFERENCES ProductsSold (id),
  period_start DATETIME NOT NULL,
  price        MONEY    NOT NULL CHECK (price >= 0),
  PRIMARY KEY (product_id, period_start),
  CONSTRAINT fk_price_prod
  FOREIGN KEY (product_id) REFERENCES ProductsSold (id)
    ON DELETE CASCADE
)


CREATE TABLE LoginLog (
  username   NVARCHAR(64) NOT NULL FOREIGN KEY REFERENCES Users (username),
  login_time DATETIME
)


CREATE TABLE ProductsUsage (
  product_id INT   NOT NULL FOREIGN KEY REFERENCES Products (id),
  date       DATE  NOT NULL,
  quantity   FLOAT NOT NULL CHECK (quantity >= 0)
)


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
  FOREIGN KEY (warehouse_order_id) REFERENCES Warehouse_orders (id)
    ON DELETE CASCADE,
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
  FOREIGN KEY (client_order_id) REFERENCES Client_orders (id)
    ON DELETE CASCADE,
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