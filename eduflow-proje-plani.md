# EduFlow — Online Kurs Platformu Proje Planı
## ASP.NET Web Forms | SQL Server | Bootstrap 5

---

## 1. Proje Yapısı

```
EduFlow/
├── App_Code/
│   ├── DAL/
│   │   ├── UserDAL.cs
│   │   ├── CourseDAL.cs
│   │   ├── OrderDAL.cs
│   │   ├── ReviewDAL.cs
│   │   └── AdDAL.cs
│   └── Models/
│       ├── User.cs
│       ├── Course.cs
│       ├── Order.cs
│       └── Review.cs
├── Admin/
│   ├── Admin.master
│   ├── Dashboard.aspx
│   ├── Courses.aspx
│   ├── Users.aspx
│   ├── Ads.aspx
│   └── Comments.aspx
├── Assets/
│   ├── css/
│   ├── js/
│   └── images/
├── Site.Master
├── Home.aspx
├── Login.aspx
├── Register.aspx
├── Courses.aspx
├── CourseDetail.aspx
├── Dashboard.aspx
├── Cart.aspx
├── Favorites.aspx
├── Profile.aspx
├── OrderHistory.aspx
├── PaymentSuccess.aspx
├── PaymentFail.aspx
└── Web.config
```

---

## 2. Veritabanı Şeması (SQL Server)

```sql
-- 1. Roles
CREATE TABLE Roles (
    RoleId   INT PRIMARY KEY IDENTITY,
    RoleName NVARCHAR(50)  -- 'Admin', 'Student'
)

-- 2. Users
CREATE TABLE Users (
    UserId    INT PRIMARY KEY IDENTITY,
    FullName  NVARCHAR(100) NOT NULL,
    Email     NVARCHAR(150) NOT NULL UNIQUE,
    Password  NVARCHAR(256) NOT NULL,  -- SHA256 hash
    PhotoUrl  NVARCHAR(300),
    RoleId    INT FOREIGN KEY REFERENCES Roles(RoleId),
    IsActive  BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE()
)

-- 3. Categories
CREATE TABLE Categories (
    CategoryId INT PRIMARY KEY IDENTITY,
    Name       NVARCHAR(100),
    IconClass  NVARCHAR(50)  -- Bootstrap icon class, örn: "bi-code-slash"
)

-- 4. Courses
CREATE TABLE Courses (
    CourseId       INT PRIMARY KEY IDENTITY,
    Title          NVARCHAR(200) NOT NULL,
    Description    NVARCHAR(MAX),
    ThumbnailUrl   NVARCHAR(300),
    Price          DECIMAL(10,2) DEFAULT 0,
    IsFree         BIT DEFAULT 0,
    IsFeatured     BIT DEFAULT 0,
    CategoryId     INT FOREIGN KEY REFERENCES Categories(CategoryId),
    InstructorName NVARCHAR(100),
    Level          NVARCHAR(50),  -- 'Beginner', 'Intermediate', 'Advanced'
    Language       NVARCHAR(50),
    IsActive       BIT DEFAULT 1,
    CreatedAt      DATETIME DEFAULT GETDATE()
)

-- 5. Lessons
CREATE TABLE Lessons (
    LessonId   INT PRIMARY KEY IDENTITY,
    CourseId   INT FOREIGN KEY REFERENCES Courses(CourseId),
    Title      NVARCHAR(200),
    VideoUrl   NVARCHAR(300),  -- YouTube embed URL: https://www.youtube.com/embed/VIDEO_ID
    Duration   INT,            -- dakika cinsinden
    OrderIndex INT,
    IsPreview  BIT DEFAULT 0  -- ücretsiz önizleme izni
)

-- 6. LessonProgress
CREATE TABLE LessonProgress (
    ProgressId  INT PRIMARY KEY IDENTITY,
    UserId      INT FOREIGN KEY REFERENCES Users(UserId),
    LessonId    INT FOREIGN KEY REFERENCES Lessons(LessonId),
    IsCompleted BIT DEFAULT 0,
    CompletedAt DATETIME
)

-- 7. Enrollments
CREATE TABLE Enrollments (
    EnrollmentId INT PRIMARY KEY IDENTITY,
    UserId       INT FOREIGN KEY REFERENCES Users(UserId),
    CourseId     INT FOREIGN KEY REFERENCES Courses(CourseId),
    EnrolledAt   DATETIME DEFAULT GETDATE()
)

-- 8. Orders
CREATE TABLE Orders (
    OrderId    INT PRIMARY KEY IDENTITY,
    UserId     INT FOREIGN KEY REFERENCES Users(UserId),
    CourseId   INT FOREIGN KEY REFERENCES Courses(CourseId),
    Amount     DECIMAL(10,2),
    Status     NVARCHAR(50),   -- 'Pending', 'Completed', 'Failed'
    PaymentRef NVARCHAR(200),  -- İyzico token
    CreatedAt  DATETIME DEFAULT GETDATE()
)

-- 9. Reviews
CREATE TABLE Reviews (
    ReviewId   INT PRIMARY KEY IDENTITY,
    UserId     INT FOREIGN KEY REFERENCES Users(UserId),
    CourseId   INT FOREIGN KEY REFERENCES Courses(CourseId),
    Rating     INT CHECK (Rating BETWEEN 1 AND 5),
    Comment    NVARCHAR(MAX),
    IsApproved BIT DEFAULT 0,
    CreatedAt  DATETIME DEFAULT GETDATE()
)

-- 10. Favorites
CREATE TABLE Favorites (
    FavoriteId INT PRIMARY KEY IDENTITY,
    UserId     INT FOREIGN KEY REFERENCES Users(UserId),
    CourseId   INT FOREIGN KEY REFERENCES Courses(CourseId),
    AddedAt    DATETIME DEFAULT GETDATE()
)

-- 11. Advertisements
CREATE TABLE Advertisements (
    AdId        INT PRIMARY KEY IDENTITY,
    Title       NVARCHAR(100),
    ImageUrl    NVARCHAR(300),
    RedirectUrl NVARCHAR(300),
    Position    NVARCHAR(50),  -- 'Header', 'Sidebar', 'Footer'
    ClickCount  INT DEFAULT 0,
    IsActive    BIT DEFAULT 1,
    StartDate   DATETIME,
    EndDate     DATETIME
)
```

