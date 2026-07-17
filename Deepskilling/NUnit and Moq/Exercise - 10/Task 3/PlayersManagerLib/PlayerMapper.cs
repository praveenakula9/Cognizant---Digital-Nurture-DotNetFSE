using System.Data.SqlClient;

namespace PlayersManagerLib
{
    public class PlayerMapper : IPlayerMapper
    {
        private readonly string _connectionString =
            "Data Source=(local);Initial Catalog=GameDB;Integrated Security=True";

        public bool IsPlayerNameExistsInDb(string name)
        {
            using SqlConnection connection = new SqlConnection(_connectionString);

            connection.Open();

            using SqlCommand command = connection.CreateCommand();

            command.CommandText = "SELECT COUNT(*) FROM Player WHERE Name=@name";
            command.Parameters.AddWithValue("@name", name);

            int count = (int)command.ExecuteScalar();

            return count > 0;
        }

        public void AddNewPlayerIntoDb(string name)
        {
            using SqlConnection connection = new SqlConnection(_connectionString);

            connection.Open();

            using SqlCommand command = connection.CreateCommand();

            command.CommandText = "INSERT INTO Player(Name) VALUES(@name)";
            command.Parameters.AddWithValue("@name", name);

            command.ExecuteNonQuery();
        }
    }
}