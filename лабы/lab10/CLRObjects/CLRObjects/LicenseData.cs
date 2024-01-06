using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;
using Microsoft.SqlServer.Server;


[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedType(Format.UserDefined, IsByteOrdered = true, MaxByteSize = 8000)]
public struct LicenseData: INullable,IBinarySerialize
{
    public override string ToString()
    {
        // Replace with your own code
        return $"{LicenseName} {LicenseKey} {ExpirationDate}";
    }
    
    public bool IsNull
    {
        get
        {
            // Put your code here
            return _null;
        }
    }
    
    public static LicenseData Null
    {
        get
        {
            LicenseData h = new LicenseData();
            h._null = true;
            return h;
        }
    }
    
    public static LicenseData Parse(SqlString s)
    {
        if (s.IsNull)
            return Null;
        LicenseData u = new LicenseData();
        // Put your code here
        return u;
    }

    public void Read(BinaryReader r)
    {
        LicenseKey = new SqlString(r.ReadString());
        LicenseName = new SqlString(r.ReadString());
        ExpirationDate = new SqlString(r.ReadString());
    }

    public void Write(BinaryWriter w)
    {
        w.Write(LicenseKey.Value);
        w.Write(LicenseName.Value);
        w.Write(ExpirationDate.Value);
    }


    // This is a place-holder member field
    public SqlString LicenseKey { get; set; }
    public SqlString LicenseName { get; set; }
    public SqlString ExpirationDate { get; set; }

    //  Private member
    private bool _null;
}