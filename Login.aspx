<%@ Page Title="Giriş Yap" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="EduFlow.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .modal-custom-backdrop {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(28, 43, 58, 0.6);
            backdrop-filter: blur(4px);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1050;
            animation: fadeIn 0.2s ease-out;
        }
        .modal-custom-card {
            background: var(--color-bg);
            border: 1px solid var(--color-border);
            border-radius: var(--radius-lg);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            max-width: 420px;
            width: 90%;
            padding: 24px;
            animation: scaleIn 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        .modal-custom-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--color-border);
            padding-bottom: 12px;
            margin-bottom: 16px;
        }
        .modal-custom-title {
            margin: 0;
            font-size: 1.15rem;
            font-weight: 500;
            color: var(--color-primary);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .modal-custom-close {
            background: none;
            border: 0;
            font-size: 1.5rem;
            color: var(--color-text-muted);
            cursor: pointer;
            line-height: 1;
            transition: color var(--transition);
        }
        .modal-custom-close:hover {
            color: var(--color-danger);
        }
        .modal-custom-body {
            text-align: left;
        }
        .modal-custom-footer {
            display: flex;
            justify-content: flex-end;
            gap: 8px;
            border-top: 1px solid var(--color-border);
            padding-top: 16px;
            margin-top: 16px;
        }
        .demo-badge {
            cursor: pointer;
            transition: all var(--transition);
            border: 1px solid var(--color-border);
            background-color: var(--color-surface);
            user-select: none;
        }
        .demo-badge:hover {
            background-color: var(--color-primary) !important;
            color: var(--color-on-primary) !important;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(30, 58, 95, 0.15);
            border-color: var(--color-primary);
        }
        .demo-badge:hover i {
            color: var(--color-accent) !important;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        @keyframes scaleIn {
            from { transform: scale(0.95); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }
    </style>

    <section class="auth-wrap">
        <div class="auth-card">
            <div class="auth-logo">
                <i class="bi bi-mortarboard-fill"></i>
                <strong>EduFlow</strong>
            </div>
            <h1 style="font-size:1.5rem;text-align:center;margin-bottom:6px;">Hesabına giriş yap</h1>
            <p class="text-muted text-center mb-4" style="font-size:14px;">Kurslarına devam etmek için giriş yap</p>

            <% if (!string.IsNullOrEmpty(Message)) { %>
            <div class="alert alert-danger mb-3"><i class="bi bi-exclamation-circle"></i> <%: Message %></div>
            <% } %>

            <div class="alert alert-info mb-4" style="font-size:13px; border-left: 4px solid var(--color-primary);">
                <div class="mb-2" style="font-weight: 500;">
                    <i class="bi bi-info-circle-fill"></i> <strong>Hızlı Giriş (Demo Hesapları):</strong>
                </div>
                <div class="d-flex flex-wrap gap-2 mt-1">
                    <span class="badge demo-badge p-2 rounded text-dark" onclick="fillCredentials('ogrenci@eduflow.test', '123456')" title="Öğrenci girişi için tıklayın">
                        <i class="bi bi-person-fill text-primary"></i> Öğrenci
                    </span>
                    <span class="badge demo-badge p-2 rounded text-dark" onclick="fillCredentials('egitmen@eduflow.test', '123456')" title="Eğitmen girişi için tıklayın">
                        <i class="bi bi-person-video3 text-success"></i> Eğitmen
                    </span>
                    <span class="badge demo-badge p-2 rounded text-dark" onclick="fillCredentials('admin@eduflow.test', 'admin123')" title="Admin girişi için tıklayın">
                        <i class="bi bi-shield-lock-fill text-danger"></i> Yönetici
                    </span>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label" for="email">E-posta adresi</label>
                <input class="form-control" id="email" name="email" type="email" placeholder="ornek@mail.com" required autocomplete="email" style="width: 100%;" />
            </div>
            <div class="mb-3">
                <label class="form-label" for="password">
                    Şifre
                    <a href="javascript:void(0);" onclick="openForgotPasswordModal()" style="float:right;font-size:13px;color:var(--color-primary);font-weight:500;">Şifremi unuttum</a>
                </label>
                <input class="form-control" id="password" name="password" type="password" placeholder="••••••••" required autocomplete="current-password" style="width: 100%;" />
            </div>
            <button class="btn btn-primary-custom w-100 mb-3" type="submit" style="padding:12px; display: block; width: 100%;">
                <i class="bi bi-box-arrow-in-right"></i> Giriş Yap
            </button>

            <div style="text-align:center;position:relative;margin:16px 0;">
                <hr style="border-color:var(--color-border);" />
                <span style="position:absolute;top:-10px;left:50%;transform:translateX(-50%);background:var(--color-bg);padding:0 12px;color:var(--color-text-muted);font-size:13px;">veya</span>
            </div>

            <p class="text-center mb-0" style="font-size:14px;">
                Hesabın yok mu? <a href="Register.aspx"><strong>Ücretsiz kayıt ol</strong></a>
            </p>
        </div>
    </section>

    <!-- Şifremi Unuttum Modal -->
    <div id="forgotPasswordModal" class="modal-custom-backdrop" style="display:none;">
        <div class="modal-custom-card">
            <div class="modal-custom-header">
                <h5 class="modal-custom-title"><i class="bi bi-key-fill"></i> Şifremi Unuttum</h5>
                <button type="button" class="modal-custom-close" onclick="closeForgotPasswordModal()">&times;</button>
            </div>
            <div class="modal-custom-body">
                <p class="text-muted mb-3" style="font-size:14px; line-height: 1.5;">E-posta adresinizi girin. Size şifre sıfırlama bağlantısı göndereceğiz (Demo ortamı).</p>
                <div class="mb-3">
                    <label class="form-label" for="forgotEmail">E-posta adresi</label>
                    <input class="form-control" id="forgotEmail" type="email" placeholder="ornek@mail.com" style="width:100%;" />
                </div>
                <div id="forgotPasswordMessage" class="alert alert-success" style="display:none; font-size:13px; padding:10px;"></div>
                <div id="forgotPasswordError" class="alert alert-danger" style="display:none; font-size:13px; padding:10px;"></div>
            </div>
            <div class="modal-custom-footer">
                <button type="button" class="btn btn-outline-custom btn-sm" onclick="closeForgotPasswordModal()">Kapat</button>
                <button type="button" class="btn btn-primary-custom btn-sm" onclick="sendForgotPasswordLink()">Bağlantı Gönder</button>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function fillCredentials(email, password) {
            document.getElementById('email').value = email;
            document.getElementById('password').value = password;
        }

        function openForgotPasswordModal() {
            document.getElementById('forgotPasswordModal').style.display = 'flex';
            document.getElementById('forgotPasswordMessage').style.display = 'none';
            document.getElementById('forgotPasswordError').style.display = 'none';
            document.getElementById('forgotEmail').value = document.getElementById('email').value; // prefill from login if any
        }

        function closeForgotPasswordModal() {
            document.getElementById('forgotPasswordModal').style.display = 'none';
        }

        function sendForgotPasswordLink() {
            const emailInput = document.getElementById('forgotEmail');
            const msgDiv = document.getElementById('forgotPasswordMessage');
            const errDiv = document.getElementById('forgotPasswordError');
            
            msgDiv.style.display = 'none';
            errDiv.style.display = 'none';
            
            const email = emailInput.value.trim();
            if (!email || !email.includes('@')) {
                errDiv.innerText = 'Lütfen geçerli bir e-posta adresi girin.';
                errDiv.style.display = 'block';
                return;
            }
            
            // Simulate sending recovery link
            msgDiv.innerHTML = '<i class="bi bi-check-circle-fill"></i> Şifre sıfırlama bağlantısı başarıyla <strong>' + email + '</strong> adresine gönderildi! (Demo)';
            msgDiv.style.display = 'block';
            
            setTimeout(() => {
                closeForgotPasswordModal();
            }, 2500);
        }
    </script>
</asp:Content>
