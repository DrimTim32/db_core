USE BarProject
GO

INSERT INTO Categories (slug, category_name, overriding_category) VALUES
  ('NAPOJE', 'NAPOJE', NULL),
  ('PIWO', 'PIWO', NULL),
  ('KAWA', 'KAWA', NULL),
  ('HERBATA', 'HERBATA', NULL)


INSERT INTO Categories (slug, category_name, overriding_category) VALUES
  ('NAP_SOK', 'SOKI', 1),
  ('PIWO_KEG', 'PIWO BECZKA', 2),
  ('PIWO_BUT', 'PIWO BUTELKA', 2),
  ('HER_ZIEL', 'HEBRATY ZIELONE', 4),
  ('HER_INNE', 'HEBRATY INNE', 4),
  ('HER_CZAR', 'HEBRATY CZARNE', 4)

-- soki-sprzedawane
INSERT INTO Products (category_id, unit_id, tax_id, name) VALUES
  (5, 5, 2, 'SOK JABLKOWY'),
  (5, 5, 2, 'SOK POMARANCZOWY')

INSERT INTO ProductsSold (id) VALUES
  (1),
  (2)

INSERT INTO Prices (product_id, period_start, price) VALUES
  (1, '2016-12-9', 5.50),
  (2, '2016-12-10', 5.50)

--soki-magazynowane
INSERT INTO Products (category_id, unit_id, tax_id, name) VALUES
  (5, 5, 2, 'SOK MALINOWY')

INSERT INTO ProductsStored (id) VALUES
  (3)

--piwo-magazynowane-i-sprzedawane
INSERT INTO Products (category_id, unit_id, tax_id, name) VALUES
  (2, 5, 1, 'TYSKIE'),
  (2, 5, 1, 'IMPERIUM PRUNUM')

INSERT INTO ProductsSold (id) VALUES
  (4),
  (5)

INSERT INTO ProductsStored (id) VALUES
  (4)

INSERT INTO Prices (product_id, period_start, price) VALUES
  (4, '2016-12-9', 7),
  (5, '2016-12-10', 50)

--piwo z sokiem

INSERT INTO Recipes (description) VALUES
  ('receptura na piwo z sokiem')

INSERT INTO Ingredients (recipe_id, ingredient_id, quantity) VALUES
  (1, 3, 1),
  (1, 4, 1)

INSERT INTO Products (category_id, unit_id, tax_id, name) VALUES
  (2, 5, 1, 'TYSKIE Z SOKIEM')

INSERT INTO ProductsSold (id, recipe_id) VALUES
  (6, 1)

INSERT INTO Prices (product_id, period_start, price) VALUES
  (6, '2016-12-9', 9)

INSERT INTO Prices (product_id, period_start, price) VALUES
  (6, '2017-01-31', 12)


USE BarProject

INSERT INTO Locations (name, address, city, postal_code, country, phone) VALUES
  ('Lokal domyslny', 'Lojasiewicza 6', 'Kraków', '33-333', 'Polska', '12 123-45-67'),
  ('Hevre', 'Meiselsa 18', 'Kraków', '31-058', 'Polska', '12 123-45-67')


INSERT INTO Suppliers (name, address, city, postal_code, country, contact_name, phone, fax, website) VALUES
  ('Dostawca domyslny', 'Dostawcza 1', 'Krakow', '30-000', 'Polska', 'Jan Konwalski', '123456789', '987654321',
   'http://dostawy.dd'),
  ('SOK-HURT Janusz Wąs', 'Dziurawa 14', 'Krakow', '30-000', 'Polska', 'Janusz Wąs', '123456789', '987654321',
   'http://sok-hurt.darmowyhosting.xd')


INSERT INTO Warehouse (location_id, product_in_stock_id, quantity) VALUES
  (1, 1, 30),
  (1, 2, 31),
  (1, 3, 32),
  (1, 4, 90),
  (1, 5, 2)

INSERT INTO Spots (location_id, name) VALUES
  (1, 'Bar'),
  (1, 'Bar piwnica')


INSERT INTO Workstations (location_id, name) VALUES
  (1, 'Zaplecze'),
  (1, 'Bar POS1'),
  (1, 'Bar POS2'),
  (1, 'Bar piwnica POS')

INSERT INTO Workstation_rights (workstation_id, employe_permissions) VALUES
  (1, 1),
  (2, 1),
  (3, 5),
  (4, 1)

INSERT INTO Warehouse_orders (employee_id, supplier_id, location_id, order_date, required_date, delivery_date) VALUES
  (1, 1, 1, '2017-02-17', '2017-02-20', NULL)

INSERT INTO Warehouse_order_details (warehouse_order_id, product_id, unit_price, quantity) VALUES
  (1, 3, 5, 48),
  (1, 4, 3, 90),
  (1, 5, 30, 10)


INSERT INTO Client_orders (spot_id, employee_id, order_time, payment_time) VALUES
  (1, 1, GETDATE(), GETDATE()),
  (2, 1, GETDATE(), GETDATE())


INSERT INTO Client_order_details (client_order_id, products_sold_id, quantity) VALUES
  (1, 5, 1),
  (1, 4, 10),
  (2, 5, 1),
  (2, 6, 3)
