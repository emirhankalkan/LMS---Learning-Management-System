using System;
using System.Collections.Generic;
using System.Linq;
using EduFlow.Models;

namespace EduFlow.Services
{
    public static class SampleData
    {
        public static readonly List<Category> Categories = new List<Category>
        {
            new Category { CategoryId = 1, Name = "Yazılım Geliştirme", IconClass = "bi-code-slash" },
            new Category { CategoryId = 2, Name = "Tasarım & UX", IconClass = "bi-palette" },
            new Category { CategoryId = 3, Name = "Veri & Yapay Zeka", IconClass = "bi-bar-chart" },
            new Category { CategoryId = 4, Name = "İş & Girişimcilik", IconClass = "bi-briefcase" },
            new Category { CategoryId = 5, Name = "Kişisel Gelişim", IconClass = "bi-person-circle" },
            new Category { CategoryId = 6, Name = "Pazarlama", IconClass = "bi-megaphone" }
        };

        public static readonly List<Course> Courses = new List<Course>
        {
            new Course {
                CourseId = 1,
                Title = "ASP.NET Web Forms ile Kurumsal Proje Geliştirme",
                Description = "ADO.NET, stored procedure, session yönetimi, master page ve admin paneli ile gerçek dünya projeleri geliştirin. Sıfırdan çalışan bir e-ticaret altyapısı inşa edin.",
                ThumbnailUrl = "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=900&q=80",
                Price = 1499, IsFeatured = true, IsFree = false,
                CategoryId = 1, CategoryName = "Yazılım Geliştirme",
                InstructorName = "Mert Kaya", Level = "Orta Seviye", Language = "Türkçe",
                AverageRating = 4.7, EnrollmentCount = 3248,
                LessonCount = 52, TotalHours = 18
            },
            new Course {
                CourseId = 2,
                Title = "SQL Server: Veritabanı Tasarımı ve Stored Procedure Uzmanlığı",
                Description = "İlişkisel veritabanı tasarımı, normalizasyon, indexleme, stored procedure yazımı ve performans optimizasyonu. DBA'dan developer'a herkes için.",
                ThumbnailUrl = "https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&w=900&q=80",
                Price = 999, IsFeatured = true, IsFree = false,
                CategoryId = 3, CategoryName = "Veri & Yapay Zeka",
                InstructorName = "Elif Demir", Level = "Orta Seviye", Language = "Türkçe",
                AverageRating = 4.5, EnrollmentCount = 1894,
                LessonCount = 38, TotalHours = 14
            },
            new Course {
                CourseId = 3,
                Title = "Bootstrap 5 ile Sıfırdan Modern Arayüz Tasarımı",
                Description = "Responsive grid sistemi, bileşenler, formlar, kartlar ve kurumsal UI pratiği. Hiç HTML bilmeden başlayıp profesyonel arayüzler tasarlayın.",
                ThumbnailUrl = "https://images.unsplash.com/photo-1545235617-9465d2a55698?auto=format&fit=crop&w=900&q=80",
                Price = 0, IsFeatured = true, IsFree = true,
                CategoryId = 2, CategoryName = "Tasarım & UX",
                InstructorName = "Derya Akın", Level = "Başlangıç", Language = "Türkçe",
                AverageRating = 4.8, EnrollmentCount = 5621,
                LessonCount = 29, TotalHours = 9
            },
            new Course {
                CourseId = 4,
                Title = "Dijital Ürün Yönetimi: Sıfırdan Ürün Müdürü Ol",
                Description = "Kullanıcı araştırması, roadmap oluşturma, A/B testi ve metrik odaklı karar alma. Gerçek ürün vakaları ile öğrenin.",
                ThumbnailUrl = "https://images.unsplash.com/photo-1552664730-d307ca884978?auto=format&fit=crop&w=900&q=80",
                Price = 799, IsFeatured = false, IsFree = false,
                CategoryId = 4, CategoryName = "İş & Girişimcilik",
                InstructorName = "Can Öz", Level = "Başlangıç", Language = "Türkçe",
                AverageRating = 4.3, EnrollmentCount = 872,
                LessonCount = 24, TotalHours = 8
            },
            new Course {
                CourseId = 5,
                Title = "Python ile Veri Bilimi ve Makine Öğrenmesi",
                Description = "NumPy, Pandas, Scikit-Learn ve gerçek veri setleriyle makine öğrenmesi modellerini sıfırdan oluşturun. Kaggle yarışmalarına hazırlanın.",
                ThumbnailUrl = "https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=900&q=80",
                Price = 1299, IsFeatured = true, IsFree = false,
                CategoryId = 3, CategoryName = "Veri & Yapay Zeka",
                InstructorName = "Ahmet Yıldız", Level = "Orta Seviye", Language = "Türkçe",
                AverageRating = 4.9, EnrollmentCount = 7412,
                LessonCount = 67, TotalHours = 26
            },
            new Course {
                CourseId = 6,
                Title = "React.js ile Modern Web Uygulamaları",
                Description = "Hooks, Context API, Redux, React Router ve REST API entegrasyonu. Tam kapsamlı bir e-ticaret uygulaması inşa edin.",
                ThumbnailUrl = "https://images.unsplash.com/photo-1633356122544-f134324a6cee?auto=format&fit=crop&w=900&q=80",
                Price = 1199, IsFeatured = true, IsFree = false,
                CategoryId = 1, CategoryName = "Yazılım Geliştirme",
                InstructorName = "Zeynep Çelik", Level = "İleri Seviye", Language = "Türkçe",
                AverageRating = 4.6, EnrollmentCount = 4103,
                LessonCount = 58, TotalHours = 22
            },
            new Course {
                CourseId = 7,
                Title = "Figma ile UX/UI Tasarım: Başlangıçtan Uzmanlığa",
                Description = "Wireframe, prototip, tasarım sistemi ve developer handoff süreçleri. Gerçek projelerde uygulanan tasarım düşüncesini öğrenin.",
                ThumbnailUrl = "https://images.unsplash.com/photo-1561070791-2526d30994b5?auto=format&fit=crop&w=900&q=80",
                Price = 899, IsFeatured = false, IsFree = false,
                CategoryId = 2, CategoryName = "Tasarım & UX",
                InstructorName = "Selin Arslan", Level = "Başlangıç", Language = "Türkçe",
                AverageRating = 4.7, EnrollmentCount = 2934,
                LessonCount = 41, TotalHours = 15
            },
            new Course {
                CourseId = 8,
                Title = "Dijital Pazarlama: Google Ads, SEO ve Sosyal Medya",
                Description = "Google Ads kampanya yönetimi, SEO teknikleri, sosyal medya stratejisi ve dönüşüm optimizasyonu. Ölçülebilir sonuçlar için pratik yaklaşım.",
                ThumbnailUrl = "https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=900&q=80",
                Price = 699, IsFeatured = false, IsFree = false,
                CategoryId = 6, CategoryName = "Pazarlama",
                InstructorName = "Burak Şahin", Level = "Başlangıç", Language = "Türkçe",
                AverageRating = 4.4, EnrollmentCount = 1567,
                LessonCount = 33, TotalHours = 11
            },
            new Course {
                CourseId = 9,
                Title = "C# ile Nesne Yönelimli Programlama",
                Description = "OOP prensipleri, SOLID, tasarım desenleri ve gerçek proje uygulamaları. Junior'dan mid-level developer'a geçiş yolculuğunuz.",
                ThumbnailUrl = "https://images.unsplash.com/photo-1515879218367-8466d910aaa4?auto=format&fit=crop&w=900&q=80",
                Price = 0, IsFeatured = false, IsFree = true,
                CategoryId = 1, CategoryName = "Yazılım Geliştirme",
                InstructorName = "Kaan Demir", Level = "Başlangıç", Language = "Türkçe",
                AverageRating = 4.5, EnrollmentCount = 4289,
                LessonCount = 45, TotalHours = 17
            },
            new Course {
                CourseId = 10,
                Title = "Etkili İletişim ve Sunum Becerileri",
                Description = "İş dünyasında ikna edici konuşma, sunum hazırlama ve beden dili. TED konuşmacılarının tekniklerini öğrenin.",
                ThumbnailUrl = "https://images.unsplash.com/photo-1475721027785-f74eccf877e2?auto=format&fit=crop&w=900&q=80",
                Price = 499, IsFeatured = false, IsFree = false,
                CategoryId = 5, CategoryName = "Kişisel Gelişim",
                InstructorName = "Aylin Yurt", Level = "Başlangıç", Language = "Türkçe",
                AverageRating = 4.6, EnrollmentCount = 3102,
                LessonCount = 22, TotalHours = 7
            },
            new Course {
                CourseId = 11,
                Title = "Docker ve Kubernetes ile DevOps Temelleri",
                Description = "Container teknolojisi, CI/CD pipeline kurulumu, Kubernetes orkestrasyon ve bulut deployment. Gerçek üretim ortamı deneyimi.",
                ThumbnailUrl = "https://images.unsplash.com/photo-1667372393119-3d4c48d07fc9?auto=format&fit=crop&w=900&q=80",
                Price = 1399, IsFeatured = true, IsFree = false,
                CategoryId = 1, CategoryName = "Yazılım Geliştirme",
                InstructorName = "Emre Koca", Level = "İleri Seviye", Language = "Türkçe",
                AverageRating = 4.8, EnrollmentCount = 2187,
                LessonCount = 49, TotalHours = 20
            },
            new Course {
                CourseId = 12,
                Title = "Excel ve Power BI ile İş Analitiği",
                Description = "Pivot tablolar, DAX formülleri, interaktif dashboard tasarımı ve veri görselleştirme. İş kararlarını veriye dayandırın.",
                ThumbnailUrl = "https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=900&q=80",
                Price = 599, IsFeatured = false, IsFree = false,
                CategoryId = 3, CategoryName = "Veri & Yapay Zeka",
                InstructorName = "Neslihan Öz", Level = "Orta Seviye", Language = "Türkçe",
                AverageRating = 4.4, EnrollmentCount = 1843,
                LessonCount = 36, TotalHours = 13
            }
        };

