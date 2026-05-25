-- ============================================================
--  EduFlow — Zengin Örnek Veri Ekleme (Seed Data)
--  Bu script veritabanını öğretmen sunumu için çok zengin ve gerçekçi verilerle doldurur.
--  SSMS'de EduFlowDB seçili iken çalıştırın.
-- ============================================================

USE EduFlowDB;
GO

-- 1. Tablolardaki mevcut ilişkili verileri güvenli sırayla temizle (Yeniden kurulabilir olması için)
DELETE FROM Favorites;
DELETE FROM Reviews;
DELETE FROM LessonProgress;
DELETE FROM Enrollments;
DELETE FROM Orders;
DELETE FROM Lessons;
DELETE FROM InstructorProfiles;
-- Courses tablosundaki referansları geçici olarak temizle veya sil
UPDATE Courses SET InstructorUserId = NULL;
DELETE FROM Courses;
DELETE FROM Users;
DELETE FROM Categories;
DELETE FROM Roles;
GO

-- 2. ROLLERİ YENİDEN EKLE
SET IDENTITY_INSERT Roles ON;
INSERT INTO Roles (RoleId, RoleName) VALUES 
(1, N'Admin'), 
(2, N'Student'),
(3, N'Instructor');
SET IDENTITY_INSERT Roles OFF;
GO

-- 3. KATEGORİLERİ YENİDEN EKLE
SET IDENTITY_INSERT Categories ON;
INSERT INTO Categories (CategoryId, Name, IconClass) VALUES
(1, N'Yazılım Geliştirme', N'bi-code-slash'),
(2, N'Tasarım & UX/UI',      N'bi-palette'),
(3, N'Veri & Yapay Zeka',   N'bi-bar-chart'),
(4, N'İş & Girişimcilik',   N'bi-briefcase'),
(5, N'Kişisel Gelişim',     N'bi-person-circle'),
(6, N'Pazarlama',           N'bi-megaphone');
SET IDENTITY_INSERT Categories OFF;
GO

-- 4. KULLANICILAR (Öğrenci, Eğitmen ve Adminler)
-- Şifrelerin tamamı '123456' hash'idir: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
-- Admin şifresi 'admin123' hash'idir: 8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918

SET IDENTITY_INSERT Users ON;

