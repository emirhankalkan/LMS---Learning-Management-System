USE EduFlowDB;
GO

-- Varsa tabloyu sil (Yeniden kurulabilir olması için)
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'CourseDiscounts')
    DROP TABLE CourseDiscounts;
GO

CREATE TABLE CourseDiscounts (
    DiscountId INT PRIMARY KEY IDENTITY(1,1),
    CourseId INT NOT NULL REFERENCES Courses(CourseId) ON DELETE CASCADE,
    Code NVARCHAR(50) NOT NULL UNIQUE,
    DiscountPercentage INT NOT NULL CHECK (DiscountPercentage BETWEEN 1 AND 99),
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Eğitmen için kurs indirim kodunu ekle/güncelle (Bir kursun tek aktif kodu olabilir)
CREATE OR ALTER PROCEDURE sp_SaveCourseDiscount
    @CourseId INT,
    @Code NVARCHAR(50),
    @DiscountPercentage INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Varsa eski kodunu kaldır
    DELETE FROM CourseDiscounts WHERE CourseId = @CourseId;
    
    -- Varsa aynı kod başka bir kurstaysa çakışmayı önlemek için sil
    DELETE FROM CourseDiscounts WHERE Code = UPPER(LTRIM(RTRIM(@Code)));
    
    -- Yeni kodu ekle
    INSERT INTO CourseDiscounts (CourseId, Code, DiscountPercentage, IsActive)
    VALUES (@CourseId, UPPER(LTRIM(RTRIM(@Code))), @DiscountPercentage, 1);
END
GO

-- Koda göre indirim getir
CREATE OR ALTER PROCEDURE sp_GetDiscountByCode
    @Code NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM CourseDiscounts 
    WHERE Code = UPPER(LTRIM(RTRIM(@Code))) AND IsActive = 1;
END
GO

-- Kursa göre indirim getir
CREATE OR ALTER PROCEDURE sp_GetDiscountByCourse
    @CourseId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 * FROM CourseDiscounts WHERE CourseId = @CourseId AND IsActive = 1;
END
GO

-- Demo verisi ekleyelim
EXEC sp_SaveCourseDiscount 1, 'WEBFORM25', 25; -- CourseId = 1 için %25 indirim
EXEC sp_SaveCourseDiscount 5, 'PYTHON50', 50;  -- CourseId = 5 için %50 indirim
EXEC sp_SaveCourseDiscount 10, 'CORE10', 10;   -- CourseId = 10 için %10 indirim
GO

PRINT 'İndirim sistemi tabloları ve SP''ler başarıyla oluşturuldu!';
