<%@ Page Title="Ders İzle" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="LessonWatch.aspx.cs" Inherits="EduFlow.LessonWatch" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
<style>
.watch-layout {
    display: grid;
    grid-template-columns: 1fr 320px;
    gap: 0;
    min-height: calc(100vh - 64px);
}
@media (max-width: 900px) {
    .watch-layout { grid-template-columns: 1fr; }
    .lesson-sidebar { order: 2; }
    .lesson-player-col { order: 1; }
}
.lesson-sidebar {
    background: var(--color-primary);
    color: #fff;
    overflow-y: auto;
    max-height: calc(100vh - 64px);
    position: sticky;
    top: 64px;
}
.sidebar-header {
    padding: 20px 16px 14px;
    border-bottom: 1px solid rgba(255,255,255,0.12);
}
.sidebar-header h2 {
    font-size: 14px;
    font-weight: 500;
    color: #fff;
    margin: 0 0 4px;
    line-height: 1.4;
}
.sidebar-progress-bar {
    height: 4px;
    background: rgba(255,255,255,0.2);
    border-radius: 2px;
    margin-top: 10px;
    overflow: hidden;
}
.sidebar-progress-bar span {
    display: block;
    height: 100%;
    background: var(--color-accent);
    border-radius: 2px;
    transition: width 0.4s;
}
.lesson-item {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 12px 16px;
    cursor: pointer;
    border-bottom: 1px solid rgba(255,255,255,0.06);
    transition: background 0.15s;
    text-decoration: none;
    color: rgba(255,255,255,0.75);
    font-size: 13px;
}
.lesson-item:hover { background: rgba(255,255,255,0.08); color: #fff; }
.lesson-item.active { background: rgba(255,255,255,0.15); color: #fff; }
.lesson-item.completed .lesson-icon { color: var(--color-accent); }
.lesson-icon { width: 20px; flex-shrink: 0; }
.lesson-num { width: 24px; height: 24px; border-radius: 50%; background: rgba(255,255,255,0.15); display:flex; align-items:center; justify-content:center; font-size:11px; flex-shrink:0; }
.lesson-item.completed .lesson-num { background: var(--color-accent); color: var(--color-accent-dark); }
.lesson-item.active .lesson-num { background: #fff; color: var(--color-primary); }
.lesson-title-text { flex: 1; line-height: 1.35; }
.lesson-dur { font-size: 11px; opacity: 0.6; flex-shrink: 0; }
.preview-tag { font-size: 10px; background: rgba(232,175,42,.25); color: var(--color-accent); padding: 1px 6px; border-radius: 999px; margin-left: 4px; flex-shrink:0; }

.player-area {
    background: #0a0a0a;
    aspect-ratio: 16/9;
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
    overflow: hidden;
}
.player-area iframe, .player-area video {
    width: 100%;
    height: 100%;
    border: 0;
    display: block;
}
.no-video-placeholder {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 12px;
    color: rgba(255,255,255,0.4);
    font-size: 14px;
}
.no-video-placeholder i { font-size: 3rem; }

.lesson-player-col { background: var(--color-surface); }
.lesson-info-bar {
    padding: 20px 24px;
    background: #fff;
    border-bottom: 1px solid var(--color-border);
}
.lesson-info-bar h1 { font-size: 1.1rem; margin: 0 0 8px; }
.lesson-meta-row {
    display: flex;
    align-items: center;
    gap: 16px;
    font-size: 13px;
    color: var(--color-text-muted);
    flex-wrap: wrap;
}
.complete-btn {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 8px 20px;
    background: var(--color-success);
    color: #fff;
    border: none;
    border-radius: var(--radius-sm);
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: background 0.2s;
    margin-left: auto;
}
.complete-btn:disabled {
    background: var(--color-success-bg);
    color: var(--color-success);
    cursor: default;
}
.complete-btn:hover:not(:disabled) { background: #1e6b3f; }

.nav-btns {
    display: flex;
    gap: 8px;
    padding: 16px 24px;
    background: #fff;
    border-bottom: 1px solid var(--color-border);
}
</style>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<% if (Course == null) { %>
<div class="container" style="padding:60px 0;text-align:center;">
    <i class="bi bi-exclamation-circle" style="font-size:3rem;color:var(--color-text-muted)"></i>
    <h2 class="mt-3" style="color:var(--color-text-secondary)">Kurs bulunamadı</h2>
    <a href="Courses.aspx" class="btn btn-primary-custom mt-3">Kurslara Git</a>
</div>
<% } else { %>

<div class="watch-layout">

    <!-- Ana İzleme Alanı -->
    <div class="lesson-player-col">

        <!-- Video oynatıcı -->
        <div class="player-area">
            <% if (CurrentLesson != null && !string.IsNullOrEmpty(CurrentLesson.VideoUrl)) { %>
                <% if (IsLocalVideo(CurrentLesson.VideoUrl)) { %>
                <video controls preload="auto" style="width:100%; height:100%; object-fit:contain;">
                    <source src="<%= System.Web.HttpUtility.HtmlAttributeEncode(ResolveVideoUrl(CurrentLesson.VideoUrl)) %>" type="<%= GetVideoMimeType(CurrentLesson.VideoUrl) %>" />
                    Tarayıcınız video oynatmayı desteklemiyor.
                </video>
                <% } else { %>
                <iframe src="<%: CurrentLesson.VideoUrl %>?autoplay=1&rel=0"
                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                        allowfullscreen></iframe>
                <% } %>
            <% } else { %>
            <div class="no-video-placeholder">
                <i class="bi bi-play-circle"></i>
                <span>Bu ders için video eklenmemiş</span>
            </div>
            <% } %>
        </div>

        <!-- Ders bilgi barı -->
        <div class="lesson-info-bar">
            <h1>
                <%: CurrentLesson != null ? CurrentLesson.Title : "Ders Seçin" %>
                <% if (CurrentLesson != null && CurrentLesson.IsPreview) { %>
                <span class="badge-free" style="font-size:11px;margin-left:8px;">Önizleme</span>
                <% } %>
            </h1>
            <div class="lesson-meta-row">
                <span><i class="bi bi-mortarboard"></i> <%: Course.Title %></span>
                <% if (CurrentLesson != null) { %>
                <span><i class="bi bi-clock"></i> <%: CurrentLesson.Duration %> dakika</span>
                <span><i class="bi bi-list-ol"></i> <%: CurrentLesson.OrderIndex %>. Ders</span>
                <% } %>

                <% if (IsLoggedIn && IsEnrolled && CurrentLesson != null) { %>
                    <% if (IsCompleted) { %>
                    <button class="complete-btn" disabled>
                        <i class="bi bi-check-circle-fill"></i> Tamamlandı
                    </button>
                    <% } else { %>
                    <a href="LessonWatch.aspx?courseId=<%: Course.CourseId %>&lessonId=<%: CurrentLesson.LessonId %>&complete=1"
                       class="complete-btn">
                        <i class="bi bi-check-circle"></i> Tamamlandı İşaretle
                    </a>
                    <% } %>
                <% } else if (!IsLoggedIn || !IsEnrolled) { %>
                <a href="CourseDetail.aspx?id=<%: Course.CourseId %>" class="btn btn-primary-custom btn-sm ms-auto" style="margin-left:auto;">
                    <i class="bi bi-bag-plus"></i> Kursa Kaydol
                </a>
                <% } %>
            </div>
        </div>

        <!-- Önceki / Sonraki navigasyon -->
        <% if (PrevLessonId > 0 || NextLessonId > 0) { %>
        <div class="nav-btns">
            <% if (PrevLessonId > 0) { %>
            <a href="LessonWatch.aspx?courseId=<%: Course.CourseId %>&lessonId=<%: PrevLessonId %>"
               class="btn btn-sm" style="border:1px solid var(--color-border);background:transparent;color:var(--color-text-secondary);font-size:13px;">
                <i class="bi bi-arrow-left"></i> Önceki Ders
            </a>
            <% } %>
            <% if (NextLessonId > 0) { %>
            <a href="LessonWatch.aspx?courseId=<%: Course.CourseId %>&lessonId=<%: NextLessonId %>"
               class="btn btn-sm btn-primary-custom" style="font-size:13px;">
                Sonraki Ders <i class="bi bi-arrow-right"></i>
            </a>
            <% } %>
        </div>
        <% } %>

        <!-- Kurs açıklaması -->
        <div style="padding:20px 24px;">
            <h2 style="font-size:1rem;margin-bottom:10px;"><i class="bi bi-info-circle" style="color:var(--color-primary)"></i> Kurs Hakkında</h2>
            <p style="font-size:14px;color:var(--color-text-secondary);line-height:1.7;"><%: Course.Description %></p>
            <div style="margin-top:12px;display:flex;gap:12px;flex-wrap:wrap;">
                <span style="font-size:13px;color:var(--color-text-muted);"><i class="bi bi-person"></i> <%: Course.InstructorName %></span>
                <span style="font-size:13px;color:var(--color-text-muted);"><i class="bi bi-collection-play"></i> <%: Course.LessonCount %> ders</span>
                <span style="font-size:13px;color:var(--color-text-muted);"><i class="bi bi-translate"></i> <%: Course.Language %></span>
                <span class="badge-level" style="font-size:11px;"><%: Course.Level %></span>
            </div>
        </div>
    </div>

    <!-- Ders Listesi Sidebar -->
    <div class="lesson-sidebar">
        <div class="sidebar-header">
            <h2><%: Course.Title %></h2>
            <div style="font-size:12px;color:rgba(255,255,255,0.6);margin-top:4px;">
                <%: CompletedCount %>/<%: Lessons.Count %> ders tamamlandı
            </div>
            <div class="sidebar-progress-bar">
                <span style="width:<%: ProgressPercent %>%"></span>
            </div>
        </div>

        <% foreach (var lesson in Lessons) { %>
        <a href="LessonWatch.aspx?courseId=<%: Course.CourseId %>&lessonId=<%: lesson.LessonId %>"
           class="lesson-item <%: lesson.LessonId == (CurrentLesson?.LessonId ?? 0) ? "active" : "" %> <%: CompletedLessonIds.Contains(lesson.LessonId) ? "completed" : "" %>">
            <div class="lesson-num">
                <% if (CompletedLessonIds.Contains(lesson.LessonId)) { %>
                <i class="bi bi-check-lg" style="font-size:11px;"></i>
                <% } else { %>
                <%: lesson.OrderIndex %>
                <% } %>
            </div>
            <div class="lesson-title-text">
                <%: lesson.Title %>
                <% if (lesson.IsPreview) { %>
                <span class="preview-tag">Önizleme</span>
                <% } %>
            </div>
            <span class="lesson-dur"><%: lesson.Duration %>dk</span>
        </a>
        <% } %>
    </div>

</div>

<% } %>

</asp:Content>
