use SoftwareLicenses
select * from sys.tables

create table Licensees (
	licensee_id int primary key,
	name nvarchar(10),
	surname nvarchar(10),
	organization nvarchar(20),
	contact nvarchar(30),
	add_details nvarchar(20)
);


create table Licenses (
	license_id int primary key,
	license_name nvarchar(20),
	license_type nvarchar(20),
	date_of_issue date,
	expiration_date date,
	description nvarchar(30),
	status nvarchar(20),
	licensees_id int,
	id_of_key int,
	total_license_cost decimal(10,2),
	licensee_contact nvarchar(30),
	foreign key (licensees_id) references Licensees (licensee_id)
);


create table License_keys (
	id_of_key int primary key,
	id_of_license int,
	foreign key (id_of_license) references Licenses (license_id),
	key_of_name nvarchar(20),
	status nvarchar(20)
);




create table License_Rules (
	rule_id int primary key,
	license_id int,
	foreign key (license_id) references Licenses(license_id),
	text_rules nvarchar(20),
	data_create date,
	data_change date
);

create table License_History (
	record_id int primary key,
	license_id int,
	foreign key (license_id) references Licenses(license_id),
	action nvarchar(10),
	date_of_action date,
	username nvarchar(10)
);

drop table License_History;
drop table License_Rules;
drop table License_keys;
drop table Licensees;
drop table Licenses;
drop table SoftwareCosts;
drop table LicenseOrders;


alter table Licenses
add constraint Licenses_idOfKey_FK FOREIGN KEY ( id_of_key ) references License_keys(id_of_key)






























ALTER TABLE Licenses
ADD device_id INT;

ALTER TABLE Licenses
ADD CONSTRAINT FK_Licenses_Devices
    FOREIGN KEY (device_id)
    REFERENCES Devices(device_id);

