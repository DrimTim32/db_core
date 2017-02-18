--create database BarProject

USE BarProject

create table Locations -- OK
(
	id int IDENTITY(1,1) not null,
	name nvarchar(40) not null,
	address nvarchar(60),
	city nvarchar(15),
	postal_code nvarchar(10),
	country nvarchar(15),
	phone nvarchar(25),
	primary key (id)
)

create table Warehouse -- OK
(
	location_id int not null,
	product_in_stock_id int not null,
	quantity smallint not null,
	primary key (location_id, product_in_stock_id),
	constraint check_quantity_positivity CHECK (quantity>=0), -- =0 ?eby umo?liwi? pobranie wszystkich elementów z magazynu + odpali? trigger?
	foreign key (location_id) references Locations(id), 
	foreign key (product_in_stock_id) references Products(id) -- Products = tabela Bartka (artykuly spozywcze; spr. zgodno?? nazwy)
	on delete cascade
)



create table Suppliers -- OK
(
	id int IDENTITY(1,1) not null,
	name nvarchar(40) not null,
	address nvarchar(60),
	city nvarchar(15),
	postal_code nvarchar(10),
	country nvarchar(15),
	contact_name nvarchar(30),
	phone nvarchar(25),
	fax nvarchar(25),
	website nvarchar(max),
	primary key (id)
)

create table Warehouse_orders -- OK
(
	id int IDENTITY(1,1) not null,
	employee_id int not null, --odnosi sie do nie mojej tabeli-> ujednolicic, by 'Employees' oraz 'Users' mialy te sama nazwe (to te same byty)
	supplier_id int not null,
	location_id int not null,
	order_date datetime,
	required_date datetime,
	delivery_date datetime, -- gdy ta wartosc nie jest nullem, powinien si? zwi?ksza? stan magazynu
	constraint chk_DatesWO check (order_date<=required_date and order_date<=delivery_date),
	primary key (id),
	foreign key (employee_id) references Users(id), -- ujednolicona nazwa
	foreign key (supplier_id) references Suppliers(id),
	foreign key (location_id) references Locations(id)
)

create table Warehouse_order_details -- OK
(
	warehouse_order_id int not null,
	product_id int not null,
	unit_price money not null,
	quantity smallint not null,
	constraint chk_MoneyWOD check (unit_price >= 0),
	constraint chk_QuantityWOD check (quantity >= 0),
	primary key (warehouse_order_id, product_id),
	foreign key (warehouse_order_id) references Warehouse_orders(id),
	foreign key (product_id) references Products(id) -- Products = tabela Bartka (artykuly spozywcze; spr. zgodno?? nazwy)
)

create table Spots -- OK   -- miejsce zamowienia klienta, np. bar, stolik nr 1, czerwona kanapa etc.
(
	id int IDENTITY(1,1) not null,
	location_id int not null,
	name nvarchar(40) not null,
	primary key (id),
	foreign key (location_id) references Locations(id)
)

create table Client_orders -- OK
(
	id int IDENTITY(1,1) not null,
	spot_id int not null, -- gdzie klient zamówi?, np.: bar, czerwona sofa, czarna sofa etc.
	employee_id int not null,
	order_time datetime,
	payment_time datetime,
	constraint chk_DatesCO check (order_time<=payment_time),
	primary key (id),
	foreign key (spot_id) references Spots(id),
	foreign key (employee_id) references Users(id) -- Employees = Users -> ujednolici?, je?li nie ujednolicone!
)

create table Client_order_details -- OK
(
	client_order_id int not null,
	products_sold_id int not null,
	quantity smallint not null,
	constraint chk_QuantityCOD check (quantity >= 0),
	primary key (client_order_id, products_sold_id),
	foreign key (client_order_id) references Client_orders(id),
	foreign key (products_sold_id) references ProductsSold(id)
)



create table Workstations --OK   -- stanowiska pracy, np. bar, pizza etc.
(
	id int IDENTITY(1,1) not null,
	location_id int not null,
	name nvarchar(40) not null,
	primary key (id),
	foreign key (location_id) references Locations(id),
)

create table Workstation_rights -- OK
(
	workstation_id int not null,
	employe_permissions tinyint not null, -- Employees = Users -> ujednolici?! (zgodnie z tab Marcina)
	primary key (workstation_id, employe_permissions),
	foreign key (workstation_id) references Workstations(id),
	foreign key (employe_permissions) references EmployePermissions(id), -- typ pracownikow/userow to nie moja tab, ujednolicic nazwy
)