        private static readonly Dictionary<int, List<Lesson>> _lessons = new Dictionary<int, List<Lesson>>
        {
            {
                1, new List<Lesson>
                {
                    new Lesson { LessonId = 101, CourseId = 1, Title = "Kursa Giriş ve Proje Tanıtımı", Duration = 10, OrderIndex = 1, IsPreview = true },
                    new Lesson { LessonId = 102, CourseId = 1, Title = "Geliştirme Ortamı Kurulumu (VS 2022 + SQL Server)", Duration = 18, OrderIndex = 2, IsPreview = true },
                    new Lesson { LessonId = 103, CourseId = 1, Title = "ASP.NET Web Forms Mimarisi", Duration = 22, OrderIndex = 3 },
                    new Lesson { LessonId = 104, CourseId = 1, Title = "Master Page ve ContentPlaceHolder", Duration = 28, OrderIndex = 4 },
                    new Lesson { LessonId = 105, CourseId = 1, Title = "Veritabanı Şeması Tasarımı", Duration = 35, OrderIndex = 5 },
                    new Lesson { LessonId = 106, CourseId = 1, Title = "ADO.NET ile DAL Katmanı", Duration = 40, OrderIndex = 6 },
                    new Lesson { LessonId = 107, CourseId = 1, Title = "Stored Procedure Yazımı", Duration = 32, OrderIndex = 7 },
                    new Lesson { LessonId = 108, CourseId = 1, Title = "Session Yönetimi ve Güvenlik", Duration = 25, OrderIndex = 8 },
                    new Lesson { LessonId = 109, CourseId = 1, Title = "Kullanıcı Giriş/Kayıt Sistemi", Duration = 38, OrderIndex = 9 },
                    new Lesson { LessonId = 110, CourseId = 1, Title = "Admin Paneli ve GridView", Duration = 45, OrderIndex = 10 }
                }
            },
            {
                2, new List<Lesson>
                {
                    new Lesson { LessonId = 201, CourseId = 2, Title = "İlişkisel Veritabanı Temelleri", Duration = 20, OrderIndex = 1, IsPreview = true },
                    new Lesson { LessonId = 202, CourseId = 2, Title = "Normalizasyon: 1NF, 2NF, 3NF", Duration = 35, OrderIndex = 2 },
                    new Lesson { LessonId = 203, CourseId = 2, Title = "Primary Key, Foreign Key ve İlişkiler", Duration = 28, OrderIndex = 3 },
                    new Lesson { LessonId = 204, CourseId = 2, Title = "SELECT, JOIN ve Alt Sorgular", Duration = 42, OrderIndex = 4 },
                    new Lesson { LessonId = 205, CourseId = 2, Title = "Stored Procedure: Giriş ve Temel Sözdizimi", Duration = 30, OrderIndex = 5 },
                    new Lesson { LessonId = 206, CourseId = 2, Title = "Parametreli SP ve Döndürme Değerleri", Duration = 38, OrderIndex = 6 },
                    new Lesson { LessonId = 207, CourseId = 2, Title = "Index Stratejileri ve Sorgu Optimizasyonu", Duration = 45, OrderIndex = 7 },
                    new Lesson { LessonId = 208, CourseId = 2, Title = "Transaction Yönetimi ve Hata Yakalama", Duration = 32, OrderIndex = 8 }
                }
            },
            {
                3, new List<Lesson>
                {
                    new Lesson { LessonId = 301, CourseId = 3, Title = "Bootstrap 5 Nedir? CDN ile Başlangıç", Duration = 12, OrderIndex = 1, IsPreview = true },
                    new Lesson { LessonId = 302, CourseId = 3, Title = "Grid Sistemi: Container, Row, Col", Duration = 25, OrderIndex = 2, IsPreview = true },
                    new Lesson { LessonId = 303, CourseId = 3, Title = "Tipografi ve Renk Yardımcıları", Duration = 18, OrderIndex = 3 },
                    new Lesson { LessonId = 304, CourseId = 3, Title = "Butonlar, Formlar ve Input Grupları", Duration = 30, OrderIndex = 4 },
                    new Lesson { LessonId = 305, CourseId = 3, Title = "Navbar ve Responsive Menü", Duration = 28, OrderIndex = 5 },
                    new Lesson { LessonId = 306, CourseId = 3, Title = "Card ve Modal Bileşenleri", Duration = 22, OrderIndex = 6 },
                    new Lesson { LessonId = 307, CourseId = 3, Title = "Proje: Kurs Platformu Arayüzü", Duration = 50, OrderIndex = 7 }
                }
            },
            {
                5, new List<Lesson>
                {
                    new Lesson { LessonId = 501, CourseId = 5, Title = "Python Kurulum ve Temel Veri Tipleri", Duration = 20, OrderIndex = 1, IsPreview = true },
                    new Lesson { LessonId = 502, CourseId = 5, Title = "NumPy: Dizi İşlemleri ve Matris Hesaplaması", Duration = 38, OrderIndex = 2 },
                    new Lesson { LessonId = 503, CourseId = 5, Title = "Pandas: Veri Yükleme ve Temizleme", Duration = 45, OrderIndex = 3 },
                    new Lesson { LessonId = 504, CourseId = 5, Title = "Keşifsel Veri Analizi (EDA)", Duration = 52, OrderIndex = 4 },
                    new Lesson { LessonId = 505, CourseId = 5, Title = "Scikit-Learn ile Lineer Regresyon", Duration = 40, OrderIndex = 5 },
                    new Lesson { LessonId = 506, CourseId = 5, Title = "Karar Ağaçları ve Random Forest", Duration = 48, OrderIndex = 6 },
                    new Lesson { LessonId = 507, CourseId = 5, Title = "Model Değerlendirme ve Hiperparametre Ayarı", Duration = 42, OrderIndex = 7 },
                    new Lesson { LessonId = 508, CourseId = 5, Title = "Kaggle Projesi: Ev Fiyat Tahmini", Duration = 60, OrderIndex = 8 }
                }
            },
            {
                6, new List<Lesson>
                {
                    new Lesson { LessonId = 601, CourseId = 6, Title = "React Nedir? Modern Web'e Giriş", Duration = 15, OrderIndex = 1, IsPreview = true },
                    new Lesson { LessonId = 602, CourseId = 6, Title = "JSX ve Bileşen Yapısı", Duration = 28, OrderIndex = 2 },
                    new Lesson { LessonId = 603, CourseId = 6, Title = "useState ve useEffect Hook'ları", Duration = 40, OrderIndex = 3 },
                    new Lesson { LessonId = 604, CourseId = 6, Title = "Props ve State Yönetimi", Duration = 35, OrderIndex = 4 },
                    new Lesson { LessonId = 605, CourseId = 6, Title = "React Router ile SPA Navigasyon", Duration = 32, OrderIndex = 5 },
                    new Lesson { LessonId = 606, CourseId = 6, Title = "Context API ile Global State", Duration = 38, OrderIndex = 6 },
                    new Lesson { LessonId = 607, CourseId = 6, Title = "Axios ile REST API Entegrasyonu", Duration = 42, OrderIndex = 7 },
                    new Lesson { LessonId = 608, CourseId = 6, Title = "Redux Toolkit: Modern State Yönetimi", Duration = 50, OrderIndex = 8 },
                    new Lesson { LessonId = 609, CourseId = 6, Title = "Proje: Tam Kapsamlı E-Ticaret Uygulaması", Duration = 75, OrderIndex = 9 }
                }
            }
        };

