# EduFlow - Learning Management System (LMS)

This project is a comprehensive, web-based e-learning platform developed as the Final Project for the "Web-Based Technologies" course. Built collaboratively as a group project, EduFlow serves as a fully-featured Learning Management System (LMS) designed to connect students with expert instructors.

---

## Technical Stack
- **Backend:** C#, ASP.NET Web Forms, .NET Framework 4.7.2
- **Data Access:** ADO.NET, Microsoft SQL Server (Stored Procedures)
- **Frontend:** Vanilla CSS, Bootstrap, JavaScript, HTML5, Bootstrap Icons
- **Simulation Layer:** Simulated iyzico 3D Secure Payment Gateway

---

## Core Modules

### 1. Student Portal
- **Dashboard:** Tracks enrolled courses, learning progress, and completion status.
- **Course Catalog:** Dynamic searching and filtering of courses by level, language, category, and average rating.
- **Favorites:** Ability to bookmark courses for future reference.
- **Interactive Reviews:** Verified students can leave course ratings and approved text reviews.

### 2. Instructor Portal
- **Dashboard:** Provides key statistics including total students enrolled, total courses published, and cumulative course revenues.
- **Course Management:** Interfaces to add, update, or remove courses, including specific lesson configurations.
- **Student Insights:** Detailed views tracking student enrollments in specific instructor-led courses.
- **Course Discounting:** Ability to generate and manage course-specific coupon codes.

### 3. Course-Specific Discount System
- Instructors can assign unique alphanumeric coupon codes and discount percentages to their courses.
- Students can apply these coupons inside their cart. The system validates the code against the database, links it to the target course, calculates the discounted price, and renders it in the cart summary.
- The interface supports strikethrough original pricing and highlighted discount statuses.

### 4. Simulated iyzico 3D Secure Checkout
- Provides a realistic replication of the iyzico sandbox checkout process.
- Features a live 3D credit card preview that dynamically formats numbers and identifies the card issuer (Visa or Mastercard).
- Integrates a complete multi-step validation layer, including an iyzico secure connection loading overlay, simulated 3D Secure SMS validation with a live countdown timer, and detailed transaction logging.
- Upon successful payment, orders are stored in the database under the calculated discounted rates, and students are instantly enrolled in their courses.

---

## Database Architecture
The system uses a highly structured relational database schema powered by Stored Procedures to maintain optimal performance and security:
- **Users & Roles:** Separate user flows and authorization checks for Students, Instructors, and Administrators.
- **Courses & Lessons:** Relational mappings of multi-lesson curricula.
- **CourseDiscounts:** Active tracking of custom instructor discount codes.
- **Orders & Enrollments:** Transaction logs storing order amounts, payment references, and active user course enrollments.

---

## Setup and Installation

### Prerequisites
- Visual Studio 2022 (with ASP.NET and web development workload)
- Microsoft SQL Server & SQL Server Management Studio (SSMS)
- IIS Express (configured automatically by Visual Studio)

### Installation Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/emirhankalkan/LMS---Learning-Management-System.git
   ```
2. Open the solution file `EduFlow.sln` in Visual Studio 2022.
3. Configure the database connection string inside the `Web.config` file to point to your local SQL Server instance.
4. Execute the SQL setup scripts found under the `Database/` directory to construct the tables, seed mock data, and compile the required stored procedures.
5. Rebuild the solution and run it via IIS Express.
