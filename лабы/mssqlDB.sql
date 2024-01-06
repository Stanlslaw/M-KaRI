Create DataBase HandleSoftwareLicenses;
USE HandleSoftwareLicenses;

-- Create tables
CREATE TABLE Vendors (
  vendor_id INT IDENTITY(1,1) PRIMARY KEY,
  vendor_name VARCHAR(255),
  vendor_address VARCHAR(255),
  vendor_contact VARCHAR(255)
);

CREATE TABLE Software (
  software_id INT IDENTITY(1,1) PRIMARY KEY,
  vendor_id INT REFERENCES Vendors(vendor_id),
  software_name VARCHAR(255)
);

CREATE TABLE Users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  group_id INT,
  username VARCHAR(255),
  email VARCHAR(255),
  password VARCHAR(255)
);

CREATE TABLE User_Groups (
  group_id INT IDENTITY(1,1) PRIMARY KEY,
  group_name VARCHAR(255),
  user_id INT
);

CREATE TABLE User_Groups_Link (
  group_id INT REFERENCES User_Groups(group_id),
  user_id INT REFERENCES Users(user_id),
  PRIMARY KEY (group_id, user_id)
);

CREATE TABLE Licenses (
  license INT IDENTITY(1,1) PRIMARY KEY,
  software_id INT REFERENCES Software(software_id),
  user_id INT REFERENCES Users(user_id),
  license_key VARCHAR(255),
  expiration_date DATE
);

-- Create indexes
CREATE INDEX idx_vendor_name ON Vendors(vendor_name);
CREATE INDEX idx_software_name ON Software(software_name);
CREATE INDEX idx_user_username ON Users(username);
CREATE INDEX idx_license_key ON Licenses(license_key);

-- Insert sample data
INSERT INTO Vendors (vendor_name, vendor_address, vendor_contact)
VALUES
  ('Vendor A', 'Address A', 'Contact A'),
  ('Vendor B', 'Address B', 'Contact B'),
  ('Vendor C', 'Address C', 'Contact C');

INSERT INTO Software (software_name)
VALUES
  ('Software A'),
  ('Software B'),
  ('Software C');

INSERT INTO Users (username, email, password)
VALUES
  ('User A', 'usera@example.com', 'passwordA'),
  ('User B', 'userb@example.com', 'passwordB'),
  ('User C', 'userc@example.com', 'passwordC');

INSERT INTO User_Groups (group_name, user_id)
VALUES
  ('Group 1', 1),
  ('Group 2', 2),
  ('Group 3', 3);

INSERT INTO User_Groups_Link (group_id, user_id)
VALUES
  (1, 1),
  (1, 2),
  (2, 2),
  (3, 3);

INSERT INTO Licenses (software_id, user_id, license_key, expiration_date)
VALUES
  (1, 1, 'LicenseKey1', '2023-12-31'),
  (2, 2, 'LicenseKey2', '2024-06-30'),
  (3, 3, 'LicenseKey3', '2023-09-15');
 Go
-- Create views
CREATE VIEW Software_Licenses AS
SELECT s.software_name, l.license_key, l.expiration_date
FROM Software s
JOIN Licenses l ON s.software_id = l.software_id;
Go
CREATE VIEW User_Licenses AS
SELECT u.username, s.software_name, l.license_key, l.expiration_date
FROM Users u
JOIN Licenses l ON u.user_id = l.user_id
JOIN Software s ON s.software_id = l.software_id;
Go
--Trigger to update the expiration date of a license when a new license is inserted for the same software and user
CREATE TRIGGER update_license_expiration_trigger
ON Licenses
AFTER INSERT
AS
BEGIN
  UPDATE l
  SET expiration_date = i.expiration_date
  FROM Licenses l
  INNER JOIN inserted i ON l.software_id = i.software_id AND l.user_id = i.user_id;
END
GO
--Trigger to prevent the deletion of a vendor if there are associated software records
CREATE TRIGGER prevent_vendor_deletion_trigger
ON Vendors
INSTEAD OF DELETE
AS
BEGIN
  IF EXISTS (
      SELECT 1
      FROM Software s
      WHERE s.vendor_id IN (SELECT vendor_id FROM deleted)
    )
  BEGIN
    RAISERROR ('Cannot delete the vendor. Associated software records exist.', 16, 1);
    ROLLBACK TRANSACTION; -- Optionally, you can rollback the transaction to prevent the deletion.
  END
  ELSE
  BEGIN
    DELETE FROM Vendors
    WHERE vendor_id IN (SELECT vendor_id FROM deleted);
  END
END
GO
--Trigger to update the group name in the User_Groups table when a user's username is updated
CREATE TRIGGER update_group_name_trigger
ON Users
AFTER UPDATE
AS
BEGIN
  IF UPDATE(username)
  BEGIN
    UPDATE ug
    SET group_name = u.username
    FROM User_Groups ug
    INNER JOIN inserted i ON ug.user_id = i.user_id
    INNER JOIN Users u ON u.user_id = i.user_id;
  END
