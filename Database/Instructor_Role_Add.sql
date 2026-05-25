-- ============================================================
--  EduFlow — Instructor Rolü Ekleme (Mevcut DB'ye uygula)
--  SSMS'de EduFlowDB seçili iken çalıştır
-- ============================================================

USE EduFlowDB;
GO

-- 1. Instructor rolünü ekle (yoksa)
IF NOT EXISTS (SELECT 1 FROM Roles WHERE RoleName = 'Instructor')
    INSERT INTO Roles (RoleName) VALUES ('Instructor');
GO

-- 2. InstructorProfiles tablosu
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'InstructorProfiles')
BEGIN
    CREATE TABLE InstructorProfiles (
        ProfileId    INT PRIMARY KEY IDENTITY(1,1),
        UserId       INT NOT NULL REFERENCES Users(UserId) ON DELETE CASCADE,
        CategoryId   INT NULL REFERENCES Categories(CategoryId),
        Bio          NVARCHAR(1000) NULL,
        LinkedInUrl  NVARCHAR(300) NULL,
        PortfolioUrl NVARCHAR(300) NULL,
        UNIQUE (UserId)
    );
END
GO

-- 3. Courses tablosuna InstructorUserId sütunu ekle (eğitmenin userId'si)
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('Courses') AND name = 'InstructorUserId')
    ALTER TABLE Courses ADD InstructorUserId INT NULL REFERENCES Users(UserId);
GO

-- ============================================================
--  STORED PROCEDURES
-- ============================================================

-- Eğitmen kayıt
CREATE OR ALTER PROCEDURE sp_RegisterInstructor
    @FullName    NVARCHAR(100),
    @Email       NVARCHAR(150),
    @Password    NVARCHAR(256),
    @CategoryId  INT,
    @Bio         NVARCHAR(1000),
    @LinkedInUrl NVARCHAR(300),
    @PortfolioUrl NVARCHAR(300)
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Users WHERE Email = @Email)
    BEGIN
        SELECT -1;
        RETURN;
    END

    DECLARE @InstructorRoleId INT = (SELECT RoleId FROM Roles WHERE RoleName = 'Instructor');

    INSERT INTO Users (FullName, Email, Password, RoleId)
    VALUES (@FullName, @Email, @Password, @InstructorRoleId);

    DECLARE @NewUserId INT = SCOPE_IDENTITY();

    INSERT INTO InstructorProfiles (UserId, CategoryId, Bio, LinkedInUrl, PortfolioUrl)
    VALUES (@NewUserId,
            NULLIF(@CategoryId, 0),
            NULLIF(@Bio, ''),
            NULLIF(@LinkedInUrl, ''),
            NULLIF(@PortfolioUrl, ''));

    SELECT @NewUserId;
END
GO

-- Eğitmen dashboard istatistikleri
CREATE OR ALTER PROCEDURE sp_GetInstructorDashboard
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        (SELECT COUNT(*) FROM Courses WHERE InstructorUserId = @UserId AND IsActive = 1) AS TotalCourses,
        (SELECT COUNT(*) FROM Enrollments e
            JOIN Courses c ON c.CourseId = e.CourseId
            WHERE c.InstructorUserId = @UserId) AS TotalStudents,
        (SELECT ISNULL(SUM(o.Amount), 0) FROM Orders o
            JOIN Courses c ON c.CourseId = o.CourseId
            WHERE c.InstructorUserId = @UserId AND o.Status = 'Completed') AS TotalRevenue,
        (SELECT COUNT(*) FROM Reviews r
            JOIN Courses c ON c.CourseId = r.CourseId
            WHERE c.InstructorUserId = @UserId AND r.IsApproved = 1) AS TotalReviews,
        (SELECT ISNULL(AVG(CAST(r.Rating AS FLOAT)), 0) FROM Reviews r
            JOIN Courses c ON c.CourseId = r.CourseId
            WHERE c.InstructorUserId = @UserId AND r.IsApproved = 1) AS AvgRating;
END
GO

-- Eğitmenin kursları
CREATE OR ALTER PROCEDURE sp_GetInstructorCourses
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT c.*, cat.Name AS CategoryName,
           ISNULL((SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.CourseId = c.CourseId AND r.IsApproved = 1), 0) AS AverageRating,
           ISNULL((SELECT COUNT(*) FROM Enrollments e WHERE e.CourseId = c.CourseId), 0) AS EnrollmentCount,
           ISNULL((SELECT SUM(o.Amount) FROM Orders o WHERE o.CourseId = c.CourseId AND o.Status = 'Completed'), 0) AS CourseRevenue
    FROM   Courses c
    JOIN   Categories cat ON cat.CategoryId = c.CategoryId
    WHERE  c.InstructorUserId = @UserId
    ORDER  BY c.CreatedAt DESC;
END
GO

