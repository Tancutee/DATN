import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import '../../../app_routes.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tw.dart';
import '../../../core/widgets/mui.dart';
import '../../../core/widgets/notify.dart';
import '../../../core/widgets/tw_widgets.dart';
import '../../auth/screens/student_login_screen.dart';
import '../student_models.dart';
import '../student_service.dart';

/// Đăng ký thí sinh — `features/student/pages/StudentRegister.tsx`.
class StudentRegisterScreen extends StatefulWidget {
  const StudentRegisterScreen({super.key});

  @override
  State<StudentRegisterScreen> createState() => _StudentRegisterScreenState();
}

class _StudentRegisterScreenState extends State<StudentRegisterScreen> {
  final _service = StudentService();
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  List<SchoolClass> _classes = [];
  bool _loadingClasses = true;
  String? _school;
  int _classId = 0;
  bool _showSchool = false;
  bool _showClass = false;
  String _schoolSearch = '';
  String _classSearch = '';
  bool _showPassword = false;
  bool _showConfirm = false;
  bool _loading = false;
  Map<String, String> _errors = {};

  @override
  void initState() {
    super.initState();
    _service.getClasses().then((list) {
      if (mounted) setState(() => _classes = list);
    }).catchError((_) {}).whenComplete(() {
      if (mounted) setState(() => _loadingClasses = false);
    });
  }

