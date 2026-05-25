using System;
using System.Web.UI;

namespace EduFlow.Instructor
{
    public partial class InstructorMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["UserRole"]?.ToString() != "Instructor")
                Response.Redirect("~/Login.aspx");
        }
    }
}
