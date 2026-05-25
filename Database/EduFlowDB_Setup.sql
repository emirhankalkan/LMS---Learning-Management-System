-- ============================================================
--  EduFlow Database Setup Script
--  SQL Server 2019+ / 2022
--  Çalıştırma: SSMS'de aç, F5 ile tamamını çalıştır
-- ============================================================

USE master;
GO

-- Varsa sil ve yeniden oluştur
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'EduFlowDB')
BEGIN
    ALTER DATABASE EduFlowDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE EduFlowDB;
END
GO

CREATE DATABASE EduFlowDB
    COLLATE Turkish_CI_AS;
GO

USE EduFlowDB;
GO

-- ============================================================
--  1. TABLOLAR
-- ============================================================

-- Roles
CREATE TABLE Roles (
    RoleId   INT PRIMARY KEY IDENTITY(1,1),
    RoleName NVARCHAR(50) NOT NULL
);

-- Users
CREATE TABLE Users (
    UserId    INT PRIMARY KEY IDENTITY(1,1),
    FullName  NVARCHAR(100) NOT NULL,
    Email     NVARCHAR(150) NOT NULL UNIQUE,
    Password  NVARCHAR(256) NOT NULL,   -- SHA256 hash
    PhotoUrl  NVARCHAR(300) NULL,
    RoleId    INT NOT NULL REFERENCES Roles(RoleId),
    IsActive  BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);

-- Categories
CREATE TABLE Categories (
    CategoryId INT PRIMARY KEY IDENTITY(1,1),
    Name       NVARCHAR(100) NOT NULL,
    IconClass  NVARCHAR(50) NOT NULL DEFAULT 'bi-book'
);

-- Courses
CREATE TABLE Courses (
    CourseId       INT PRIMARY KEY IDENTITY(1,1),
    Title          NVARCHAR(200) NOT NULL,
    Description    NVARCHAR(MAX) NULL,
    ThumbnailUrl   NVARCHAR(300) NULL,
    Price          DECIMAL(10,2) NOT NULL DEFAULT 0,
    IsFree         BIT NOT NULL DEFAULT 0,
    IsFeatured     BIT NOT NULL DEFAULT 0,
    CategoryId     INT NOT NULL REFERENCES Categories(CategoryId),
    InstructorName NVARCHAR(100) NOT NULL,
    Level          NVARCHAR(50) NOT NULL DEFAULT 'Başlangıç',
    Language       NVARCHAR(50) NOT NULL DEFAULT 'Türkçe',
    LessonCount    INT NOT NULL DEFAULT 0,
    TotalHours     INT NOT NULL DEFAULT 0,
    IsActive       BIT NOT NULL DEFAULT 1,
    CreatedAt      DATETIME NOT NULL DEFAULT GETDATE()
);

-- Lessons
CREATE TABLE Lessons (
    LessonId   INT PRIMARY KEY IDENTITY(1,1),
    CourseId   INT NOT NULL REFERENCES Courses(CourseId) ON DELETE CASCADE,
    Title      NVARCHAR(200) NOT NULL,
    VideoUrl   NVARCHAR(300) NULL,
    Duration   INT NOT NULL DEFAULT 0,   -- dakika
    OrderIndex INT NOT NULL DEFAULT 1,
    IsPreview  BIT NOT NULL DEFAULT 0
);

-- LessonProgress
CREATE TABLE LessonProgress (
    ProgressId  INT PRIMARY KEY IDENTITY(1,1),
    UserId      INT NOT NULL REFERENCES Users(UserId),
    LessonId    INT NOT NULL REFERENCES Lessons(LessonId),
    IsCompleted BIT NOT NULL DEFAULT 0,
    CompletedAt DATETIME NULL,
    UNIQUE (UserId, LessonId)
);

-- Enrollments
CREATE TABLE Enrollments (
    EnrollmentId INT PRIMARY KEY IDENTITY(1,1),
    UserId       INT NOT NULL REFERENCES Users(UserId),
    CourseId     INT NOT NULL REFERENCES Courses(CourseId),
    EnrolledAt   DATETIME NOT NULL DEFAULT GETDATE(),
    UNIQUE (UserId, CourseId)
);

