CREATE TABLE LicenseOrders (
    order_id NUMBER PRIMARY KEY,
    licensee_id NUMBER,
    license_id NUMBER,
    order_date DATE,
    FOREIGN KEY (licensee_id) REFERENCES Licensees (licensee_id),
    FOREIGN KEY (license_id) REFERENCES Licenses (license_id)
);

drop table License_keys
drop table Licensees
drop table Licenses
drop table MyHierarchy
select * from Licensees
SELECT * FROM Licensees;

truncate table Licensees

-- Licensees
INSERT INTO Licensees (licensee_id, name, surname, organization, contact, add_details)
VALUES (1, 'John', 'Doe', 'ABC Corp', 'john.doe@example.com', 'Additional details 1');
  
INSERT INTO Licensees (licensee_id, name, surname, organization, contact, add_details)
VALUES (2, 'Jane', 'Smith', 'XYZ Inc', 'jane.smith@exzample.com', 'Additional details 2');
  
INSERT INTO Licensees (licensee_id, name, surname, organization, contact, add_details)
VALUES (3, 'Alice', 'Johnson', '123 Ltd', 'alice.johnson@example.com', 'Additional details 3');
  
INSERT INTO Licensees (licensee_id, name, surname, organization, contact, add_details)
VALUES (4, 'Bob', 'Williams', '456 Corp', 'bob.williams@example.com', 'Additional details 4');

INSERT INTO Licensees (licensee_id, name, surname, organization, contact, add_details)
VALUES  (5, 'Eva', 'Brown', '789 LLC', 'eva.brown@example.com', 'Additional details 5');
  
INSERT INTO Licensees (licensee_id, name, surname, organization, contact, add_details)
VALUES (6, 'David', 'Miller', 'CCC Ltd', 'david.miller@example.com', 'Additional details 6');
  
INSERT INTO Licensees (licensee_id, name, surname, organization, contact, add_details)
VALUES (7, 'Olivia', 'Jones', 'DDD Corp', 'olivia.jones@example.com', 'Additional details 7');

ALTER TABLE Licenses
ADD device_id NUMBER;

-- Licenses
INSERT INTO Licenses (license_id, license_name, license_type, date_of_issue, expiration_date, description, status, licensees_id, id_of_key, total_license_cost, licensee_contact, device_id)
select 1, 'Windows', 'Enterprise', TO_DATE('2023-01-01', 'YYYY-MM-DD'), TO_DATE('2024-01-01', 'YYYY-MM-DD'), 'OS License', 'Active', 1, 1, 100.00, 'john.doe@example.com', 1 FROM dual UNION ALL
select 2, 'Office', 'Professional', TO_DATE('2023-02-01', 'YYYY-MM-DD'), TO_DATE('2024-02-01', 'YYYY-MM-DD'), 'Office Suite License', 'Active', 2, 2, 150.00, 'jane.smith@example.com', 2 FROM dual UNION ALL
select 3, 'Photoshop', 'Standard', TO_DATE('2023-03-01', 'YYYY-MM-DD'), TO_DATE('2024-03-01', 'YYYY-MM-DD'), 'Graphics Software License', 'Active', 3, 3, 200.00, 'alice.johnson@example.com', 3 FROM dual UNION ALL
select 4, 'AutoCAD', 'Professional', TO_DATE('2023-04-01', 'YYYY-MM-DD'), TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'CAD Software License', 'Active', 4, 4, 250.00, 'bob.williams@example.com', 1 FROM dual UNION ALL
select 5, 'Antivirus', 'Business', TO_DATE('2023-05-01', 'YYYY-MM-DD'), TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'Security Software License', 'Active', 5, 5, 120.00, 'eva.brown@example.com', 5 FROM dual UNION ALL
select 6, 'WebStorm', 'Developer', TO_DATE('2023-06-01', 'YYYY-MM-DD'), TO_DATE('2024-06-01', 'YYYY-MM-DD'), 'IDE License', 'Active', 6, 6, 180.00, 'david.miller@example.com', 5 FROM dual UNION ALL
select 7, 'Illustrator', 'Standard', TO_DATE('2023-07-01', 'YYYY-MM-DD'), TO_DATE('2024-07-01', 'YYYY-MM-DD'), 'Graphics Software License', 'Active', 7, 7, 220.00, 'olivia.jones@example.com', 9 FROM dual;


