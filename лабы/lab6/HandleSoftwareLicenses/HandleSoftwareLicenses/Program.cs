

using System.Data.SQLite;
using HandleSoftwareLicenses.Database;

namespace HandleSoftwareLicenses;

class Program
{
    public static void Main()
    {
        DBContext db = new DBContext("HandleSoftwareLicenses.db");
        SQLiteConnection conn = db.GetDbConnection();
        conn.Open();


    }
}

