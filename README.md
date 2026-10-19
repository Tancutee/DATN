# DATN – App Olympic Tin học (Flutter)

Ứng dụng di động cho cuộc thi Olympic Tin học – Khoa CNTT, Cao đẳng Kỹ thuật Cao Thắng.

## Cấu trúc

| Thư mục | Nội dung |
|---|---|
| `test_datn/` | Mã nguồn app Flutter |
| `database/olympicdev.sql` | CSDL MySQL/MariaDB kèm dữ liệu mẫu |

App lấy dữ liệu qua API của backend **Contests-BE** (Node.js + Prisma), backend đọc CSDL `olympicdev`.

## Cài đặt

1. **CSDL** – bật MySQL (vd. XAMPP), rồi import:
   ```
   mysql -u root < database/olympicdev.sql
   ```
2. **Backend Contests-BE** – trong `.env` đặt
   `DATABASE_URL="mysql://root:@localhost:3306/olympicdev"`, sau đó:
   ```
   npm install
   npm run build
   npm start
   ```
   Backend chạy ở cổng `3000`.
3. **App** –
   ```
   cd test_datn
   flutter pub get
   flutter run
   ```
   Máy ảo Android tự kết nối `http://10.0.2.2:3000`. Điện thoại thật: đổi địa chỉ trong màn hình *Cài đặt máy chủ* của app.

## Tài khoản mẫu

| Vai trò | Tên đăng nhập | Mật khẩu |
|---|---|---|
| Admin | `admin` | `admin123` |
| Thí sinh | `student_10102`, `student_11204`, … | `123456` |
