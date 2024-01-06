create table Licensees (
	licensee_id int primary key,
	name nvarchar2(10),
	surname nvarchar2(10),
	organization nvarchar2(20),
	contact nvarchar2(20),
	add_details nvarchar2(20)
);

create table Licenses (
	license_id int primary key,
	license_name nvarchar2(20),
	license_type nvarchar2(20),
	date_of_issue date,
	expiration_date date,
	description nvarchar2(20),
	status nvarchar2(20),
	licensees_id int,
    id_of_key int,
	total_license_cost decimal(10,2),
	licensee_contact nvarchar2(20),
	foreign key (licensees_id) references Licensees (licensee_id)
);



create table License_keys (
	id_of_key int primary key,
	id_of_license int,
	foreign key (id_of_license) references Licenses (license_id),
	key_of_name nvarchar2(20),
	status nvarchar2(20)
);

alter table Licenses
add constraint Licenses_idOfKey_FK FOREIGN KEY ( id_of_key ) references License_keys(id_of_key);

create table License_Rules (
	rule_id int primary key,
	license_id int,
	foreign key (license_id) references Licenses(license_id),
	text_rules nvarchar2(20),
	data_create date,
	data_change date
);

create table License_History (
	record_id int primary key,
	license_id int,
	foreign key (license_id) references Licenses(license_id),
	action nvarchar2(10),
	date_of_action date,
	username nvarchar2(10)
);

drop table License_History;
drop table License_Rules;
drop table License_keys;
drop table Licensees;
drop table Licenses;