using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace EduFlow.DAL
{
    public class Ad
    {
        public int AdId { get; set; }
        public string Title { get; set; }
        public string ImageUrl { get; set; }
        public string RedirectUrl { get; set; }
        public string Position { get; set; }
        public int ClickCount { get; set; }
        public bool IsActive { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
    }

    public class AdDAL
    {
        public List<Ad> GetAll()
        {
            var list = new List<Ad>();
            using (var conn = Db.OpenConnection())
            using (var cmd = Db.StoredProcedure("sp_GetAllAds", conn))
            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                    list.Add(MapAd(reader));
            }
            return list;
        }

        public Ad GetByPosition(string position)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd = Db.StoredProcedure("sp_GetAdByPosition", conn))
            {
                cmd.Parameters.AddWithValue("@Position", position);
                using (var reader = cmd.ExecuteReader())
                    return reader.Read() ? MapAd(reader) : null;
            }
        }

        public int Insert(string title, string imageUrl, string redirectUrl,
                          string position, DateTime? startDate, DateTime? endDate)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd = Db.StoredProcedure("sp_InsertAd", conn))
            {
                cmd.Parameters.AddWithValue("@Title",       title);
                cmd.Parameters.AddWithValue("@ImageUrl",    (object)imageUrl    ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@RedirectUrl", (object)redirectUrl ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Position",    position);
                cmd.Parameters.AddWithValue("@StartDate",   (object)startDate   ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@EndDate",     (object)endDate     ?? DBNull.Value);
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        public void SetActive(int adId, bool isActive)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd = Db.StoredProcedure("sp_SetAdActive", conn))
            {
                cmd.Parameters.AddWithValue("@AdId",     adId);
                cmd.Parameters.AddWithValue("@IsActive", isActive);
                cmd.ExecuteNonQuery();
            }
        }

        public void Delete(int adId)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd = Db.StoredProcedure("sp_DeleteAd", conn))
            {
                cmd.Parameters.AddWithValue("@AdId", adId);
                cmd.ExecuteNonQuery();
            }
        }

        public void IncrementClick(int adId)
        {
            using (var conn = Db.OpenConnection())
            using (var cmd = Db.StoredProcedure("sp_IncrementAdClick", conn))
            {
                cmd.Parameters.AddWithValue("@AdId", adId);
                cmd.ExecuteNonQuery();
            }
        }

        private static Ad MapAd(SqlDataReader r) => new Ad
        {
            AdId        = Convert.ToInt32(r["AdId"]),
            Title       = r["Title"].ToString(),
            ImageUrl    = r["ImageUrl"]    == DBNull.Value ? null : r["ImageUrl"].ToString(),
            RedirectUrl = r["RedirectUrl"] == DBNull.Value ? null : r["RedirectUrl"].ToString(),
            Position    = r["Position"].ToString(),
            ClickCount  = Convert.ToInt32(r["ClickCount"]),
            IsActive    = Convert.ToBoolean(r["IsActive"]),
            StartDate   = r["StartDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(r["StartDate"]),
            EndDate     = r["EndDate"]   == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(r["EndDate"])
        };
    }
}