-- Eğitmenin öğrenci listesi
CREATE OR ALTER PROCEDURE sp_GetInstructorStudents
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT u.UserId, u.FullName, u.Email, c.Title AS CourseTitle,
           c.CourseId, e.EnrolledAt
    FROM   Enrollments e
    JOIN   Users u   ON u.UserId   = e.UserId
    JOIN   Courses c ON c.CourseId = e.CourseId
    WHERE  c.InstructorUserId = @UserId
    ORDER  BY e.EnrolledAt DESC;
END
GO

-- Eğitmenin son aktif kurslarının recent enrollment
CREATE OR ALTER PROCEDURE sp_GetInstructorRecentActivity
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 5 u.FullName, c.Title AS CourseTitle, e.EnrolledAt
    FROM   Enrollments e
    JOIN   Users u   ON u.UserId   = e.UserId
    JOIN   Courses c ON c.CourseId = e.CourseId
    WHERE  c.InstructorUserId = @UserId
    ORDER  BY e.EnrolledAt DESC;
END
GO

-- Kurs ekleme (eğitmen tarafından)
CREATE OR ALTER PROCEDURE sp_AddCourse
    @Title          NVARCHAR(200),
    @Description    NVARCHAR(MAX),
    @ThumbnailUrl   NVARCHAR(300),
    @Price          DECIMAL(10,2),
    @IsFree         BIT,
    @CategoryId     INT,
    @InstructorUserId INT,
    @InstructorName NVARCHAR(100),
    @Level          NVARCHAR(50),
    @Language       NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Courses (Title, Description, ThumbnailUrl, Price, IsFree, IsFeatured,
                         CategoryId, InstructorUserId, InstructorName, Level, Language,
                         LessonCount, TotalHours, IsActive)
    VALUES (@Title, @Description, NULLIF(@ThumbnailUrl,''), @Price, @IsFree, 0,
            @CategoryId, @InstructorUserId, @InstructorName, @Level, @Language,
            0, 0, 1);
    SELECT SCOPE_IDENTITY() AS CourseId;
END
GO

-- Ders ekleme
CREATE OR ALTER PROCEDURE sp_AddLesson
    @CourseId   INT,
    @Title      NVARCHAR(200),
    @VideoUrl   NVARCHAR(300),
    @Duration   INT,
    @IsPreview  BIT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @NextOrder INT = ISNULL((SELECT MAX(OrderIndex) FROM Lessons WHERE CourseId = @CourseId), 0) + 1;

    INSERT INTO Lessons (CourseId, Title, VideoUrl, Duration, OrderIndex, IsPreview)
    VALUES (@CourseId, @Title, NULLIF(@VideoUrl,''), @Duration, @NextOrder, @IsPreview);

    -- LessonCount güncelle
    UPDATE Courses
    SET LessonCount  = (SELECT COUNT(*) FROM Lessons WHERE CourseId = @CourseId),
        TotalHours   = (SELECT ISNULL(SUM(Duration), 0) / 60 FROM Lessons WHERE CourseId = @CourseId)
    WHERE CourseId = @CourseId;

    SELECT SCOPE_IDENTITY() AS LessonId;
END
GO

-- Kurs silme (eğitmen sadece kendi kursunu silebilir)
CREATE OR ALTER PROCEDURE sp_DeleteCourse
    @CourseId         INT,
    @InstructorUserId INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Courses SET IsActive = 0
    WHERE CourseId = @CourseId AND InstructorUserId = @InstructorUserId;
END
GO

-- Eğitmen profil bilgisi
CREATE OR ALTER PROCEDURE sp_GetInstructorProfile
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT u.UserId, u.FullName, u.Email, u.PhotoUrl,
           ip.Bio, ip.LinkedInUrl, ip.PortfolioUrl, ip.CategoryId,
           cat.Name AS CategoryName
    FROM   Users u
    LEFT JOIN InstructorProfiles ip ON ip.UserId = u.UserId
    LEFT JOIN Categories cat ON cat.CategoryId = ip.CategoryId
    WHERE  u.UserId = @UserId;
END
GO

-- Demo eğitmen hesabı
DECLARE @InstructorRoleId INT = (SELECT RoleId FROM Roles WHERE RoleName = 'Instructor');
IF NOT EXISTS (SELECT 1 FROM Users WHERE Email = 'egitmen@eduflow.test')
BEGIN
    INSERT INTO Users (FullName, Email, Password, RoleId)
    VALUES ('Mert Kaya', 'egitmen@eduflow.test',
            '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', -- 123456
            @InstructorRoleId);

    DECLARE @DemoInstructorId INT = SCOPE_IDENTITY();

    INSERT INTO InstructorProfiles (UserId, CategoryId, Bio, LinkedInUrl)
    VALUES (@DemoInstructorId, 1,
            'ASP.NET, SQL Server ve kurumsal uygulama geliştirme alanında 10+ yıl deneyimli yazılım mimarı.',
            'https://linkedin.com');

    -- Demo eğitmenin mevcut kursu kendine bağla
    UPDATE Courses SET InstructorUserId = @DemoInstructorId WHERE InstructorName = 'Mert Kaya';
END
GO

PRINT 'Instructor rolü başarıyla eklendi!';
PRINT 'Demo eğitmen: egitmen@eduflow.test / 123456';
GO
