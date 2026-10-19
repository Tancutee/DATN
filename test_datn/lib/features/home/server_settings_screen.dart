import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

import '../../core/config/app_config.dart';
import '../../core/network/api_client.dart';
import '../../core/theme/tw.dart';
import '../../core/widgets/notify.dart';
import '../../core/widgets/tw_widgets.dart';

/// Màn hình riêng của app: đổi địa chỉ Contests-BE và kiểm tra kết nối (`GET /health`).
class ServerSettingsScreen extends StatefulWidget {
  const ServerSettingsScreen({super.key});

  @override
  State<ServerSettingsScreen> createState() => _ServerSettingsScreenState();
}

class _ServerSettingsScreenState extends State<ServerSettingsScreen> {
  late final _url = TextEditingController(text: AppConfig.baseUrl);
  bool _testing = false;
  String? _result;
  bool _ok = false;

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  Future<void> _test() async {
    setState(() {
      _testing = true;
      _result = null;
    });
    var base = _url.text.trim();
    while (base.endsWith('/')) {
      base = base.substring(0, base.length - 1);
    }
    try {
      final res = await Dio(BaseOptions(connectTimeout: const Duration(seconds: 6))).get('$base/health');
      final data = res.data;
      _ok = data is Map && data['success'] == true;
      _result = _ok ? 'Kết nối thành công: ${data['message']}' : 'Phản hồi không đúng định dạng Contests-BE';
    } catch (e) {
      _ok = false;
      _result = 'Không kết nối được tới $base';
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  Future<void> _save() async {
    await AppConfig.setBaseUrl(_url.text);
    ApiClient.instance.reloadBaseUrl();
    await ApiClient.instance.clearCookies();
    AppNotify.toast('Đã lưu địa chỉ máy chủ', ToastType.success);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Tw.blue50, Tw.indigo100]),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back, color: Tw.gray700)),
                  Text('Cài đặt máy chủ', style: Tw.xl(c: Tw.gray900, w: Tw.bold)),
                ],
              ),
              const SizedBox(height: 16),
              TwCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TwInput(
                      label: 'Địa chỉ Contests-BE',
                      icon: HeroIcons.server,
                      controller: _url,
                      placeholder: 'http://192.168.1.10:3000',
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '• Android emulator: http://10.0.2.2:3000\n'
                      '• Điện thoại thật: IP LAN của máy chạy BE\n'
                      '• Không thêm "/api" ở cuối',
                      style: Tw.sm(c: Tw.gray500).copyWith(height: 1.6),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: _testing ? null : _test,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Tw.gray300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(_testing ? 'Đang kiểm tra...' : 'Kiểm tra kết nối', style: Tw.sm(c: Tw.gray700, w: Tw.medium)),
                    ),
                    if (_result != null) ...[
                      const SizedBox(height: 12),
                      Text(_result!, style: Tw.sm(c: _ok ? Tw.green600 : Tw.red600)),
                    ],
                    const SizedBox(height: 16),
                    TwPrimaryButton(label: 'Lưu', onPressed: _save),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => _url.text = AppConfig.defaultBaseUrl,
                      child: Text('Khôi phục mặc định (${AppConfig.defaultBaseUrl})', style: Tw.sm(c: Tw.indigo600)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
