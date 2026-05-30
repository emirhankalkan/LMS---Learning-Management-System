# EduFlow - Learning Management System

EduFlow is a web-based Learning Management System built with ASP.NET Web Forms and SQL Server. It was developed as a final project for a Web-Based Technologies course.

The system includes student, instructor, and admin workflows such as course browsing, course enrollment, lesson watching, progress tracking, course creation, local video uploads, discount codes, and basic platform management.

---

## Screenshots

### Home Page
![Home Page](screenshots/homepage.png)

### Course Catalog
![Course Catalog](screenshots/courses.png)

### Course Detail
![Course Detail](screenshots/course-detail.png)

### Lesson Watch
![Lesson Watch](screenshots/lesson-watch.png)

### Student Dashboard
![Student Dashboard](screenshots/dashboard.png)

### Cart & Checkout
![Cart](screenshots/cart.png)
![Checkout](screenshots/checkout.png)

### Instructor Panel
![Instructor Dashboard](screenshots/instructor-dashboard.png)
![Instructor Courses](screenshots/instructor-courses.png)

---

## Tech Stack

| Layer | Technology |
|---|---|
| Backend | C#, ASP.NET Web Forms, .NET Framework 4.7.2 |
| Database | Microsoft SQL Server |
| Data Access | ADO.NET, stored procedures, parameterized SQL |
| Frontend | HTML5, CSS, JavaScript, Bootstrap |
| Auth | Session-based authentication with PBKDF2 password hashing |
| Payment | Simulated iyzico checkout flow |

---

## Main Features

### Student
- Register and log in
- Browse and search courses
- Add courses to cart and complete simulated checkout
- Enroll in free courses directly
- Watch lessons with an HTML5 video player
- Continue from the last watched lesson
- Mark lessons as completed
- Track course progress
- Add courses to favorites
- View order history
- Update profile information and password

### Instructor
- View instructor dashboard statistics
- Create and edit courses
- Set course price
- Add discount codes for paid courses
- Upload local lesson videos
- Add, delete, and reorder lessons
- View enrolled students

### Admin
- View platform statistics
- Manage users
- View all courses
- Moderate comments/reviews
- Manage advertisements

---

## Project Structure

```text
EduFlow/
|-- Admin/          Admin panel pages
|-- Instructor/     Instructor panel pages
|-- DAL/            Data access classes
|-- Models/         Entity models
|-- Services/       Shared services
|-- Database/       SQL setup and seed scripts
|-- Content/        CSS files
|-- Scripts/        JavaScript libraries
|-- Uploads/        Uploaded lesson video folder
```

Uploaded lesson video files are ignored by Git. The folder is kept with `.gitkeep`.

---

## Database

Main tables:

- Users
- Roles
- Courses
- Lessons
- Enrollments
- LessonProgress
- Orders
- Reviews
- Favorites
- Categories
- CourseDiscounts
- Advertisements

Most core data operations use stored procedures. Some helper flows use parameterized SQL.

---

## Setup

### Requirements

- Visual Studio 2022
- .NET Framework 4.7.2
- SQL Server or SQL Server Express
- IIS Express

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/emirhankalkan/LMS---Learning-Management-System.git
   ```

2. Open `EduFlow.sln` in Visual Studio.

3. Update the SQL Server connection string in `Web.config` if needed:

   ```xml
   <add name="EduFlowDb"
        connectionString="Data Source=localhost;Initial Catalog=EduFlowDB;Integrated Security=True;MultipleActiveResultSets=True"
        providerName="System.Data.SqlClient" />
   ```

4. Run the SQL scripts in the `Database/` folder.

   Recommended order:

   1. `EduFlowDB_Setup.sql`
   2. `Instructor_Role_Add.sql`
   3. `Course_Discounts_Setup.sql`
   4. `Instructor_Course_Edit_Setup.sql`
   5. `Profile_Ads_Updates.sql`
   6. `Seed_Rich_Sample_Data.sql`

5. Build and run the project with IIS Express.

---

## Demo Accounts

| Role | Email | Password |
|---|---|---|
| Admin | admin@eduflow.test | 123456 |
| Instructor | egitmen@eduflow.test | 123456 |
| Student | ogrenci@eduflow.test | 123456 |

---

## Notes

- Uploaded video files are stored under `Uploads/Lessons/`.
- Video files are not committed to GitHub.
- Checkout is a simulation and does not process real payments.
- Password reset is intentionally kept simple and does not use email tokens.

---

## Authors

Developed as a group final project for the Web-Based Technologies course.