-- Orders
CREATE TABLE Orders (
    OrderId    INT PRIMARY KEY IDENTITY(1,1),
    UserId     INT NOT NULL REFERENCES Users(UserId),
    CourseId   INT NOT NULL REFERENCES Courses(CourseId),
    Amount     DECIMAL(10,2) NOT NULL,
    Status     NVARCHAR(50) NOT NULL DEFAULT 'Pending',  -- Pending | Completed | Failed
    PaymentRef NVARCHAR(200) NULL,
    CreatedAt  DATETIME NOT NULL DEFAULT GETDATE()
);

-- Reviews
CREATE TABLE Reviews (
    ReviewId   INT PRIMARY KEY IDENTITY(1,1),
    UserId     INT NOT NULL REFERENCES Users(UserId),
    CourseId   INT NOT NULL REFERENCES Courses(CourseId),
    Rating     INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment    NVARCHAR(MAX) NULL,
    IsApproved BIT NOT NULL DEFAULT 0,
    CreatedAt  DATETIME NOT NULL DEFAULT GETDATE()
);

-- Favorites
CREATE TABLE Favorites (
    FavoriteId INT PRIMARY KEY IDENTITY(1,1),
    UserId     INT NOT NULL REFERENCES Users(UserId),
    CourseId   INT NOT NULL REFERENCES Courses(CourseId),
    AddedAt    DATETIME NOT NULL DEFAULT GETDATE(),
    UNIQUE (UserId, CourseId)
);

-- Advertisements
CREATE TABLE Advertisements (
    AdId        INT PRIMARY KEY IDENTITY(1,1),
    Title       NVARCHAR(100) NOT NULL,
    ImageUrl    NVARCHAR(300) NULL,
    RedirectUrl NVARCHAR(300) NULL,
    Position    NVARCHAR(50) NOT NULL DEFAULT 'Sidebar',  -- Header | Sidebar | Footer
    ClickCount  INT NOT NULL DEFAULT 0,
    IsActive    BIT NOT NULL DEFAULT 1,
    StartDate   DATETIME NULL,
    EndDate     DATETIME NULL
);
GO

-- ============================================================
--  2. STORED PROCEDURES
-- ============================================================

-- ---- Kullanıcı ----

CREATE OR ALTER PROCEDURE sp_LoginUser
    @Email    NVARCHAR(150),
    @Password NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT u.UserId, u.FullName, u.Email, u.PhotoUrl, u.IsActive,
           u.CreatedAt, r.RoleName
    FROM   Users u
    JOIN   Roles r ON r.RoleId = u.RoleId
    WHERE  u.Email = @Email AND u.Password = @Password AND u.IsActive = 1;
END
GO

CREATE OR ALTER PROCEDURE sp_RegisterUser
    @FullName NVARCHAR(100),
    @Email    NVARCHAR(150),
    @Password NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Users WHERE Email = @Email)
    BEGIN
        SELECT -1;  -- email zaten kayıtlı
        RETURN;
    END
    INSERT INTO Users (FullName, Email, Password, RoleId)
    VALUES (@FullName, @Email, @Password, (SELECT RoleId FROM Roles WHERE RoleName = 'Student'));
    SELECT SCOPE_IDENTITY();
END
GO

-- ---- Kurs ----

CREATE OR ALTER PROCEDURE sp_GetAllCourses
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.*, cat.Name AS CategoryName,
           ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.CourseId = c.CourseId AND r.IsApproved = 1), 0) AS AverageRating,
           ISNULL((SELECT COUNT(*) FROM Enrollments e WHERE e.CourseId = c.CourseId), 0) AS EnrollmentCount
    FROM   Courses c
    JOIN   Categories cat ON cat.CategoryId = c.CategoryId
    WHERE  c.IsActive = 1
    ORDER  BY c.CreatedAt DESC;
END
GO

CREATE OR ALTER PROCEDURE sp_GetFeaturedCourses
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.*, cat.Name AS CategoryName,
           ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.CourseId = c.CourseId AND r.IsApproved = 1), 0) AS AverageRating,
           ISNULL((SELECT COUNT(*) FROM Enrollments e WHERE e.CourseId = c.CourseId), 0) AS EnrollmentCount
    FROM   Courses c
    JOIN   Categories cat ON cat.CategoryId = c.CategoryId
    WHERE  c.IsActive = 1 AND c.IsFeatured = 1
    ORDER  BY c.CreatedAt DESC;
