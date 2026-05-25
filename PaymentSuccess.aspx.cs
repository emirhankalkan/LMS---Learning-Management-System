using System;
using System.Web.UI;

namespace EduFlow
{
    public partial class PaymentSuccess : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Session["Cart"] = null;
        }
    }
}
