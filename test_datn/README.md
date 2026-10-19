# Contests Mobile (Flutter)

Ứng dụng mobile cho hệ thống thi đấu, kết nối với **[Contests-BE](https://github.com/minhdat2k4/Contests-BE)**
(REST + Socket.IO). Giao diện dựng lại theo **[Contests-FE](https://github.com/longphan2k4/Contests-FE)**, lấy bản hiển thị
trên điện thoại (các class Tailwind không có tiền tố `sm:`/`md:`/`lg:`).

## Giao diện ↔ Contests-FE

| Màn hình Flutter | Trang / component FE |
|---|---|
| `home/home_screen.dart`, `home_sections.dart`, `chatbot_widget.dart` | `features/home/pages/HomePage.tsx`, `layouts/HomeLayout/HomeHeader.tsx`, `HomeFooter.tsx`, `features/home/components/contest/*`, `features/chatbot` |
| `auth/screens/student_login_screen.dart` | `features/student/pages/StudentLogin.tsx` |
| `student/screens/student_register_screen.dart` | `features/student/pages/StudentRegister.tsx` |
| `auth/screens/admin_login_screen.dart` | `features/auth/pages/login.tsx` + `components/LoginForm.tsx` |
| `auth/screens/forgot_password_screen.dart` | `features/auth/pages/forgot-password.tsx` + `components/forgot-password/*` |
| `auth/screens/profile_screen.dart` | `features/account/pages/ProfilePage.tsx` + `components/*` |
| `student/screens/student_dashboard_screen.dart` | `features/student/pages/StudentDashboard.tsx` |
| `student/screens/student_exam_screen.dart`, `widgets/exam_widgets.dart` | `StudentWaitingRoom.tsx`, `QuestionAnswerRefactored.tsx`, `QuestionHeader/Content/Options/Result`, `EssayInput`, `MediaGrid`, `MediaModal`, `AntiCheatStatus/Warning`, `RescueAnimation` |
| `judge/screens/judge_contest_list_screen.dart` | `features/judge/components/selector/ContestList.tsx`, `MatchList.tsx` |
| `judge/screens/judge_home_screen.dart` | `features/judge/pages/JudgeHomePage.tsx` + `components/home/*` |
| `audience/screens/audience_opinion_screen.dart` | `features/audience/pages/AudienceOpinionPage.tsx`, `MultipleChoiceInput`, `OpenEndedInput` |
| `core/widgets/notify.dart` | `contexts/toastContext.tsx` (toast) + `contexts/NotificationContext.tsx` (MUI Snackbar) |

Bộ màu/kích thước dùng chung: `core/theme/tw.dart` (bảng màu, shadow, cỡ chữ của Tailwind) và `core/widgets/mui.dart`
(theme MUI Cao Thắng: Button gradient, TextField bo góc 10, Card, Alert, Chip…). Icon Heroicons dùng package `heroicons`,
icon MUI dùng Material Icons, logo lấy từ `assets/image/logo/logo-caothang.svg` của FE.

Những chỗ app **khác web** do giới hạn của nền tảng mobile:
- Menu mobile của trang chủ có thêm 2 mục chỉ có trên app: **Khán giả trợ giúp (quét QR)** (trên web khán giả mở link QR bằng
  camera) và **Cài đặt máy chủ**.
- Thẻ trận đấu trên dashboard thí sinh chạm được để vào phòng chờ (trên web chỉ tự chuyển khi trận bắt đầu).
- "Toàn màn hình" = chế độ immersive của Android. Thoát immersive hoặc rời khỏi app khi đang làm bài tính là vi phạm.
- Thanh tab của trọng tài cuộn ngang được (trên web 4 tab bị tràn khỏi màn hình điện thoại).
- Video YouTube trang chủ nhúng bằng WebView; video/audio của câu hỏi phát bằng `video_player`.

## API / Socket sử dụng

| Vai trò | API / Socket của BE |
|---|---|
| Thí sinh | `POST /auth/student-login`, `POST /auth/register-student`, `GET /class/list-with-school`, `GET /auth/profile-student`, `GET /auth/registration-number`, `POST /results/submit-answer`, `POST /results/ban-contestant`; socket `/student`: `joinMatchRoom`, `student:joinMatch`, `student:getMatchStatus`, `student:confirmStart`, `match:started`, `match:questionShown`, `timer:update`, `timer:ended`, `match:ended`, `student:rescued` |
| Trọng tài | `POST /auth/login`, `GET /contest/list-contest/judge`, `GET /match/judge/:contestId`, `GET /match/:slug/matchInfo`, `GET /group-divisions/contestant/judge/:slug`, `GET /group/match/:slug`; socket `/match-control`: `joinMatchRoom`, `contestant:status-update-judge`, `group:confirmCurrentQuestion-update`, `currentQuestion:get` |
| Khán giả | `GET /rescue/match/:slug/:id`, `POST /rescue/supportAnswer/:id` (trắc nghiệm gửi chữ cái A/B/C/D, tự luận ghép chữ cái như FE) |
| Chung | `/auth/profile`, `/auth/change-info`, `/auth/change-password`, `/auth/forgot-password`, `/auth/verify-otp`, `/auth/reset-password`, `/auth/logout`, `/auth/refresh-token` |

Tài khoản Admin đăng nhập được. Mục "Trang quản lý" trên app chỉ báo dùng bản web, vì trang quản trị của FE thiết kế cho
màn hình lớn.

## Chạy ứng dụng

1. Chạy Contests-BE (mặc định cổng `3000`), theo README của BE (PostgreSQL + `npm run prisma:migrate` + `npm run prisma:seed` + `npm run dev`).
2. Chạy app:
   ```bash
   flutter pub get
   flutter run                                                     # emulator Android → http://10.0.2.2:3000
   flutter run --dart-define=API_BASE_URL=http://192.168.1.10:3000  # máy thật: IP LAN của máy chạy BE
   ```
   Có thể đổi địa chỉ server trong app: menu ☰ trên trang chủ → **Cài đặt máy chủ** → *Kiểm tra kết nối* (`GET /health`).

Không cần sửa BE: app mobile không gửi header `Origin` nên không bị CORS chặn.

## Xác thực

BE chỉ đọc JWT từ **cookie httpOnly** `accessToken` / `refreshToken`, không đọc header `Authorization`. Vì vậy app:
- dùng `dio` + `PersistCookieJar` để lưu cookie (giữ phiên giữa các lần mở app), tương đương `withCredentials: true` của axios;
- khi gặp `401` thì gọi `GET /auth/refresh-token` rồi gửi lại request. Với `USER_NOT_FOUND_OR_INACTIVE` / `INVALID_OR_EXPIRED_TOKEN`, app đăng xuất và quay về trang chủ;
- gửi cookie qua header `Cookie` khi bắt tay Socket.IO (BE đọc `socket.handshake.headers.cookie`).

## Ghi chú kỹ thuật

- `pubspec.yaml` ghim `html: 0.15.6` (`dependency_overrides`) vì `flutter_html 3.0.0` không build được với `html 0.15.7`.
- `android/gradle.properties` tắt `kotlin.incremental`. Trên Windows, khi project và pub cache nằm ở hai ổ đĩa khác nhau,
  Kotlin incremental cache bị lỗi.
- Namespace `/student` của BE chỉ đăng ký handler sau một truy vấn DB khi kết nối, nên app thử lại `student:joinMatch` /
  `joinMatchRoom` vài lần thay vì emit ngay.