END
GO

CREATE OR ALTER PROCEDURE sp_GetFreeCourses
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.*, cat.Name AS CategoryName,
           ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.CourseId = c.CourseId AND r.IsApproved = 1), 0) AS AverageRating,
           ISNULL((SELECT COUNT(*) FROM Enrollments e WHERE e.CourseId = c.CourseId), 0) AS EnrollmentCount
    FROM   Courses c
    JOIN   Categories cat ON cat.CategoryId = c.CategoryId
    WHERE  c.IsActive = 1 AND c.IsFree = 1
    ORDER  BY c.CreatedAt DESC;
END
GO

CREATE OR ALTER PROCEDURE sp_GetCoursesByCategory
    @CategoryId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.*, cat.Name AS CategoryName,
           ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.CourseId = c.CourseId AND r.IsApproved = 1), 0) AS AverageRating,
           ISNULL((SELECT COUNT(*) FROM Enrollments e WHERE e.CourseId = c.CourseId), 0) AS EnrollmentCount
    FROM   Courses c
    JOIN   Categories cat ON cat.CategoryId = c.CategoryId
    WHERE  c.IsActive = 1 AND c.CategoryId = @CategoryId
    ORDER  BY c.CreatedAt DESC;
END
GO

CREATE OR ALTER PROCEDURE sp_SearchCourses
    @Query      NVARCHAR(200) = '',
    @CategoryId INT = 0,
    @Level      NVARCHAR(50) = ''
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.*, cat.Name AS CategoryName,
           ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.CourseId = c.CourseId AND r.IsApproved = 1), 0) AS AverageRating,
           ISNULL((SELECT COUNT(*) FROM Enrollments e WHERE e.CourseId = c.CourseId), 0) AS EnrollmentCount
    FROM   Courses c
    JOIN   Categories cat ON cat.CategoryId = c.CategoryId
    WHERE  c.IsActive = 1
      AND  (@Query = '' OR c.Title LIKE '%' + @Query + '%' OR c.Description LIKE '%' + @Query + '%' OR c.InstructorName LIKE '%' + @Query + '%')
      AND  (@CategoryId = 0 OR c.CategoryId = @CategoryId)
      AND  (@Level = '' OR c.Level = @Level)
    ORDER  BY c.CreatedAt DESC;
END
GO

CREATE OR ALTER PROCEDURE sp_GetCourseDetail
    @CourseId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.*, cat.Name AS CategoryName,
           ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.CourseId = c.CourseId AND r.IsApproved = 1), 0) AS AverageRating,
           ISNULL((SELECT COUNT(*) FROM Enrollments e WHERE e.CourseId = c.CourseId), 0) AS EnrollmentCount
    FROM   Courses c
    JOIN   Categories cat ON cat.CategoryId = c.CategoryId
    WHERE  c.CourseId = @CourseId AND c.IsActive = 1;
END
GO

-- ---- Ders ----

CREATE OR ALTER PROCEDURE sp_GetLessonsByCourse
    @CourseId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Lessons WHERE CourseId = @CourseId ORDER BY OrderIndex;
END
GO

CREATE OR ALTER PROCEDURE sp_CompleteLesson
    @UserId   INT,
    @LessonId INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM LessonProgress WHERE UserId = @UserId AND LessonId = @LessonId)
        UPDATE LessonProgress SET IsCompleted = 1, CompletedAt = GETDATE()
        WHERE  UserId = @UserId AND LessonId = @LessonId;
    ELSE
        INSERT INTO LessonProgress (UserId, LessonId, IsCompleted, CompletedAt)
        VALUES (@UserId, @LessonId, 1, GETDATE());
END
GO

-- ---- Yorum ----

CREATE OR ALTER PROCEDURE sp_GetApprovedReviews
    @CourseId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT r.*, u.FullName
    FROM   Reviews r
    JOIN   Users u ON u.UserId = r.UserId
    WHERE  r.CourseId = @CourseId AND r.IsApproved = 1
    ORDER  BY r.CreatedAt DESC;
