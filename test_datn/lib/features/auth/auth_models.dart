/// Vai trò người dùng trong Contests-BE (enum `Role` của Prisma).
enum UserRole {
  admin('Admin', 'Quản trị viên'),
  judge('Judge', 'Trọng tài'),
  student('Student', 'Thí sinh'),
  unknown('', 'Không xác định');

  const UserRole(this.value, this.label);

  final String value;
  final String label;

  static UserRole parse(String? value) => UserRole.values.firstWhere(
        (r) => r.value == value,
        orElse: () => UserRole.unknown,
      );
}

/// Kết quả `GET /api/auth/profile`.
class AppUser {
  const AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.isActive,
  });

  final int id;
  final String username;
  final String email;
  final UserRole role;
  final bool isActive;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: (json['id'] as num).toInt(),
        username: json['username']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        role: UserRole.parse(json['role']?.toString()),
        isActive: json['isActive'] != false,
      );
}
