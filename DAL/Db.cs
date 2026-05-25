using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace EduFlow.DAL
{
    public static class Db
    {
        public static SqlConnection OpenConnection()
        {
            var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["EduFlowDb"].ConnectionString);
            connection.Open();
            return connection;
        }

        public static SqlCommand StoredProcedure(string name, SqlConnection connection)
        {
            return new SqlCommand(name, connection) { CommandType = CommandType.StoredProcedure };
        }
    }
}
