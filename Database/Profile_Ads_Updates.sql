-- ============================================================
--  EduFlow — Profil, Reklam ve Ders Tamamlama SP Güncellemeleri
--  SSMS'de EduFlowDB seçili iken çalıştır
-- ============================================================

USE EduFlowDB;
GO

-- ============================================================
--  KULLANICI PROFİLİ
-- ============================================================

CREATE OR ALTER PROCEDURE sp_GetUserById
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT u.UserId, u.FullName, u.Email, u.PhotoUrl, u.IsActive, u.CreatedAt,
           r.RoleName,
           (SELECT COUNT(*) FROM Enrollments WHERE UserId = u.UserId) AS EnrolledCourses,
           (SELECT COUNT(*) FROM LessonProgress WHERE UserId = u.UserId AND IsCompleted = 1) AS CompletedLessons
    FROM   Users u
    JOIN   Roles r ON r.RoleId = u.RoleId
    WHERE  u.UserId = @UserId;
END
GO

CREATE OR ALTER PROCEDURE sp_UpdateUserProfile
    @UserId   INT,
    @FullName NVARCHAR(100),
    @PhotoUrl NVARCHAR(300) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Users
    SET FullName = @FullName,
        PhotoUrl = CASE WHEN @PhotoUrl IS NULL OR @PhotoUrl = '' THEN PhotoUrl ELSE @PhotoUrl END
    WHERE UserId = @UserId;
END
GO

CREATE OR ALTER PROCEDURE sp_ChangePassword
    @UserId      INT,
    @OldPassword NVARCHAR(256),
    @NewPassword NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Users WHERE UserId = @UserId AND Password = @OldPassword)
    BEGIN
        UPDATE Users SET Password = @NewPassword WHERE UserId = @UserId;
        SELECT 1 AS Success;
    END
    ELSE
        SELECT 0 AS Success;
END
GO

-- ============================================================
--  REKLAM YÖNETİMİ
-- ============================================================

CREATE OR ALTER PROCEDURE sp_GetAllAds
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Advertisements ORDER BY AdId DESC;
END
GO

CREATE OR ALTER PROCEDURE sp_InsertAd
    @Title       NVARCHAR(100),
    @ImageUrl    NVARCHAR(300),
    @RedirectUrl NVARCHAR(300),
    @Position    NVARCHAR(50),
    @StartDate   DATETIME = NULL,
    @EndDate     DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Advertisements (Title, ImageUrl, RedirectUrl, Position, IsActive, StartDate, EndDate)
    VALUES (@Title, NULLIF(@ImageUrl,''), NULLIF(@RedirectUrl,''), @Position, 1,
            @StartDate, @EndDate);
    SELECT SCOPE_IDENTITY() AS AdId;
END
GO

CREATE OR ALTER PROCEDURE sp_SetAdActive
    @AdId     INT,
    @IsActive BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Advertisements SET IsActive = @IsActive WHERE AdId = @AdId;
END
GO

CREATE OR ALTER PROCEDURE sp_DeleteAd
    @AdId INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM Advertisements WHERE AdId = @AdId;
END
GO

-- ============================================================
--  DEMO REKLAM VERİSİ (opsiyonel)
-- ============================================================

IF NOT EXISTS (SELECT 1 FROM Advertisements)
BEGIN
    INSERT INTO Advertisements (Title, ImageUrl, RedirectUrl, Position, IsActive)
    VALUES
    ('Ücretsiz Python Kursu', 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=728&h=90&fit=crop', 'Courses.aspx?category=3', 'Header', 1),
    ('React ile Modern Web', 'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=300&h=250&fit=crop', 'Courses.aspx?category=1', 'Sidebar', 1),
    ('EduFlow Pro Üyelik', 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=728&h=90&fit=crop', 'Register.aspx', 'Footer', 1);
END
GO

PRINT 'Profil, Reklam ve Sipariş SP güncellemeleri tamamlandı!';
GO
