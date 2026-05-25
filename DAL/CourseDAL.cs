using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using EduFlow.Models;

namespace EduFlow.DAL
{
    public class CourseDAL
    {
        public List<Course> GetAllCourses()
        {
            return ReadCourses("sp_GetAllCourses");
        }

        public List<Course> GetFeaturedCourses()
        {
            return ReadCourses("sp_GetFeaturedCourses");
        }

        public List<Course> GetFreeCourses()
        {
            return ReadCourses("sp_GetFreeCourses");
        }

        public List<Course> SearchCourses(string query, int categoryId, string level)
        {
            var courses = new List<Course>();
            using (var conn = Db.OpenConnection())
            using (var cmd = Db.StoredProcedure("sp_SearchCourses", conn))
            {
                cmd.Parameters.AddWithValue("@Query", string.IsNullOrEmpty(query) ? "" : query);
                cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                cmd.Parameters.AddWithValue("@Level", string.IsNullOrEmpty(level) ? "" : level);
                using (var reader = cmd.ExecuteReader())
                    while (reader.Read())
                        courses.Add(MapCourse(reader));
            }
            return courses;
        }

        public Course GetCourseDetail(int courseId)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd = Db.StoredProcedure("sp_GetCourseDetail", conn))
            {
                cmd.Parameters.AddWithValue("@CourseId", courseId);
                using (var reader = cmd.ExecuteReader())
                    return reader.Read() ? MapCourse(reader) : null;
            }
        }

        public List<Lesson> GetLessonsByCourse(int courseId)
        {
            var list = new List<Lesson>();
            using (var conn = Db.OpenConnection())
            using (var cmd = Db.StoredProcedure("sp_GetLessonsByCourse", conn))
            {
                cmd.Parameters.AddWithValue("@CourseId", courseId);
                using (var reader = cmd.ExecuteReader())
                    while (reader.Read())
                        list.Add(new Lesson
                        {
                            LessonId   = Convert.ToInt32(reader["LessonId"]),
                            CourseId   = Convert.ToInt32(reader["CourseId"]),
                            Title      = reader["Title"].ToString(),
                            VideoUrl   = reader["VideoUrl"] == DBNull.Value ? null : reader["VideoUrl"].ToString(),
                            Duration   = Convert.ToInt32(reader["Duration"]),
                            OrderIndex = Convert.ToInt32(reader["OrderIndex"]),
                            IsPreview  = Convert.ToBoolean(reader["IsPreview"])
                        });
            }
            return list;
        }

        public List<Review> GetApprovedReviews(int courseId)
        {
            var list = new List<Review>();
            using (var conn = Db.OpenConnection())
            using (var cmd = Db.StoredProcedure("sp_GetApprovedReviews", conn))
            {
                cmd.Parameters.AddWithValue("@CourseId", courseId);
                using (var reader = cmd.ExecuteReader())
                    while (reader.Read())
                        list.Add(new Review
                        {
                            ReviewId   = Convert.ToInt32(reader["ReviewId"]),
                            CourseId   = Convert.ToInt32(reader["CourseId"]),
                            FullName   = reader["FullName"].ToString(),
                            Rating     = Convert.ToInt32(reader["Rating"]),
                            Comment    = reader["Comment"].ToString(),
                            IsApproved = Convert.ToBoolean(reader["IsApproved"]),
                            CreatedAt  = Convert.ToDateTime(reader["CreatedAt"])
                        });
            }
            return list;
        }

        public List<Category> GetAllCategories()
        {
            var list = new List<Category>();
            using (var conn = Db.OpenConnection())
            using (var cmd = Db.StoredProcedure("sp_GetAllCategories", conn))
            using (var reader = cmd.ExecuteReader())
                while (reader.Read())
                    list.Add(new Category
                    {
                        CategoryId  = Convert.ToInt32(reader["CategoryId"]),
                        Name        = reader["Name"].ToString(),
                        IconClass   = reader["IconClass"].ToString(),
                        CourseCount = reader["CourseCount"] == DBNull.Value ? 0 : Convert.ToInt32(reader["CourseCount"])
                    });
            return list;
        }

        // ---- Yeni Metotlar (Dashboard, Favorites, Orders) ----
        public List<Course> GetUserDashboard(int userId)
        {
            var list = new List<Course>();
            using (var conn = Db.OpenConnection())
            using (var cmd = Db.StoredProcedure("sp_GetUserDashboard", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                using (var reader = cmd.ExecuteReader())
                    while (reader.Read())
                        list.Add(MapCourse(reader));
            }
            return list;
        }

        public List<Course> GetUserFavorites(int userId)
        {
            var list = new List<Course>();
            using (var conn = Db.OpenConnection())
            using (var cmd = Db.StoredProcedure("sp_GetUserFavorites", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                using (var reader = cmd.ExecuteReader())
                    while (reader.Read())
                        list.Add(MapCourse(reader));
            }
            return list;
        }

        public void ToggleFavorite(int userId, int courseId)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd = Db.StoredProcedure("sp_ToggleFavorite", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@CourseId", courseId);
                cmd.ExecuteNonQuery();
            }
        }

        public int CreateOrder(int userId, int courseId, decimal amount)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd = Db.StoredProcedure("sp_CreateOrder", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@CourseId", courseId);
                cmd.Parameters.AddWithValue("@Amount", amount);
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        public void CompleteOrder(int orderId, string paymentRef)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd = Db.StoredProcedure("sp_CompleteOrder", conn))
            {
                cmd.Parameters.AddWithValue("@OrderId", orderId);
                cmd.Parameters.AddWithValue("@PaymentRef", paymentRef);
                cmd.ExecuteNonQuery();
            }
        }

        // ---- Yardımcı ----
        private static List<Course> ReadCourses(string sp)
        {
            var list = new List<Course>();
            using (var conn = Db.OpenConnection())
            using (var cmd  = Db.StoredProcedure(sp, conn))
            using (var r    = cmd.ExecuteReader())
                while (r.Read())
                    list.Add(MapCourse(r));
            return list;
        }

        private static Course MapCourse(SqlDataReader r)
        {
            var c = new Course
            {
                CourseId       = Convert.ToInt32(r["CourseId"]),
                Title          = r["Title"].ToString(),
                Description    = r["Description"].ToString(),
                ThumbnailUrl   = r["ThumbnailUrl"] == DBNull.Value ? null : r["ThumbnailUrl"].ToString(),
                Price          = Convert.ToDecimal(r["Price"]),
                IsFree         = Convert.ToBoolean(r["IsFree"]),
                IsFeatured     = Convert.ToBoolean(r["IsFeatured"]),
                CategoryId     = Convert.ToInt32(r["CategoryId"]),
                CategoryName   = r["CategoryName"].ToString(),
                InstructorName = r["InstructorName"].ToString(),
                InstructorUserId = r["InstructorUserId"] == DBNull.Value ? (int?)null : Convert.ToInt32(r["InstructorUserId"]),
                Level          = r["Level"].ToString(),
                Language       = r["Language"].ToString(),
                LessonCount    = r["LessonCount"] == DBNull.Value ? 0 : Convert.ToInt32(r["LessonCount"]),
                TotalHours     = r["TotalHours"]  == DBNull.Value ? 0 : Convert.ToInt32(r["TotalHours"]),
                AverageRating  = r["AverageRating"] == DBNull.Value ? 0 : Convert.ToDouble(r["AverageRating"]),
                EnrollmentCount= r["EnrollmentCount"] == DBNull.Value ? 0 : Convert.ToInt32(r["EnrollmentCount"]),
                IsActive       = Convert.ToBoolean(r["IsActive"])
            };

            for (int i = 0; i < r.FieldCount; i++)
            {
                if (r.GetName(i).Equals("CompletedLessons", StringComparison.OrdinalIgnoreCase))
                {
                    c.CompletedLessons = r["CompletedLessons"] == DBNull.Value ? 0 : Convert.ToInt32(r["CompletedLessons"]);
                    break;
                }
            }

            return c;
        }

        public void SaveCourseDiscount(int courseId, string code, int discountPercentage)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd = Db.StoredProcedure("sp_SaveCourseDiscount", conn))
            {
                cmd.Parameters.AddWithValue("@CourseId", courseId);
                cmd.Parameters.AddWithValue("@Code", code);
                cmd.Parameters.AddWithValue("@DiscountPercentage", discountPercentage);
                cmd.ExecuteNonQuery();
            }
        }

        public CourseDiscount GetDiscountByCode(string code)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd = Db.StoredProcedure("sp_GetDiscountByCode", conn))
            {
                cmd.Parameters.AddWithValue("@Code", code);
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return new CourseDiscount
                        {
                            DiscountId = Convert.ToInt32(reader["DiscountId"]),
                            CourseId = Convert.ToInt32(reader["CourseId"]),
                            Code = reader["Code"].ToString(),
                            DiscountPercentage = Convert.ToInt32(reader["DiscountPercentage"]),
                            IsActive = Convert.ToBoolean(reader["IsActive"]),
                            CreatedAt = Convert.ToDateTime(reader["CreatedAt"])
                        };
                    }
                }
            }
            return null;
        }

        public CourseDiscount GetDiscountByCourse(int courseId)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd = Db.StoredProcedure("sp_GetDiscountByCourse", conn))
            {
                cmd.Parameters.AddWithValue("@CourseId", courseId);
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return new CourseDiscount
                        {
                            DiscountId = Convert.ToInt32(reader["DiscountId"]),
                            CourseId = Convert.ToInt32(reader["CourseId"]),
                            Code = reader["Code"].ToString(),
                            DiscountPercentage = Convert.ToInt32(reader["DiscountPercentage"]),
                            IsActive = Convert.ToBoolean(reader["IsActive"]),
                            CreatedAt = Convert.ToDateTime(reader["CreatedAt"])
                        };
                    }
                }
            }
            return null;
        }
    }
}
