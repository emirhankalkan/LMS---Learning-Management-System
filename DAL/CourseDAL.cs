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

        public bool EnrollFreeCourse(int userId, int courseId)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd = new SqlCommand(
                @"IF EXISTS (SELECT 1 FROM Courses WHERE CourseId = @CourseId AND IsActive = 1 AND IsFree = 1)
                  BEGIN
                      IF NOT EXISTS (SELECT 1 FROM Enrollments WHERE UserId = @UserId AND CourseId = @CourseId)
                          INSERT INTO Enrollments (UserId, CourseId) VALUES (@UserId, @CourseId);

                      SELECT CAST(1 AS BIT);
                  END
                  ELSE
                      SELECT CAST(0 AS BIT);", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@CourseId", courseId);
                return Convert.ToBoolean(cmd.ExecuteScalar());
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
            {
                EnsureCourseDiscounts(conn);

                using (var cmd = new SqlCommand(
                    @"DELETE FROM CourseDiscounts WHERE CourseId = @CourseId;
                      DELETE FROM CourseDiscounts WHERE Code = UPPER(LTRIM(RTRIM(@Code)));
                      INSERT INTO CourseDiscounts (CourseId, Code, DiscountPercentage, IsActive)
                      VALUES (@CourseId, UPPER(LTRIM(RTRIM(@Code))), @DiscountPercentage, 1);", conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    cmd.Parameters.AddWithValue("@Code", code);
                    cmd.Parameters.AddWithValue("@DiscountPercentage", discountPercentage);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        public void ClearCourseDiscount(int courseId)
        {
            using (var conn = Db.OpenConnection())
            {
                EnsureCourseDiscounts(conn);

                using (var cmd = new SqlCommand("DELETE FROM CourseDiscounts WHERE CourseId = @CourseId", conn))
                {
                    cmd.Parameters.AddWithValue("@CourseId", courseId);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        public CourseDiscount GetDiscountByCode(string code)
        {
            using (var conn = Db.OpenConnection())
            {
                EnsureCourseDiscounts(conn);

                using (var cmd = new SqlCommand(
                    @"SELECT TOP 1 *
                      FROM CourseDiscounts
                      WHERE Code = UPPER(LTRIM(RTRIM(@Code))) AND IsActive = 1;", conn))
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
            }
            return null;
        }

        public CourseDiscount GetDiscountByCourse(int courseId)
        {
            using (var conn = Db.OpenConnection())
            {
                EnsureCourseDiscounts(conn);

                using (var cmd = new SqlCommand(
                    @"SELECT TOP 1 *
                      FROM CourseDiscounts
                      WHERE CourseId = @CourseId AND IsActive = 1
                      ORDER BY CreatedAt DESC;", conn))
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
            }
            return null;
        }

        private static void EnsureCourseDiscounts(SqlConnection conn)
        {
            using (var cmd = new SqlCommand(
                @"IF OBJECT_ID('dbo.CourseDiscounts', 'U') IS NULL
                  BEGIN
                      CREATE TABLE dbo.CourseDiscounts (
                          DiscountId INT IDENTITY(1,1) PRIMARY KEY,
                          CourseId INT NOT NULL REFERENCES dbo.Courses(CourseId) ON DELETE CASCADE,
                          Code NVARCHAR(50) NOT NULL UNIQUE,
                          DiscountPercentage INT NOT NULL CHECK (DiscountPercentage BETWEEN 1 AND 99),
                          IsActive BIT NOT NULL DEFAULT 1,
                          CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
                      );
                  END", conn))
            {
                cmd.ExecuteNonQuery();
            }
        }

        // ---- Sipariş Geçmişi ----
        public List<Models.Order> GetUserOrders(int userId)
        {
            var list = new List<Models.Order>();
            using (var conn = Db.OpenConnection())
            using (var cmd = Db.StoredProcedure("sp_GetUserOrders", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new Models.Order
                        {
                            OrderId      = Convert.ToInt32(reader["OrderId"]),
                            UserId       = Convert.ToInt32(reader["UserId"]),
                            CourseId     = Convert.ToInt32(reader["CourseId"]),
                            CourseTitle  = reader["CourseTitle"].ToString(),
                            ThumbnailUrl = reader["ThumbnailUrl"] == DBNull.Value ? null : reader["ThumbnailUrl"].ToString(),
                            Amount       = Convert.ToDecimal(reader["Amount"]),
                            Status       = reader["Status"].ToString(),
                            PaymentRef   = reader["PaymentRef"] == DBNull.Value ? null : reader["PaymentRef"].ToString(),
                            CreatedAt    = Convert.ToDateTime(reader["CreatedAt"])
                        });
                    }
                }
            }
            return list;
        }

        // ---- Ders Tamamlama ----
        public void CompleteLesson(int userId, int lessonId)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd = Db.StoredProcedure("sp_CompleteLesson", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@LessonId", lessonId);
                cmd.ExecuteNonQuery();
            }
        }

        public void MarkLessonWatched(int userId, int lessonId)
        {
            using (var conn = Db.OpenConnection())
            {
                EnsureLastWatchedColumn(conn);

                using (var cmd = new SqlCommand(
                    @"IF EXISTS (SELECT 1 FROM LessonProgress WHERE UserId = @UserId AND LessonId = @LessonId)
                          UPDATE LessonProgress
                          SET LastWatchedAt = GETDATE()
                          WHERE UserId = @UserId AND LessonId = @LessonId;
                      ELSE
                          INSERT INTO LessonProgress (UserId, LessonId, IsCompleted, CompletedAt, LastWatchedAt)
                          VALUES (@UserId, @LessonId, 0, NULL, GETDATE());", conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@LessonId", lessonId);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        public Lesson GetLastWatchedLesson(int userId)
        {
            using (var conn = Db.OpenConnection())
            {
                EnsureLastWatchedColumn(conn);

                using (var cmd = new SqlCommand(
                    @"SELECT TOP 1
                             l.LessonId,
                             l.CourseId,
                             l.Title,
                             l.VideoUrl,
                             l.Duration,
                             l.OrderIndex,
                             l.IsPreview,
                             c.Title AS CourseTitle,
                             (SELECT COUNT(*) FROM Lessons tl WHERE tl.CourseId = l.CourseId) AS TotalLessons,
                             (SELECT COUNT(*)
                              FROM LessonProgress clp
                              JOIN Lessons cl ON cl.LessonId = clp.LessonId
                              WHERE clp.UserId = @UserId
                                AND cl.CourseId = l.CourseId
                                AND clp.IsCompleted = 1) AS CompletedLessons
                      FROM LessonProgress lp
                      JOIN Lessons l ON l.LessonId = lp.LessonId
                      JOIN Courses c ON c.CourseId = l.CourseId
                      WHERE lp.UserId = @UserId
                        AND c.IsActive = 1
                        AND EXISTS (
                            SELECT 1
                            FROM Enrollments e
                            WHERE e.UserId = @UserId AND e.CourseId = l.CourseId
                        )
                        AND (lp.LastWatchedAt IS NOT NULL OR lp.CompletedAt IS NOT NULL)
                      ORDER BY COALESCE(lp.LastWatchedAt, lp.CompletedAt) DESC, lp.ProgressId DESC;", conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    using (var reader = cmd.ExecuteReader())
                    {
                        if (!reader.Read()) return null;

                        var completed = Convert.ToInt32(reader["CompletedLessons"]);
                        var total = Convert.ToInt32(reader["TotalLessons"]);

                        return new Lesson
                        {
                            LessonId = Convert.ToInt32(reader["LessonId"]),
                            CourseId = Convert.ToInt32(reader["CourseId"]),
                            Title = reader["Title"].ToString(),
                            VideoUrl = reader["VideoUrl"] == DBNull.Value ? null : reader["VideoUrl"].ToString(),
                            Duration = Convert.ToInt32(reader["Duration"]),
                            OrderIndex = Convert.ToInt32(reader["OrderIndex"]),
                            IsPreview = Convert.ToBoolean(reader["IsPreview"]),
                            CourseTitle = reader["CourseTitle"].ToString(),
                            CompletedLessons = completed,
                            TotalLessons = total,
                            CourseProgressPercent = total > 0 ? (completed * 100) / total : 0
                        };
                    }
                }
            }
        }

        private static void EnsureLastWatchedColumn(SqlConnection conn)
        {
            using (var cmd = new SqlCommand(
                @"IF COL_LENGTH('dbo.LessonProgress', 'LastWatchedAt') IS NULL
                      ALTER TABLE dbo.LessonProgress ADD LastWatchedAt DATETIME NULL;", conn))
            {
                cmd.ExecuteNonQuery();
            }
        }

        // ---- Kullanıcının Kursa Kayıtlı Olup Olmadığını Kontrol Et ----
        public bool IsEnrolled(int userId, int courseId)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd = new SqlCommand(
                "SELECT COUNT(*) FROM Enrollments WHERE UserId=@UserId AND CourseId=@CourseId", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@CourseId", courseId);
                return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
            }
        }
    }
}