        private static readonly Dictionary<int, List<Review>> _reviews = new Dictionary<int, List<Review>>
        {
            {
                1, new List<Review>
                {
                    new Review { CourseId = 1, FullName = "Ayşe Yılmaz", Rating = 5, Comment = "Muhteşem bir kurs! ADO.NET ve stored procedure konularını çok net anlattı. Projeyi bitirdiğimde gerçekten bir şeyler öğrendiğimi hissettim.", IsApproved = true, CreatedAt = DateTime.Today.AddDays(-5) },
                    new Review { CourseId = 1, FullName = "Burak Şen", Rating = 4, Comment = "Web Forms mantığını anlamak için harika bir başlangıç. Özellikle session yönetimi ve güvenlik bölümleri çok bilgilendirici.", IsApproved = true, CreatedAt = DateTime.Today.AddDays(-3) },
                    new Review { CourseId = 1, FullName = "Cemre Aktaş", Rating = 5, Comment = "Admin paneli bölümü beni çok etkiledi. GridView, FormView konularını pratikte görmek çok faydalıydı. Kesinlikle tavsiye ederim.", IsApproved = true, CreatedAt = DateTime.Today.AddDays(-1) },
                    new Review { CourseId = 1, FullName = "Deniz Koç", Rating = 4, Comment = "Anlatım temposu ideal. Hızlı geçmeden her konuyu pekiştiriyor. Kayıt olduğuma pişman değilim.", IsApproved = true, CreatedAt = DateTime.Today.AddDays(-7) }
                }
            },
            {
                2, new List<Review>
                {
                    new Review { CourseId = 2, FullName = "Fatma Çetin", Rating = 5, Comment = "SQL'i hiç bilmeden başladım, artık kendi stored procedure'larımı yazabiliyorum. Teşekkürler!", IsApproved = true, CreatedAt = DateTime.Today.AddDays(-4) },
                    new Review { CourseId = 2, FullName = "Güven Arslan", Rating = 4, Comment = "Normalizasyon konuları çok iyi işlenmiş. Gerçek projelerde bu bilgileri kullanabiliyorum.", IsApproved = true, CreatedAt = DateTime.Today.AddDays(-2) },
                    new Review { CourseId = 2, FullName = "Hande Kaya", Rating = 5, Comment = "Index optimizasyonu bölümü altın değerinde. Sorgu sürelerim %70 azaldı!", IsApproved = true, CreatedAt = DateTime.Today.AddDays(-6) }
                }
            },
            {
                3, new List<Review>
                {
                    new Review { CourseId = 3, FullName = "İrem Demir", Rating = 5, Comment = "Ücretsiz olmasına rağmen kalitesi ücretli kursları geçiyor! Grid sistemi artık kafama tam oturdu.", IsApproved = true, CreatedAt = DateTime.Today.AddDays(-2) },
                    new Review { CourseId = 3, FullName = "Kemal Şahin", Rating = 5, Comment = "Proje bölümünde gerçek bir kurs platformu arayüzü yapmak çok motive edici. Bravo!", IsApproved = true, CreatedAt = DateTime.Today.AddDays(-1) },
                    new Review { CourseId = 3, FullName = "Lale Öztürk", Rating = 4, Comment = "Responsive tasarım konularını çok iyi ele almış. Mobil öncelikli düşünmeyi öğrendim.", IsApproved = true, CreatedAt = DateTime.Today.AddDays(-3) }
                }
            },
            {
                5, new List<Review>
                {
                    new Review { CourseId = 5, FullName = "Mert Ulusoy", Rating = 5, Comment = "Kaggle projesinde ilk madalyamı aldım! Bu kurs olmadan başaramazdım.", IsApproved = true, CreatedAt = DateTime.Today.AddDays(-1) },
                    new Review { CourseId = 5, FullName = "Nilüfer Aydın", Rating = 5, Comment = "EDA bölümü gerçekten göz açıcı. Veriye nasıl bakacağımı artık biliyorum.", IsApproved = true, CreatedAt = DateTime.Today.AddDays(-4) },
                    new Review { CourseId = 5, FullName = "Onur Güler", Rating = 4, Comment = "Random Forest bölümü biraz hızlı geçti ama genel anlatım çok iyi.", IsApproved = true, CreatedAt = DateTime.Today.AddDays(-6) }
                }
            },
            {
                6, new List<Review>
                {
                    new Review { CourseId = 6, FullName = "Pınar Sezer", Rating = 5, Comment = "Redux bölümü sonunda anlayabildiğim ilk kaynak. Çok net anlatım!", IsApproved = true, CreatedAt = DateTime.Today.AddDays(-2) },
                    new Review { CourseId = 6, FullName = "Rıdvan Yıldız", Rating = 4, Comment = "E-ticaret projesi çok kapsamlı. Portfolio'ya ekleyince iş başvurularında fark yaratıyor.", IsApproved = true, CreatedAt = DateTime.Today.AddDays(-5) }
                }
            }
        };

