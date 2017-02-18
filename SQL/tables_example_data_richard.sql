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
  (3, 1),
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
  (1, 5, 1)

INSERT INTO Client_order_details (client_order_id, products_sold_id, quantity) VALUES
  (1, 4, 10)

INSERT INTO Client_order_details (client_order_id, products_sold_id, quantity) VALUES
  (2, 5, 1)

INSERT INTO Client_order_details (client_order_id, products_sold_id, quantity) VALUES
  (2, 6, 3)