END






--Функция "UserAuthentication" для авторизации пользователя в системе:
GO
CREATE FUNCTION UserAuthentication(@username VARCHAR(255), @password VARCHAR(255))
RETURNS INT
AS
BEGIN
  DECLARE @userId INT;
  SET @userId = (SELECT user_id FROM Users WHERE username = @username AND password = @password);
  RETURN @userId;
END;
--Процедура "ViewLicenses" для просмотра лицензий:
GO
CREATE PROCEDURE ViewLicenses(@userId INT)
AS
BEGIN
  SELECT s.software_name, l.license_key, l.expiration_date
  FROM Licenses l
  INNER JOIN Software s ON l.software_id = s.software_id
  WHERE l.user_id = @userId;
END;
--Процедура "NotifyLicenseExpiration" для получения уведомления о истечении лицензии:
GO
CREATE PROCEDURE NotifyLicenseExpiration(@userId INT)
AS
BEGIN
  DECLARE @expirationDate DATE;
  SET @expirationDate = (SELECT MIN(expiration_date) FROM Licenses WHERE user_id = @userId);
  
  IF GETDATE() >= @expirationDate
  BEGIN
    -- Ваш код для отправки уведомления о истечении лицензии
    PRINT 'Уведомление: Ваша лицензия истекла!';
  END;
END;
--Процедура "AccessSoftwareWithValidLicense" для получения доступа к ПО с активной лицензией:
GO
CREATE PROCEDURE AccessSoftwareWithValidLicense(@userId INT, @softwareId INT)
AS
BEGIN
  IF EXISTS (SELECT 1 FROM Licenses WHERE user_id = @userId AND software_id = @softwareId AND expiration_date >= GETDATE())
  BEGIN
    -- Ваш код для предоставления доступа к ПО с активной лицензией
    PRINT 'Доступ разрешен. Можно использовать ПО.';
  END
  ELSE
  BEGIN
    -- Ваш код для обработки отсутствия активной лицензии
    PRINT 'Доступ запрещен. Требуется активная лицензия для использования ПО.';
  END;
END;
--Процедура "AddVendor" для добавления поставщика (только для администратора):
GO
CREATE PROCEDURE AddVendor(@vendorName VARCHAR(255), @vendorAddress VARCHAR(255), @vendorContact VARCHAR(255))
AS
BEGIN
  INSERT INTO Vendors (vendor_name, vendor_address, vendor_contact)
  VALUES (@vendorName, @vendorAddress, @vendorContact);
END;
--Процедура "DeleteVendor" для удаления поставщика (только для администратора):
GO
CREATE PROCEDURE DeleteVendor(@vendorId INT)
AS
BEGIN
  DELETE FROM Vendors WHERE vendor_id = @vendorId;
END;
--Процедура "UpdateVendor" для изменения данных о поставщике (только для администратора):
GO
CREATE PROCEDURE UpdateVendor(@vendorId INT, @vendorName VARCHAR(255), @vendorAddress VARCHAR(255), @vendorContact VARCHAR(255))
AS
BEGIN
  UPDATE Vendors
  SET vendor_name = @vendorName, vendor_address = @vendorAddress, vendor_contact = @vendorContact
  WHERE vendor_id = @vendorId;
END;
--Процедура "RevokeLicense" для отзыва лицензии (только для администратора):
GO
CREATE PROCEDURE RevokeLicense(@licenseId INT)
AS
BEGIN
  DELETE FROM Licenses WHERE license = @licenseId;
END;
--Процедура "RenewLicense" для продления лицензии (только для администратора):
GO
CREATE PROCEDURE RenewLicense(@licenseId INT, @expirationDate DATE)
AS
BEGIN
  UPDATE Licenses
  SET expiration_date = @expirationDate
  WHERE license = @licenseId;
END;
--Процедура "UpdateLicense" для изменения данных лицензии (только для администратора):
GO
CREATE PROCEDURE UpdateLicense(@licenseId INT, @expirationDate DATE)
AS
BEGIN
  UPDATE Licenses
  SET expiration_date = @expirationDate
  WHERE license = @licenseId;
END;
--Процедура "GrantLicense" для выдачи лицензии (только для администратора):
GO
CREATE PROCEDURE GrantLicense(@softwareId INT, @userId INT, @licenseKey VARCHAR(255), @expirationDate DATE)
AS
BEGIN
  INSERT INTO Licenses (software_id, user_id, license_key, expiration_date)
  VALUES (@softwareId, @userId, @licenseKey, @expirationDate);
END;


EXECUTE InsertEmployee @empId = 1, @empName = 'John Doe', @empSalary = 5000;

select license_key from Licenses