END
GO

CREATE OR ALTER PROCEDURE sp_GetPendingReviews
AS
BEGIN
    SET NOCOUNT ON;
    SELECT r.*, u.FullName, c.Title AS CourseTitle
    FROM   Reviews r
    JOIN   Users u ON u.UserId = r.UserId
    JOIN   Courses c ON c.CourseId = r.CourseId
    WHERE  r.IsApproved = 0
    ORDER  BY r.CreatedAt DESC;
END
GO

CREATE OR ALTER PROCEDURE sp_AddReview
    @UserId   INT,
    @CourseId INT,
    @Rating   INT,
    @Comment  NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM Reviews WHERE UserId = @UserId AND CourseId = @CourseId)
        INSERT INTO Reviews (UserId, CourseId, Rating, Comment, IsApproved)
        VALUES (@UserId, @CourseId, @Rating, @Comment, 0);
END
GO

CREATE OR ALTER PROCEDURE sp_ApproveReview
    @ReviewId INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Reviews SET IsApproved = 1 WHERE ReviewId = @ReviewId;
END
GO

CREATE OR ALTER PROCEDURE sp_DeleteReview
    @ReviewId INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM Reviews WHERE ReviewId = @ReviewId;
END
GO

-- ---- Favori ----

CREATE OR ALTER PROCEDURE sp_ToggleFavorite
    @UserId   INT,
    @CourseId INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Favorites WHERE UserId = @UserId AND CourseId = @CourseId)
    BEGIN
        DELETE FROM Favorites WHERE UserId = @UserId AND CourseId = @CourseId;
        SELECT 0 AS IsFavorite;
    END
    ELSE
    BEGIN
        INSERT INTO Favorites (UserId, CourseId) VALUES (@UserId, @CourseId);
        SELECT 1 AS IsFavorite;
    END
END
GO

CREATE OR ALTER PROCEDURE sp_GetUserFavorites
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.*, cat.Name AS CategoryName,
           ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.CourseId = c.CourseId AND r.IsApproved = 1), 0) AS AverageRating,
           ISNULL((SELECT COUNT(*) FROM Enrollments e WHERE e.CourseId = c.CourseId), 0) AS EnrollmentCount
    FROM   Favorites f
    JOIN   Courses c ON c.CourseId = f.CourseId
    JOIN   Categories cat ON cat.CategoryId = c.CategoryId
    WHERE  f.UserId = @UserId AND c.IsActive = 1
    ORDER  BY f.AddedAt DESC;
END
GO

-- ---- Sipariş & Ödeme ----

CREATE OR ALTER PROCEDURE sp_CreateOrder
    @UserId   INT,
    @CourseId INT,
    @Amount   DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Orders (UserId, CourseId, Amount, Status)
    VALUES (@UserId, @CourseId, @Amount, 'Pending');
    SELECT SCOPE_IDENTITY() AS OrderId;
END
GO

CREATE OR ALTER PROCEDURE sp_CompleteOrder
    @OrderId   INT,
    @PaymentRef NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Orders SET Status = 'Completed', PaymentRef = @PaymentRef WHERE OrderId = @OrderId;
    DECLARE @UserId INT, @CourseId INT;
    SELECT @UserId = UserId, @CourseId = CourseId FROM Orders WHERE OrderId = @OrderId;
    IF NOT EXISTS (SELECT 1 FROM Enrollments WHERE UserId = @UserId AND CourseId = @CourseId)
        INSERT INTO Enrollments (UserId, CourseId) VALUES (@UserId, @CourseId);
END
GO

CREATE OR ALTER PROCEDURE sp_FailOrder
    @OrderId INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Orders SET Status = 'Failed' WHERE OrderId = @OrderId;
END
GO

CREATE OR ALTER PROCEDURE sp_GetUserOrders
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT o.*, c.Title AS CourseTitle, c.ThumbnailUrl
    FROM   Orders o
    JOIN   Courses c ON c.CourseId = o.CourseId
    WHERE  o.UserId = @UserId
    ORDER  BY o.CreatedAt DESC;
END
GO

-- ---- Dashboard ----

