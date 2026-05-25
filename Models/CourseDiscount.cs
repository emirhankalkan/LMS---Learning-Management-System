using System;

namespace EduFlow.Models
{
    public class CourseDiscount
    {
        public int DiscountId { get; set; }
        public int CourseId { get; set; }
        public string Code { get; set; }
        public int DiscountPercentage { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
