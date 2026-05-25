using System;

namespace EduFlow.Models
{
    public class Course
    {
        public int CourseId { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string ThumbnailUrl { get; set; }
        public decimal Price { get; set; }
        public bool IsFree { get; set; }
        public bool IsFeatured { get; set; }
        public int CategoryId { get; set; }
        public string CategoryName { get; set; }
        public string InstructorName { get; set; }
        public int? InstructorUserId { get; set; }
        public string Level { get; set; }
        public string Language { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedAt { get; set; }
        public double AverageRating { get; set; }
        public int EnrollmentCount { get; set; }
        public int LessonCount { get; set; }
        public int TotalHours { get; set; }
        public int CompletedLessons { get; set; }
    }
}
