-- Представление для отображения информации о лицензиях и их владельцах
CREATE OR REPLACE VIEW LicenseInfo AS
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

-- Представление для отображения истории действий с лицензиями
CREATE OR REPLACE VIEW LicenseHistory AS
SELECT
    LH.record_id,
    LH.action,
    LH.date_of_action,
    LH.username,
    L.license_name
FROM License_History LH
INNER JOIN Licenses L ON LH.license_id = L.license_id;

-- Индекс на поле license_name в таблице Licenses
CREATE INDEX IX_LicenseName ON Licenses (license_name);

-- Индекс на поле licensees_id в таблице Licenses
CREATE INDEX IX_LicenseesID ON Licenses (licensees_id);

-- Создание последовательности для генерации уникальных идентификаторов лицензий
CREATE SEQUENCE LicenseIDSeq
    START WITH 1
    INCREMENT BY 1;

-- Пример функции для расчета суммарной стоимости лицензии
CREATE OR REPLACE FUNCTION CalculateLicenseCost (p_license_id NUMBER) RETURN NUMBER IS
    p_cost NUMBER(10, 2);
BEGIN
    SELECT total_license_cost INTO p_cost FROM Licenses WHERE license_id = p_license_id;
    RETURN p_cost;
END CalculateLicenseCost;

-- Пример процедуры для добавления новой лицензии
CREATE OR REPLACE PROCEDURE AddLicense(
    p_name IN NVARCHAR2,
    p_type IN NVARCHAR2,
    p_issue_date IN DATE,
    p_expiration_date IN DATE,
    p_description IN NVARCHAR2,
    p_status IN NVARCHAR2,
    p_licensee_id IN NUMBER,
    p_total_cost IN NUMBER
) IS
BEGIN
    INSERT INTO Licenses (license_id, license_name, license_type, date_of_issue, expiration_date, description, status, licensees_id, total_license_cost)
    VALUES (LicenseIDSeq.NEXTVAL, p_name, p_type, p_issue_date, p_expiration_date, p_description, p_status, p_licensee_id, p_total_cost);
    COMMIT;
END AddLicense;