CREATE OR ALTER PROCEDURE sp_GetUserDashboard
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.*, cat.Name AS CategoryName,
           ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.CourseId = c.CourseId AND r.IsApproved = 1), 0) AS AverageRating,
           ISNULL((SELECT COUNT(*) FROM Enrollments e WHERE e.CourseId = c.CourseId), 0) AS EnrollmentCount,
           ISNULL((SELECT COUNT(*) FROM LessonProgress lp JOIN Lessons l ON l.LessonId = lp.LessonId WHERE lp.UserId = @UserId AND l.CourseId = c.CourseId AND lp.IsCompleted = 1), 0) AS CompletedLessons
    FROM   Enrollments en
    JOIN   Courses c ON c.CourseId = en.CourseId
    JOIN   Categories cat ON cat.CategoryId = c.CategoryId
    WHERE  en.UserId = @UserId AND c.IsActive = 1
    ORDER  BY en.EnrolledAt DESC;
END
GO

-- ---- Admin ----

CREATE OR ALTER PROCEDURE sp_GetAdminStats
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        (SELECT COUNT(*) FROM Users) AS TotalUsers,
        (SELECT COUNT(*) FROM Courses WHERE IsActive = 1) AS TotalCourses,
        (SELECT COUNT(*) FROM Orders WHERE Status = 'Completed') AS TotalOrders,
        (SELECT ISNULL(SUM(Amount), 0) FROM Orders WHERE Status = 'Completed') AS TotalRevenue,
        (SELECT COUNT(*) FROM Reviews WHERE IsApproved = 0) AS PendingReviews;
END
GO

CREATE OR ALTER PROCEDURE sp_GetAllUsers
AS
BEGIN
    SET NOCOUNT ON;
    SELECT u.*, r.RoleName FROM Users u JOIN Roles r ON r.RoleId = u.RoleId ORDER BY u.CreatedAt DESC;
END
GO

CREATE OR ALTER PROCEDURE sp_SetUserActive
    @UserId   INT,
    @IsActive BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Users SET IsActive = @IsActive WHERE UserId = @UserId;
END
GO

-- ---- Kategori ----

CREATE OR ALTER PROCEDURE sp_GetAllCategories
AS
BEGIN
    SET NOCOUNT ON;
    SELECT cat.*, COUNT(c.CourseId) AS CourseCount
    FROM   Categories cat
    LEFT JOIN Courses c ON c.CategoryId = cat.CategoryId AND c.IsActive = 1
    GROUP BY cat.CategoryId, cat.Name, cat.IconClass
    ORDER BY cat.CategoryId;
END
GO

-- ---- Reklam ----

CREATE OR ALTER PROCEDURE sp_GetAdByPosition
    @Position NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 * FROM Advertisements
    WHERE  IsActive = 1 AND Position = @Position
      AND  (StartDate IS NULL OR StartDate <= GETDATE())
      AND  (EndDate   IS NULL OR EndDate   >= GETDATE())
    ORDER BY NEWID();
END
GO

CREATE OR ALTER PROCEDURE sp_IncrementAdClick
    @AdId INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Advertisements SET ClickCount = ClickCount + 1 WHERE AdId = @AdId;
END
GO

-- ============================================================
--  3. SEED DATA
-- ============================================================

-- Roles
INSERT INTO Roles (RoleName) VALUES ('Admin'), ('Student');

-- Users (SHA256: admin@eduflow.test + admin123 | ogrenci@eduflow.test + 123456)
INSERT INTO Users (FullName, Email, Password, RoleId)
VALUES
('Admin Kullanici', 'admin@eduflow.test',
 '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918',  -- admin123
 1),
('Ogrenci Kullanici', 'ogrenci@eduflow.test',
 '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',  -- 123456
 2),
('Test Kullanici', 'test@eduflow.test',
 '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',
 2);

-- Categories
INSERT INTO Categories (Name, IconClass) VALUES
('Yazilim Gelistirme', 'bi-code-slash'),
('Tasarim & UX',       'bi-palette'),
('Veri & Yapay Zeka',  'bi-bar-chart'),
('Is & Girisimcilik',  'bi-briefcase'),
('Kisisel Gelisim',    'bi-person-circle'),
('Pazarlama',          'bi-megaphone');

