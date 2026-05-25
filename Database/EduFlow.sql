CREATE TABLE Roles (
    RoleId INT PRIMARY KEY IDENTITY,
    RoleName NVARCHAR(50) NOT NULL
);

CREATE TABLE Users (
    UserId INT PRIMARY KEY IDENTITY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) NOT NULL UNIQUE,
    Password NVARCHAR(256) NOT NULL,
    PhotoUrl NVARCHAR(300),
    RoleId INT NOT NULL FOREIGN KEY REFERENCES Roles(RoleId),
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Categories (
    CategoryId INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100) NOT NULL,
    IconClass NVARCHAR(50)
);

CREATE TABLE Courses (
    CourseId INT PRIMARY KEY IDENTITY,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX),
    ThumbnailUrl NVARCHAR(300),
    Price DECIMAL(10,2) NOT NULL DEFAULT 0,
    IsFree BIT NOT NULL DEFAULT 0,
    IsFeatured BIT NOT NULL DEFAULT 0,
    CategoryId INT NOT NULL FOREIGN KEY REFERENCES Categories(CategoryId),
    InstructorName NVARCHAR(100),
    Level NVARCHAR(50),
    Language NVARCHAR(50),
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Lessons (
    LessonId INT PRIMARY KEY IDENTITY,
    CourseId INT NOT NULL FOREIGN KEY REFERENCES Courses(CourseId),
    Title NVARCHAR(200) NOT NULL,
    VideoUrl NVARCHAR(300),
    Duration INT NOT NULL DEFAULT 0,
    OrderIndex INT NOT NULL DEFAULT 0,
    IsPreview BIT NOT NULL DEFAULT 0
);

CREATE TABLE LessonProgress (
    ProgressId INT PRIMARY KEY IDENTITY,
    UserId INT NOT NULL FOREIGN KEY REFERENCES Users(UserId),
    LessonId INT NOT NULL FOREIGN KEY REFERENCES Lessons(LessonId),
    IsCompleted BIT NOT NULL DEFAULT 0,
    CompletedAt DATETIME
);

CREATE TABLE Enrollments (
    EnrollmentId INT PRIMARY KEY IDENTITY,
    UserId INT NOT NULL FOREIGN KEY REFERENCES Users(UserId),
    CourseId INT NOT NULL FOREIGN KEY REFERENCES Courses(CourseId),
    EnrolledAt DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Orders (
    OrderId INT PRIMARY KEY IDENTITY,
    UserId INT NOT NULL FOREIGN KEY REFERENCES Users(UserId),
    CourseId INT NOT NULL FOREIGN KEY REFERENCES Courses(CourseId),
    Amount DECIMAL(10,2) NOT NULL,
    Status NVARCHAR(50) NOT NULL,
    PaymentRef NVARCHAR(200),
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Reviews (
    ReviewId INT PRIMARY KEY IDENTITY,
    UserId INT NOT NULL FOREIGN KEY REFERENCES Users(UserId),
    CourseId INT NOT NULL FOREIGN KEY REFERENCES Courses(CourseId),
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(MAX),
    IsApproved BIT NOT NULL DEFAULT 0,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Favorites (
    FavoriteId INT PRIMARY KEY IDENTITY,
    UserId INT NOT NULL FOREIGN KEY REFERENCES Users(UserId),
    CourseId INT NOT NULL FOREIGN KEY REFERENCES Courses(CourseId),
    AddedAt DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Advertisements (
    AdId INT PRIMARY KEY IDENTITY,
    Title NVARCHAR(100) NOT NULL,
    ImageUrl NVARCHAR(300),
    RedirectUrl NVARCHAR(300),
    Position NVARCHAR(50) NOT NULL,
    ClickCount INT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    StartDate DATETIME,
    EndDate DATETIME
);

INSERT INTO Roles (RoleName) VALUES ('Admin'), ('Student');
INSERT INTO Categories (Name, IconClass) VALUES
('Yazilim', 'bi-code-slash'),
('Tasarim', 'bi-palette'),
('Veri', 'bi-bar-chart'),
('Isletme', 'bi-briefcase');

GO
CREATE PROCEDURE sp_LoginUser
    @Email NVARCHAR(150),
    @Password NVARCHAR(256)
AS
BEGIN
    SELECT u.UserId, u.FullName, u.Email, u.PhotoUrl, r.RoleName, u.IsActive, u.CreatedAt
    FROM Users u
    INNER JOIN Roles r ON r.RoleId = u.RoleId
    WHERE u.Email = @Email AND u.Password = @Password AND u.IsActive = 1;
END
GO
CREATE PROCEDURE sp_RegisterUser
    @FullName NVARCHAR(100),
    @Email NVARCHAR(150),
    @Password NVARCHAR(256)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Users WHERE Email = @Email)
    BEGIN
        SELECT -1;
        RETURN;
    END

    INSERT INTO Users (FullName, Email, Password, RoleId)
    VALUES (@FullName, @Email, @Password, 2);

    SELECT SCOPE_IDENTITY();
END
GO
CREATE PROCEDURE sp_GetAllCourses
AS
BEGIN
    SELECT c.*, cat.Name AS CategoryName,
           ISNULL((SELECT AVG(CAST(Rating AS FLOAT)) FROM Reviews r WHERE r.CourseId = c.CourseId AND r.IsApproved = 1), 0) AS AverageRating,
           (SELECT COUNT(*) FROM Enrollments e WHERE e.CourseId = c.CourseId) AS EnrollmentCount
    FROM Courses c
    INNER JOIN Categories cat ON cat.CategoryId = c.CategoryId
    WHERE c.IsActive = 1
    ORDER BY c.CreatedAt DESC;
END
GO
CREATE PROCEDURE sp_GetFeaturedCourses
AS
BEGIN
    SELECT c.*, cat.Name AS CategoryName,
           ISNULL((SELECT AVG(CAST(Rating AS FLOAT)) FROM Reviews r WHERE r.CourseId = c.CourseId AND r.IsApproved = 1), 0) AS AverageRating,
           (SELECT COUNT(*) FROM Enrollments e WHERE e.CourseId = c.CourseId) AS EnrollmentCount
    FROM Courses c
    INNER JOIN Categories cat ON cat.CategoryId = c.CategoryId
    WHERE c.IsActive = 1 AND c.IsFeatured = 1
    ORDER BY c.CreatedAt DESC;
END
GO
CREATE PROCEDURE sp_GetCourseDetail
    @CourseId INT
AS
BEGIN
    SELECT c.*, cat.Name AS CategoryName,
           ISNULL((SELECT AVG(CAST(Rating AS FLOAT)) FROM Reviews r WHERE r.CourseId = c.CourseId AND r.IsApproved = 1), 0) AS AverageRating,
           (SELECT COUNT(*) FROM Enrollments e WHERE e.CourseId = c.CourseId) AS EnrollmentCount
    FROM Courses c
    INNER JOIN Categories cat ON cat.CategoryId = c.CategoryId
    WHERE c.CourseId = @CourseId AND c.IsActive = 1;
END
