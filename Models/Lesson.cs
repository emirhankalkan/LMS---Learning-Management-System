namespace EduFlow.Models
{
    public class Lesson
    {
        public int LessonId { get; set; }
        public int CourseId { get; set; }
        public string Title { get; set; }
        public string VideoUrl { get; set; }
        public int Duration { get; set; }
        public int OrderIndex { get; set; }
        public bool IsPreview { get; set; }
        public string CourseTitle { get; set; }
        public int CompletedLessons { get; set; }
        public int TotalLessons { get; set; }
        public int CourseProgressPercent { get; set; }
    }
}