-- License_Keys
INSERT INTO License_Keys (id_of_key, id_of_license, key_of_name, status)
select 1, 1, 'ABCDE-12345', 'Active' FROM dual UNION ALL
SELECT 2, 2, 'FGHIJ-67890', 'Active' FROM dual UNION ALL
SELECT 3, 3, 'KLMNO-54321', 'Active' FROM dual UNION ALL
SELECT 4, 4, 'PQRST-98765', 'Active' FROM dual UNION ALL
SELECT 5, 5, 'UVWXY-13579', 'Active' FROM dual UNION ALL
SELECT 6, 6, 'ZABCD-24680', 'Active' FROM dual UNION ALL
SELECT 7, 7, '12345-ABCDE', 'Active' FROM dual;

-- License_Rules
INSERT INTO License_Rules (rule_id, license_id, text_rules, data_create, data_change)
select 1, 1, 'Rule for Windows', TO_DATE('2023-01-01', 'YYYY-MM-DD'), TO_DATE('2023-01-05', 'YYYY-MM-DD') FROM dual UNION ALL
select 2, 2, 'Rule for Office', TO_DATE('2023-02-01', 'YYYY-MM-DD'), TO_DATE('2023-02-05', 'YYYY-MM-DD') FROM dual UNION ALL
select 3, 3, 'Rule for Photoshop', TO_DATE('2023-03-01', 'YYYY-MM-DD'), TO_DATE('2023-03-05', 'YYYY-MM-DD') FROM dual UNION ALL
select 4, 4, 'Rule for AutoCAD', TO_DATE('2023-04-01', 'YYYY-MM-DD'), TO_DATE('2023-04-05', 'YYYY-MM-DD') FROM dual UNION ALL
select 5, 5, 'Rule for Antivirus', TO_DATE('2023-05-01', 'YYYY-MM-DD'), TO_DATE('2023-05-05', 'YYYY-MM-DD') FROM dual UNION ALL
select 6, 6, 'Rule for WebStorm', TO_DATE('2023-06-01', 'YYYY-MM-DD'), TO_DATE('2023-06-05', 'YYYY-MM-DD') FROM dual UNION ALL
select 7, 7, 'Rule for Illustrator', TO_DATE('2023-07-01', 'YYYY-MM-DD'), TO_DATE('2023-07-05', 'YYYY-MM-DD') FROM dual;

-- License_History
INSERT INTO License_History (record_id, license_id, action, date_of_action, username)
select 1, 1, 'Activation', TO_DATE('2023-01-02', 'YYYY-MM-DD'), 'admin' FROM dual UNION ALL
select 2, 2, 'Renewal', TO_DATE('2023-02-02', 'YYYY-MM-DD'), 'admin' FROM dual UNION ALL
select 3, 3, 'Activation', TO_DATE('2023-03-02', 'YYYY-MM-DD'), 'admin'  FROM dual UNION ALL
select 4, 4, 'Renewal', TO_DATE('2023-04-02', 'YYYY-MM-DD'), 'admin' FROM dual UNION ALL
select 5, 5, 'Activation', TO_DATE('2023-05-02', 'YYYY-MM-DD'), 'admin' FROM dual UNION ALL
select 6, 6, 'Renewal', TO_DATE('2023-06-02', 'YYYY-MM-DD'), 'admin' FROM dual UNION ALL
select 7, 7, 'Activation', TO_DATE('2023-07-02', 'YYYY-MM-DD'), 'admin' FROM dual;

