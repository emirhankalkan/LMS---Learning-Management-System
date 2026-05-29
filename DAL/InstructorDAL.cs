using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using EduFlow.Models;

namespace EduFlow.DAL
{
    public class InstructorDAL
    {
        // ---- Dashboard İstatistikleri ----
        public InstructorStats GetDashboard(int userId)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd  = Db.StoredProcedure("sp_GetInstructorDashboard", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                using (var r = cmd.ExecuteReader())
                {
                    if (!r.Read()) return new InstructorStats();
                    return new InstructorStats
                    {
                        TotalCourses  = Convert.ToInt32(r["TotalCourses"]),
                        TotalStudents = Convert.ToInt32(r["TotalStudents"]),
                        TotalRevenue  = Convert.ToDecimal(r["TotalRevenue"]),
                        TotalReviews  = Convert.ToInt32(r["TotalReviews"]),
                        AvgRating     = Convert.ToDouble(r["AvgRating"])
                    };
                }
            }
        }

        // ---- Eğitmenin Kursları ----
        public List<InstructorCourse> GetMyCourses(int userId)
        {
            var list = new List<InstructorCourse>();
            using (var conn = Db.OpenConnection())
            using (var cmd  = Db.StoredProcedure("sp_GetInstructorCourses", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        list.Add(new InstructorCourse
                        {
                            CourseId        = Convert.ToInt32(r["CourseId"]),
                            Title           = r["Title"].ToString(),
                            CategoryName    = r["CategoryName"].ToString(),
                            Level           = r["Level"].ToString(),
                            Price           = Convert.ToDecimal(r["Price"]),
                            IsFree          = Convert.ToBoolean(r["IsFree"]),
                            ThumbnailUrl    = r["ThumbnailUrl"] == DBNull.Value ? null : r["ThumbnailUrl"].ToString(),
                            EnrollmentCount = Convert.ToInt32(r["EnrollmentCount"]),
                            AverageRating   = Convert.ToDouble(r["AverageRating"]),
                            CourseRevenue   = Convert.ToDecimal(r["CourseRevenue"]),
                            LessonCount     = Convert.ToInt32(r["LessonCount"]),
                            IsActive        = Convert.ToBoolean(r["IsActive"])
                        });
                    }
                }
            }
            return list;
        }

        // ---- Öğrenci Listesi ----
        public List<InstructorStudent> GetMyStudents(int userId)
        {
            var list = new List<InstructorStudent>();
            using (var conn = Db.OpenConnection())
            using (var cmd  = Db.StoredProcedure("sp_GetInstructorStudents", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        list.Add(new InstructorStudent
                        {
                            UserId      = Convert.ToInt32(r["UserId"]),
                            FullName    = r["FullName"].ToString(),
                            Email       = r["Email"].ToString(),
                            CourseTitle = r["CourseTitle"].ToString(),
                            CourseId    = Convert.ToInt32(r["CourseId"]),
                            EnrolledAt  = Convert.ToDateTime(r["EnrolledAt"])
                        });
                    }
                }
            }
            return list;
        }

        // ---- Son Aktivite ----
        public List<InstructorStudent> GetRecentActivity(int userId)
        {
            var list = new List<InstructorStudent>();
            using (var conn = Db.OpenConnection())
            using (var cmd  = Db.StoredProcedure("sp_GetInstructorRecentActivity", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        list.Add(new InstructorStudent
                        {
                            FullName    = r["FullName"].ToString(),
                            CourseTitle = r["CourseTitle"].ToString(),
                            EnrolledAt  = Convert.ToDateTime(r["EnrolledAt"])
                        });
                    }
                }
            }
            return list;
        }

        // ---- Kurs Ekle ----
        public int AddCourse(string title, string description, string thumbnailUrl,
                             decimal price, bool isFree, int categoryId,
                             int instructorUserId, string instructorName,
                             string level, string language)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd  = Db.StoredProcedure("sp_AddCourse", conn))
            {
                cmd.Parameters.AddWithValue("@Title",             title);
                cmd.Parameters.AddWithValue("@Description",       description);
                cmd.Parameters.AddWithValue("@ThumbnailUrl",      thumbnailUrl ?? "");
                cmd.Parameters.AddWithValue("@Price",             price);
                cmd.Parameters.AddWithValue("@IsFree",            isFree);
                cmd.Parameters.AddWithValue("@CategoryId",        categoryId);
                cmd.Parameters.AddWithValue("@InstructorUserId",  instructorUserId);
                cmd.Parameters.AddWithValue("@InstructorName",    instructorName);
                cmd.Parameters.AddWithValue("@Level",             level);
                cmd.Parameters.AddWithValue("@Language",          language);
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        // ---- Ders Ekle ----
        public int AddLesson(int courseId, string title, string videoUrl, int duration, bool isPreview)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd  = Db.StoredProcedure("sp_AddLesson", conn))
            {
                cmd.Parameters.AddWithValue("@CourseId",  courseId);
                cmd.Parameters.AddWithValue("@Title",     title);
                cmd.Parameters.AddWithValue("@VideoUrl",  videoUrl ?? "");
                cmd.Parameters.AddWithValue("@Duration",  duration);
                cmd.Parameters.AddWithValue("@IsPreview", isPreview);
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        // ---- Kurs Sil (pasife al) ----
        public void DeleteCourse(int courseId, int instructorUserId)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd  = Db.StoredProcedure("sp_DeleteCourse", conn))
            {
                cmd.Parameters.AddWithValue("@CourseId",          courseId);
                cmd.Parameters.AddWithValue("@InstructorUserId",  instructorUserId);
                cmd.ExecuteNonQuery();
            }
        }

        // ---- Kurs Derslerini Getir ----
        public List<Lesson> GetLessons(int courseId)
        {
            var list = new List<Lesson>();
            using (var conn = Db.OpenConnection())
            using (var cmd  = Db.StoredProcedure("sp_GetLessonsByCourse", conn))
            {
                cmd.Parameters.AddWithValue("@CourseId", courseId);
                using (var r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        list.Add(new Lesson
                        {
                            LessonId   = Convert.ToInt32(r["LessonId"]),
                            CourseId   = courseId,
                            Title      = r["Title"].ToString(),
                            VideoUrl   = r["VideoUrl"] == DBNull.Value ? null : r["VideoUrl"].ToString(),
                            Duration   = Convert.ToInt32(r["Duration"]),
                            OrderIndex = Convert.ToInt32(r["OrderIndex"]),
                            IsPreview  = Convert.ToBoolean(r["IsPreview"])
                        });
                    }
                }
            }
            return list;
        }

        // ---- Kurs Güncelle ----
        public void UpdateCourse(int courseId, string title, string description, string thumbnailUrl,
                                 decimal price, bool isFree, int categoryId,
                                 string level, string language)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd  = Db.StoredProcedure("sp_UpdateCourse", conn))
            {
                cmd.Parameters.AddWithValue("@CourseId",     courseId);
                cmd.Parameters.AddWithValue("@Title",        title);
                cmd.Parameters.AddWithValue("@Description",  description);
                cmd.Parameters.AddWithValue("@ThumbnailUrl", thumbnailUrl ?? "");
                cmd.Parameters.AddWithValue("@Price",        price);
                cmd.Parameters.AddWithValue("@IsFree",       isFree);
                cmd.Parameters.AddWithValue("@CategoryId",   categoryId);
                cmd.Parameters.AddWithValue("@Level",        level);
                cmd.Parameters.AddWithValue("@Language",     language);
                cmd.ExecuteNonQuery();
            }
        }

        // ---- Ders Sil ----
        public void DeleteLesson(int lessonId)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd  = Db.StoredProcedure("sp_DeleteLesson", conn))
            {
                cmd.Parameters.AddWithValue("@LessonId", lessonId);
                cmd.ExecuteNonQuery();
            }
        }

        // ---- Ders Sırası Değiştir (Yukarı/Aşağı) ----
        public void MoveLesson(int lessonId, string direction)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd  = Db.StoredProcedure("sp_MoveLesson", conn))
            {
                cmd.Parameters.AddWithValue("@LessonId",  lessonId);
                cmd.Parameters.AddWithValue("@Direction", direction);
                cmd.ExecuteNonQuery();
            }
        }
    }

    // ---- Yardımcı Modeller ----
    public class InstructorStats
    {
        public int     TotalCourses  { get; set; }
        public int     TotalStudents { get; set; }
        public decimal TotalRevenue  { get; set; }
        public int     TotalReviews  { get; set; }
        public double  AvgRating     { get; set; }
    }

    public class InstructorCourse
    {
        public int     CourseId        { get; set; }
        public string  Title           { get; set; }
        public string  CategoryName    { get; set; }
        public string  Level           { get; set; }
        public decimal Price           { get; set; }
        public bool    IsFree          { get; set; }
        public string  ThumbnailUrl    { get; set; }
        public int     EnrollmentCount { get; set; }
        public double  AverageRating   { get; set; }
        public decimal CourseRevenue   { get; set; }
        public int     LessonCount     { get; set; }
        public bool    IsActive        { get; set; }
    }

    public class InstructorStudent
    {
        public int      UserId      { get; set; }
        public string   FullName    { get; set; }
        public string   Email       { get; set; }
        public string   CourseTitle { get; set; }
        public int      CourseId    { get; set; }
        public DateTime EnrolledAt  { get; set; }
    }
}
