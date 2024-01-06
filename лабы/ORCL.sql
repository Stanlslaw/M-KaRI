-- Create sequences
CREATE SEQUENCE vendor_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE software_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE user_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE group_id_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE license_id_seq START WITH 1 INCREMENT BY 1;

-- Create tables
CREATE TABLE Vendors (
  vendor_id INT DEFAULT vendor_id_seq.NEXTVAL PRIMARY KEY,
  vendor_name VARCHAR2(255),
  vendor_address VARCHAR2(255),
  vendor_contact VARCHAR2(255)
);

CREATE TABLE Software (
  software_id INT DEFAULT software_id_seq.NEXTVAL PRIMARY KEY,
  vendor_id INT REFERENCES Vendors(vendor_id),
  software_name VARCHAR2(255)
);

CREATE TABLE Users (
  user_id INT DEFAULT user_id_seq.NEXTVAL PRIMARY KEY,
  group_id INT,
  username VARCHAR2(255),
  email VARCHAR2(255),
  password VARCHAR2(255)
);

CREATE TABLE User_Groups (
  group_id INT DEFAULT group_id_seq.NEXTVAL PRIMARY KEY,
  group_name VARCHAR2(255),
  user_id INT
);

CREATE TABLE User_Groups_Link (
  group_id INT REFERENCES User_Groups(group_id),
  user_id INT REFERENCES Users(user_id),
  PRIMARY KEY (group_id, user_id)
);

CREATE TABLE Licenses (
  license_id INT DEFAULT license_id_seq.NEXTVAL PRIMARY KEY,
  software_id INT REFERENCES Software(software_id),
  user_id INT REFERENCES Users(user_id),
  license_key VARCHAR2(255),
  expiration_date DATE
);

-- Create indexes
CREATE INDEX idx_vendor_name ON Vendors(vendor_name);
CREATE INDEX idx_software_name ON Software(software_name);
CREATE INDEX idx_user_username ON Users(username);
CREATE INDEX idx_license_key ON Licenses(license_key);

-- Insert sample data
-- Insert sample data
INSERT INTO Vendors (vendor_name, vendor_address, vendor_contact)
VALUES
  ('Vendor A', 'Address A', 'Contact A');

INSERT INTO Vendors (vendor_name, vendor_address, vendor_contact)
VALUES
  ('Vendor B', 'Address B', 'Contact B');

INSERT INTO Vendors (vendor_name, vendor_address, vendor_contact)
VALUES
  ('Vendor C', 'Address C', 'Contact C');

INSERT INTO Software (vendor_id, software_name)
VALUES
  (1, 'Software A');

INSERT INTO Software (vendor_id, software_name)
VALUES
  (2, 'Software B');

INSERT INTO Software (vendor_id, software_name)
VALUES
  (3, 'Software C');

INSERT INTO Users (group_id, username, email, password)
VALUES
  (1, 'User A', 'usera@example.com', 'passwordA');

INSERT INTO Users (group_id, username, email, password)
VALUES
  (2, 'User B', 'userb@example.com', 'passwordB');

INSERT INTO Users (group_id, username, email, password)
VALUES
  (3, 'User C', 'userc@example.com', 'passwordC');

INSERT INTO User_Groups (group_name, user_id)
VALUES
  ('Group 1', 1);

INSERT INTO User_Groups (group_name, user_id)
VALUES
  ('Group 2', 2);

INSERT INTO User_Groups (group_name, user_id)
VALUES
  ('Group 3', 3);

INSERT INTO User_Groups_Link (group_id, user_id)
VALUES
  (1, 1);

INSERT INTO User_Groups_Link (group_id, user_id)
VALUES
  (1, 2);

INSERT INTO User_Groups_Link (group_id, user_id)
VALUES
  (2, 2);

INSERT INTO User_Groups_Link (group_id, user_id)
VALUES
  (3, 3);

INSERT INTO Licenses (software_id, user_id, license_key, expiration_date)
VALUES
  (1, 1, 'LicenseKey1', DATE '2023-12-31');

