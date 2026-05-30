<%@ Page Title="İletişim" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="EduFlow.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <span class="hero-kicker"><i class="bi bi-envelope-fill"></i> İletişim</span>
            <h1>Bizimle İletişime Geç</h1>
            <p>Sorularınız, önerileriniz veya destek talepleriniz için buradayız. Size en kısa sürede geri döneceğiz.</p>
        </div>
    </div>

    <div class="section">
        <div class="container">
            <div class="row g-5">

                <!-- Sol: İletişim Bilgileri + SSS -->
                <div class="col-lg-5">
                    <h2 style="margin-bottom:24px;">İletişim Bilgileri</h2>

                    <div class="plain-card" style="margin-bottom:16px;display:flex;align-items:flex-start;gap:16px;padding:20px 22px;">
                        <div style="width:44px;height:44px;border-radius:10px;background:var(--color-primary-light);color:var(--color-primary);display:flex;align-items:center;justify-content:center;font-size:20px;flex-shrink:0;">
                            <i class="bi bi-envelope"></i>
                        </div>
                        <div>
                            <div style="font-weight:500;margin-bottom:3px;">E-posta</div>
                            <div style="color:var(--color-text-muted);font-size:14px;">destek@eduflow.test</div>
                            <div style="color:var(--color-text-muted);font-size:14px;">bilgi@eduflow.test</div>
                        </div>
                    </div>

                    <div class="plain-card" style="margin-bottom:16px;display:flex;align-items:flex-start;gap:16px;padding:20px 22px;">
                        <div style="width:44px;height:44px;border-radius:10px;background:var(--color-primary-light);color:var(--color-primary);display:flex;align-items:center;justify-content:center;font-size:20px;flex-shrink:0;">
                            <i class="bi bi-telephone"></i>
                        </div>
                        <div>
                            <div style="font-weight:500;margin-bottom:3px;">Telefon</div>
                            <div style="color:var(--color-text-muted);font-size:14px;">+90 212 000 00 00</div>
                            <div style="color:var(--color-text-muted);font-size:14px;">Hft. içi 09:00 – 18:00</div>
                        </div>
                    </div>

                    <div class="plain-card" style="margin-bottom:32px;display:flex;align-items:flex-start;gap:16px;padding:20px 22px;">
                        <div style="width:44px;height:44px;border-radius:10px;background:var(--color-primary-light);color:var(--color-primary);display:flex;align-items:center;justify-content:center;font-size:20px;flex-shrink:0;">
                            <i class="bi bi-geo-alt"></i>
                        </div>
                        <div>
                            <div style="font-weight:500;margin-bottom:3px;">Adres</div>
                            <div style="color:var(--color-text-muted);font-size:14px;">Levent, Beşiktaş</div>
                            <div style="color:var(--color-text-muted);font-size:14px;">İstanbul, Türkiye</div>
                        </div>
                    </div>

                    <!-- SSS -->
                    <h3 style="margin-bottom:16px;">Sık Sorulan Sorular</h3>

                    <div class="plain-card" style="margin-bottom:10px;padding:16px 18px;">
                        <div style="font-weight:500;font-size:14px;color:var(--color-primary);margin-bottom:6px;">
                            <i class="bi bi-question-circle" style="margin-right:6px;"></i>Satın aldığım kursa ne kadar süre erişebilirim?
                        </div>
                        <div style="font-size:13px;color:var(--color-text-secondary);">Satın aldığınız kurslara ömür boyu erişim hakkınız bulunmaktadır.</div>
                    </div>

                    <div class="plain-card" style="margin-bottom:10px;padding:16px 18px;">
                        <div style="font-weight:500;font-size:14px;color:var(--color-primary);margin-bottom:6px;">
                            <i class="bi bi-question-circle" style="margin-right:6px;"></i>Eğitmen olarak nasıl başvurabilirim?
                        </div>
                        <div style="font-size:13px;color:var(--color-text-secondary);">Kayıt sayfasından "Eğitmen olarak kaydol" seçeneğini seçerek başvurabilirsiniz.</div>
                    </div>

                    <div class="plain-card" style="padding:16px 18px;">
                        <div style="font-weight:500;font-size:14px;color:var(--color-primary);margin-bottom:6px;">
                            <i class="bi bi-question-circle" style="margin-right:6px;"></i>İade politikanız nedir?
                        </div>
                        <div style="font-size:13px;color:var(--color-text-secondary);">Satın alma tarihinden itibaren 14 gün içinde iade talebinde bulunabilirsiniz.</div>
                    </div>
                </div>

                <!-- Sağ: İletişim Formu -->
                <div class="col-lg-7">
                    <h2 style="margin-bottom:24px;">Mesaj Gönder</h2>
                    <div class="plain-card" style="padding:32px;">
                        <div id="contactSuccess" style="display:none;" class="alert alert-success" style="margin-bottom:20px;">
                            <i class="bi bi-check-circle" style="margin-right:8px;"></i>
                            Mesajınız başarıyla gönderildi! En kısa sürede size geri döneceğiz.
                        </div>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label" for="contactName">Ad Soyad</label>
                                <input type="text" id="contactName" class="form-control" placeholder="Adınız Soyadınız" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" for="contactEmail">E-posta Adresi</label>
                                <input type="email" id="contactEmail" class="form-control" placeholder="ornek@mail.com" />
                            </div>
                            <div class="col-12">
                                <label class="form-label" for="contactSubject">Konu</label>
                                <select id="contactSubject" class="form-select">
                                    <option value="">Konu seçin...</option>
                                    <option>Teknik Destek</option>
                                    <option>Ödeme ve Fatura</option>
                                    <option>Eğitmen Başvurusu</option>
                                    <option>Kurs İçeriği Hakkında</option>
                                    <option>Diğer</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="form-label" for="contactMessage">Mesajınız</label>
                                <textarea id="contactMessage" class="form-control" rows="6" placeholder="Mesajınızı buraya yazın..." style="resize:vertical;"></textarea>
                            </div>
                            <div class="col-12" style="margin-top:8px;">
                                <button type="button" id="btnSendContact" class="btn-primary-custom" style="width:100%;justify-content:center;padding:12px;">
                                    <i class="bi bi-send"></i> Mesaj Gönder
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Sosyal Medya -->
                    <div style="margin-top:24px;display:flex;align-items:center;gap:14px;flex-wrap:wrap;">
                        <span style="font-size:14px;color:var(--color-text-muted);">Bizi takip edin:</span>
                        <a href="#" style="display:inline-flex;align-items:center;gap:6px;font-size:14px;color:var(--color-text-secondary);padding:7px 14px;border:1px solid var(--color-border);border-radius:6px;">
                            <i class="bi bi-twitter-x"></i> Twitter
                        </a>
                        <a href="#" style="display:inline-flex;align-items:center;gap:6px;font-size:14px;color:var(--color-text-secondary);padding:7px 14px;border:1px solid var(--color-border);border-radius:6px;">
                            <i class="bi bi-linkedin"></i> LinkedIn
                        </a>
                        <a href="#" style="display:inline-flex;align-items:center;gap:6px;font-size:14px;color:var(--color-text-secondary);padding:7px 14px;border:1px solid var(--color-border);border-radius:6px;">
                            <i class="bi bi-instagram"></i> Instagram
                        </a>
                        <a href="#" style="display:inline-flex;align-items:center;gap:6px;font-size:14px;color:var(--color-text-secondary);padding:7px 14px;border:1px solid var(--color-border);border-radius:6px;">
                            <i class="bi bi-youtube"></i> YouTube
                        </a>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script>
        document.getElementById('btnSendContact').addEventListener('click', function () {
            var name    = document.getElementById('contactName').value.trim();
            var email   = document.getElementById('contactEmail').value.trim();
            var subject = document.getElementById('contactSubject').value;
            var message = document.getElementById('contactMessage').value.trim();

            if (!name || !email || !subject || !message) {
                alert('Lütfen tüm alanları doldurun.');
                return;
            }

            // Formu temizle ve başarı mesajı göster
            document.getElementById('contactName').value    = '';
            document.getElementById('contactEmail').value   = '';
            document.getElementById('contactSubject').value = '';
            document.getElementById('contactMessage').value = '';

            var successEl = document.getElementById('contactSuccess');
            successEl.style.display = 'block';
            setTimeout(function () { successEl.style.display = 'none'; }, 5000);
        });
    </script>

</asp:Content>