-- LicenseOrders
INSERT INTO LicenseOrders (order_id, licensee_id, license_id, order_date)
select 1, 1, 1, TO_DATE('2023-01-10', 'YYYY-MM-DD') FROM dual UNION ALL
select  2, 2, 2, TO_DATE('2023-02-10', 'YYYY-MM-DD') FROM dual UNION ALL
select  3, 3, 3, TO_DATE('2023-03-10', 'YYYY-MM-DD') FROM dual UNION ALL
select  4, 4, 4, TO_DATE('2023-04-10', 'YYYY-MM-DD') FROM dual UNION ALL
select  5, 5, 5, TO_DATE('2023-05-10', 'YYYY-MM-DD') FROM dual UNION ALL
select  6, 6, 6, TO_DATE('2023-06-10', 'YYYY-MM-DD') FROM dual UNION ALL
select  7, 7, 7, TO_DATE('2023-07-10', 'YYYY-MM-DD') FROM dual;











---------------------------2--------------------------------







-- Common Table Expression (CTE) DateMetrics - разбивает даты лицензий на компоненты года, месяца, квартала и полугодия
WITH DateMetrics AS (
    SELECT
        license_id,
        total_license_cost,
        EXTRACT(YEAR FROM date_of_issue) AS IssueYear,
        EXTRACT(MONTH FROM date_of_issue) AS IssueMonth,
        TO_NUMBER(TO_CHAR(date_of_issue, 'Q')) AS IssueQuarter,
        -- Определение первой или второй половины года
        CASE 
            WHEN EXTRACT(MONTH FROM date_of_issue) <= 6 THEN 1
            ELSE 2
        END AS IssueHalfYear
    FROM Licenses
)

-- Основной запрос агрегирует данные о стоимости лицензий для каждого месяца и предоставляет результаты для ежемесячных, квартальных, полугодовых и годовых метрик.
SELECT
    IssueYear,
    IssueMonth,
    SUM(total_license_cost) AS MonthlyLicenseCost,
    SUM(CASE WHEN IssueQuarter = 1 THEN total_license_cost ELSE 0 END) AS Q1LicenseCost,
    SUM(CASE WHEN IssueQuarter = 2 THEN total_license_cost ELSE 0 END) AS Q2LicenseCost,
    SUM(CASE WHEN IssueQuarter = 3 THEN total_license_cost ELSE 0 END) AS Q3LicenseCost,
    SUM(CASE WHEN IssueQuarter = 4 THEN total_license_cost ELSE 0 END) AS Q4LicenseCost,
    SUM(CASE WHEN IssueHalfYear = 1 THEN total_license_cost ELSE 0 END) AS H1LicenseCost,
    SUM(CASE WHEN IssueHalfYear = 2 THEN total_license_cost ELSE 0 END) AS H2LicenseCost,
    SUM(total_license_cost) AS YearlyLicenseCost
FROM DateMetrics
GROUP BY IssueYear, IssueMonth
ORDER BY IssueYear, IssueMonth;











------------------------------------3--------------------------------




WITH LicenseSummary AS (
    SELECT
        l.license_id,
        COUNT(*) AS LicenseCount,
        SUM(l.total_license_cost) AS TotalLicenseCost
    FROM Licenses l
    GROUP BY l.license_id
),

TotalLicenses AS (
    SELECT COUNT(*) AS GrandTotalLicenses FROM LicenseSummary
),

TotalLicenseCost AS (
    SELECT SUM(TotalLicenseCost) AS GrandTotalLicenseCost FROM LicenseSummary
),

MaxLicenseCount AS (
    SELECT MAX(LicenseCount) AS BestLicenseCount FROM LicenseSummary
)

SELECT
    ls.license_id,
    ls.LicenseCount,
    ls.TotalLicenseCost,
    (ls.LicenseCount / tl.GrandTotalLicenses * 100) AS LicenseCountPercentageOfTotal,
    (ls.TotalLicenseCost / tlc.GrandTotalLicenseCost * 100) AS TotalLicenseCostPercentageOfTotal,
    (ls.LicenseCount / mlc.BestLicenseCount * 100) AS LicenseCountPercentageOfBest,
    (ls.TotalLicenseCost / tlc.GrandTotalLicenseCost * 100) AS TotalLicenseCostPercentageOfBest
FROM LicenseSummary ls
CROSS JOIN TotalLicenses tl
CROSS JOIN TotalLicenseCost tlc
CROSS JOIN MaxLicenseCount mlc
ORDER BY ls.TotalLicenseCost DESC;





