using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;
using Microsoft.SqlServer.Server;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction]
    public static LicenseData GetLicenseFromFile(string path)
    {
        LicenseData licenseData = new LicenseData();
        StreamReader sr = new StreamReader(path);
        licenseData.LicenseKey = sr.ReadLine();
        licenseData.LicenseName = sr.ReadLine();
        licenseData.ExpirationDate = sr.ReadLine();
        return licenseData;
    }
}
