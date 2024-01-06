use SoftwareLicenses
go

-- Представление для отображения информации о лицензиях и их владельцах
CREATE VIEW LicenseInfo AS
SELECT
    L.license_id,
    L.license_name,
    L.license_type,
    L.date_of_issue,
    L.expiration_date,
    L.description,
    L.status,
    Le.name AS licensee_name,
    Le.surname AS licensee_surname,
    Le.organization AS licensee_organization
FROM Licenses L
INNER JOIN Licensees Le ON L.licensees_id = Le.licensee_id;
go
-- Представление для отображения истории действий с лицензиями
CREATE VIEW LicenseHistory AS
SELECT
    LH.record_id,
    LH.action,
    LH.date_of_action,
    LH.username,
    L.license_name
FROM License_History LH
INNER JOIN Licenses L ON LH.license_id = L.license_id;


-- Индекс на поле license_name в таблице Licenses
CREATE NONCLUSTERED INDEX IX_LicenseName ON Licenses (license_name);

-- Индекс на поле licensees_id в таблице Licenses
CREATE NONCLUSTERED INDEX IX_LicenseesID ON Licenses (licensees_id);

-- Создание последовательности для генерации уникальных идентификаторов лицензий
CREATE SEQUENCE LicenseIDSeq
    START WITH 1
    INCREMENT BY 1;

-- Пример функции для расчета суммарной стоимости лицензии
CREATE FUNCTION CalculateLicenseCost (@license_id INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @cost DECIMAL(10, 2);

    SELECT @cost = total_license_cost
    FROM Licenses
    WHERE license_id = @license_id;

    RETURN @cost;
END;

-- Пример процедуры для добавления новой лицензии
CREATE PROCEDURE AddLicense
    @name NVARCHAR(20),
    @type NVARCHAR(20),
    @issue_date DATE,
    @expiration_date DATE,
    @description NVARCHAR(20),
    @status NVARCHAR(20),
    @licensee_id INT,
    @total_cost DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO Licenses (license_name, license_type, date_of_issue, expiration_date, description, status, licensees_id, total_license_cost)
    VALUES (@name, @type, @issue_date, @expiration_date, @description, @status, @licensee_id, @total_cost);
END;


--for report

-- Список таблиц и атрибутов
SELECT 
    t.name AS TableName,
    c.name AS ColumnName,
    ty.name AS DataType,
    CASE WHEN c.is_nullable = 1 THEN 'NULLABLE' ELSE 'NOT NULL' END AS ConstraintType,
    ep.value AS Description
FROM sys.tables t
JOIN sys.columns c ON t.object_id = c.object_id
LEFT JOIN sys.extended_properties ep ON t.object_id = ep.major_id AND c.column_id = ep.minor_id
JOIN sys.types ty ON c.user_type_id = ty.user_type_id;

-- Список индексов
SELECT 
    t.name AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType
FROM sys.tables t
JOIN sys.indexes i ON t.object_id = i.object_id;

-- Список последовательностей
SELECT 
    name AS SequenceName
FROM sys.sequences;

-- Список функций
SELECT 
    schema_name(schema_id) AS SchemaName,
    name AS FunctionName,
    OBJECT_DEFINITION(object_id) AS FunctionDefinition
FROM sys.objects
WHERE type_desc LIKE '%FUNCTION%';

-- Список процедур
SELECT 
    schema_name(schema_id) AS SchemaName,
    name AS ProcedureName,
    OBJECT_DEFINITION(object_id) AS ProcedureDefinition
FROM sys.objects
WHERE type_desc LIKE '%PROCEDURE%';

-- Список представлений
SELECT 
    schema_name(schema_id) AS SchemaName,
    name AS ViewName,
    OBJECT_DEFINITION(object_id) AS ViewDefinition
FROM sys.objects
WHERE type_desc LIKE '%VIEW%';