INSERT INTO Licenses (software_id, user_id, license_key, expiration_date)
VALUES
  (2, 2, 'LicenseKey2', DATE '2024-06-30');

INSERT INTO Licenses (software_id, user_id, license_key, expiration_date)
VALUES
  (3, 3, 'LicenseKey3', DATE '2023-09-15');
-- Create views
CREATE VIEW Software_Licenses AS
SELECT s.software_name, l.license_key, l.expiration_date
FROM Software s
JOIN Licenses l ON s.software_id = l.software_id;

CREATE VIEW User_Licenses AS
SELECT u.username, s.software_name, l.license_key, l.expiration_date
FROM Users u
JOIN Licenses l ON u.user_id = l.user_id
JOIN Software s ON s.software_id = l.software_id;

-- Trigger to update the expiration date of a license when a new license is inserted for the same software and user
CREATE OR REPLACE TRIGGER update_license_expiration_trigger
AFTER INSERT ON Licenses
FOR EACH ROW
BEGIN
  UPDATE Licenses
  SET expiration_date = :NEW.expiration_date
  WHERE software_id = :NEW.software_id AND user_id = :NEW.user_id;
END;

-- Trigger to prevent the deletion of a vendor if there are associated software records
CREATE OR REPLACE TRIGGER prevent_vendor_deletion_trigger
BEFORE DELETE ON Vendors
FOR EACH ROW
DECLARE
  software_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO software_count
  FROM Software
  WHERE vendor_id = :OLD.vendor_id;

  IF software_count > 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Cannot delete the vendor. Associated software records exist.');
  END IF;
END;


-- Trigger to update the group name in the User_Groups table when a user's username is updated
CREATE OR REPLACE TRIGGER update_group_name_trigger
AFTER UPDATE OF username ON Users
FOR EACH ROW
BEGIN
  IF UPDATING('username') THEN
    UPDATE User_Groups
    SET group_name = :NEW.username
    WHERE user_id = :NEW.user_id;
  END IF;
END;

--Functions and procedures
--Function "UserAuthentication" for user authentication in the system:

CREATE OR REPLACE FUNCTION UserAuthentication(username IN VARCHAR2, password IN VARCHAR2)
  RETURN NUMBER
IS
  userId NUMBER;
BEGIN
  SELECT user_id INTO userId
  FROM Users
  WHERE username = UserAuthentication.username AND password = UserAuthentication.password;
  
  RETURN userId;
END;

--Procedure "ViewLicenses" for viewing licenses:

CREATE OR REPLACE PROCEDURE ViewLicenses(userId IN NUMBER)
IS
BEGIN
  FOR licenseRec IN (SELECT l.license_id, s.software_name, l.license_key, l.expiration_date
                     FROM Licenses l
                     INNER JOIN Software s ON l.software_id = s.software_id
                     WHERE l.user_id = ViewLicenses.userId)
  LOOP
    DBMS_OUTPUT.PUT_LINE('License ID: ' || licenseRec.license_id);
    DBMS_OUTPUT.PUT_LINE('Software Name: ' || licenseRec.software_name);
    DBMS_OUTPUT.PUT_LINE('License Key: ' || licenseRec.license_key);
    DBMS_OUTPUT.PUT_LINE('Expiration Date: ' || licenseRec.expiration_date);
    DBMS_OUTPUT.PUT_LINE('------------------');
  END LOOP;
END;

--Procedure "NotifyLicenseExpiration" for receiving notifications about license expiration:

CREATE OR REPLACE PROCEDURE NotifyLicenseExpiration(userId IN NUMBER)
IS
  expirationDate DATE;
BEGIN
  SELECT MIN(expiration_date) INTO expirationDate
  FROM Licenses
  WHERE user_id = NotifyLicenseExpiration.userId;
  
  IF SYSDATE >= expirationDate THEN
    -- Your code for sending a notification about license expiration
    DBMS_OUTPUT.PUT_LINE('Notification: Your license has expired!');
  END IF;