-- Courses
INSERT INTO Courses (Title, Description, ThumbnailUrl, Price, IsFree, IsFeatured, CategoryId, InstructorName, Level, Language, LessonCount, TotalHours) VALUES
('ASP.NET Web Forms ile Kurumsal Proje Gelistirme',
 'ADO.NET, stored procedure, session yonetimi, master page ve admin paneli ile gercek dunya projeleri gelistirin.',
 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=900&q=80',
 1499, 0, 1, 1, 'Mert Kaya', 'Orta Seviye', 'Turkce', 52, 18),

('SQL Server: Veritabani Tasarimi ve Stored Procedure Uzmanligi',
 'Iliskisel veritabani tasarimi, normalizasyon, indexleme ve stored procedure yazimi.',
 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&w=900&q=80',
 999, 0, 1, 3, 'Elif Demir', 'Orta Seviye', 'Turkce', 38, 14),

('Bootstrap 5 ile Sifirdan Modern Arayuz Tasarimi',
 'Responsive grid sistemi, bilesen ve formlar. Hic HTML bilmeden baslayip profesyonel arayuzler tasarlayin.',
 'https://images.unsplash.com/photo-1545235617-9465d2a55698?auto=format&fit=crop&w=900&q=80',
 0, 1, 1, 2, 'Derya Akin', 'Baslangic', 'Turkce', 29, 9),

('Dijital Urun Yonetimi: Sifirdan Urun Muduru Ol',
 'Kullanici arastirmasi, roadmap olusturma, A/B testi ve metrik odakli karar alma.',
 'https://images.unsplash.com/photo-1552664730-d307ca884978?auto=format&fit=crop&w=900&q=80',
 799, 0, 0, 4, 'Can Oz', 'Baslangic', 'Turkce', 24, 8),

('Python ile Veri Bilimi ve Makine Ogrenmesi',
 'NumPy, Pandas, Scikit-Learn ve gercek veri setleriyle makine ogrenmesi modelleri olusturun.',
 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=900&q=80',
 1299, 0, 1, 3, 'Ahmet Yildiz', 'Orta Seviye', 'Turkce', 67, 26),

('React.js ile Modern Web Uygulamalari',
 'Hooks, Context API, Redux, React Router ve REST API entegrasyonu. Tam kapsamli e-ticaret uygulamasi.',
 'https://images.unsplash.com/photo-1633356122544-f134324a6cee?auto=format&fit=crop&w=900&q=80',
 1199, 0, 1, 1, 'Zeynep Celik', 'Ileri Seviye', 'Turkce', 58, 22),

('Figma ile UX/UI Tasarim: Baslangictan Uzmanliga',
 'Wireframe, prototip, tasarim sistemi ve developer handoff surecleri.',
 'https://images.unsplash.com/photo-1561070791-2526d30994b5?auto=format&fit=crop&w=900&q=80',
 899, 0, 0, 2, 'Selin Arslan', 'Baslangic', 'Turkce', 41, 15),

('Dijital Pazarlama: Google Ads, SEO ve Sosyal Medya',
 'Google Ads kampanya yonetimi, SEO teknikleri, sosyal medya stratejisi.',
 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=900&q=80',
 699, 0, 0, 6, 'Burak Sahin', 'Baslangic', 'Turkce', 33, 11),

('C# ile Nesne Yonelimli Programlama',
 'OOP prensipleri, SOLID, tasarim desenleri ve gercek proje uygulamalari.',
 'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?auto=format&fit=crop&w=900&q=80',
 0, 1, 0, 1, 'Kaan Demir', 'Baslangic', 'Turkce', 45, 17),

('Etkili Iletisim ve Sunum Becerileri',
 'Is dunyasinda ikna edici konusma, sunum hazirlama ve beden dili.',
 'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?auto=format&fit=crop&w=900&q=80',
 499, 0, 0, 5, 'Aylin Yurt', 'Baslangic', 'Turkce', 22, 7),

('Docker ve Kubernetes ile DevOps Temelleri',
 'Container teknolojisi, CI/CD pipeline kurulumu, Kubernetes orkestrasyon ve bulut deployment.',
 'https://images.unsplash.com/photo-1667372393119-3d4c48d07fc9?auto=format&fit=crop&w=900&q=80',
 1399, 0, 1, 1, 'Emre Koca', 'Ileri Seviye', 'Turkce', 49, 20),

