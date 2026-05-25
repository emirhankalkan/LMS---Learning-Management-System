using System;

namespace EduFlow.Models
{
    public class Order
    {
        public int OrderId { get; set; }
        public int UserId { get; set; }
        public int CourseId { get; set; }
        public string CourseTitle { get; set; }
        public decimal Amount { get; set; }
        public string Status { get; set; }
        public string PaymentRef { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