--В Oracle не требуется использование AS перед определением алиасов для столбцов внутри CTE.
--В Oracle для определения процентов можно использовать оператор * 100 вместо / 100.



------------------------------------4-----------------------------------




WITH OrderedResults AS (
    SELECT
        license_id,
        license_name,
        license_type,
        date_of_issue,
        expiration_date,
        description,
        status,
        licensees_id,
        id_of_key,
        total_license_cost,
        licensee_contact,
        ROW_NUMBER() OVER (ORDER BY license_id) AS row_num
    FROM
        Licenses
)
SELECT
    license_id,
    license_name,
    license_type,
    date_of_issue,
    expiration_date,
    description,
    status,
    licensees_id,
    id_of_key,
    total_license_cost,
    licensee_contact
FROM
    OrderedResults
WHERE
    row_num BETWEEN 1 AND 20; -- Для первой страницы






------------------------------5--------------------------



DELETE FROM Licenses
WHERE (license_id, ROWID) IN (
    SELECT license_id, MAX(ROWID) AS rid
    FROM Licenses
    GROUP BY license_id
    HAVING COUNT(*) > 1
);



------------------------6-----------------------------


SELECT
    license_name,
    EXTRACT(YEAR FROM date_of_issue) AS IssueYear,
    EXTRACT(MONTH FROM date_of_issue) AS IssueMonth,
    COUNT(DISTINCT license_id) AS LicensesSold
FROM Licenses
WHERE date_of_issue >= ADD_MONTHS(CURRENT_DATE, -12)
GROUP BY license_name, EXTRACT(YEAR FROM date_of_issue), EXTRACT(MONTH FROM date_of_issue);









----------------------------7----------------------------

CREATE TABLE Devices (
    device_id NUMBER PRIMARY KEY,
    device_name NVARCHAR2(20),
    device_type NVARCHAR2(20)
);


INSERT INTO Devices (device_id, device_name, device_type)
SELECT 1, 'Desktop', 'Desktop Computer' FROM DUAL
UNION ALL SELECT 2, 'Laptop', 'Laptop Computer' FROM DUAL
UNION ALL SELECT 3, 'Server', 'Server' FROM DUAL
UNION ALL SELECT 4, 'Tablet', 'Tablet' FROM DUAL
UNION ALL SELECT 5, 'Desktop', 'Desktop Computer' FROM DUAL
UNION ALL SELECT 6, 'Laptop', 'Laptop Computer' FROM DUAL
UNION ALL SELECT 7, 'Server', 'Server' FROM DUAL
UNION ALL SELECT 8, 'Desktop', 'Desktop Computer' FROM DUAL
UNION ALL SELECT 9, 'Desktop', 'Desktop Computer' FROM DUAL
UNION ALL SELECT 10, 'Desktop', 'Desktop Computer' FROM DUAL
UNION ALL SELECT 11, 'Desktop', 'Desktop Computer' FROM DUAL
UNION ALL SELECT 12, 'Laptop', 'Laptop Computer' FROM DUAL
UNION ALL SELECT 13, 'Server', 'Server' FROM DUAL
UNION ALL SELECT 14, 'Desktop', 'Desktop Computer' FROM DUAL
UNION ALL SELECT 15, 'Laptop', 'Laptop Computer' FROM DUAL;


WITH RankedSoftware AS (
    SELECT
        d.device_type,
        l.license_type,
        COUNT(l.license_id) AS software_count,
        RANK() OVER (PARTITION BY d.device_type ORDER BY COUNT(l.license_id) DESC) AS rnk
    FROM
        Devices d
        JOIN Licenses l ON d.device_id = l.id_of_key
    GROUP BY
        d.device_type, l.license_type
)
SELECT
    device_type,
    license_type,
    software_count
FROM (
    SELECT
        device_type,
        license_type,
        software_count,
        RANK() OVER (PARTITION BY device_type ORDER BY software_count DESC) AS rnk
    FROM
        RankedSoftware
)
WHERE
    rnk = 1;