('Excel ve Power BI ile Is Analistigi',
 'Pivot tablolar, DAX formuller, interaktif dashboard tasarimi ve veri gorsellestirme.',
 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=900&q=80',
 599, 0, 0, 3, 'Neslihan Oz', 'Orta Seviye', 'Turkce', 36, 13);

-- Lessons (Kurs 1 için örnek)
INSERT INTO Lessons (CourseId, Title, Duration, OrderIndex, IsPreview) VALUES
(1, 'Kursa Giris ve Proje Tanitimi', 10, 1, 1),
(1, 'Gelistirme Ortami Kurulumu (VS 2022 + SQL Server)', 18, 2, 1),
(1, 'ASP.NET Web Forms Mimarisi', 22, 3, 0),
(1, 'Master Page ve ContentPlaceHolder', 28, 4, 0),
(1, 'Veritabani Semasi Tasarimi', 35, 5, 0),
(1, 'ADO.NET ile DAL Katmani', 40, 6, 0),
(1, 'Stored Procedure Yazimi', 32, 7, 0),
(1, 'Session Yonetimi ve Guvenlik', 25, 8, 0),
(1, 'Kullanici Giris/Kayit Sistemi', 38, 9, 0),
(1, 'Admin Paneli ve GridView', 45, 10, 0);

-- Lessons (Kurs 3 için)
INSERT INTO Lessons (CourseId, Title, Duration, OrderIndex, IsPreview) VALUES
(3, 'Bootstrap 5 Nedir? CDN ile Baslangic', 12, 1, 1),
(3, 'Grid Sistemi: Container, Row, Col', 25, 2, 1),
(3, 'Tipografi ve Renk Yardimlari', 18, 3, 0),
(3, 'Butonlar, Formlar ve Input Gruplari', 30, 4, 0),
(3, 'Navbar ve Responsive Menu', 28, 5, 0),
(3, 'Card ve Modal Bilesenleri', 22, 6, 0),
(3, 'Proje: Kurs Platformu Arayuzu', 50, 7, 0);

-- Lessons (Kurs 5 için)
INSERT INTO Lessons (CourseId, Title, Duration, OrderIndex, IsPreview) VALUES
(5, 'Python Kurulum ve Temel Veri Tipleri', 20, 1, 1),
(5, 'NumPy: Dizi Islemleri ve Matris Hesaplamasi', 38, 2, 0),
(5, 'Pandas: Veri Yukleme ve Temizleme', 45, 3, 0),
(5, 'Kesifsel Veri Analizi (EDA)', 52, 4, 0),
(5, 'Scikit-Learn ile Lineer Regresyon', 40, 5, 0),
(5, 'Karar Agaclari ve Random Forest', 48, 6, 0),
(5, 'Model Degerlendirme ve Hiperparametre Ayari', 42, 7, 0),
(5, 'Kaggle Projesi: Ev Fiyat Tahmini', 60, 8, 0);

-- Demo enrollment (ogrenci kursa kayıtlı)
INSERT INTO Enrollments (UserId, CourseId) VALUES (2, 1), (2, 5);

-- Demo reviews (onaylı)
INSERT INTO Reviews (UserId, CourseId, Rating, Comment, IsApproved) VALUES
(2, 1, 5, 'Muhtesem bir kurs! ADO.NET ve stored procedure konularini cok net anlatti.', 1),
(2, 1, 4, 'Web Forms mantigini anlamak icin harika bir baslangic.', 1),
(2, 3, 5, 'Ucretsiz olmasina ragmen kalitesi ucretli kurslari geciyor!', 1),
(2, 5, 5, 'Kaggle da ilk madalyami aldim! Bu kurs olmadan basaramazdim.', 1);

-- Demo favorites
INSERT INTO Favorites (UserId, CourseId) VALUES (2, 5), (2, 7), (2, 11);

PRINT 'EduFlowDB kurulumu tamamlandi!';
PRINT 'Admin: admin@eduflow.test / admin123';
PRINT 'Ogrenci: ogrenci@eduflow.test / 123456';
GO
