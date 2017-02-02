USE BarProject

INSERT INTO UnitTypes (type_name) VALUES
  ('vol'),
  ('mass'),
  ('piece')

INSERT INTO Units (unit_name, convert_factor, unit_type) VALUES
  ('szt.', 1, 3),
  ('kg', 1, 2),
  ('dag', 100, 2),
  ('l', 1, 1),
  ('ml', 1000, 1)

INSERT INTO Taxes (tax_name, tax_value) VALUES
  ('VAT 23 %', 0.23),
  ('VAT 7%', 0.08)