---

## 3. Stored Procedures

```sql
-- Kullanıcı işlemleri
sp_LoginUser           -- Email + SHA256 hash ile doğrula, User objesini döndür
sp_RegisterUser        -- Yeni kullanıcı ekle, email duplicate kontrolü yap

-- Kurs işlemleri
sp_GetAllCourses       -- Tüm aktif kursları listele
sp_GetCoursesByCategory -- CategoryId'ye göre filtrele
sp_GetCourseDetail     -- Kurs + avg rating + enrollment sayısı
sp_SearchCourses       -- Başlık ve açıklamada LIKE ile arama
sp_GetFeaturedCourses  -- IsFeatured = 1 olanları getir

-- Yorum işlemleri
sp_AddReview           -- Yeni yorum ekle (IsApproved = 0 başlangıçta)
sp_ApproveReview       -- Admin onayı: IsApproved = 1
sp_DeleteReview        -- Admin silme

-- Favori işlemleri
sp_ToggleFavorite      -- Yoksa ekle, varsa sil
sp_GetUserFavorites    -- Kullanıcının favori kursları

-- Sipariş & ödeme işlemleri
sp_CreateOrder         -- Yeni sipariş oluştur (Status = 'Pending')
sp_CompleteOrder       -- İyzico callback sonrası: Status = 'Completed', Enrollment ekle
sp_FailOrder           -- Status = 'Failed'
sp_GetUserOrders       -- Kullanıcının sipariş geçmişi

-- Dashboard
sp_GetUserDashboard    -- Kullanıcının kayıtlı kursları + her kurs için tamamlanan ders sayısı
sp_CompleteLesson      -- LessonProgress güncelle

-- Admin
sp_GetAdminStats       -- Toplam kullanıcı, kurs, sipariş, gelir
sp_GetAllUsers         -- Kullanıcı listesi (admin için)
sp_SetUserActive       -- Kullanıcıyı aktif/pasif yap

-- Reklam
sp_GetAdByPosition     -- Position'a göre aktif reklam getir
sp_IncrementAdClick    -- ClickCount + 1
```

