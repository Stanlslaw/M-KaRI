use Lab7Migration;

CREATE TABLE License_Types (
	type_id INT primary key,
	type_name	nvarchar(50)
);

CREATE TABLE License_Costs (
	cost_id	INT primary key,
	type_id	INT foreign key references License_Types(type_id),
	cost float,
	effective_date	date
	
);

INSERT INTO License_Types (type_id, type_name) VALUES (1, 'Type A');
INSERT INTO License_Types (type_id, type_name) VALUES (2, 'Type B');
INSERT INTO License_Types (type_id, type_name) VALUES (3, 'Type C');
-- Add more INSERT statements as needed for additional data

INSERT INTO License_Costs (cost_id, type_id, cost, effective_date) VALUES (1, 1, 10.99, '2022-01-01');
INSERT INTO License_Costs (cost_id, type_id, cost, effective_date) VALUES (2, 2, 15.99, '2022-01-01');
INSERT INTO License_Costs (cost_id, type_id, cost, effective_date) VALUES (3, 3, 20.99, '2022-01-01');

select * from License_Costs c join License_Types t on t.type_id=c.type_id