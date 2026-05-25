<%@ Page Title="Demo Ödeme Simülasyonu" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="EduFlow.Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .iyzico-container {
            background-color: #f4f6fa;
            min-height: 80vh;
            padding: 40px 0;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .iyzico-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            box-shadow: 0 15px 35px rgba(28, 43, 58, 0.08);
            border: 1px solid var(--color-border);
            max-width: 800px;
            width: 100%;
            overflow: hidden;
            display: flex;
            flex-direction: row;
        }
        .iyzico-left {
            flex: 1.2;
            padding: 36px;
            border-right: 1px solid #f0f2f5;
        }
        .iyzico-right {
            flex: 0.8;
            padding: 36px;
            background-color: #fafbfc;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .iyzico-logo-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }
        .iyzico-logo {
            font-size: 24px;
            font-weight: 800;
            color: #0b1a30;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 2px;
        }
        .iyzico-logo span {
            color: #1783FA;
        }
        .iyzico-badge {
            background-color: #e3f2fd;
            color: #0d47a1;
            font-size: 11px;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: var(--radius-pill);
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .iyzico-form-title {
            font-size: 16px;
            font-weight: 600;
            color: #1c2b3a;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .iyzico-form-title i {
            color: #1783FA;
        }
        .iyzico-btn {
            background-color: #1783FA;
            color: #ffffff;
            font-weight: 600;
            padding: 14px;
            border-radius: var(--radius-sm);
            border: 0;
            cursor: pointer;
            transition: background var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: 100%;
            margin-top: 16px;
            box-shadow: 0 4px 12px rgba(23, 131, 250, 0.2);
        }
        .iyzico-btn:hover {
            background-color: #126ecf;
            color: #ffffff;
        }
        .card-preview {
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            border-radius: var(--radius-md);
            padding: 20px;
            color: #ffffff;
            height: 170px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
            margin-bottom: 24px;
            position: relative;
            overflow: hidden;
        }
        .card-preview::before {
            content: '';
            position: absolute;
            top: -20px;
            right: -20px;
            width: 120px;
            height: 120px;
            background: rgba(255,255,255,0.03);
            border-radius: 50%;
        }
        .card-preview-chip {
            width: 36px;
            height: 26px;
            background: #e5c158;
            border-radius: 4px;
            box-shadow: inset 0 1px 3px rgba(0,0,0,0.2);
        }
        .card-preview-number {
            font-family: 'Courier New', Courier, monospace;
            font-size: 18px;
            letter-spacing: 2px;
            margin: 16px 0;
        }
        .card-preview-holder {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1px;
            opacity: 0.8;
        }
        .card-preview-expiry {
            font-size: 11px;
            opacity: 0.8;
            text-align: right;
        }
        
        /* 3D Secure Simulator Styles */
        .secure-modal-backdrop {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(11, 26, 48, 0.7);
            backdrop-filter: blur(4px);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 2000;
        }
        .secure-modal-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            width: 90%;
            max-width: 440px;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0,0,0,0.25);
            border: 1px solid var(--color-border);
            animation: scaleIn 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        .secure-modal-header {
            background-color: #0b1a30;
            color: #ffffff;
            padding: 16px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .secure-bank-logo {
            font-weight: 700;
            font-size: 15px;
            letter-spacing: 0.5px;
            color: #ffffff;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .secure-bank-logo i {
            color: #e5c158;
        }
        .secure-modal-body {
            padding: 24px;
        }
        .secure-code-input {
            border: 1.5px solid #1783FA;
            border-radius: var(--radius-sm);
            color: #0b1a30;
            font-size: 22px;
            font-weight: 800;
            letter-spacing: 10px;
            line-height: 1;
            padding: 12px 6px 12px 16px;
            text-align: center;
            width: 100%;
        }
        .secure-code-input::placeholder {
            color: #9fb3c8;
            letter-spacing: 10px;
        }
        .secure-code-hint {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 6px;
            margin: 8px auto 0;
            max-width: 220px;
        }
        .secure-code-hint span {
            border-bottom: 2px solid #d8e4f0;
            height: 6px;
        }
        
        @media (max-width: 768px) {
            .iyzico-card {
                flex-direction: column;
            }
            .iyzico-left {
                border-right: 0;
                border-bottom: 1px solid #f0f2f5;
                padding: 24px;
            }
            .iyzico-right {
                padding: 24px;
            }
        }
    </style>

    <div class="iyzico-container">
        <div class="container d-flex justify-content-center">
            <div class="iyzico-card">
                
                <!-- LEFT COLUMN: Payment Info & Card Fields -->
                <div class="iyzico-left">
                    <div class="iyzico-logo-bar">
                        <div class="iyzico-logo">
                            iyzi<span>co</span>
                        </div>
                        <div class="iyzico-badge">
                            <i class="bi bi-shield-fill-check"></i> Demo ödeme simülasyonu
                        </div>
                    </div>

                    <div class="iyzico-form-title">
                        <i class="bi bi-credit-card-2-front-fill"></i> Kart ile demo ödeme
                    </div>

                    <!-- Interactive Card Preview -->
                    <div class="card-preview">
                        <div class="d-flex justify-content-between align-items-start">
                            <div class="card-preview-chip"></div>
                            <div style="font-weight: 800; font-style: italic; font-size: 14px; opacity:0.8;">Secure Pay</div>
                        </div>
                        <div class="card-preview-number" id="previewNumber">•••• •••• •••• ••••</div>
                        <div class="d-flex justify-content-between align-items-end">
                            <div>
                                <div style="font-size: 8px; opacity: 0.6; margin-bottom: 2px;">KART SAHİBİ</div>
                                <div class="card-preview-holder" id="previewHolder">AD SOYAD</div>
                            </div>
                            <div>
                                <div style="font-size: 8px; opacity: 0.6; margin-bottom: 2px; text-align: right;">SON KUL.</div>
                                <div class="card-preview-expiry" id="previewExpiry">AA/YY</div>
                            </div>
                        </div>
                    </div>

                    <!-- Card Form Fields -->
                    <div class="mb-3">
                        <label class="form-label" for="cardHolder" style="font-size:12.5px;">Kart Sahibi Adı Soyadı</label>
                        <input class="form-control" id="cardHolder" type="text" placeholder="Kartın üzerindeki isim" onkeyup="updateCardPreview()" autocomplete="off" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label" for="cardNumber" style="font-size:12.5px;">Kart Numarası</label>
                        <div class="position-relative">
                            <input class="form-control" id="cardNumber" type="text" maxlength="19" placeholder="0000 0000 0000 0000" onkeyup="formatCardNumber(); updateCardPreview();" autocomplete="off" />
                            <i class="bi bi-credit-card position-absolute" style="right:12px; top:12px; color:var(--color-text-muted);" id="cardIcon"></i>
                        </div>
                    </div>

                    <div class="row g-3">
                        <div class="col-8">
                            <label class="form-label" style="font-size:12.5px;">Son Kullanma Tarihi</label>
                            <div class="d-flex gap-2">
                                <select class="form-select" id="cardMonth" onchange="updateCardPreview()">
                                    <option value="">Ay</option>
                                    <% for (int i = 1; i <= 12; i++) { %>
                                        <option value="<%= i.ToString("D2") %>"><%= i.ToString("D2") %></option>
                                    <% } %>
                                </select>
                                <select class="form-select" id="cardYear" onchange="updateCardPreview()">
                                    <option value="">Yıl</option>
                                    <% for (int i = 2026; i <= 2035; i++) { %>
                                        <option value="<%= i.ToString().Substring(2) %>"><%= i %></option>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                        <div class="col-4">
                            <label class="form-label" for="cardCvv" style="font-size:12.5px;">CVC / CVV</label>
                            <input class="form-control" id="cardCvv" type="password" maxlength="3" placeholder="•••" autocomplete="off" />
                        </div>
                    </div>

                    <div id="paymentErrorMessage" class="alert alert-danger mt-3" style="display:none; font-size:13px; padding:10px;"></div>

                    <!-- Hidden Button to trigger actual ASP.NET code-behind checkout after 3D validation -->
                    <asp:Button ID="btnRealCheckout" runat="server" OnClick="btnRealCheckout_Click" style="display:none;" />

                    <!-- Trigger payment simulator -->
                    <button class="iyzico-btn" type="button" onclick="start3DSecure()">
                        <i class="bi bi-shield-lock-fill"></i> Demo Ödemeyi Tamamla
                    </button>
                </div>

                <!-- RIGHT COLUMN: Order Summary -->
                <div class="iyzico-right">
                    <div>
                        <h4 style="font-size: 14px; font-weight: 700; color: #1c2b3a; border-bottom: 1px solid #f0f2f5; padding-bottom: 12px; margin-bottom: 16px;">
                            Sipariş Özeti
                        </h4>
                        
                        <div style="max-height: 240px; overflow-y: auto; padding-right: 4px;">
                            <%= OrderItemsHtml %>
                        </div>
                    </div>

                    <div style="border-top: 1px solid #f0f2f5; padding-top: 16px; margin-top: 16px;">
                        <div class="d-flex justify-content-between mb-2" style="font-size: 13px; color: var(--color-text-secondary);">
                            <span>Ara Toplam</span>
                            <span><%= SubTotalText %></span>
                        </div>
                        <div class="d-flex justify-content-between mb-3" style="font-size: 13px; color: var(--color-text-secondary);">
                            <span>KDV (%0)</span>
                            <span>₺0</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span style="font-weight: 700; color: #0b1a30; font-size:14px;">Ödenecek Tutar</span>
                            <span style="font-size: 20px; font-weight: 800; color: #1783FA;"><%= TotalText %></span>
                        </div>
                        
                        <div class="text-center" style="font-size: 11px; color: var(--color-text-muted);">
                            Bu ekran demo amaçlıdır; gerçek iyzico tahsilatı yapılmaz.
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- 3D SECURE SIMULATOR MODALS -->
    
    <!-- 1. Loading Overlay -->
    <div id="loadingOverlay" class="secure-modal-backdrop" style="display:none;">
        <div class="secure-modal-card text-center p-5" style="max-width:320px;">
            <div class="spinner-border text-primary mb-3" role="status" style="width: 3rem; height: 3rem;">
                <span class="visually-hidden">Yükleniyor...</span>
            </div>
            <h5 style="font-size:15px; font-weight:600; color:#0b1a30; margin-bottom:6px;">Demo Güvenli Bağlantı</h5>
            <p class="text-muted mb-0" style="font-size:13px;">3D Secure simülasyonu hazırlanıyor. Lütfen pencereyi kapatmayın...</p>
        </div>
    </div>

    <!-- 2. 3D Secure SMS Verification Modal -->
    <div id="smsOverlay" class="secure-modal-backdrop" style="display:none;">
        <div class="secure-modal-card">
            <div class="secure-modal-header">
                <div class="secure-bank-logo">
                    <i class="bi bi-shield-shaded"></i> Simüle Bankası 3D Secure
                </div>
                <div style="font-size: 11px; font-weight:600; opacity:0.8; background:rgba(255,255,255,0.15); padding:2px 8px; border-radius:4px;">
                    Güvenli İşlem
                </div>
            </div>
            <div class="secure-modal-body">
                <div class="text-center mb-3">
                    <div style="font-size: 40px; color: #1783FA; line-height: 1;"><i class="bi bi-chat-left-text-fill"></i></div>
                    <h5 style="font-size: 15px; font-weight:700; margin-top:10px; color:#0b1a30;">Doğrulama Kodu Gönderildi</h5>
                    <p class="text-muted" style="font-size:12.5px; line-height: 1.5; margin-bottom: 0;">
                        Lütfen sistemde kayıtlı cep telefonunuza gönderilen 6 haneli 3D Secure şifresini giriniz.
                    </p>
                </div>

                <div class="alert alert-info text-center py-2 mb-3" style="font-size: 13px; border-radius: var(--radius-sm); border:1px dashed #90caf9;">
                    <i class="bi bi-key-fill text-primary"></i> Demo Onay Kodu: <strong>123456</strong>
                </div>

                <div class="mb-3">
                    <label class="form-label text-center d-block" for="smsCode" style="font-size:12px; font-weight:600; color:#5a6a7a;">Tek Kullanımlık Şifre (SMS Kodu)</label>
                    <input class="form-control secure-code-input" id="smsCode" type="text" inputmode="numeric" pattern="[0-9]*" maxlength="6" placeholder="000000" autocomplete="one-time-code" oninput="formatSmsCode()" />
                    <div class="secure-code-hint" aria-hidden="true">
                        <span></span><span></span><span></span><span></span><span></span><span></span>
                    </div>
                </div>

                <div id="smsErrorMessage" class="alert alert-danger text-center" style="display:none; font-size:12.5px; padding:8px;"></div>

                <div class="d-flex justify-content-between align-items-center" style="font-size:12px; color:var(--color-text-muted);">
                    <span>Kalan Süre: <strong id="secureTimer" style="color:var(--color-danger);">02:00</strong></span>
                    <a href="javascript:void(0);" onclick="alert('Yeni SMS kodu demo ortamı için yeniden gönderildi.'); resetTimer();" style="color:#1783FA; text-decoration:none; font-weight:500;">Yeniden SMS Gönder</a>
                </div>

                <button class="btn w-100 mt-4" type="button" style="background-color:#0b1a30; color:#ffffff; font-weight:600; padding:12px;" onclick="verifySmsCode()">
                    İşlemi Onayla ve Öde
                </button>
                <button class="btn btn-outline-custom w-100 mt-2" type="button" style="padding:10px; font-size:13px;" onclick="cancel3DSecure()">
                    İşlemi İptal Et
                </button>
            </div>
        </div>
    </div>

    <!-- JavaScript Form Interactions & Validations -->
    <script type="text/javascript">
        // Real-time card formatting & preview updates
        function formatCardNumber() {
            const input = document.getElementById('cardNumber');
            let value = input.value.replace(/\D/g, '');
            let formatted = '';
            for (let i = 0; i < value.length; i++) {
                if (i > 0 && i % 4 === 0) formatted += ' ';
                formatted += value[i];
            }
            input.value = formatted;
            
            // Detect card brand
            const cardIcon = document.getElementById('cardIcon');
            if (value.startsWith('4')) {
                cardIcon.className = "bi bi-credit-card-2-front-fill position-absolute text-primary";
                cardIcon.style.color = "#1783FA";
            } else if (value.startsWith('5')) {
                cardIcon.className = "bi bi-credit-card-2-front-fill position-absolute text-warning";
            } else {
                cardIcon.className = "bi bi-credit-card position-absolute text-muted";
            }
        }

        function updateCardPreview() {
            const holder = document.getElementById('cardHolder').value.trim();
            const number = document.getElementById('cardNumber').value.trim();
            const month = document.getElementById('cardMonth').value;
            const year = document.getElementById('cardYear').value;

            document.getElementById('previewHolder').innerText = holder ? holder : 'AD SOYAD';
            document.getElementById('previewNumber').innerText = number ? number : '•••• •••• •••• ••••';
            document.getElementById('previewExpiry').innerText = (month || year) ? (month + '/' + year) : 'AA/YY';
        }

        // 3D Secure Simulation Flows
        let timerInterval;

        function start3DSecure() {
            const holder = document.getElementById('cardHolder').value.trim();
            const number = document.getElementById('cardNumber').value.replace(/\s/g, '');
            const month = document.getElementById('cardMonth').value;
            const year = document.getElementById('cardYear').value;
            const cvv = document.getElementById('cardCvv').value.trim();
            const errDiv = document.getElementById('paymentErrorMessage');

            errDiv.style.display = 'none';

            // Validations
            if (!holder || holder.split(' ').length < 2) {
                showError('Lütfen kart sahibinin adını ve soyadını eksiksiz girin.');
                return;
            }
            if (number.length < 16) {
                showError('Lütfen 16 haneli kart numaranızı girin.');
                return;
            }
            if (!month || !year) {
                showError('Lütfen son kullanma tarihini seçin.');
                return;
            }
            if (cvv.length < 3) {
                showError('Lütfen kartın arkasındaki 3 haneli CVV kodunu girin.');
                return;
            }

            // Show Loading Spinner
            document.getElementById('loadingOverlay').style.display = 'flex';

            setTimeout(() => {
                // Hide Loading and Show SMS Verification Modal
                document.getElementById('loadingOverlay').style.display = 'none';
                document.getElementById('smsOverlay').style.display = 'flex';
                document.getElementById('smsCode').value = '';
                document.getElementById('smsErrorMessage').style.display = 'none';
                document.getElementById('smsCode').focus();
                startTimer();
            }, 1800);
        }

        function cancel3DSecure() {
            clearInterval(timerInterval);
            document.getElementById('smsOverlay').style.display = 'none';
        }

        function startTimer() {
            let duration = 120; // 2 minutes
            const timerSpan = document.getElementById('secureTimer');
            
            clearInterval(timerInterval);
            timerInterval = setInterval(() => {
                let minutes = Math.floor(duration / 60);
                let seconds = duration % 60;
                
                minutes = minutes < 10 ? '0' + minutes : minutes;
                seconds = seconds < 10 ? '0' + seconds : seconds;
                
                timerSpan.innerText = minutes + ':' + seconds;
                
                if (--duration < 0) {
                    clearInterval(timerInterval);
                    timerSpan.innerText = 'Süre Doldu';
                    alert('İşlem süresi doldu. Lütfen tekrar deneyiniz.');
                    cancel3DSecure();
                }
            }, 1000);
        }

        function resetTimer() {
            startTimer();
        }

        function formatSmsCode() {
            const input = document.getElementById('smsCode');
            input.value = input.value.replace(/\D/g, '').slice(0, 6);
        }

        function verifySmsCode() {
            const smsCode = document.getElementById('smsCode').value.replace(/\D/g, '');
            const errDiv = document.getElementById('smsErrorMessage');
            errDiv.style.display = 'none';

            if (smsCode.length !== 6) {
                errDiv.innerText = 'Lütfen 6 haneli SMS doğrulama kodunu girin.';
                errDiv.style.display = 'block';
                return;
            }

            if (smsCode === '123456') {
                clearInterval(timerInterval);
                document.getElementById('smsOverlay').style.display = 'none';
                
                // Show a clean success overlay before submitting
                document.getElementById('loadingOverlay').innerHTML = `
                    <div class="secure-modal-card text-center p-5" style="max-width:320px; animation:scaleIn 0.2s ease-out;">
                        <div class="text-success mb-3" style="font-size:3.5rem; line-height: 1;"><i class="bi bi-check-circle-fill"></i></div>
                        <h5 style="font-size:15px; font-weight:600; color:#0b1a30; margin-bottom:6px;">Demo Ödeme Onaylandı</h5>
                        <p class="text-muted mb-0" style="font-size:12.5px;">Siparişiniz demo akışıyla tamamlandı. Yönlendiriliyorsunuz...</p>
                    </div>`;
                document.getElementById('loadingOverlay').style.display = 'flex';

                setTimeout(() => {
                    // Trigger actual ASP.NET code-behind to complete order
                    document.getElementById('<%= btnRealCheckout.ClientID %>').click();
                }, 2000);
            } else {
                errDiv.innerText = 'Hatalı SMS şifresi girdiniz. Lütfen demo şifresini (123456) deneyin.';
                errDiv.style.display = 'block';
            }
        }

        function showError(message) {
            const errDiv = document.getElementById('paymentErrorMessage');
            errDiv.innerText = message;
            errDiv.style.display = 'block';
            errDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
    </script>
</asp:Content>