---

## 4. Sayfalar

### Public Sayfalar (giriş gerekmez)
| Sayfa | İçerik |
|---|---|
| `Home.aspx` | Hero section, öne çıkan kurslar (IsFeatured), kategoriler, sidebar reklam |
| `Courses.aspx` | Kurs listeleme, kategori filtresi (DropDownList), arama (UpdatePanel) |
| `CourseDetail.aspx` | Kurs bilgisi, ders listesi, ortalama puan, yorumlar, Satın Al / Favorile butonu |
| `Login.aspx` | Email + şifre formu |
| `Register.aspx` | Ad soyad, email, şifre, şifre tekrar |

### Kullanıcı Sayfaları (Session kontrolü zorunlu)
| Sayfa | İçerik |
|---|---|
| `Dashboard.aspx` | Satın alınan kurslar, her kurs için ilerleme yüzdesi |
| `Profile.aspx` | Ad, fotoğraf güncelleme; şifre değiştirme |
| `Favorites.aspx` | Favori kurs listesi, favoriden çıkar butonu |
| `Cart.aspx` | Sepet özeti (Session["Cart"]), İyzico ödeme başlat |
| `OrderHistory.aspx` | Tüm siparişler, durum, tarih, tutar |
| `PaymentSuccess.aspx` | sp_CompleteOrder çağır, başarı mesajı göster |
| `PaymentFail.aspx` | sp_FailOrder çağır, hata mesajı göster |

### Admin Sayfaları (`/Admin/` klasörü, Admin.master ile)
| Sayfa | İçerik |
|---|---|
| `Dashboard.aspx` | İstatistik kartları: toplam kullanıcı, kurs, sipariş, gelir |
| `Courses.aspx` | GridView kurs listesi; FormView ile ekle/düzenle/sil |
| `Users.aspx` | Kullanıcı listesi, aktif/pasif toggle |
| `Comments.aspx` | Onay bekleyen yorumlar, Onayla / Sil butonları |
| `Ads.aspx` | Reklam ekle/düzenle/sil, position seçimi, aktif/pasif toggle |

---

## 5. Session Yapısı

```csharp
Session["UserId"]   // int
Session["UserRole"] // string: "Admin" veya "Student"
Session["FullName"] // string
Session["Cart"]     // List<int> — CourseId listesi
```

Her kullanıcı sayfasının Page_Load'unda:
```csharp
if (Session["UserId"] == null) {
    Response.Redirect("~/Login.aspx");
}
```

Admin.master'ın Page_Load'unda:
```csharp
if (Session["UserRole"]?.ToString() != "Admin") {
    Response.Redirect("~/Login.aspx");
}
```

---

## 6. Master Page Yapısı

### Site.Master (public + kullanıcı sayfaları)
- Navbar: Logo, Kurslar, Kategoriler, Giriş Yap / Profil dropdown
- Footer: Linkler, telif hakkı
- Bootstrap 5 CDN
- Bootstrap Icons CDN

### Admin/Admin.master (admin sayfaları)
- Sol sidebar navigasyon: Dashboard, Kurslar, Kullanıcılar, Yorumlar, Reklamlar
- Üst navbar: Admin adı, Çıkış butonu
- İçerik alanı: ContentPlaceHolder

---

## 7. Kullanılacak Web Forms Kontrolleri

| Kontrol | Kullanım yeri |
|---|---|
| `GridView` | Admin kurs/kullanıcı/yorum listeleri, sipariş geçmişi |
| `Repeater` | Home kurs kartları, CourseDetail yorum listesi |
| `FormView` | Admin kurs ekle/düzenle |
| `DetailsView` | Kullanıcı profil görüntüleme |
| `UpdatePanel + ScriptManager` | Arama, favori butonu, yorum ekleme |
| `DropDownList` | Kategori filtresi, seviye seçimi |
| `FileUpload` | Kurs thumbnail, profil fotoğrafı |
| `RequiredFieldValidator` | Tüm zorunlu alanlar |
| `RegularExpressionValidator` | Email formatı |
| `CompareValidator` | Şifre tekrar kontrolü |
| `RangeValidator` | Fiyat alanı (0-9999) |
| `SqlDataSource` | Basit dropdown bağlama (kategori listesi) |