END;

--Procedure "AccessSoftwareWithValidLicense" for accessing software with an active license:

CREATE OR REPLACE PROCEDURE AccessSoftwareWithValidLicense(userId IN NUMBER, softwareId IN NUMBER)
IS
  licenseCount NUMBER;
BEGIN
  SELECT COUNT(*) INTO licenseCount
  FROM Licenses
  WHERE user_id = AccessSoftwareWithValidLicense.userId AND
        software_id = AccessSoftwareWithValidLicense.softwareId AND
        expiration_date >= SYSDATE;
  
  IF licenseCount > 0 THEN
    -- Your code for granting access to software with an active license
    DBMS_OUTPUT.PUT_LINE('Access granted. You can use the software.');
  ELSE
    -- Your code for handling absence of an active license
    DBMS_OUTPUT.PUT_LINE('Access denied. An active license is required to use the software.');
  END IF;
END;

--Procedure "AddVendor" for adding a vendor (only for administrators):

CREATE OR REPLACE PROCEDURE AddVendor(vendorName IN VARCHAR2, vendorAddress IN VARCHAR2, vendorContact IN VARCHAR2)
IS
BEGIN
  INSERT INTO Vendors (vendor_name, vendor_address, vendor_contact)
  VALUES (AddVendor.vendorName, AddVendor.vendorAddress, AddVendor.vendorContact);
  COMMIT;
END;

--Procedure "DeleteVendor" for deleting a vendor (only for administrators):

CREATE OR REPLACE PROCEDURE DeleteVendor(vendorId IN NUMBER)
IS
BEGIN
  DELETE FROM Vendors WHERE vendor_id = DeleteVendor.vendorId;
  COMMIT;
END;

--Procedure "UpdateVendor" for updating vendor data (only for administrators):

CREATE OR REPLACE PROCEDURE UpdateVendor(vendorId IN NUMBER, vendorName IN VARCHAR2, vendorAddress IN VARCHAR2, vendorContact IN VARCHAR2)
IS
BEGIN
  UPDATE Vendors
  SET vendor_name = UpdateVendor.vendorName, vendor_address = UpdateVendor.vendorAddress, vendor_contact = UpdateVendor.vendorContact
  WHERE vendor_id = UpdateVendor.vendorId;
  COMMIT;
END;

--Procedure "RevokeLicense" for revoking a license (only for administrators):

CREATE OR REPLACE PROCEDURE RevokeLicense(licenseId IN NUMBER)
IS
BEGIN
  DELETE FROM Licenses WHERE license_id = RevokeLicense.licenseId;
  COMMIT;
END;

--Procedure "RenewLicense" for renewing a license (only for administrators):

CREATE OR REPLACE PROCEDURE RenewLicense(licenseId IN NUMBER, expirationDate IN DATE)
IS
BEGIN
  UPDATE Licenses
  SET expiration_date = RenewLicense.expirationDate
  WHERE license_id = RenewLicense.licenseId;
  COMMIT;
END;

--Procedure "UpdateLicense" for updating license data (only for administrators):

CREATE OR REPLACE PROCEDURE UpdateLicense(licenseId IN NUMBER, expirationDate IN DATE)
IS
BEGIN
  UPDATE Licenses
  SET expiration_date = UpdateLicense. expirationDate
  WHERE license_id = UpdateLicense.licenseId;
  COMMIT;
END;

--Procedure "GrantLicense" for granting a license (only for administrators):

CREATE OR REPLACE PROCEDURE GrantLicense(softwareId IN NUMBER, userId IN NUMBER, licenseKey IN VARCHAR2, expirationDate IN DATE)
IS
BEGIN
  INSERT INTO Licenses (software_id, user_id, license_key, expiration_date)
  VALUES (GrantLicense.softwareId, GrantLicense.userId, GrantLicense.licenseKey, GrantLicense.expirationDate);
  COMMIT;
END;