        public static Course FindCourse(int id)
        {
            return Courses.FirstOrDefault(c => c.CourseId == id);
        }

        public static List<Lesson> LessonsFor(int courseId)
        {
            if (_lessons.ContainsKey(courseId))
                return _lessons[courseId];

            // Varsayılan ders listesi
            return new List<Lesson>
            {
                new Lesson { LessonId = courseId * 100 + 1, CourseId = courseId, Title = "Kursa Giriş ve Genel Bakış", Duration = 12, OrderIndex = 1, IsPreview = true },
                new Lesson { LessonId = courseId * 100 + 2, CourseId = courseId, Title = "Temel Kavramlar ve Terminoloji", Duration = 22, OrderIndex = 2 },
                new Lesson { LessonId = courseId * 100 + 3, CourseId = courseId, Title = "İlk Uygulama: Adım Adım Rehber", Duration = 35, OrderIndex = 3 },
                new Lesson { LessonId = courseId * 100 + 4, CourseId = courseId, Title = "Pratik Egzersizler ve Alıştırmalar", Duration = 28, OrderIndex = 4 },
                new Lesson { LessonId = courseId * 100 + 5, CourseId = courseId, Title = "İleri Seviye Teknikler", Duration = 40, OrderIndex = 5 },
                new Lesson { LessonId = courseId * 100 + 6, CourseId = courseId, Title = "Gerçek Dünya Projesi", Duration = 55, OrderIndex = 6 },
                new Lesson { LessonId = courseId * 100 + 7, CourseId = courseId, Title = "Sertifika ve Sonraki Adımlar", Duration = 10, OrderIndex = 7 }
            };
        }

