using Microsoft.Data.SqlClient;

Console.Write("Ange en epostadress: ");
var email = Console.ReadLine();

Console.WriteLine("\nOsäker sökning:");
SearchUserUnsafe(email);

Console.WriteLine("\n\nSäker sökning:");
SearchUserSafe(email);


Console.Write("\n\nTryck på en tangent för att stänga fönstret...");
Console.ReadKey();


static void SearchUserUnsafe(string email)
{
    //string connectionString = "Server=YOUR_SERVER;Database=YOUR_DB;Trusted_Connection=True;TrustServerCertificate=True;";
    string connectionString = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=FailSafeIT;Integrated Security=True;Connect Timeout=30;Encrypt=True;Trust Server Certificate=False;Application Intent=ReadWrite;Multi Subnet Failover=False;Command Timeout=30";

    // Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=FailSafeIT;Integrated Security=True;Connect Timeout=30;Encrypt=True;Trust Server Certificate=False;Application Intent=ReadWrite;Multi Subnet Failover=False;Command Timeout=30

    // FEL/SÅRBART: Strängkonkaternering gör att indata blir en del av själva SQL-koden
    string query = "SELECT Id, Username, Email FROM Users WHERE Email = '" + email + "'";

    using (SqlConnection conn = new SqlConnection(connectionString))
    {
        SqlCommand cmd = new SqlCommand(query, conn);
        conn.Open();
        using (SqlDataReader reader = cmd.ExecuteReader())
        {
            while (reader.Read())
            {
                Console.WriteLine($"ID: {reader["Id"]}, User: {reader["Username"]}, Email: {reader["Email"]}");
            }
        }
    }
}

static void SearchUserSafe(string email)
{
    //string connectionString = "Server=YOUR_SERVER;Database=YOUR_DB;Trusted_Connection=True;TrustServerCertificate=True;";
    string connectionString = "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=FailSafeIT;Integrated Security=True;Connect Timeout=30;Encrypt=True;Trust Server Certificate=False;Application Intent=ReadWrite;Multi Subnet Failover=False;Command Timeout=30";


    // RÄTT/SÄKERT: Använd en parameter (@Email) istället för sammansatt sträng
    string query = "SELECT Id, Username, Email FROM Users WHERE Email = @Email";

    using (SqlConnection conn = new SqlConnection(connectionString))
    {
        SqlCommand cmd = new SqlCommand(query, conn);

        // Här definieras datatyp och storlek explicit för parametern
        cmd.Parameters.Add("@Email", System.Data.SqlDbType.VarChar, 100).Value = email;

        conn.Open();
        using (SqlDataReader reader = cmd.ExecuteReader())
        {
            while (reader.Read())
            {
                Console.WriteLine($"ID: {reader["Id"]}, User: {reader["Username"]}, Email: {reader["Email"]}");
            }
        }
    }
}

