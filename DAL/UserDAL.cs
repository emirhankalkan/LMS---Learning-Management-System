using System;
using System.Data.SqlClient;
using EduFlow.Models;
using EduFlow.Services;

namespace EduFlow.DAL
{
    public class UserDAL
    {
        public User Login(string email, string password)
        {
            using (var connection = Db.OpenConnection())
            using (var command = new SqlCommand(@"
                SELECT u.UserId, u.FullName, u.Email, u.Password, u.PhotoUrl, u.IsActive,
                       u.CreatedAt, r.RoleName
                FROM   Users u
                JOIN   Roles r ON r.RoleId = u.RoleId
                WHERE  u.Email = @Email AND u.IsActive = 1;", connection))
            {
                command.Parameters.AddWithValue("@Email", email);

                using (var reader = command.ExecuteReader())
                {
                    if (!reader.Read())
                        return null;

                    var user = MapUser(reader);
                    return SecurityService.VerifyPassword(password, user.Password) ? user : null;
                }
            }
        }

        public int Register(string fullName, string email, string passwordHash)
        {
            using (var connection = Db.OpenConnection())
            using (var command = Db.StoredProcedure("sp_RegisterUser", connection))
            {
                command.Parameters.AddWithValue("@FullName", fullName);
                command.Parameters.AddWithValue("@Email", email);
                command.Parameters.AddWithValue("@Password", passwordHash);
                return Convert.ToInt32(command.ExecuteScalar());
            }
        }

        public int RegisterInstructor(string fullName, string email, string passwordHash,
                                      int categoryId, string bio, string linkedIn, string portfolio)
        {
            using (var connection = Db.OpenConnection())
            using (var command = Db.StoredProcedure("sp_RegisterInstructor", connection))
            {
                command.Parameters.AddWithValue("@FullName",     fullName);
                command.Parameters.AddWithValue("@Email",        email);
                command.Parameters.AddWithValue("@Password",     passwordHash);
                command.Parameters.AddWithValue("@CategoryId",   categoryId);
                command.Parameters.AddWithValue("@Bio",          bio ?? "");
                command.Parameters.AddWithValue("@LinkedInUrl",  linkedIn ?? "");
                command.Parameters.AddWithValue("@PortfolioUrl", portfolio ?? "");
                return Convert.ToInt32(command.ExecuteScalar());
            }
        }


        private static User MapUser(SqlDataReader reader)
        {
            return new User
            {
                UserId = Convert.ToInt32(reader["UserId"]),
                FullName = reader["FullName"].ToString(),
                Email = reader["Email"].ToString(),
                Password = reader["Password"] == DBNull.Value ? null : reader["Password"].ToString(),
                PhotoUrl = reader["PhotoUrl"] == DBNull.Value ? null : reader["PhotoUrl"].ToString(),
                RoleName = reader["RoleName"].ToString(),
                IsActive = Convert.ToBoolean(reader["IsActive"]),
                CreatedAt = Convert.ToDateTime(reader["CreatedAt"])
            };
        }
    }
}