---

## 8. İyzico Entegrasyonu

```
Akış:
1. Cart.aspx → "Ödemeye Geç" butonuna tıkla
2. sp_CreateOrder → OrderId oluştur (Status = 'Pending')
3. İyzico sandbox API'ye initialize isteği gönder → token al
4. Kullanıcıyı İyzico checkout formuna yönlendir
5a. Başarılı → PaymentSuccess.aspx → sp_CompleteOrder → sp Enrollment ekler
5b. Başarısız → PaymentFail.aspx → sp_FailOrder
```

İyzico Sandbox bilgileri Web.config'de:
```xml
<add key="IyzicoApiKey" value="sandbox-api-key" />
<add key="IyzicoSecretKey" value="sandbox-secret-key" />
<add key="IyzicoBaseUrl" value="https://sandbox-api.iyzipay.com" />
```

---

## 9. Reklam Sistemi

Advertisements tablosundan `sp_GetAdByPosition` ile çekilen reklam, ilgili Master Page alanında gösterilir.

Pozisyonlar:
- `Header` — Home.aspx üst banner (tam genişlik)
- `Sidebar` — Courses.aspx sağ panel
- `Footer` — Tüm sayfalarda alt banner

Tıklama sayacı:
```csharp
// Reklam linkine tıklandığında AJAX ile:
sp_IncrementAdClick(@AdId)
// Sonra Response.Redirect(RedirectUrl)
```

---

## 10. Güvenlik Notları

- Şifre: `SHA256(password + email)` hash ile sakla, düz metin asla
- SQL Injection: Tüm sorgular Stored Procedure veya parametreli query ile
- Admin klasörü: `web.config` ile ekstra koruma
  ```xml
  <location path="Admin">
    <system.web>
      <authorization>
        <deny users="?" />
      </authorization>
    </system.web>
  </location>
  ```

---

## 11. Geliştirme Sırası (Öncelik)

```
Adım 1  — DB: Tablolar + seed data + stored procedures
Adım 2  — App_Code: Model sınıfları + DAL katmanı
Adım 3  — Site.Master + Admin.master
Adım 4  — Login.aspx + Register.aspx (auth tam çalışsın)
Adım 5  — Home.aspx + Courses.aspx + CourseDetail.aspx
Adım 6  — Dashboard.aspx + Favorites.aspx + Profile.aspx
Adım 7  — Admin paneli (tüm sayfalar)
Adım 8  — Cart.aspx + İyzico + PaymentSuccess/Fail
Adım 9  — Reklam sistemi
Adım 10 — UpdatePanel iyileştirmeleri + UI polish + test
```

---

## 12. Teknik Gereksinim Özeti

- **Framework:** ASP.NET Web Forms (.NET Framework 4.x)
- **Veritabanı:** SQL Server (LocalDB geliştirme, full SQL Server prod)
- **ORM:** Yok — ADO.NET ile DAL katmanı
- **UI:** Bootstrap 5 + Bootstrap Icons (CDN)
- **Ödeme:** İyzico (sandbox)
- **Video:** YouTube embed iframe
- **Fotoğraf upload:** Server'a kaydet → `~/Uploads/` klasörü
- **AJAX:** ASP.NET UpdatePanel (jQuery kullanma)
- **Şifreleme:** SHA256 (System.Security.Cryptography)

---

## 13. Tasarım Sistemi

### Genel Felsefe
Kurumsal, profesyonel ve modern bir görünüm hedeflenir. Tasarım temiz, düz (flat) ve ağır efektlerden uzak olmalıdır. Kullanıcı güven hissettirmeli; eğitim platformu ciddiyeti ile modern SaaS estetiği birleştirilmelidir.

