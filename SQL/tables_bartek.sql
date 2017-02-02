USE BarProject

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
  category_id INT FOREIGN KEY REFERENCES Categories (id),
  unit_id     INT FOREIGN KEY REFERENCES Units (id),
  tax_id      INT FOREIGN KEY REFERENCES Taxes (id),
  name        NVARCHAR(128) UNIQUE NOT NULL,
)

CREATE TABLE ProductsStored (
  id INT PRIMARY KEY FOREIGN KEY REFERENCES Products (id)
)

CREATE TABLE Receipts (
  id          INT PRIMARY KEY IDENTITY (1, 1),
  description NVARCHAR(512)
)

CREATE TABLE ProductsSold (
  id         INT PRIMARY KEY FOREIGN KEY REFERENCES Products (id),
  receipt_id INT FOREIGN KEY REFERENCES Receipts (id)
)

CREATE TABLE Ingredients (
  receipt_id    INT FOREIGN KEY REFERENCES Receipts (id),
  ingredient_id INT FOREIGN KEY REFERENCES ProductsStored (id),
  quantity      FLOAT NOT NULL,
  PRIMARY KEY (receipt_id, ingredient_id)
)

CREATE TABLE Prices (
  product_id   INT FOREIGN KEY REFERENCES ProductsSold (id),
  period_start DATE  NOT NULL,
  price        MONEY NOT NULL CHECK (price >= 0),
  PRIMARY KEY (product_id, period_start)
)