  @override
  void dispose() {
    for (final c in [_fullName, _email, _username, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  void _clearErrors() {
    if (_errors.isNotEmpty) setState(() => _errors = {});
  }

  List<String> get _schools => _classes.map((c) => c.schoolName).toSet().toList();

  List<SchoolClass> get _classesOfSchool => _classes.where((c) => c.schoolName == _school).toList();

  /// RegisterSchema (features/student/schemas/validation.ts).
  Map<String, String> _validate() {
    final e = <String, String>{};
    final u = _username.text.trim();
    if (u.length < 3) {
      e['username'] = 'Tên đăng nhập phải có ít nhất 3 ký tự';
    } else if (u.length > 20) {
      e['username'] = 'Tên đăng nhập không được quá 20 ký tự';
    }
    final n = _fullName.text.trim();
    if (n.length < 2) {
      e['fullName'] = 'Họ và tên phải có ít nhất 2 ký tự';
    } else if (n.length > 100) {
      e['fullName'] = 'Họ và tên không được quá 100 ký tự';
    }
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(_email.text.trim())) e['email'] = 'Email không hợp lệ';
    if (_password.text.length < 8) {
      e['password'] = 'Mật khẩu phải có ít nhất 8 ký tự';
    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]').hasMatch(_password.text)) {
      e['password'] = 'Mật khẩu phải chứa ít nhất 1 chữ hoa, 1 chữ thường, 1 số và 1 ký tự đặc biệt';
    }
    if (_confirm.text.isEmpty) {
      e['confirmPassword'] = 'Vui lòng xác nhận mật khẩu';
    } else if (_confirm.text != _password.text) {
      e['confirmPassword'] = 'Mật khẩu xác nhận không khớp';
    }
    if (_school == null) e['school'] = 'Vui lòng chọn trường';
    if (_classId <= 0) e['classId'] = 'Vui lòng chọn lớp';
    return e;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final errors = _validate();
    if (errors.isNotEmpty) {
      setState(() => _errors = errors);
      AppNotify.error('Dữ liệu không hợp lệ', title: 'Lỗi');
      return;
    }
    setState(() {
      _loading = true;
      _errors = {};
    });
    try {
      await _service.register(
        username: _username.text,
        fullName: _fullName.text,
        email: _email.text,
        password: _password.text,
        confirmPassword: _confirm.text,
        classId: _classId,
      );
      AppNotify.success('Đăng ký thành công! Vui lòng đăng nhập để tiếp tục.', duration: const Duration(seconds: 2));
      Timer(const Duration(seconds: 2), () {
        if (mounted) AppRoutes.studentLogin(replace: true);
      });
    } on ApiException catch (e) {
      if (e.fieldErrors.isNotEmpty) {
        setState(() => _errors = Map.of(e.fieldErrors));
        AppNotify.error(e.fieldErrors.values.first, title: 'Lỗi');
      } else {
        setState(() => _errors = {'general': e.message});
        AppNotify.error(e.message, title: 'Lỗi');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StudentAuthBackground(
      child: Column(
        children: [
          const StudentAuthHeader('Đăng ký Thí sinh'),
          TwCard(
            radius: 16,
            shadow: Tw.shadow2xl,
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_errors['general'] != null) ...[TwErrorBox(_errors['general']!), const SizedBox(height: 24)],
                TwInput(
                  label: 'Họ và tên',
                  icon: HeroIcons.user,
                  controller: _fullName,
                  placeholder: 'Nhập họ và tên đầy đủ',
                  error: _errors['fullName'],
                  onChanged: (_) => _clearErrors(),
                ),
                const SizedBox(height: 24),
                _dropdownField(
                  label: 'Trường',
                  value: _school ?? 'Chọn trường',
                  hasValue: _school != null,
                  error: _errors['school'],
                  open: _showSchool,
                  onTap: () => setState(() {
                    _showSchool = !_showSchool;
                    _showClass = false;
                  }),
                  menu: _menu(
                    searchHint: 'Tìm trường...',
                    onSearch: (v) => setState(() => _schoolSearch = v),
                    loadingText: 'Đang tải danh sách trường...',
                    emptyText: 'Không tìm thấy trường',
                    items: [
                      for (final s in _schools.where((s) => s.toLowerCase().contains(_schoolSearch.toLowerCase())))
                        (
                          s,
                          () => setState(() {
                            _school = s;
                            _classId = 0;
                            _showSchool = false;
                            _schoolSearch = '';
                            _errors = {};
                          })
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _dropdownField(
                  label: 'Lớp',
                  value: _classId <= 0
                      ? (_school != null ? 'Chọn lớp' : 'Vui lòng chọn trường trước')
                      : _classesOfSchool.firstWhere((c) => c.id == _classId).name,
                  hasValue: _classId > 0,
                  disabled: _school == null,
                  error: _school != null ? _errors['classId'] : null,
                  open: _showClass && _school != null,
                  onTap: () {
                    if (_school != null) {
                      setState(() {
                        _showClass = !_showClass;
                        _showSchool = false;
                      });
                    }
                  },
                  menu: _menu(
                    searchHint: 'Tìm lớp...',
                    onSearch: (v) => setState(() => _classSearch = v),
                    loadingText: 'Đang tải danh sách lớp...',
                    emptyText: 'Không tìm thấy lớp',
                    items: [
                      for (final c in _classesOfSchool.where((c) => c.name.toLowerCase().contains(_classSearch.toLowerCase())))
                        (
                          c.name,
                          () => setState(() {
                            _classId = c.id;
                            _showClass = false;
                            _classSearch = '';
                            _errors = {};
                          })
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TwInput(
                  label: 'Email',
                  icon: HeroIcons.envelope,
                  controller: _email,
                  placeholder: 'Nhập địa chỉ email',
                  keyboardType: TextInputType.emailAddress,
                  error: _errors['email'],
                  onChanged: (_) => _clearErrors(),
                ),
                const SizedBox(height: 24),
                TwInput(
                  label: 'Tên đăng nhập',
                  icon: HeroIcons.user,
                  controller: _username,
                  placeholder: 'Nhập tên đăng nhập',
                  error: _errors['username'],
                  onChanged: (_) => _clearErrors(),
                ),
                const SizedBox(height: 24),
                TwInput(
                  label: 'Mật khẩu',
                  icon: HeroIcons.lockClosed,
                  controller: _password,
                  placeholder: 'Nhập mật khẩu (ít nhất 8 ký tự)',
                  obscure: !_showPassword,
                  onToggleObscure: () => setState(() => _showPassword = !_showPassword),
                  error: _errors['password'],
                  onChanged: (_) => _clearErrors(),
                ),
                const SizedBox(height: 24),
                TwInput(
                  label: 'Xác nhận mật khẩu',
                  icon: HeroIcons.lockClosed,
                  controller: _confirm,
                  placeholder: 'Nhập lại mật khẩu',
                  obscure: !_showConfirm,
                  onToggleObscure: () => setState(() => _showConfirm = !_showConfirm),
                  error: _errors['confirmPassword'],
                  onChanged: (_) => _clearErrors(),
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 24),
                TwPrimaryButton(label: 'Đăng ký', loadingLabel: 'Đang đăng ký...', loading: _loading, onPressed: _submit),
                const SizedBox(height: 24),
                const TwOrDivider(),
                const SizedBox(height: 32),
                Center(
                  child: Text.rich(
                    TextSpan(
                      style: Tw.sm(c: Tw.gray600),
                      children: [
                        const TextSpan(text: 'Đã có tài khoản? '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: GestureDetector(
                            onTap: () => AppRoutes.studentLogin(replace: true),
                            child: Text('Đăng nhập ngay', style: Tw.sm(c: Tw.indigo600, w: Tw.medium)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdownField({
    required String label,
    required String value,
    required bool hasValue,
    required bool open,
    required VoidCallback onTap,
    required Widget menu,
    String? error,
    bool disabled = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Tw.sm(c: Tw.gray700, w: Tw.medium)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: TwFieldBox(
            focused: open,
            error: error != null,
            disabled: disabled,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 12, right: 8),
                    child: HeroIcon(HeroIcons.buildingOffice, size: 20, color: Tw.gray400),
                  ),
                  Expanded(
                    child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: Tw.base(c: Tw.gray900)),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: HeroIcon(HeroIcons.chevronDown, size: 20, color: Tw.gray400),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (open) ...[const SizedBox(height: 4), menu],
        if (error != null) ...[const SizedBox(height: 4), Text(error, style: Tw.sm(c: Tw.red600))],
      ],
    );
  }

  Widget _menu({
    required String searchHint,
    required ValueChanged<String> onSearch,
    required String loadingText,
    required String emptyText,
    required List<(String, VoidCallback)> items,
  }) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 240),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Tw.gray300),
        borderRadius: BorderRadius.circular(8),
        boxShadow: Tw.shadowLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Tw.gray200))),
            child: TextField(
              autofocus: true,
              onChanged: onSearch,
              style: Tw.sm(c: Tw.gray900),
              decoration: InputDecoration(
                isDense: true,
                hintText: searchHint,
                hintStyle: Tw.sm(c: Tw.gray400),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 12, right: 8),
                  child: HeroIcon(HeroIcons.magnifyingGlass, size: 16, color: Tw.gray400),
                ),
                prefixIconConstraints: const BoxConstraints(),
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Tw.gray300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Tw.gray300)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Tw.indigo500, width: 2)),
              ),
            ),
          ),
          Flexible(
            child: _loadingClasses
                ? Padding(padding: const EdgeInsets.all(12), child: Text(loadingText, textAlign: TextAlign.center, style: Tw.sm(c: Tw.gray500)))
                : items.isEmpty
                    ? Padding(padding: const EdgeInsets.all(12), child: Text(emptyText, textAlign: TextAlign.center, style: Tw.sm(c: Tw.gray500)))
                    : ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        children: [
                          for (final (label, onTap) in items)
                            InkWell(
                              onTap: onTap,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Text(label, style: Tw.sm(c: Tw.gray900)),
                              ),
                            ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}
