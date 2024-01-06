PRAGMA foreign_keys = ON;

CREATE TABLE "License_Types" (
	"type_id"	INTEGER,
	"type_name"	TEXT UNIQUE,
	PRIMARY KEY("type_id" AUTOINCREMENT)
);
CREATE TABLE "License_Costs" (
	"cost_id"	INTEGER,
	"type_id"	INTEGER,
	"cost"	NUMERIC,
	"effective_date"	TEXT,
	FOREIGN KEY("type_id") REFERENCES "License_Types"("type_id") ON DELETE CASCADE,
	PRIMARY KEY("cost_id" AUTOINCREMENT)
);

CREATE INDEX "License_costs_cost_index" ON "License_Costs" (
	"cost",
	"cost_id"
);

begin TRANSACTION;
insert into License_Types (type_name) VALUES('TYPE L');
commit;
begin TRANSACTION;
INSERT into License_Types (type_id,type_name) VALUES(7,'TYPE M');
Rollback;


DROP VIEW "main"."pricing_by_type_name";
CREATE VIEW pricing_by_type_name as
SELECT lt.type_name, lc.cost
from License_Types as lt
JOIN License_Costs as lc on lt.type_id = lc.type_id
ORDER BY lc.cost DESC;

CREATE TRIGGER update_effective_date
AFTER INSERT ON License_Costs
FOR EACH ROW
BEGIN
    UPDATE License_Costs
    SET effective_date = DATE('now')
    WHERE cost_id = NEW.cost_id;
END;


INSERT INTO License_Types (type_id, type_name) VALUES (1, 'Type A');
INSERT INTO License_Types (type_id, type_name) VALUES (2, 'Type B');
INSERT INTO License_Types (type_id, type_name) VALUES (3, 'Type C');
-- Add more INSERT statements as needed for additional data

INSERT INTO License_Costs (cost_id, type_id, cost, effective_date) VALUES (1, 1, 10.99, '2022-01-01');
INSERT INTO License_Costs (cost_id, type_id, cost, effective_date) VALUES (2, 2, 15.99, '2022-01-01');
INSERT INTO License_Costs (cost_id, type_id, cost, effective_date) VALUES (3, 3, 20.99, '2022-01-01');
-- Add more INSERT statements as needed for additional data

UPDATE License_Costs SET cost = 12.99 WHERE cost_id = 1;

INSERT INTO License_Costs (cost_id, type_id, cost, effective_date) VALUES (4, 1, 8.99, '2022-02-01');

DELETE FROM License_Costs WHERE cost_id = 3;


BEGIN TRANSACTION;

-- Update data
UPDATE License_Costs SET cost = 12.99 WHERE cost_id = 1;

-- Add new data
INSERT INTO License_Costs (cost_id, type_id, cost, effective_date) VALUES (4, 1, 8.99, '2022-02-01');

-- Delete data
DELETE FROM License_Costs WHERE cost_id = 3;

COMMIT;



delete from License_Costs
delete from License_Types
VACUUM