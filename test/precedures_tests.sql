USE BAR

EXEC addUnit 'hektolitr', 0.01, 1

SELECT * from Units

exec deleteUnit 'hektolitr'



exec addTax 'vat 1%', 0.01

SELECT * from Taxes

exec updateTax 3, 'VAT 3%', 0.03

