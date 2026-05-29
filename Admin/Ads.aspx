<%@ Page Title="Reklamlar" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeBehind="Ads.aspx.cs" Inherits="EduFlow.Admin.Ads" %>

<asp:Content ID="Content1" ContentPlaceHolderID="AdminContent" runat="server">

    <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:24px;">
        <div>
            <h1 style="font-size:1.4rem;margin-bottom:4px;"><i class="bi bi-megaphone" style="color:var(--color-primary)"></i> Reklam Yönetimi</h1>
            <p style="font-size:14px;color:var(--color-text-muted);margin:0;">Site genelindeki reklam alanlarını yönetin</p>
        </div>
        <button type="button" class="btn btn-primary-custom btn-sm"
                onclick="document.getElementById('addAdPanel').style.display = document.getElementById('addAdPanel').style.display === 'none' ? 'block' : 'none';">
            <i class="bi bi-plus-circle"></i> Yeni Reklam Ekle
        </button>
    </div>

    <% if (!string.IsNullOrEmpty(Message)) { %>
    <div class="alert alert-<%: MessageType %> mb-4"><i class="bi bi-info-circle"></i> <%: Message %></div>
    <% } %>

    <!-- Yeni Reklam Formu -->
    <div id="addAdPanel" style="display:none;margin-bottom:24px;">
        <div class="plain-card" style="padding:24px;">
            <h2 style="font-size:1rem;margin-bottom:20px;"><i class="bi bi-plus" style="color:var(--color-primary)"></i> Yeni Reklam</h2>
            <input type="hidden" name="adAction" id="adActionField" value="" />
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Başlık <span style="color:var(--color-danger)">*</span></label>
                    <input class="form-control" type="text" name="adTitle" placeholder="Reklam başlığı" required />
                </div>
                <div class="col-md-6">
                    <label class="form-label">Pozisyon <span style="color:var(--color-danger)">*</span></label>
                    <select class="form-control" name="adPosition" style="appearance:auto;">
                        <option value="Header">Header (Üst Banner — 728x90)</option>
                        <option value="Sidebar" selected>Sidebar (Yan Panel — 300x250)</option>
                        <option value="Footer">Footer (Alt Banner — 728x90)</option>
                    </select>
                </div>
                <div class="col-12">
                    <label class="form-label">Görsel URL</label>
                    <input class="form-control" type="url" name="adImageUrl" placeholder="https://example.com/banner.jpg" />
                </div>
                <div class="col-12">
                    <label class="form-label">Yönlendirme URL</label>
                    <input class="form-control" type="text" name="adRedirectUrl" placeholder="Courses.aspx?category=1 veya https://..." />
                </div>
                <div class="col-md-6">
                    <label class="form-label">Başlangıç Tarihi <small class="text-muted">(opsiyonel)</small></label>
                    <input class="form-control" type="date" name="adStartDate" />
                </div>
                <div class="col-md-6">
                    <label class="form-label">Bitiş Tarihi <small class="text-muted">(opsiyonel)</small></label>
                    <input class="form-control" type="date" name="adEndDate" />
                </div>
            </div>
            <div class="mt-3 d-flex gap-2">
                <button type="submit" class="btn btn-primary-custom btn-sm"
                        onclick="document.getElementById('adActionField').value='insertAd';">
                    <i class="bi bi-check2"></i> Reklamı Ekle
                </button>
                <button type="button" class="btn btn-sm" style="border:1px solid var(--color-border);background:transparent;"
                        onclick="document.getElementById('addAdPanel').style.display='none';">
                    İptal
                </button>
            </div>
        </div>
    </div>

    <!-- Reklam Listesi -->
    <div class="plain-card" style="padding:0;overflow:hidden;">
        <div style="padding:16px 20px;border-bottom:1px solid var(--color-border);display:flex;align-items:center;justify-content:space-between;">
            <h2 style="font-size:1rem;margin:0;">Mevcut Reklamlar</h2>
            <span style="font-size:13px;color:var(--color-text-muted);"><%: AdList.Count %> reklam</span>
        </div>

        <% if (AdList.Count == 0) { %>
        <div class="p-5 text-center">
            <i class="bi bi-megaphone" style="font-size:3rem;color:var(--color-text-muted)"></i>
            <h3 class="mt-3" style="color:var(--color-text-secondary);font-size:1rem;">Henüz reklam yok</h3>
            <p class="text-muted" style="font-size:14px;">"Yeni Reklam Ekle" butonuna tıklayarak ilk reklamı oluşturun.</p>
        </div>
        <% } else { %>

        <!-- Tablo başlığı -->
        <div style="display:grid;grid-template-columns:1fr 100px 120px 80px 80px;gap:0;padding:10px 20px;background:var(--color-surface);font-size:12px;font-weight:500;color:var(--color-text-muted);border-bottom:1px solid var(--color-border);">
            <span>REKLAM</span>
            <span>POZİSYON</span>
            <span>TARİH</span>
            <span style="text-align:center;">TIK</span>
            <span style="text-align:right;">İŞLEMLER</span>
        </div>

        <% foreach (var ad in AdList) { %>
        <div style="display:grid;grid-template-columns:1fr 100px 120px 80px 80px;gap:0;padding:14px 20px;border-bottom:1px solid var(--color-border);align-items:center;">
            <!-- Reklam Bilgisi -->
            <div style="display:flex;align-items:center;gap:12px;min-width:0;">
                <% if (!string.IsNullOrEmpty(ad.ImageUrl)) { %>
                <img src="<%: ad.ImageUrl %>" alt="<%: ad.Title %>"
                     style="width:60px;height:40px;object-fit:cover;border-radius:6px;flex-shrink:0;"
                     onerror="this.style.display='none'" />
                <% } else { %>
                <div style="width:60px;height:40px;background:var(--color-surface);border-radius:6px;display:flex;align-items:center;justify-content:center;flex-shrink:0;">
                    <i class="bi bi-image" style="color:var(--color-text-muted)"></i>
                </div>
                <% } %>
                <div style="min-width:0;">
                    <div style="font-size:14px;font-weight:500;color:var(--color-text-primary);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;"><%: ad.Title %></div>
                    <% if (!string.IsNullOrEmpty(ad.RedirectUrl)) { %>
                    <div style="font-size:11px;color:var(--color-text-muted);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">→ <%: ad.RedirectUrl %></div>
                    <% } %>
                    <span style="font-size:11px;padding:2px 8px;border-radius:999px;<%: ad.IsActive ? "background:var(--color-success-bg);color:var(--color-success);" : "background:var(--color-danger-bg);color:var(--color-danger);" %>">
                        <%: ad.IsActive ? "Aktif" : "Pasif" %>
                    </span>
                </div>
            </div>
            <!-- Pozisyon -->
            <div>
                <span class="badge-level" style="font-size:11px;"><%: ad.Position %></span>
            </div>
            <!-- Tarih -->
            <div style="font-size:12px;color:var(--color-text-muted);">
                <% if (ad.StartDate.HasValue || ad.EndDate.HasValue) { %>
                <span><%: ad.StartDate?.ToString("dd.MM.yy") ?? "—" %></span><br />
                <span><%: ad.EndDate?.ToString("dd.MM.yy") ?? "—" %></span>
                <% } else { %>
                <span>Süresiz</span>
                <% } %>
            </div>
            <!-- Tık sayısı -->
            <div style="text-align:center;font-size:14px;font-weight:500;color:var(--color-primary);">
                <%: ad.ClickCount.ToString("N0") %>
            </div>
            <!-- İşlemler -->
            <div style="text-align:right;display:flex;gap:6px;justify-content:flex-end;">
                <% if (ad.IsActive) { %>
                <a href="?toggleAd=<%: ad.AdId %>&active=0"
                   class="btn btn-sm"
                   style="background:var(--color-warning-bg);color:var(--color-warning);border:0;font-size:12px;padding:4px 8px;"
                   title="Pasife Al">
                    <i class="bi bi-pause-circle"></i>
                </a>
                <% } else { %>
                <a href="?toggleAd=<%: ad.AdId %>&active=1"
                   class="btn btn-sm"
                   style="background:var(--color-success-bg);color:var(--color-success);border:0;font-size:12px;padding:4px 8px;"
                   title="Aktife Al">
                    <i class="bi bi-play-circle"></i>
                </a>
                <% } %>
                <a href="?deleteAd=<%: ad.AdId %>"
                   class="btn btn-sm"
                   style="background:var(--color-danger-bg);color:var(--color-danger);border:0;font-size:12px;padding:4px 8px;"
                   title="Sil"
                   onclick="return confirm('Bu reklamı silmek istediğinizden emin misiniz?');">
                    <i class="bi bi-trash"></i>
                </a>
            </div>
        </div>
        <% } %>

        <% } %>
    </div>

    <!-- Pozisyon Kılavuzu -->
    <div class="row g-3 mt-4">
        <div class="col-md-4">
            <div class="plain-card" style="padding:16px;">
                <h3 style="font-size:14px;margin-bottom:8px;"><i class="bi bi-layout-text-window-reverse" style="color:var(--color-primary)"></i> Header</h3>
                <p style="font-size:12px;color:var(--color-text-muted);margin:0;">728×90 px banner. Ana sayfanın üst kısmında gösterilir.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="plain-card" style="padding:16px;">
                <h3 style="font-size:14px;margin-bottom:8px;"><i class="bi bi-layout-sidebar-reverse" style="color:var(--color-primary)"></i> Sidebar</h3>
                <p style="font-size:12px;color:var(--color-text-muted);margin:0;">300×250 px kutu. Kurs listesi sayfasının sağ sütununda gösterilir.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="plain-card" style="padding:16px;">
                <h3 style="font-size:14px;margin-bottom:8px;"><i class="bi bi-layout-text-window" style="color:var(--color-primary)"></i> Footer</h3>
                <p style="font-size:12px;color:var(--color-text-muted);margin:0;">728×90 px banner. Tüm sayfalarda footer'ın üstünde gösterilir.</p>
            </div>
        </div>
    </div>

</asp:Content>
