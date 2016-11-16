USE MCGYVER

CREATE TABLE UnitTypes (
  id        INT PRIMARY KEY IDENTITY (1, 1),
  type_name NVARCHAR(4) UNIQUE NOT NULL
)

CREATE TABLE Units (
  id             INT PRIMARY KEY IDENTITY (1, 1),
  unit_name      NVARCHAR(32) UNIQUE NOT NULL,
  convert_factor FLOAT             NOT NULL,
  unit_type      INT FOREIGN KEY REFERENCES UnitTypes (id)
)

CREATE TABLE Categories (
  id                  INT PRIMARY KEY IDENTITY (1, 1),
  category_name       NVARCHAR(64) UNIQUE NOT NULL,
  overriding_categpry INT
);