# 📧 Пошаговая инструкция: Как отправить сертификаты по email

## 🎯 **User Flow - Отправка сертификатов**

### 📱 **В Flutter приложении:**

#### 1. **Подготовка участников**
```
📋 Certificate Generator Screen
↓
📤 Upload Participants → "Choose File (Demo)"
✅ 4 participants found
```

#### 2. **Генерация сертификатов**  
```
🏭 Generate Certificates
↓
▶️ "Run Certificate Generation" 
⏳ Процесс: Reading CSV → Creating PDFs → QR codes...
✅ Generation Complete!
```

#### 3. **Настройка Email**
```
📧 Нажмите "Send Emails"
↓
⚙️ Email Configuration Dialog:
   📧 Email: nuraiym.kuandyk@gmail.com
   🔑 App Password: svpd ebsf xtau obym
   🌐 SMTP Server: smtp.gmail.com  
   🔌 Port: 587
↓
▶️ "Send to All"
```

#### 4. **Отправка и результат**
```
⏳ Email sending in progress...
↓
✅ Success Dialog с детальным отчетом
📊 "✅ Successful: 4, ❌ Failed: 0, 📧 Total: 4"
```

### 🐍 **Что происходит в backend:**

#### 1. **Flutter → Python**
```
📱 Flutter App создает:
   ├── email_config.json (ваши SMTP настройки)
   └── participants_for_email.json (список участников)

📞 Вызывает: python3 send_emails.py config.json participants.json
```

#### 2. **Python Email Process**
```
🐍 Python скрипт:
   ├── 📖 Читает конфигурацию SMTP
   ├── 👥 Загружает список участников  
   ├── 📄 Находит PDF сертификаты
   ├── ✉️ Создает HTML письма
   ├── 📎 Прикрепляет PDF файлы
   └── 📧 Отправляет через Gmail SMTP
```

#### 3. **Email Content**
```html
📧 Subject: "Your CovHack Certificate - [Name]"

🎉 Congratulations [Name]!
📜 Certificate attached (PDF)
🔗 Verification: https://certificateverifier.vercel.app/verify?code=ABC123
📱 QR code instructions included

📋 Certificate Details:
   • Participant: [Name]
   • Event: CovHack  
   • Code: ABC123
```

## 🔧 **Troubleshooting**

### ❌ **Если email не отправляется:**

#### 1. **Проверьте App Password**
```bash
# Gmail Security Settings:
https://myaccount.google.com/security

# Убедитесь что:
✅ 2FA включена
✅ App Password создан  
✅ Пароль скопирован правильно (16 символов)
```

#### 2. **Проверьте SMTP настройки**
```json
{
  "smtp_server": "smtp.gmail.com",
  "smtp_port": 587,  // ← STARTTLS
  // или
  "smtp_port": 465   // ← SSL
}
```

#### 3. **Ручное тестирование**
```bash
cd /Users/user1/Desktop/cert_verifier_project

# Тест email системы:
python3 send_emails.py email_config.json participants_for_email.json

# Должно показать:
# ✅ Email sent to [Name] ([Email])
# 📊 Successful: X, Failed: 0
```

### 📋 **Проверочный чек-лист:**

#### ✅ **Файлы готовы:**
- `/cert_verifier_project/email_config.json` - ваши SMTP данные
- `/cert_verifier_project/participants_for_email.json` - участники  
- `/cert_verifier_project/generate_cert/certificates_batch/*.pdf` - сертификаты

#### ✅ **Gmail настроен:**
- 2FA включена в Google Account
- App Password создан и скопирован
- SMTP доступ разрешен

#### ✅ **Flutter app работает:**
- Участники загружены (4 found)
- Сертификаты сгенерированы (PDFs created)
- Email настройки введены корректно

## 🎉 **Ready to Send!**

После выполнения всех шагов:
1. **Нажмите "Send Emails"** в Flutter app
2. **Введите свои данные** в диалоге  
3. **Получите результат** - все участники получат персонализированные письма с PDF сертификатами!

**🚀 Ваша email система готова к работе!**