-- 4a. Yöneticiler (RoleId = 1)
INSERT INTO Users (UserId, FullName, Email, Password, RoleId, PhotoUrl, IsActive, CreatedAt) VALUES
(1, N'Ahmet Yılmaz (Yönetici)', N'admin@eduflow.test', N'8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 1, NULL, 1, DATEADD(month, -6, GETDATE()));

-- 4b. Eğitmenler (RoleId = 3)
INSERT INTO Users (UserId, FullName, Email, Password, RoleId, PhotoUrl, IsActive, CreatedAt) VALUES
(2, N'Mert Kaya', N'mert.kaya@eduflow.test', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 3, NULL, 1, DATEADD(month, -5, GETDATE())),
(3, N'Elif Demir', N'elif.demir@eduflow.test', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 3, NULL, 1, DATEADD(month, -5, GETDATE())),
(4, N'Derya Akın', N'derya.akin@eduflow.test', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 3, NULL, 1, DATEADD(month, -4, GETDATE())),
(5, N'Can Öz', N'can.oz@eduflow.test', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 3, NULL, 1, DATEADD(month, -4, GETDATE())),
(6, N'Ahmet Yıldız', N'ahmet.yildiz@eduflow.test', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 3, NULL, 1, DATEADD(month, -3, GETDATE())),
(7, N'Zeynep Çelik', N'zeynep.celik@eduflow.test', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 3, NULL, 1, DATEADD(month, -3, GETDATE())),
(8, N'Selin Arslan', N'selin.arslan@eduflow.test', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 3, NULL, 1, DATEADD(month, -2, GETDATE())),
(9, N'Burak Şahin', N'burak.sahin@eduflow.test', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 3, NULL, 1, DATEADD(month, -2, GETDATE())),
(10, N'Kaan Demir', N'kaan.demir@eduflow.test', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 3, NULL, 1, DATEADD(month, -1, GETDATE()));

-- Ana demo eğitmen hesabını oluştur
INSERT INTO Users (UserId, FullName, Email, Password, RoleId, PhotoUrl, IsActive, CreatedAt) VALUES
(11, N'Mert Kaya (Demo)', N'egitmen@eduflow.test', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 3, NULL, 1, DATEADD(month, -5, GETDATE()));

-- 4c. Öğrenciler (RoleId = 2)
INSERT INTO Users (UserId, FullName, Email, Password, RoleId, PhotoUrl, IsActive, CreatedAt) VALUES
(12, N'Öğrenci Can (Demo)', N'ogrenci@eduflow.test', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 2, NULL, 1, DATEADD(month, -3, GETDATE())),
(13, N'Ayşe Yılmaz', N'ayse.yilmaz@gmail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 2, NULL, 1, DATEADD(month, -3, GETDATE())),
(14, N'Mehmet Kaya', N'mehmet.kaya@gmail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 2, NULL, 1, DATEADD(month, -3, GETDATE())),
(15, N'Büşra Çelik', N'busra.celik@hotmail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 2, NULL, 1, DATEADD(month, -2, GETDATE())),
(16, N'Ali Öztürk', N'ali.ozturk@outlook.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 2, NULL, 1, DATEADD(month, -2, GETDATE())),
(17, N'Fatma Şahin', N'fatma.sahin@gmail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 2, NULL, 1, DATEADD(month, -2, GETDATE())),
(18, N'Mustafa Koç', N'mustafa.koc@gmail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 2, NULL, 1, DATEADD(month, -2, GETDATE())),
(19, N'Zeynep Güler', N'zeynep.guler@yahoo.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 2, NULL, 1, DATEADD(month, -1, GETDATE())),
(20, N'Hakan Aslan', N'hakan.aslan@gmail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 2, NULL, 1, DATEADD(month, -1, GETDATE())),
(21, N'Merve Yurt', N'merve.yurt@gmail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 2, NULL, 1, DATEADD(month, -1, GETDATE())),
(22, N'Selin Tekin', N'selin.tekin@gmail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 2, NULL, 1, DATEADD(day, -15, GETDATE())),
(23, N'Emre Bulut', N'emre.bulut@gmail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 2, NULL, 1, DATEADD(day, -10, GETDATE())),
(24, N'Gizem Aksoy', N'gizem.aksoy@gmail.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 2, NULL, 1, DATEADD(day, -5, GETDATE())),
(25, N'Yiğit Doğan', N'yigit.dogan@outlook.com', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 2, NULL, 1, DATEADD(day, -2, GETDATE()));

SET IDENTITY_INSERT Users OFF;
GO

-- 5. EĞİTMEN PROFİLLERİ (InstructorProfiles)
INSERT INTO InstructorProfiles (UserId, CategoryId, Bio, LinkedInUrl, PortfolioUrl) VALUES
(2, 1, N'ASP.NET, SQL Server ve kurumsal mimari tasarımında 10 yıldan fazla deneyimli Kıdemli Yazılım Geliştirici.', N'https://linkedin.com/in/mertkaya', N'https://mertkaya.dev'),
(3, 3, N'Microsoft SQL Server ve veri tabanı optimizasyon teknikleri üzerine uzmanlaşmış Veri Tabanı Yöneticisi.', N'https://linkedin.com/in/elifdemir', NULL),
(4, 2, N'Mobil ve web uygulamalarında kullanıcı odaklı arayüzler ve etkileşimli deneyimler tasarlayan UX Tasarımcısı.', N'https://linkedin.com/in/deryaakin', N'https://behance.net/deryaakin'),
(5, 4, N'Büyük ölçekli teknoloji şirketlerinde 8+ yıllık ürün yönetimi tecrübesine sahip Ürün Yöneticisi ve Danışman.', N'https://linkedin.com/in/canoz', NULL),
(6, 3, N'Yapay zeka modelleri ve derin öğrenme algoritmaları üzerinde çalışan kıdemli Veri Bilimci.', N'https://linkedin.com/in/ahmetyildiz', N'https://github.com/ahmetyildiz'),
(7, 1, N'Modern frontend kütüphaneleri (React, Vue) ve web performansı optimizasyonunda uzman Arayüz Geliştirici.', N'https://linkedin.com/in/zeynepcelik', N'https://zeynepcelik.com'),
(8, 2, N'Kullanılabilirlik testleri ve kullanıcı araştırmaları alanında doktora derecesine sahip UX Araştırmacısı.', N'https://linkedin.com/in/selinarslan', NULL),
(9, 6, N'Google Ads ve SEO alanında birçok e-ticaret markasına büyüme danışmanlığı yapan Dijital Pazarlama Müdürü.', N'https://linkedin.com/in/buraksahin', NULL),
(10, 1, N'Yazılım kalitesi, SOLID prensipleri ve Clean Architecture konularında eğitimler veren Yazılım Mimarı.', N'https://linkedin.com/in/kaandemir', N'https://medium.com/@kaandemir'),
(11, 1, N'ASP.NET, SQL Server ve kurumsal uygulama geliştirme alanında 10+ yıl deneyimli yazılım mimarı.', N'https://linkedin.com/in/mertkaya-demo', N'https://mertkaya.dev');
GO

-- 6. KURSLAR (Courses)
SET IDENTITY_INSERT Courses ON;

INSERT INTO Courses (CourseId, Title, Description, ThumbnailUrl, Price, IsFree, IsFeatured, CategoryId, InstructorUserId, InstructorName, Level, Language, LessonCount, TotalHours, IsActive, CreatedAt) VALUES
(1, N'ASP.NET Web Forms ile Kurumsal Proje Geliştirme',
 N'ADO.NET, stored procedure, session yönetimi, master page ve admin paneli mimarileri ile sıfırdan güvenli ve profesyonel kurumsal web uygulamaları geliştirin.',
 N'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=900&q=80',
 1499.00, 0, 1, 1, 11, N'Mert Kaya (Demo)', N'Orta Seviye', N'Türkçe', 10, 5, 1, DATEADD(month, -3, GETDATE())),

(2, N'SQL Server: Veritabanı Tasarımı ve Stored Procedure Uzmanlığı',
 N'İlişkisel veritabanı teorisi, ileri seviye sorgulama teknikleri, normalizasyon kuralları, indexleme stratejileri ve yüksek performanslı stored procedure yazımı.',
 N'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&w=900&q=80',
 999.00, 0, 1, 3, 3, N'Elif Demir', N'Orta Seviye', N'Türkçe', 8, 4, 1, DATEADD(month, -3, GETDATE())),

(3, N'Bootstrap 5 ile Sıfırdan Modern Arayüz Tasarımı',
 N'Mobil öncelikli responsive (duyarlı) tasarım felsefesi, bootstrap grid yapısı, modern form elemanları ve premium arayüz bileşenlerinin etkin kullanımı.',
 N'https://images.unsplash.com/photo-1545235617-9465d2a55698?auto=format&fit=crop&w=900&q=80',
 0.00, 1, 1, 2, 4, N'Derya Akın', N'Başlangıç', N'Türkçe', 7, 3, 1, DATEADD(month, -2, GETDATE())),

(4, N'Dijital Ürün Yönetimi: Sıfırdan Ürün Müdürü Ol',
 N'Pazar araştırması, kullanıcı persona çıkarma, ürün yol haritası (roadmap) planlama, önceliklendirme matrisleri ve A/B test metrikleriyle başarı ölçümü.',
 N'https://images.unsplash.com/photo-1552664730-d307ca884978?auto=format&fit=crop&w=900&q=80',
 799.00, 0, 0, 4, 5, N'Can Öz', N'Başlangıç', N'Türkçe', 6, 2, 1, DATEADD(month, -2, GETDATE())),

(5, N'Python ile Veri Bilimi ve Makine Öğrenmesi',
 N'NumPy, Pandas veri analiz kütüphaneleri, Matplotlib görselleştirme araçları, Scikit-Learn ile regresyon, sınıflandırma ve kümeleme algoritmaları.',
 N'https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=900&q=80',
 1299.00, 0, 1, 3, 6, N'Ahmet Yıldız', N'Orta Seviye', N'Türkçe', 8, 4, 1, DATEADD(month, -2, GETDATE())),

(6, N'React.js ile Modern Web Uygulamaları (Redux & Context)',
 N'React Hooks, Custom Hooks, Context API, Redux Toolkit mimarisi, React Router ve RESTful API entegrasyonu ile tam donanımlı web uygulaması geliştirme.',
 N'https://images.unsplash.com/photo-1633356122544-f134324a6cee?auto=format&fit=crop&w=900&q=80',
 1199.00, 0, 1, 1, 7, N'Zeynep Çelik', N'İleri Seviye', N'Türkçe', 6, 2, 1, DATEADD(month, -1, GETDATE())),

(7, N'Figma ile Profesyonel UI/UX Tasarım Eğitimi',
 N'Arayüz tasarım prensipleri, renk teorisi, tipografi, Figma autolayout kullanımı, etkileşimli prototipleme ve yazılımcılara tasarım teslim süreçleri.',
 N'https://images.unsplash.com/photo-1561070791-2526d30994b5?auto=format&fit=crop&w=900&q=80',
 899.00, 0, 0, 2, 8, N'Selin Arslan', N'Başlangıç', N'Türkçe', 6, 2, 1, DATEADD(month, -1, GETDATE())),

(8, N'Dijital Pazarlama: Google Ads ve SEO Teknikleri',
 N'Google arama ve görüntülü reklam ağları, anahtar kelime analiz araçları, site içi/site dışı SEO optimizasyonu ve Google Analytics dönüşüm izleme.',
 N'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=900&q=80',
 699.00, 0, 0, 6, 9, N'Burak Şahin', N'Başlangıç', N'Türkçe', 5, 2, 1, DATEADD(day, -20, GETDATE())),

(9, N'C# ile Nesne Yönelimli Programlama (OOP) Temelleri',
 N'Sınıf ve nesne kavramları, kapsülleme, kalıtım, çok biçimlilik, soyutlama prensipleri, arayüzler (interfaces) ve SOLID tasarım ilkeleri.',
 N'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?auto=format&fit=crop&w=900&q=80',
 0.00, 1, 0, 1, 10, N'Kaan Demir', N'Başlangıç', N'Türkçe', 8, 4, 1, DATEADD(day, -10, GETDATE())),

-- Demo Eğitmen Mert Kaya'nın ek 3 yeni kursu (CourseId = 10, 11, 12)
(10, N'ASP.NET Core MVC ile Web API ve Mikroservis Mimarisi',
 N'JWT kimlik doğrulama, Dependency Injection, CQRS, MediatR, Docker ve mikroservis mimarisi standartlarında modern Web API''ler tasarlayın ve devreye alın.',
 N'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?auto=format&fit=crop&w=900&q=80',
 1299.00, 0, 1, 1, 11, N'Mert Kaya (Demo)', N'İleri Seviye', N'Türkçe', 6, 3, 1, DATEADD(day, -15, GETDATE())),

(11, N'SQL Server: İleri Seviye Sorgulama ve Performans İyileştirme',
 N'Büyük veri kümelerinde sorgu optimizasyonu, execution plan analizi, index stratejileri, deadlock çözümleri ve tablo bölme (partitioning) teknikleri.',
 N'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?auto=format&fit=crop&w=900&q=80',
 899.00, 0, 1, 3, 11, N'Mert Kaya (Demo)', N'Orta Seviye', N'Türkçe', 6, 2, 1, DATEADD(day, -10, GETDATE())),

(12, N'C# ile Clean Architecture ve SOLID Prensipleri',
 N'Sürdürülebilir, test edilebilir ve genişletilebilir projeler için Clean Architecture şablonu, Domain-Driven Design (DDD) ve xUnit ile uygulamalı Unit Test.',
 N'https://images.unsplash.com/photo-1605379399642-870262d3d051?auto=format&fit=crop&w=900&q=80',
 1199.00, 0, 1, 1, 11, N'Mert Kaya (Demo)', N'İleri Seviye', N'Türkçe', 6, 3, 1, DATEADD(day, -5, GETDATE()));

SET IDENTITY_INSERT Courses OFF;
GO

-- 7. DERSLER (Lessons)
-- Her kurs için gerçekçi ders müfredatları ekleyelim.

SET IDENTITY_INSERT Lessons ON;

INSERT INTO Lessons (LessonId, CourseId, Title, VideoUrl, Duration, OrderIndex, IsPreview) VALUES
-- Kurs 1: ASP.NET Web Forms (CourseId = 1)
(1, 1, N'Giriş ve Proje Mimarisi Tanıtımı', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 15, 1, 1),
(2, 1, N'Geliştirme Ortamı Kurulumu: Visual Studio & SQL Server', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 25, 2, 1),
(3, 1, N'Master Page Yapısı ve Arayüz Şablonu Oluşturma', NULL, 30, 3, 0),
(4, 1, N'MS SQL Server Veritabanı Şeması Tasarımı', NULL, 35, 4, 0),
(5, 1, N'ADO.NET ile Veritabanı Bağlantısı ve Helpers', NULL, 40, 5, 0),
(6, 1, N'Stored Procedure Nedir? Projeye Entegre Edilmesi', NULL, 28, 6, 0),
(7, 1, N'Üyelik Sistemi: Kullanıcı Kayıt & Şifre Hashleme', NULL, 45, 7, 0),
(8, 1, N'Güvenli Oturum Yönetimi (Session & Auth Guards)', NULL, 22, 8, 0),
(9, 1, N'Admin Paneli Yapımı ve GridView Veri Listeleme', NULL, 50, 9, 0),
(10, 1, N'Eğitmen Yönetim Ekranı ve Projenin Yayına Alınması', NULL, 35, 10, 0),

-- Kurs 2: SQL Server (CourseId = 2)
(11, 2, N'İlişkisel Veritabanı Mantığı ve Normalizasyon Kuralları', NULL, 20, 1, 1),
(12, 2, N'Veri Tipleri ve Tablo Tasarımında Altın Kurallar', NULL, 25, 2, 1),
(13, 2, N'DML Sorguları: İleri Düzey SELECT, JOIN ve Alt Sorgular', NULL, 35, 3, 0),
(14, 2, N'Kümeleme Fonksiyonları ve GROUP BY Kullanımı', NULL, 28, 4, 0),
(15, 2, N'Performans İyileştirme: Clustered & Non-Clustered Indexes', NULL, 32, 5, 0),
(16, 2, N'Stored Procedure Oluşturma, Giriş ve Çıkış Parametreleri', NULL, 40, 6, 0),
(17, 2, N'İşlem Güvenliği: Transactions ve TRY...CATCH Blokları', NULL, 30, 7, 0),
(18, 2, N'SQL Server Profiler ve Query Optimizer ile Analiz', NULL, 25, 8, 0),

-- Kurs 3: Bootstrap 5 (CourseId = 3)
(19, 3, N'Bootstrap Nedir? Projeye Dahil Etme Yöntemleri', NULL, 12, 1, 1),
(20, 3, N'Responsive Tasarım Mantığı ve Grid Sistemi (Container, Row, Col)', NULL, 28, 2, 1),
(21, 3, N'Tipografi, Renkler ve Kenarlık Sınıfları', NULL, 18, 3, 0),
(22, 3, N'Modern Form Tasarımı ve Input Grupları', NULL, 25, 4, 0),
(23, 3, N'Gezinti Elemanları: Flexbox Tabanlı Navbar ve Footer Tasarımı', NULL, 22, 5, 0),
(24, 3, N'Dinamik Bileşenler: Accordion, Modal ve Popover Kullanımı', NULL, 30, 6, 0),
(25, 3, N'Uygulamalı Proje: Tek Sayfalık Modern Portfolyo Sitesi', NULL, 45, 7, 0),

-- Kurs 4: Ürün Yönetimi (CourseId = 4)
(26, 4, N'Ürün Yönetimi (Product Management) Nedir?', NULL, 15, 1, 1),
(27, 4, N'Pazar Araştırması ve Rakip Analizi Yöntemleri', NULL, 22, 2, 1),
(28, 4, N'Kullanıcı Personası Oluşturma ve Problem Tanımlama', NULL, 20, 3, 0),
(29, 4, N'Ürün Özelliklerini Önceliklendirme: RICE & MoSCoW Yöntemleri', NULL, 25, 4, 0),
(30, 4, N'Yol Haritası (Roadmap) ve Agile/Scrum Süreçleri', NULL, 30, 5, 0),
(31, 4, N'Ürün Başarı Metrikleri: North Star Metric ve A/B Testleri', NULL, 28, 6, 0),

-- Kurs 5: Python ile Veri Bilimi (CourseId = 5)
(32, 5, N'Python ve Anaconda Dağıtımı Kurulumu', NULL, 18, 1, 1),
(33, 5, N'NumPy ile Hızlı Matris ve Dizi İşlemleri', NULL, 30, 2, 1),
(34, 5, N'Pandas ile Veri Setlerini Okuma ve Veri Manipülasyonu', NULL, 35, 3, 0),
(35, 5, N'Eksik Verilerin Giderilmesi ve Veri Ön İşleme (Pre-processing)', NULL, 40, 4, 0),
(36, 5, N'Matplotlib ve Seaborn ile Veri Görselleştirme Teknikleri', NULL, 28, 5, 0),
(37, 5, N'Makine Öğrenmesi Giriş: Denetimli vs. Denetimsiz Öğrenme', NULL, 22, 6, 0),
(38, 5, N'Lineer ve Lojistik Regresyon Modelleri Kurma', NULL, 45, 7, 0),
(39, 5, N'Model Başarısı Ölçümü: Karmaşıklık Matrisi (Confusion Matrix)', NULL, 30, 8, 0),

-- Kurs 6: React.js (CourseId = 6)
(40, 6, N'React.js Temel Mantığı ve Kurulum (Vite ile)', NULL, 15, 1, 1),
(41, 6, N'JSX Yapısı, Component Mantığı ve Props Aktarımı', NULL, 25, 2, 1),
(42, 6, N'State Yönetimi: useState ve useEffect Hooks Kullanımı', NULL, 35, 3, 0),
(43, 6, N'Context API ile Global State Yönetimi', NULL, 28, 4, 0),
(44, 6, N'React Router DOM ile Sayfa Yönlendirme ve Parametreler', NULL, 30, 5, 0),
(45, 6, N'Redux Toolkit Mimarisi ve Asenkron Thunk İşlemleri', NULL, 45, 6, 0),

-- Kurs 7: Figma Tasarım (CourseId = 7)
(46, 7, N'Figma Arayüzü ve Temel Vektör Çizim Araçları', NULL, 14, 1, 1),
(47, 7, N'Responsive Tasarımlar İçin Auto Layout & Constraints Mantığı', NULL, 28, 2, 1),
(48, 7, N'Tasarım Sistemi Kurmak: Tipografi ve Renk Değişkenleri', NULL, 22, 3, 0),
(49, 7, N'Bileşen (Component) Mimarisi ve Varyant (Variant) Oluşturma', NULL, 25, 4, 0),
(50, 7, N'Smart Animate ile Mikro Etkileşimli Gelişmiş Prototipleme', NULL, 32, 5, 0),
(51, 7, N'Developer Handoff: Tasarımı Yazılımcıya Sorunsuz Aktarma', NULL, 18, 6, 0),

-- Kurs 8: Google Ads & SEO (CourseId = 8)
(52, 8, N'Arama Motoru Optimizasyonu (SEO) Nedir? Temel Kavramlar', NULL, 18, 1, 1),
(53, 8, N'Anahtar Kelime Analizi ve Rakip SEO İnceleme Yöntemleri', NULL, 22, 2, 1),
(54, 8, N'Site İçi SEO: Meta Etiketler, Başlık Hiyerarşisi ve Site Haritası', NULL, 28, 3, 0),
(55, 8, N'Google Ads Kampanya Çeşitleri ve Arama Ağı Reklam Kurulumu', NULL, 35, 4, 0),
(56, 8, N'Reklam Bütçesi Planlama ve Kalite Skoru Artırma Yöntemleri', NULL, 25, 5, 0),

-- Kurs 9: C# OOP Temelleri (CourseId = 9)
(57, 9, N'C# Konsol Programlama ve Giriş', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 15, 1, 1),
(58, 9, N'Nesne Yönelimli Programlama Nedir? Sınıflar ve Metotlar', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 25, 2, 1),
(59, 9, N'Kapsülleme (Encapsulation) ve Properties Kullanımı', NULL, 20, 3, 0),
(60, 9, N'Kalıtım (Inheritance) ile Kod Tekrarını Önleme', NULL, 22, 4, 0),
(61, 9, N'Çok Biçimlilik (Polymorphism) ve Sanal Metotlar', NULL, 24, 5, 0),
(62, 9, N'Soyut Sınıflar (Abstract Classes) ve Arayüzler (Interfaces)', NULL, 28, 6, 0),
(63, 9, N'SOLID Tasarım İlkeleri: Tek Sorumluluk ve Açık Kapalı Prensibi', NULL, 32, 7, 0),
(64, 9, N'Uygulamalı OOP Projesi: Banka Hesap Yönetim Simülasyonu', NULL, 40, 8, 0),

-- Kurs 10: Mert Kaya Web API & Microservices (CourseId = 10)
(65, 10, N'Modern Web API Tasarım Temelleri ve REST Standartları', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 20, 1, 1),
(66, 10, N'Dependency Injection ve Service Lifetimes (Transient, Scoped, Singleton)', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 30, 2, 1),
(67, 10, N'JWT (JSON Web Token) ile Güvenli Kimlik Doğrulama', NULL, 45, 3, 0),
(68, 10, N'CQRS Tasarım Deseni ve MediatR Kütüphanesi Kullanımı', NULL, 35, 4, 0),
(69, 10, N'Docker ile API Uygulamalarını Containerize Etmek', NULL, 25, 5, 0),
(70, 10, N'Ocelot API Gateway Kurulumu ve Mikroservis Haberleşmesi', NULL, 40, 6, 0),

-- Kurs 11: Mert Kaya SQL Server Performance Tuning (CourseId = 11)
(71, 11, N'SQL Server Query Optimizer Çalışma Mantığı ve İstatistikler', NULL, 22, 1, 1),
(72, 11, N'Execution Plan Okuma ve Sorgu Darboğazlarını (Bottlenecks) Bulma', NULL, 35, 2, 1),
(73, 11, N'İleri Seviye Indexing ve Query Hinting Stratejileri', NULL, 40, 3, 0),
(74, 11, N'Dynamic SQL Yazımı ve SQL Injection Güvenlik Önlemleri', NULL, 28, 4, 0),
(75, 11, N'Table Partitioning (Tablo Bölme) ile Büyük Veri Yönetimi', NULL, 38, 5, 0),
(76, 11, N'Büyük Ölçekli Verilerde Kilitlenmeler (Deadlocks) ve Çözümleri', NULL, 45, 6, 0),

-- Kurs 12: Mert Kaya Clean Architecture (CourseId = 12)
(77, 12, N'Clean Architecture Nedir? Core, Infrastructure ve Presentation Katmanları', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 25, 1, 1),
(78, 12, N'Domain-Driven Design (DDD) Temel İlkeleri ve Entities/Value Objects', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 30, 2, 1),
(79, 12, N'Inversion of Control (IoC) ve Katmanlar Arası Gevşek Bağlılık', NULL, 28, 3, 0),
(80, 12, N'xUnit ve Moq ile Katmanlar Arası Birim Test (Unit Test) Yazımı', NULL, 45, 4, 0),
(81, 12, N'Repository ve Unit of Work Tasarım Desenleri', NULL, 35, 5, 0),
(82, 12, N'Uygulamalı Proje: Clean Architecture Şablonunun Kurulması', NULL, 50, 6, 0);

SET IDENTITY_INSERT Lessons OFF;
GO

-- Kurs sürelerini derslerin toplamına göre güncelle
UPDATE c
SET c.LessonCount = counts.cnt,
    c.TotalHours  = counts.dur / 60
FROM Courses c
INNER JOIN (
    SELECT CourseId, COUNT(*) as cnt, ISNULL(SUM(Duration), 0) as dur
    FROM Lessons
    GROUP BY CourseId
) counts ON c.CourseId = counts.CourseId;
GO


-- 8. KURS SATIN ALMALARI VE KAYITLARI (Orders & Enrollments)
-- Öğrencileri kurslara kaydet ve bunlara ilişkin siparişler ekle (Farklı tarih aralıklarında, dashboard grafiklerini gerçekçi göstermek için)

-- Öğrenci Can (Demo) (UserId = 12)
INSERT INTO Enrollments (UserId, CourseId, EnrolledAt) VALUES
(12, 1, DATEADD(day, -45, GETDATE())),
(12, 3, DATEADD(day, -30, GETDATE())),
(12, 5, DATEADD(day, -15, GETDATE())),
(12, 9, DATEADD(day, -5, GETDATE())),
(12, 10, DATEADD(day, -3, GETDATE())), -- Mert Kaya'nın yeni dersine kayıtlı
(12, 12, DATEADD(day, -1, GETDATE())); -- Mert Kaya'nın diğer yeni dersine kayıtlı

INSERT INTO Orders (UserId, CourseId, Amount, Status, CreatedAt, PaymentRef) VALUES
(12, 1, 1499.00, N'Completed', DATEADD(day, -45, GETDATE()), N'PAY-DEMO-1001'),
(12, 3, 0.00,    N'Completed', DATEADD(day, -30, GETDATE()), N'PAY-DEMO-1002'),
(12, 5, 1299.00, N'Completed', DATEADD(day, -15, GETDATE()), N'PAY-DEMO-1003'),
(12, 9, 0.00,    N'Completed', DATEADD(day, -5, GETDATE()),  N'PAY-DEMO-1004'),
(12, 10, 1299.00,N'Completed', DATEADD(day, -3, GETDATE()),  N'PAY-DEMO-1005'),
(12, 12, 1199.00,N'Completed', DATEADD(day, -1, GETDATE()),  N'PAY-DEMO-1006');

-- Ayşe Yılmaz (UserId = 13)
INSERT INTO Enrollments (UserId, CourseId, EnrolledAt) VALUES
(13, 1, DATEADD(day, -40, GETDATE())),
(13, 2, DATEADD(day, -35, GETDATE())),
(13, 6, DATEADD(day, -20, GETDATE())),
(13, 11, DATEADD(day, -2, GETDATE())); -- Mert Kaya'nın yeni SQL dersine kayıtlı

INSERT INTO Orders (UserId, CourseId, Amount, Status, CreatedAt, PaymentRef) VALUES
(13, 1, 1499.00, N'Completed', DATEADD(day, -40, GETDATE()), N'PAY-DEMO-2001'),
(13, 2, 999.00,  N'Completed', DATEADD(day, -35, GETDATE()), N'PAY-DEMO-2002'),
(13, 6, 1199.00, N'Completed', DATEADD(day, -20, GETDATE()), N'PAY-DEMO-2003'),
(13, 11, 899.00, N'Completed', DATEADD(day, -2, GETDATE()),  N'PAY-DEMO-2004');

-- Mehmet Kaya (UserId = 14)
INSERT INTO Enrollments (UserId, CourseId, EnrolledAt) VALUES
(14, 1, DATEADD(day, -38, GETDATE())),
(14, 5, DATEADD(day, -28, GETDATE())),
(14, 7, DATEADD(day, -12, GETDATE())),
(14, 10, DATEADD(day, -4, GETDATE())); -- Mert Kaya'nın yeni dersine kayıtlı

INSERT INTO Orders (UserId, CourseId, Amount, Status, CreatedAt, PaymentRef) VALUES
(14, 1, 1499.00, N'Completed', DATEADD(day, -38, GETDATE()), N'PAY-DEMO-3001'),
(14, 5, 1299.00, N'Completed', DATEADD(day, -28, GETDATE()), N'PAY-DEMO-3002'),
(14, 7, 899.00,  N'Completed', DATEADD(day, -12, GETDATE()), N'PAY-DEMO-3003'),
(14, 10, 1299.00, N'Completed', DATEADD(day, -4, GETDATE()), N'PAY-DEMO-3004');

-- Büşra Çelik (UserId = 15)
INSERT INTO Enrollments (UserId, CourseId, EnrolledAt) VALUES
(15, 1, DATEADD(day, -25, GETDATE())),
(15, 3, DATEADD(day, -24, GETDATE())),
(15, 5, DATEADD(day, -18, GETDATE())),
(15, 12, DATEADD(day, -3, GETDATE())); -- Mert Kaya'nın yeni dersine kayıtlı

INSERT INTO Orders (UserId, CourseId, Amount, Status, CreatedAt, PaymentRef) VALUES
(15, 1, 1499.00, N'Completed', DATEADD(day, -25, GETDATE()), N'PAY-DEMO-4001'),
(15, 3, 0.00,    N'Completed', DATEADD(day, -24, GETDATE()), N'PAY-DEMO-4002'),
(15, 5, 1299.00, N'Completed', DATEADD(day, -18, GETDATE()), N'PAY-DEMO-4003'),
(15, 12, 1199.00, N'Completed', DATEADD(day, -3, GETDATE()), N'PAY-DEMO-4004');

-- Diğer öğrencilerin satın alımları (Hasılat ve öğrenci sayılarını yükseltmek için)
INSERT INTO Enrollments (UserId, CourseId, EnrolledAt) VALUES
(16, 1, DATEADD(day, -20, GETDATE())), (16, 2, DATEADD(day, -18, GETDATE())), (16, 12, DATEADD(day, -5, GETDATE())),
(17, 1, DATEADD(day, -15, GETDATE())), (17, 5, DATEADD(day, -14, GETDATE())), (17, 10, DATEADD(day, -4, GETDATE())),
(18, 1, DATEADD(day, -12, GETDATE())), (18, 6, DATEADD(day, -10, GETDATE())), (18, 11, DATEADD(day, -3, GETDATE())),
(19, 1, DATEADD(day, -8, GETDATE())),  (19, 7, DATEADD(day, -8, GETDATE())),  (19, 10, DATEADD(day, -2, GETDATE())),
(20, 1, DATEADD(day, -6, GETDATE())),  (20, 2, DATEADD(day, -5, GETDATE())),   (20, 12, DATEADD(day, -1, GETDATE())),
(21, 1, DATEADD(day, -4, GETDATE())),  (21, 5, DATEADD(day, -3, GETDATE())),   (21, 11, DATEADD(day, -1, GETDATE())),
(22, 1, DATEADD(day, -2, GETDATE())),  (22, 3, DATEADD(day, -2, GETDATE())),
(23, 2, DATEADD(day, -1, GETDATE())),  (23, 5, DATEADD(day, -1, GETDATE())),
(24, 6, GETDATE()),                     (24, 7, GETDATE()),
(25, 1, GETDATE()),                     (25, 9, GETDATE());

INSERT INTO Orders (UserId, CourseId, Amount, Status, CreatedAt, PaymentRef) VALUES
(16, 1, 1499.00, N'Completed', DATEADD(day, -20, GETDATE()), N'PAY-REG-5001'),
(16, 2, 999.00,  N'Completed', DATEADD(day, -18, GETDATE()), N'PAY-REG-5002'),
(16, 12, 1199.00, N'Completed', DATEADD(day, -5, GETDATE()),  N'PAY-REG-5021'),
(17, 1, 1499.00, N'Completed', DATEADD(day, -15, GETDATE()), N'PAY-REG-5003'),
(17, 5, 1299.00, N'Completed', DATEADD(day, -14, GETDATE()), N'PAY-REG-5004'),
(17, 10, 1299.00, N'Completed', DATEADD(day, -4, GETDATE()),  N'PAY-REG-5022'),
(18, 1, 1499.00, N'Completed', DATEADD(day, -12, GETDATE()), N'PAY-REG-5005'),
(18, 6, 1199.00, N'Completed', DATEADD(day, -10, GETDATE()), N'PAY-REG-5006'),
(18, 11, 899.00,  N'Completed', DATEADD(day, -3, GETDATE()),  N'PAY-REG-5023'),
(19, 1, 1499.00, N'Completed', DATEADD(day, -8, GETDATE()),  N'PAY-REG-5007'),
(19, 7, 899.00,  N'Completed', DATEADD(day, -8, GETDATE()),  N'PAY-REG-5008'),
(19, 10, 1299.00, N'Completed', DATEADD(day, -2, GETDATE()),  N'PAY-REG-5024'),
(20, 1, 1499.00, N'Completed', DATEADD(day, -6, GETDATE()),  N'PAY-REG-5009'),
(20, 2, 999.00,  N'Completed', DATEADD(day, -5, GETDATE()),  N'PAY-REG-5010'),
(20, 12, 1199.00, N'Completed', DATEADD(day, -1, GETDATE()),  N'PAY-REG-5025'),
(21, 1, 1499.00, N'Completed', DATEADD(day, -4, GETDATE()),  N'PAY-REG-5011'),
(21, 5, 1299.00, N'Completed', DATEADD(day, -3, GETDATE()),  N'PAY-REG-5012'),
(21, 11, 899.00,  N'Completed', DATEADD(day, -1, GETDATE()),  N'PAY-REG-5026'),
(22, 1, 1499.00, N'Completed', DATEADD(day, -2, GETDATE()),  N'PAY-REG-5013'),
(22, 3, 0.00,    N'Completed', DATEADD(day, -2, GETDATE()),  N'PAY-REG-5014'),
(23, 2, 999.00,  N'Completed', DATEADD(day, -1, GETDATE()),  N'PAY-REG-5015'),
(23, 5, 1299.00, N'Completed', DATEADD(day, -1, GETDATE()),  N'PAY-REG-5016'),
(24, 6, 1199.00, N'Completed', GETDATE(),                    N'PAY-REG-5017'),
(24, 7, 899.00,  N'Completed', GETDATE(),                    N'PAY-REG-5018'),
(25, 1, 1499.00, N'Completed', GETDATE(),                    N'PAY-REG-5019'),
(25, 9, 0.00,    N'Completed', GETDATE(),                    N'PAY-REG-5020');
GO

-- 9. DEĞERLENDİRMELER VE YORUMLAR (Reviews)
-- Kurslara farklı öğrencilerden onaylanmış (IsApproved=1) zengin değerlendirmeler ekleyelim.

INSERT INTO Reviews (UserId, CourseId, Rating, Comment, IsApproved, CreatedAt) VALUES
-- Kurs 1 Yorumları (Mert Kaya ASP.NET Web Forms)
(12, 1, 5, N'ADO.NET, stored procedure, session yönetimi ve master page kavramları harika işlenmiş. Sunum öncesi projemi hazırlamamda inanılmaz faydası dokundu.', 1, DATEADD(day, -30, GETDATE())),
(13, 1, 5, N'Web Forms mimarisini bu kadar sade ve kurumsal standartlara uygun anlatan başka bir Türkçe kaynak görmedim. Emeğinize sağlık hocam!', 1, DATEADD(day, -28, GETDATE())),
(14, 1, 4, N'Kurs son derece pratik ve baştan sona uygulamalı gidiyor. Sadece CSS entegrasyonu biraz daha detaylı olabilirdi ama kod kalitesi muazzam.', 1, DATEADD(day, -20, GETDATE())),
(15, 1, 5, N'Tereddütsüz satın alabilirsiniz. Özellikle stored procedure ve DAL katmanı kısımları iş hayatında tam olarak kullanılan standartlarda.', 1, DATEADD(day, -15, GETDATE())),
(16, 1, 5, N'Muhteşem bir anlatım. Hoca en ufak detayı atlamadan anlatıyor. Teşekkürler.', 1, DATEADD(day, -10, GETDATE())),
(17, 1, 5, N'Kurumsal mimariye giriş için inanılmaz bir anlatım. Öğretmenime sunacağım ödevde bu yapıyı kullandım.', 1, DATEADD(day, -5, GETDATE())),

-- Kurs 2 Yorumları (SQL Server)
(13, 2, 5, N'SQL Server indexleme ve stored procedure optimizasyonu sayesinde iş yerindeki sorgularımızın hızı 3 kat arttı! Teşekkürler Elif hocam.', 1, DATEADD(day, -25, GETDATE())),
(16, 2, 4, N'Tablo tasarımı ve normalizasyon kuralları anlatımı harikaydı. Sorgu optimizasyonu kısımları biraz daha detaylandırılabilirdi ama genel olarak mükemmel.', 1, DATEADD(day, -10, GETDATE())),
(20, 2, 5, N'stored procedure ve transaction yönetimi bölümleri tek başına bu kursun fiyatını hak ediyor. Harika.', 1, DATEADD(day, -2, GETDATE())),

-- Kurs 3 Yorumları (Bootstrap 5)
(12, 3, 5, N'Ücretsiz olmasına inanamıyorum. Responsive grid yapısını ilk defa bu kurs sayesinde tam olarak oturtabildim.', 1, DATEADD(day, -20, GETDATE())),
(15, 3, 5, N'Derya hanım konuyu inanılmaz akıcı anlatmış. CSS ile saatlerce uğraştığım tasarımları artık dakikalar içinde responsive yapabiliyorum.', 1, DATEADD(day, -15, GETDATE())),

-- Kurs 5 Yorumları (Python ile Veri Bilimi)
(12, 5, 5, N'NumPy ve Pandas kısımlarındaki pratik uygulamalar ve son kısımdaki Kaggle ev fiyat tahmini projesi harikaydı. Çok faydalı bir eğitim.', 1, DATEADD(day, -10, GETDATE())),
(14, 5, 5, N'Zor teorik konuları son derece basitleştirerek anlatmış hocamız. Veri bilimine merakı olan herkes kesinlikle bu kursu edinmeli.', 1, DATEADD(day, -8, GETDATE())),
(15, 5, 4, N'Makine öğrenmesi modellerinin arkasındaki matematiksel mantığı anlamamda çok yardımcı oldu. Anlatım çok net.', 1, DATEADD(day, -5, GETDATE())),

-- Kurs 6 Yorumları (React.js)
(13, 6, 5, N'Redux Toolkit mimarisini bu kadar kolay anlatabilen başka bir eğitmen yok. frontend dünyasına adım atmak isteyen herkes almalı.', 1, DATEADD(day, -18, GETDATE())),
(18, 6, 5, N'React Hooks ve Context API mantığı harika oturdu. Kurulan e-ticaret uygulaması projesi son derece kapsamlı ve öğretici.', 1, DATEADD(day, -7, GETDATE())),

-- Kurs 7 Yorumları (Figma Tasarım)
(14, 7, 5, N'Auto layout ve figma component yapısı tasarımı inanılmaz hızlandırıyor. Prototipleme kısımları da çok başarılı.', 1, DATEADD(day, -8, GETDATE())),
(19, 7, 4, N'Arayüz tasarımı prensipleri, renkler ve tipografi anlatımları çok zengin ve açıklayıcı olmuş. Çok faydalandım.', 1, DATEADD(day, -6, GETDATE())),

-- Kurs 10 Yorumları (Mert Kaya Web API)
(12, 10, 5, N'Harika bir Web API ve mikroservis kursu. CQRS ve MediatR kısımları iş hayatında hayat kurtarıyor.', 1, DATEADD(day, -2, GETDATE())),
(17, 10, 5, N'Docker entegrasyonu ve API Gateway yapılandırılması inanılmaz öğretici olmuş. Teşekkürler Mert hocam.', 1, DATEADD(day, -1, GETDATE())),

-- Kurs 11 Yorumları (Mert Kaya SQL Tuning)
(13, 11, 5, N'Execution plan okumayı ve deadlock çözmeyi sonunda tam anlamıyla öğrenebildim. Muazzam!', 1, DATEADD(day, -1, GETDATE())),

-- Kurs 12 Yorumları (Mert Kaya Clean Architecture)
(12, 12, 5, N'SOLID prensiplerini ve Clean Architecture şablonunu projelerimde uygulamak için sabırsızlanıyorum.', 1, DATEADD(day, -1, GETDATE()));
GO


-- 10. DERS İLERLEMELERİ (LessonProgress)
-- Demo öğrenci Can (UserId = 12) için bazı dersleri tamamlanmış gösterelim ki profilindeki ilerleme çubukları dolu görünsün.

-- Kurs 1 (ASP.NET Web Forms) - 10 dersten 4'ü tamamlandı (%40)
INSERT INTO LessonProgress (UserId, LessonId, IsCompleted, CompletedAt) VALUES
(12, 1, 1, DATEADD(day, -40, GETDATE())),
(12, 2, 1, DATEADD(day, -38, GETDATE())),
(12, 3, 1, DATEADD(day, -35, GETDATE())),
(12, 4, 1, DATEADD(day, -30, GETDATE()));

-- Kurs 5 (Python ile Veri Bilimi) - 8 dersten 6'sı tamamlandı (%75)
INSERT INTO LessonProgress (UserId, LessonId, IsCompleted, CompletedAt) VALUES
(12, 32, 1, DATEADD(day, -12, GETDATE())),
(12, 33, 1, DATEADD(day, -10, GETDATE())),
(12, 34, 1, DATEADD(day, -8, GETDATE())),
(12, 35, 1, DATEADD(day, -6, GETDATE())),
(12, 36, 1, DATEADD(day, -5, GETDATE())),
(12, 37, 1, DATEADD(day, -4, GETDATE()));
GO


-- 11. SIK KULLANILANLAR (Favorites)
-- Demo öğrenci için bazı kursları favorilerine ekleyelim
INSERT INTO Favorites (UserId, CourseId, AddedAt) VALUES
(12, 2, DATEADD(day, -25, GETDATE())),
(12, 6, DATEADD(day, -15, GETDATE())),
(12, 7, DATEADD(day, -2, GETDATE()));
GO

-- 12. EK C#/.NET KURS PAKETİ
-- Verilen C# playlisti embed formatında kullanılır:
-- https://www.youtube.com/watch?v=oev5wH-_XCI&list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr

SET IDENTITY_INSERT Courses ON;
INSERT INTO Courses (CourseId, Title, Description, ThumbnailUrl, Price, IsFree, IsFeatured, CategoryId, InstructorUserId, InstructorName, Level, Language, LessonCount, TotalHours, IsActive, CreatedAt) VALUES
(13, N'C# Sıfırdan İleri Seviyeye: Temeller, Koleksiyonlar ve LINQ',
 N'C# diline yeni başlayanlar için değişkenler, karar yapıları, döngüler, metotlar, koleksiyonlar, exception handling ve LINQ konularını uygulamalı projelerle öğrenin.',
 N'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?auto=format&fit=crop&w=900&q=80',
 799.00, 0, 1, 1, 10, N'Kaan Demir', N'Başlangıç', N'Türkçe', 0, 0, 1, DATEADD(day, -12, GETDATE())),
(14, N'C# Windows Forms ile Stok ve Satış Takip Otomasyonu',
 N'Windows Forms, ADO.NET, SQL Server ve raporlama mantığıyla masaüstü stok takip uygulaması geliştirin. CRUD ekranları, arama, filtreleme ve satış kayıtları dahildir.',
 N'https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=900&q=80',
 999.00, 0, 1, 1, 11, N'Mert Kaya (Demo)', N'Orta Seviye', N'Türkçe', 0, 0, 1, DATEADD(day, -11, GETDATE())),
(15, N'ASP.NET MVC ile E-Ticaret Sitesi Geliştirme',
 N'ASP.NET MVC, Razor View, SQL Server, sepet, sipariş, admin paneli ve kullanıcı yönetimiyle baştan sona e-ticaret projesi kurun.',
 N'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?auto=format&fit=crop&w=900&q=80',
 1499.00, 0, 1, 1, 11, N'Mert Kaya (Demo)', N'Orta Seviye', N'Türkçe', 0, 0, 1, DATEADD(day, -10, GETDATE())),
(16, N'Entity Framework Core ve SQL Server ile Veri Katmanı Tasarımı',
 N'Code First, migration, relation mapping, repository pattern, eager/lazy loading ve performans odaklı EF Core kullanımıyla temiz veri erişim katmanı oluşturun.',
 N'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?auto=format&fit=crop&w=900&q=80',
 1199.00, 0, 1, 1, 3, N'Elif Demir', N'Orta Seviye', N'Türkçe', 0, 0, 1, DATEADD(day, -9, GETDATE())),
(17, N'Blazor ile Modern Web Uygulamaları',
 N'Blazor Server ve WebAssembly farkları, component mimarisi, form validation, API tüketimi ve authentication yapısıyla C# kullanarak modern web arayüzleri geliştirin.',
 N'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=900&q=80',
 1299.00, 0, 1, 1, 10, N'Kaan Demir', N'İleri Seviye', N'Türkçe', 0, 0, 1, DATEADD(day, -8, GETDATE())),
(18, N'ASP.NET Web Forms Proje Kampı: Admin Paneli, Sepet ve Ödeme Demo',
 N'Web Forms ile eğitim platformu, kurs listeleme, sepet, demo ödeme, admin paneli ve rol bazlı sayfa yetkilendirme akışlarını baştan sona kurun.',
 N'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?auto=format&fit=crop&w=900&q=80',
 1399.00, 0, 1, 1, 11, N'Mert Kaya (Demo)', N'Orta Seviye', N'Türkçe', 0, 0, 1, DATEADD(day, -7, GETDATE()));
SET IDENTITY_INSERT Courses OFF;
GO

SET IDENTITY_INSERT Lessons ON;
INSERT INTO Lessons (LessonId, CourseId, Title, VideoUrl, Duration, OrderIndex, IsPreview) VALUES
(83, 13, N'C# Kursuna Giriş ve Geliştirme Ortamı', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 18, 1, 1),
(84, 13, N'Değişkenler, Veri Tipleri ve Operatörler', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 28, 2, 1),
(85, 13, N'Karar Yapıları ve Döngüler', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 32, 3, 0),
(86, 13, N'Metotlar, Parametreler ve Overload', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 30, 4, 0),
(87, 13, N'List, Dictionary ve Koleksiyon Mantığı', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 35, 5, 0),
(88, 13, N'LINQ ile Veri Sorgulama', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 40, 6, 0),
(89, 14, N'Windows Forms Proje Kurulumu', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 20, 1, 1),
(90, 14, N'Form Tasarımı ve Kullanıcı Kontrolleri', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 26, 2, 1),
(91, 14, N'SQL Server Bağlantısı ve Ürün Tablosu', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 35, 3, 0),
(92, 14, N'CRUD İşlemleri: Ekle, Güncelle, Sil', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 42, 4, 0),
(93, 14, N'Satış Kaydı ve Stok Düşme Mantığı', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 38, 5, 0),
(94, 14, N'Raporlama ve Proje Teslimi', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 30, 6, 0),
(95, 15, N'ASP.NET MVC Proje Yapısı', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 24, 1, 1),
(96, 15, N'Model, View ve Controller Mantığı', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 32, 2, 1),
(97, 15, N'Ürün Listeleme ve Kategori Filtreleme', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 36, 3, 0),
(98, 15, N'Sepet ve Sipariş Akışı', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 44, 4, 0),
(99, 15, N'Admin Paneli ve Yetkilendirme', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 42, 5, 0),
(100, 15, N'Proje Yayına Hazırlık', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 28, 6, 0),
(101, 16, N'Entity Framework Core Nedir?', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 20, 1, 1),
(102, 16, N'Code First ve Migration Kullanımı', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 34, 2, 1),
(103, 16, N'İlişkiler: One-to-Many ve Many-to-Many', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 40, 3, 0),
(104, 16, N'Repository Pattern ile Veri Erişimi', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 38, 4, 0),
(105, 16, N'Performans: Include, Select ve Tracking', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 35, 5, 0),
(106, 16, N'Gerçek Projede EF Core Standartları', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 30, 6, 0),
(107, 17, N'Blazor Server ve WebAssembly Karşılaştırması', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 22, 1, 1),
(108, 17, N'Component, Parameter ve EventCallback', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 34, 2, 1),
(109, 17, N'Blazor Forms ve Validation', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 32, 3, 0),
(110, 17, N'API Tüketimi ve HttpClient', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 36, 4, 0),
(111, 17, N'Authentication ve AuthorizeView', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 40, 5, 0),
(112, 17, N'Blazor Projesi Yayına Hazırlama', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 26, 6, 0),
(113, 18, N'Web Forms Proje Planı ve Veritabanı Şeması', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 24, 1, 1),
(114, 18, N'Master Page ve Bootstrap Arayüz', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 30, 2, 1),
(115, 18, N'Kurs Listeleme ve Detay Sayfası', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 36, 3, 0),
(116, 18, N'Sepet ve Demo Ödeme Akışı', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 34, 4, 0),
(117, 18, N'Admin Paneli ve Rol Kontrolü', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 42, 5, 0),
(118, 18, N'Proje Sunumu ve Teslim Öncesi Kontroller', N'https://www.youtube.com/embed/oev5wH-_XCI?list=PLKnjBHu2xXNPmFMvGKVHA_ijjrgUyNIXr', 22, 6, 0);
SET IDENTITY_INSERT Lessons OFF;
GO

UPDATE c
SET c.LessonCount = counts.cnt,
    c.TotalHours  = counts.dur / 60
FROM Courses c
INNER JOIN (
    SELECT CourseId, COUNT(*) as cnt, ISNULL(SUM(Duration), 0) as dur
    FROM Lessons
    GROUP BY CourseId
) counts ON c.CourseId = counts.CourseId;
GO

INSERT INTO Enrollments (UserId, CourseId, EnrolledAt) VALUES
(12, 13, DATEADD(day, -2, GETDATE())),
(13, 15, DATEADD(day, -3, GETDATE())),
(14, 16, DATEADD(day, -3, GETDATE())),
(15, 18, DATEADD(day, -2, GETDATE())),
(17, 14, DATEADD(day, -1, GETDATE())),
(18, 17, DATEADD(day, -1, GETDATE()));

INSERT INTO Orders (UserId, CourseId, Amount, Status, CreatedAt, PaymentRef) VALUES
(12, 13, 799.00,  N'Completed', DATEADD(day, -2, GETDATE()), N'PAY-EXTRA-6001'),
(13, 15, 1499.00, N'Completed', DATEADD(day, -3, GETDATE()), N'PAY-EXTRA-6002'),
(14, 16, 1199.00, N'Completed', DATEADD(day, -3, GETDATE()), N'PAY-EXTRA-6003'),
(15, 18, 1399.00, N'Completed', DATEADD(day, -2, GETDATE()), N'PAY-EXTRA-6004'),
(17, 14, 999.00,  N'Completed', DATEADD(day, -1, GETDATE()), N'PAY-EXTRA-6005'),
(18, 17, 1299.00, N'Completed', DATEADD(day, -1, GETDATE()), N'PAY-EXTRA-6006');
GO

INSERT INTO Reviews (UserId, CourseId, Rating, Comment, IsApproved, CreatedAt) VALUES
(12, 13, 5, N'C# temelleri, koleksiyonlar ve LINQ kısmı çok düzenli ilerliyor. Video bağlantıları da C# içeriğiyle uyumlu.', 1, DATEADD(day, -1, GETDATE())),
(13, 15, 5, N'MVC e-ticaret projesi ödev ve portföy için çok iyi. Sepet ve admin paneli akışı net anlatılmış.', 1, DATEADD(day, -1, GETDATE())),
(14, 16, 5, N'EF Core migration ve relation mapping konularını sonunda düzgün oturttum.', 1, DATEADD(day, -1, GETDATE())),
(15, 18, 5, N'Web Forms proje kampı tam sunumluk. Admin, sepet ve demo ödeme akışı çok işe yarıyor.', 1, GETDATE()),
(17, 14, 4, N'Windows Forms stok takip projesi çok pratik. Masaüstü uygulama mantığını kavramak için güzel.', 1, GETDATE()),
(18, 17, 5, N'Blazor component yapısı ve validation kısmı çok açıklayıcıydı.', 1, GETDATE());
GO

INSERT INTO Favorites (UserId, CourseId, AddedAt) VALUES
(12, 13, DATEADD(day, -1, GETDATE())),
(12, 18, GETDATE()),
(13, 15, GETDATE()),
(14, 17, GETDATE());
GO

-- 12. DOĞRULAMA
DECLARE @TotalUsers INT;
DECLARE @TotalInstructors INT;
DECLARE @TotalStudents INT;
DECLARE @TotalCourses INT;
DECLARE @TotalLessons INT;
DECLARE @TotalOrders INT;
DECLARE @TotalEnrollments INT;
DECLARE @TotalReviews INT;
DECLARE @TotalRevenue DECIMAL(18,2);

SELECT @TotalUsers = COUNT(*) FROM Users;
SELECT @TotalInstructors = COUNT(*) FROM Users WHERE RoleId = 3;
SELECT @TotalStudents = COUNT(*) FROM Users WHERE RoleId = 2;
SELECT @TotalCourses = COUNT(*) FROM Courses;
SELECT @TotalLessons = COUNT(*) FROM Lessons;
SELECT @TotalOrders = COUNT(*) FROM Orders WHERE Status = 'Completed';
SELECT @TotalEnrollments = COUNT(*) FROM Enrollments;
SELECT @TotalReviews = COUNT(*) FROM Reviews;
SELECT @TotalRevenue = ISNULL(SUM(Amount), 0) FROM Orders WHERE Status = 'Completed';

PRINT '===========================================================';
PRINT '  EduFlowDB Zengin Örnek Veri Kurulumu Başarıyla Tamamlandı!';
PRINT '===========================================================';
PRINT 'Toplam Kullanıcı Sayısı    : ' + CAST(@TotalUsers AS VARCHAR(10));
PRINT 'Toplam Eğitmen Sayısı      : ' + CAST(@TotalInstructors AS VARCHAR(10));
PRINT 'Toplam Öğrenci Sayısı      : ' + CAST(@TotalStudents AS VARCHAR(10));
PRINT 'Toplam Kurs Sayısı         : ' + CAST(@TotalCourses AS VARCHAR(10));
PRINT 'Toplam Ders Sayısı         : ' + CAST(@TotalLessons AS VARCHAR(10));
PRINT 'Toplam Satın Alım Sayısı   : ' + CAST(@TotalOrders AS VARCHAR(10));
PRINT 'Toplam Kurs Kayıt Sayısı   : ' + CAST(@TotalEnrollments AS VARCHAR(10));
PRINT 'Toplam Yorum Sayısı        : ' + CAST(@TotalReviews AS VARCHAR(10));
PRINT 'Toplam Ciro (TL)           : ' + CAST(@TotalRevenue AS VARCHAR(30));
PRINT '===========================================================';
GO
