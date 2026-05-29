-- ==========================================
-- EĞİTMEN KURS DÜZENLEME VE DERS YÖNETİMİ
-- SP KURULUMLARI
-- ==========================================

-- 1. Kurs Güncelleme
CREATE OR ALTER PROCEDURE sp_UpdateCourse
    @CourseId       INT,
    @Title          NVARCHAR(200),
    @Description    NVARCHAR(MAX),
    @ThumbnailUrl   NVARCHAR(300),
    @Price          DECIMAL(10,2),
    @IsFree         BIT,
    @CategoryId     INT,
    @Level          NVARCHAR(50),
    @Language       NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Courses
    SET Title        = @Title,
        Description  = @Description,
        ThumbnailUrl = NULLIF(@ThumbnailUrl, ''),
        Price        = @Price,
        IsFree       = @IsFree,
        CategoryId   = @CategoryId,
        Level        = @Level,
        Language     = @Language
    WHERE CourseId   = @CourseId;
END
GO

-- 2. Ders/Video Silme
CREATE OR ALTER PROCEDURE sp_DeleteLesson
    @LessonId INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CourseId INT;
    DECLARE @OrderIndex INT;
    
    SELECT @CourseId = CourseId, @OrderIndex = OrderIndex
    FROM Lessons
    WHERE LessonId = @LessonId;
    
    IF @CourseId IS NOT NULL
    BEGIN
        -- Dersi sil
        DELETE FROM Lessons WHERE LessonId = @LessonId;
        
        -- Kalan derslerin OrderIndex değerlerini sola kaydır (boşluk kalmasın)
        UPDATE Lessons
        SET OrderIndex = OrderIndex - 1
        WHERE CourseId = @CourseId AND OrderIndex > @OrderIndex;
        
        -- Kurs ders sayılarını ve saatlerini güncelle
        UPDATE Courses
        SET LessonCount = (SELECT COUNT(*) FROM Lessons WHERE CourseId = @CourseId),
            TotalHours   = (SELECT ISNULL(SUM(Duration), 0) / 60 FROM Lessons WHERE CourseId = @CourseId)
        WHERE CourseId = @CourseId;
    END
END
GO

-- 3. Oynatma Listesi Sıralama (Dersi Yukarı/Aşağı Kaydırma)
CREATE OR ALTER PROCEDURE sp_MoveLesson
    @LessonId INT,
    @Direction NVARCHAR(10) -- 'UP' veya 'DOWN'
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CourseId INT;
    DECLARE @CurrentOrder INT;
    DECLARE @TargetLessonId INT;
    DECLARE @TargetOrder INT;
    
    SELECT @CourseId = CourseId, @CurrentOrder = OrderIndex
    FROM Lessons
    WHERE LessonId = @LessonId;
    
    IF @CourseId IS NOT NULL
    BEGIN
        IF @Direction = 'UP' AND @CurrentOrder > 1
        BEGIN
            SET @TargetOrder = @CurrentOrder - 1;
            
            SELECT @TargetLessonId = LessonId 
            FROM Lessons 
            WHERE CourseId = @CourseId AND OrderIndex = @TargetOrder;
            
            IF @TargetLessonId IS NOT NULL
            BEGIN
                -- Sıraları takas et
                UPDATE Lessons SET OrderIndex = @CurrentOrder WHERE LessonId = @TargetLessonId;
                UPDATE Lessons SET OrderIndex = @TargetOrder WHERE LessonId = @LessonId;
            END
        END
        ELSE IF @Direction = 'DOWN'
        BEGIN
            DECLARE @MaxOrder INT = (SELECT MAX(OrderIndex) FROM Lessons WHERE CourseId = @CourseId);
            IF @CurrentOrder < @MaxOrder
            BEGIN
                SET @TargetOrder = @CurrentOrder + 1;
                
                SELECT @TargetLessonId = LessonId 
                FROM Lessons 
                WHERE CourseId = @CourseId AND OrderIndex = @TargetOrder;
                
                IF @TargetLessonId IS NOT NULL
                BEGIN
                    -- Sıraları takas et
                    UPDATE Lessons SET OrderIndex = @CurrentOrder WHERE LessonId = @TargetLessonId;
                    UPDATE Lessons SET OrderIndex = @TargetOrder WHERE LessonId = @LessonId;
                END
            END
        END
    END
END
GO
