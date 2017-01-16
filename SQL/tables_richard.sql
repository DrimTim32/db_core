
create table Warehouse
(
	location_id int not null,
	product_in_stock_id int not null,
	quantity smallint not null,
	primary key (location_id, product_in_stock_id),
	foreign key (location_id) references Locations(id), 
	foreign key (product_in_stock_id) references Products(id) -- Products = tabela Bartka (artykuly spozywcze; spr. zgodnoœæ nazwy)
)

create table Locations
(
	id int IDENTITY(1,1) not null,
	name nvarchar(40) not null,
	address nvarchar(60) null,
	city nvarchar(15) null,
	postal_code nvarchar(10) null,
	country nvarchar(15) null,
	phone nvarchar(25) null,
	primary key (id)
)

create table Suppliers
(
	id int IDENTITY(1,1) not null,
	name nvarchar(40) not null,
	address nvarchar(60) null,
	city nvarchar(15) null,
	postal_code nvarchar(10) null,
	country nvarchar(15) null,
	contact_name nvarchar(30) null,
	phone nvarchar(25) null,
	fax nvarchar(25) null,
	website ntext null,
	primary key (id)
)

create table Taxes
(
	id int IDENTITY(1,1) not null,
	tax_name nvarchar(40) not null,
	tax_value decimal(5,2) check(tax_value between 0 and 100) not null,
	primary key (id)
)

create table Warehouse_orders
(
	id int IDENTITY(1,1) not null,
	employee_id int not null, --odnosi sie do nie mojej tabeli-> ujednolicic, by 'Employees' oraz 'Users' mialy te sama nazwe (to te same byty)
	supplier_id int not null,
	location_id int not null,
	order_date datetime null,
	required_date datetime null,
	delivery_date datetime null, -- gdy ta wartosc nie jest nullem, powinien siê zwiêkszaæ stan magazynu
	primary key (id),
	foreign key (employee_id) references Employees(id), -- Employees = Users -> ujednoliciæ, jesli nie ujednolicone!
	foreign key (supplier_id) references Suppliers(id),
	foreign key (location_id) references Locations(id)
)

create table Warehouse_order_details
(
	warehouse_order_id int not null,
	product_id int not null,
	unit_price money not null,
	quantity smallint not null,
	primary key (warehouse_order_id, product_id),
	foreign key (warehouse_order_id) references Warehouse_orders(id),
	foreign key (product_id) references Products(id) -- Products = tabela Bartka (artykuly spozywcze; spr. zgodnoœæ nazwy)
)

create table Client_orders
(
	id int IDENTITY(1,1) not null,
	spot_id int not null, -- gdzie klient zamówi³, np.: bar, czerwona sofa, czarna sofa etc.
	employee_id int not null,
	order_time datetime null,
	payment_time datetime null,
	primary key (id),
	foreign key (spot_id) references Spots(id),
	foreign key (employee_id) references Employees(id) -- Employees = Users -> ujednoliciæ, jeœli nie ujednolicone!
)

create table Client_order_details
(
	client_order_id int not null,
	dish_id int not null,
	unit_price money not null,
	quantity smallint not null,
	spot_id int not null,
	primary key (client_order_id, dish_id),
	foreign key (client_order_id) references Client_orders(id),
	foreign key (dish_id) references Dishes(id), -- Dishes = tabela Bartka (sprawdziæ zgodnoœæ nazwy)
	foreign key (spot_id) references Spots(id)
)

create table Spots  -- miejsce zamowienia klienta, np. bar, stolik nr 1, czerwona kanapa etc.
(
	id int IDENTITY(1,1) not null,
	name nvarchar(40) not null,
	primary key (id),
)

create table Workstations  -- stanowiska pracy, np. bar, pizza etc.
(
	id int IDENTITY(1,1) not null,
	name nvarchar(40) not null,
	primary key (id),
)

create table Workstation_rights
(
	workstation_id int not null,
	employee_type int not null, -- Employees = Users -> ujednoliciæ! (zgodnie z tab Marcina)
	primary key (workstation_id, employee_type),
	foreign key (workstation_id) references Workstations(id),
	foreign key (employee_type) references Employee_types(id), -- typ pracownikow/userow to nie moja tab, ujednolicic nazwy
)