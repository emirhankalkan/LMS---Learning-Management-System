using System;
using System.Text;
using System.Web;
using System.Web.UI;
using EduFlow.DAL;

namespace EduFlow.Instructor
{
    public partial class Students : Page
    {
        protected string StudentsHtml  { get; private set; }
        protected int    TotalStudents { get; private set; }

        private readonly InstructorDAL _dal = new InstructorDAL();

        protected void Page_Load(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            try
            {
                var students   = _dal.GetMyStudents(userId);
                TotalStudents  = students.Count;

                var sb = new StringBuilder();
                int i  = 1;
                foreach (var s in students)
                {
                    string initials = s.FullName.Length >= 2
                        ? s.FullName.Substring(0, 2).ToUpper()
                        : s.FullName.ToUpper();

                    sb.AppendFormat(@"
<tr>
  <td style=""padding:12px 16px;color:var(--color-text-muted);"">{0}</td>
  <td>
    <div style=""display:flex;align-items:center;gap:10px;"">
      <div style=""width:36px;height:36px;border-radius:50%;background:rgba(93,240,193,.15);color:#5DF0C1;display:flex;align-items:center;justify-content:center;font-weight:600;font-size:12px;flex-shrink:0;"">{1}</div>
      <span style=""font-weight:500;"">{2}</span>
    </div>
  </td>
  <td style=""color:var(--color-text-muted);font-size:13px;"">{3}</td>
  <td><a href=""../CourseDetail.aspx?id={4}"" style=""text-decoration:none;"">{5}</a></td>
  <td style=""font-size:13px;color:var(--color-text-muted);"">{6:dd MMM yyyy}</td>
</tr>",
                        i++, E(initials), E(s.FullName), E(s.Email), s.CourseId, E(s.CourseTitle), s.EnrolledAt);
                }
                StudentsHtml = sb.ToString();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Students hatası: " + ex.Message);
                StudentsHtml = "<tr><td colspan='5' class='text-center text-muted' style='padding:20px;'>Veriler yüklenemedi.</td></tr>";
            }
        }

        private static string E(string value)
            => HttpUtility.HtmlEncode(value ?? string.Empty);
    }
}