**Temel kurallar:**
- Gradient, gölge (box-shadow), blur ve neon efekt KULLANMA
- Tüm köşeler `border-radius` ile yumuşatılmış olmalı (sert köşe yok)
- Boşluk cömert kullanılmalı — elementler birbirine sıkışmamalı
- Mobil uyumlu (responsive) olmak zorunlu — Bootstrap grid kullan
- Tüm font ağırlıkları: sadece `400` (normal) ve `500` (bold). `600`, `700`, `800` kullanma — sayfaya ağır görünüm katar

---

### Renk Paleti

```css
/* Assets/css/site.css dosyasına ekle */
:root {
  /* Ana renkler */
  --color-primary:        #1E3A5F;  /* Navy Blue — navbar, butonlar, başlıklar */
  --color-primary-hover:  #2E5F9E;  /* Hover state */
  --color-primary-light:  #D6E6F4;  /* Açık mavi — badge arka planı, hover fill */

  /* Vurgu rengi */
  --color-accent:         #E8AF2A;  /* Gold — CTA butonu, öne çıkan badge, fiyat */
  --color-accent-hover:   #F0C455;
  --color-accent-dark:    #3D2800;  /* Altın üzerine yazı rengi */

  /* Arka planlar */
  --color-bg:             #FFFFFF;  /* Ana sayfa arka planı */
  --color-surface:        #F0F4F8;  /* Kart ve section arka planı */
  --color-border:         #D0D7E0;  /* Tüm border'lar */

  /* Yazı renkleri */
  --color-text-primary:   #1C2B3A;  /* Ana metin */
  --color-text-secondary: #5A6A7A;  /* İkincil metin, açıklama */
  --color-text-muted:     #8A9AAA;  /* Placeholder, tarih, meta bilgi */

  /* Durum renkleri */
  --color-success:        #2A7A4F;
  --color-success-bg:     #DFF2E8;
  --color-danger:         #C0392B;
  --color-danger-bg:      #FDECEA;
  --color-warning:        #E8AF2A;
  --color-warning-bg:     #FDF3D5;

  /* Tipografi */
  --font-main: 'Segoe UI', system-ui, -apple-system, sans-serif;

  /* Border radius */
  --radius-sm:  6px;
  --radius-md:  10px;
  --radius-lg:  16px;
  --radius-pill: 999px;

  /* Spacing */
  --space-xs:  4px;
  --space-sm:  8px;
  --space-md:  16px;
  --space-lg:  24px;
  --space-xl:  40px;
}
```

---

### Renk Kullanım Kuralları

