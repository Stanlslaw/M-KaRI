using System;
using System.Collections.Generic;
using System.Data.SQLite;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HandleSoftwareLicenses.Database
{
    internal class DBContext
    {
        private SQLiteConnection conn;
        public DBContext(string filename)
        {
            if (!File.Exists("HandleSoftwareLicenses.db"))
            {
                File.Create("HandleSoftwareLicenses.db");
            }
            conn=new SQLiteConnection($"Data Source={filename};Version=3;");
        }

        public SQLiteConnection GetDbConnection()
        {
            return conn;
        }
        
    }
}
