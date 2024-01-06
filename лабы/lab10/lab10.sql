use HandleSoftwareLicenses;
Go
CREATE FUNCTION GetLicense(@path nvarchar(255)) RETURNS LicenseData
EXTERNAL NAME CLRAssemb.UserDefinedFunctions.GetLicenseFromFile;
GO
CREATE TYPE LicenseData
EXTERNAL NAME CLRAssemb.LicenseData;
Go
CREATE ASSEMBLY CLRAssemb
FROM 'C:\Program Files\Microsoft SQL Server\CLRObjects.dll'
WITH PERMISSION_SET = EXTERNAL_ACCESS;
EXEC sp_add_trusted_assembly 'CLRFunction';
sp_configure 'clr enabled'
RECONFIGURE 
sp_configure 'show advanced options',1
sp_configure 'clr strict security', 0;
RECONFIGURE;

ALTER DATABASE [HandleSoftwareLicenses] SET TRUSTWORTHY ON;

Select dbo.GetLicense('C:\Program Files\Microsoft SQL Server\Data.txt').ToString();