| Element | Renk |
|---|---|
| Navbar arka plan | `--color-primary` (#1E3A5F) |
| Navbar yazı | `#FFFFFF` |
| Primary buton (Satın Al, Kayıt Ol) | `--color-primary` arka plan, beyaz yazı |
| CTA butonu (Ana sayfa hero) | `--color-accent` (#E8AF2A) arka plan, `--color-accent-dark` yazı |
| Kart arka planı | `#FFFFFF`, border: `1px solid --color-border` |
| Section arka planı (alternatif) | `--color-surface` (#F0F4F8) |
| Fiyat gösterimi | `--color-primary` bold |
| "Ücretsiz" badge | `--color-success-bg` arka plan, `--color-success` yazı |
| "Öne Çıkan" badge | `--color-accent` arka plan, `--color-accent-dark` yazı |
| "İndirim" badge | `--color-danger-bg` arka plan, `--color-danger` yazı |
| Form input focus | `border-color: --color-primary` |
| Link rengi | `--color-primary` |
| Footer arka plan | `--color-primary` |
| Footer yazı | `#A8C4E0` (soluk beyaz) |

---

### Tipografi

```css
body {
  font-family: var(--font-main);
  font-size: 16px;
  font-weight: 400;
  color: var(--color-text-primary);
  line-height: 1.7;
}

h1 { font-size: 2rem;   font-weight: 500; color: var(--color-primary); }
h2 { font-size: 1.5rem; font-weight: 500; color: var(--color-primary); }
h3 { font-size: 1.2rem; font-weight: 500; color: var(--color-text-primary); }

.text-muted    { color: var(--color-text-muted); font-size: 14px; }
.text-secondary { color: var(--color-text-secondary); }
```

---

### Komponent Stilleri

#### Navbar
```css
.navbar {
  background-color: var(--color-primary);
  padding: 14px 0;
  border-bottom: none;
}
.navbar-brand {
  color: #FFFFFF;
  font-size: 1.3rem;
  font-weight: 500;
  letter-spacing: 0.5px;
}
.navbar .nav-link {
  color: #A8C4E0;
  font-size: 14px;
  padding: 6px 14px;
  border-radius: var(--radius-sm);
  transition: background 0.2s, color 0.2s;
}
.navbar .nav-link:hover {
  background: rgba(255,255,255,0.1);
  color: #FFFFFF;
}
.navbar .btn-accent {
  background: var(--color-accent);
  color: var(--color-accent-dark);
  font-weight: 500;
  border: none;
  border-radius: var(--radius-sm);
  padding: 6px 18px;
  font-size: 14px;
}
```

#### Kart (Kurs Kartı)
```css
.course-card {
  background: #FFFFFF;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  overflow: hidden;
  transition: border-color 0.2s, transform 0.2s;
}
.course-card:hover {
  border-color: var(--color-primary-light);
  transform: translateY(-2px);
}
.course-card .card-img-top {
  height: 180px;
  object-fit: cover;
}
.course-card .card-body {
  padding: 16px;
}
.course-card .course-title {
  font-size: 15px;
  font-weight: 500;
  color: var(--color-text-primary);
  margin-bottom: 6px;
  line-height: 1.4;
}
.course-card .course-meta {
  font-size: 13px;
  color: var(--color-text-muted);
  margin-bottom: 12px;
}
.course-card .course-price {
  font-size: 18px;
  font-weight: 500;
  color: var(--color-primary);
}
```

#### Butonlar
```css
/* Primary */
.btn-primary-custom {
  background: var(--color-primary);
  color: #FFFFFF;
  border: none;
  border-radius: var(--radius-sm);
  padding: 10px 24px;
  font-size: 15px;
  font-weight: 500;
  transition: background 0.2s;
}
.btn-primary-custom:hover { background: var(--color-primary-hover); }

/* Accent (CTA) */
.btn-accent {
  background: var(--color-accent);
  color: var(--color-accent-dark);
  border: none;
  border-radius: var(--radius-sm);
  padding: 10px 24px;
  font-size: 15px;
  font-weight: 500;
  transition: background 0.2s;
}
.btn-accent:hover { background: var(--color-accent-hover); }

/* Outline */
.btn-outline-custom {
  background: transparent;
  color: var(--color-primary);
  border: 1.5px solid var(--color-primary);
  border-radius: var(--radius-sm);
  padding: 10px 24px;
  font-size: 15px;
  font-weight: 500;
  transition: background 0.2s, color 0.2s;
}
.btn-outline-custom:hover {
  background: var(--color-primary);
  color: #FFFFFF;
}
```

#### Badge'ler
```css
.badge-free     { background: var(--color-success-bg); color: var(--color-success); font-size: 12px; padding: 4px 10px; border-radius: var(--radius-pill); font-weight: 500; }
.badge-featured { background: var(--color-accent);     color: var(--color-accent-dark); font-size: 12px; padding: 4px 10px; border-radius: var(--radius-pill); font-weight: 500; }
.badge-discount { background: var(--color-danger-bg);  color: var(--color-danger); font-size: 12px; padding: 4px 10px; border-radius: var(--radius-pill); font-weight: 500; }
.badge-level    { background: var(--color-primary-light); color: var(--color-primary); font-size: 12px; padding: 4px 10px; border-radius: var(--radius-pill); font-weight: 500; }
```

#### Form Elemanları
```css
.form-control {
  border: 1px solid var(--color-border);
  border-radius: var(--radius-sm);
  padding: 10px 14px;
  font-size: 15px;
  color: var(--color-text-primary);
  transition: border-color 0.2s;
}
.form-control:focus {
  border-color: var(--color-primary);
  box-shadow: none;
  outline: none;
}
.form-label {
  font-size: 14px;
  font-weight: 500;
  color: var(--color-text-secondary);
  margin-bottom: 6px;
}
```

#### Hero Section (Home.aspx)
```css
.hero {
  background: var(--color-primary);
  padding: 80px 0 60px;
  color: #FFFFFF;
}
.hero h1 {
  font-size: 2.4rem;
  font-weight: 500;
  color: #FFFFFF;
  line-height: 1.3;
}
.hero p {
  font-size: 1.1rem;
  color: #A8C4E0;
  margin-bottom: 32px;
}
/* Arama kutusu hero içinde */
.hero .search-box {
  background: #FFFFFF;
  border-radius: var(--radius-md);
  padding: 6px 6px 6px 16px;
  display: flex;
  align-items: center;
  max-width: 560px;
}
.hero .search-box input {
  border: none;
  outline: none;
  font-size: 15px;
  flex: 1;
  color: var(--color-text-primary);
}
.hero .search-box button {
  background: var(--color-accent);
  color: var(--color-accent-dark);
  border: none;
  border-radius: var(--radius-sm);
  padding: 8px 20px;
  font-weight: 500;
}
```

#### Admin Sidebar
```css
.admin-sidebar {
  background: var(--color-primary);
  min-height: 100vh;
  width: 240px;
  padding: 24px 0;
}
.admin-sidebar .sidebar-brand {
  color: #FFFFFF;
  font-size: 1.1rem;
  font-weight: 500;
  padding: 0 20px 24px;
  border-bottom: 1px solid rgba(255,255,255,0.1);
  margin-bottom: 16px;
}
.admin-sidebar .nav-link {
  color: #A8C4E0;
  padding: 10px 20px;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 10px;
  border-radius: 0;
  transition: background 0.15s, color 0.15s;
}
.admin-sidebar .nav-link:hover,
.admin-sidebar .nav-link.active {
  background: rgba(255,255,255,0.1);
  color: #FFFFFF;
}
```

#### İstatistik Kartı (Admin Dashboard)
```css
.stat-card {
  background: #FFFFFF;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  padding: 20px 24px;
}
.stat-card .stat-label {
  font-size: 13px;
  color: var(--color-text-muted);
  margin-bottom: 6px;
}
.stat-card .stat-value {
  font-size: 28px;
  font-weight: 500;
  color: var(--color-primary);
}
.stat-card .stat-icon {
  color: var(--color-primary-light);
  font-size: 32px;
}
```

---

### Sayfa Bazlı Tasarım Notları

**Home.aspx**
- En üstte tam genişlik koyu navy hero section (arama kutusu içinde)
- Altında `--color-surface` arka planlı kategori şeridi (icon + isim kartları)
- Öne çıkan kurslar: 3'lü Bootstrap grid, kurs kartları
- Sağda sabit sidebar reklam alanı (160x600 veya 300x250)
- Footer: `--color-primary` arka plan, 4 kolonlu linkler

**CourseDetail.aspx**
- Sol: YouTube embed (16:9 ratio, border-radius ile)
- Sağ: Sticky satın alma kutusu (fiyat büyük, CTA butonu accent renkte)
- Altında tab yapısı: "Müfredat" / "Yorumlar" / "Eğitmen"
- Yıldız rating: Bootstrap Icons `bi-star-fill` ile gold renk (`--color-accent`)

**Login.aspx / Register.aspx**
- Sayfa ortasında tek kart (max-width: 440px)
- Kartın üstünde logo + site adı
- Arka plan: `--color-surface`

**Admin paneli**
- Sol sidebar + sağda içerik alanı (flex layout)
- GridView tablolarında satır hover: `--color-surface`
- Onay butonu: success renk, Sil butonu: danger renk

---

### CSS Dosya Yapısı

```
Assets/
└── css/
    ├── site.css        ← CSS variables + global stiller + komponent stilleri (yukarıdaki her şey)
    └── admin.css       ← Sadece admin sidebar + admin'e özel stiller
```

`site.css` her sayfada Site.Master üzerinden yüklenir.
`admin.css` sadece Admin/Admin.master üzerinden yüklenir.

Bootstrap 5 CDN **site.css'den önce** yüklenmeli; custom stiller Bootstrap'i override eder.