        public static List<Review> ReviewsFor(int courseId)
        {
            if (_reviews.ContainsKey(courseId))
                return _reviews[courseId];

            return new List<Review>
            {
                new Review { CourseId = courseId, FullName = "Ahmet Yılmaz", Rating = 5, Comment = "Mükemmel bir kurs, çok şey öğrendim. Kesinlikle tavsiye ederim!", IsApproved = true, CreatedAt = DateTime.Today.AddDays(-3) },
                new Review { CourseId = courseId, FullName = "Sevgi Demir", Rating = 4, Comment = "Anlatım açık ve sade. Pratik örnekler çok işime yaradı.", IsApproved = true, CreatedAt = DateTime.Today.AddDays(-1) }
            };
        }

        public static List<Course> GetFeaturedCourses()
        {
            return Courses.Where(c => c.IsFeatured).ToList();
        }

        public static List<Course> GetCoursesByCategory(int categoryId)
        {
            return Courses.Where(c => c.CategoryId == categoryId).ToList();
        }

        public static List<Course> SearchCourses(string query, int categoryId = 0)
        {
            var result = Courses.AsEnumerable();
            if (!string.IsNullOrWhiteSpace(query))
                result = result.Where(c =>
                    c.Title.IndexOf(query, StringComparison.OrdinalIgnoreCase) >= 0 ||
                    c.Description.IndexOf(query, StringComparison.OrdinalIgnoreCase) >= 0 ||
                    c.InstructorName.IndexOf(query, StringComparison.OrdinalIgnoreCase) >= 0);
            if (categoryId > 0)
                result = result.Where(c => c.CategoryId == categoryId);
            return result.ToList();
        }
    }
}
