using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Data.Sqlite;
using System.IO;
using System.Text;

namespace OSGeo.MapGuide.Test.Common
{
    public class SqliteDb
    {
        private SqliteConnection _conn;

        public void Open(string dbName)
        {
            _conn = new SqliteConnection($"Data Source={dbName}");
            _conn.Open();
        }

        internal SqliteConnection Connection => _conn;

        public void Close()
        {
            _conn?.Close();
        }

        public void GenerateDatabase(string dumpFileName, string dbName)
        {
            using (var conn = new SqliteConnection($"Data Source={dbName}"))
            {
                conn.Open();

                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = File.ReadAllText(dumpFileName);
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }

    public class SqliteGcBlob
    {
        private byte[] _bytes;

        public SqliteGcBlob(byte[] bytes)
        {
            _bytes = bytes;
        }

        public byte[] Read() => _bytes;
    }

    public class SqliteVm
    {
        private SqliteDataReader _rdr;
        private SqliteDb _db;

        public SqliteVm(SqliteDb db, bool b)
        {
            _db = db;
        }

        public int Execute(string sql)
        {
            var cmd = _db.Connection.CreateCommand();
            cmd.CommandText = sql;
            _rdr = cmd.ExecuteReader();
            return NextRow();
        }

        public SqliteGcBlob GetBlob(string name)
        {
            if (_rdr == null)
                return null;

            int ordinal = _rdr.GetOrdinal(name);
            if (ordinal >= 0)
            {
                if (!_rdr.IsDBNull(ordinal))
                {
                    var type = _rdr.GetFieldType(ordinal);
                    if (type == typeof(byte[]))
                    {
                        return new SqliteGcBlob(_rdr.GetFieldValue<byte[]>(ordinal));
                    }
                    else
                    {
                        var result = GetString(name);
                        return new SqliteGcBlob(Encoding.UTF8.GetBytes(result));
                    }
                }
            }

            return null;
        }

        public string GetString(string name)
        {
            if (_rdr == null)
                return string.Empty;

            int ordinal = _rdr.GetOrdinal(name);
            if (ordinal >= 0)
            {
                if (!_rdr.IsDBNull(ordinal))
                {
                    return _rdr[ordinal].ToString();
                }
            }

            return string.Empty;
        }

        public int NextRow() => (_rdr?.Read() == true) ? Sqlite.Row : Sqlite.EndOfReader;

        public void SqlFinalize()
        {
            _rdr?.Dispose();
            _rdr = null;
        }
    }

    public class Sqlite
    {
        public const int OK = 0;
        public const int Row = 1;
        public const int EndOfReader = 2;
    }
}
