import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/theme/tw.dart';
import '../../../core/widgets/notify.dart';
import '../../../core/widgets/tw_widgets.dart';
import '../rescue_service.dart';
import 'audience_opinion_screen.dart';

/// Màn hình riêng của app: trên web khán giả mở liên kết QR
/// `/khan-gia/tro-giup/:match/:rescueId` bằng camera điện thoại; trong app thì quét tại đây.
class AudienceEntryScreen extends StatefulWidget {
  const AudienceEntryScreen({super.key});

  @override
  State<AudienceEntryScreen> createState() => _AudienceEntryScreenState();
}

class _AudienceEntryScreenState extends State<AudienceEntryScreen> {
  final _match = TextEditingController();
  final _rescue = TextEditingController();

  @override
  void dispose() {
    _match.dispose();
    _rescue.dispose();
    super.dispose();
  }

  void _open(AudienceLink link) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AudienceOpinionScreen(matchSlug: link.matchSlug, rescueId: link.rescueId),
    ));
  }

  Future<void> _scan() async {
    final raw = await Navigator.of(context).push<String>(MaterialPageRoute(builder: (_) => const _QrScanPage()));
    if (raw == null || !mounted) return;
    final link = AudienceLink.parse(raw);
    if (link == null) {
      AppNotify.toast('Mã QR không phải liên kết trợ giúp khán giả', ToastType.error);
      return;
    }
    _open(link);
  }

  void _submit() {
    final pasted = AudienceLink.parse(_match.text);
    if (pasted != null) return _open(pasted);
    final id = int.tryParse(_rescue.text.trim());
    if (_match.text.trim().isEmpty || id == null) {
      AppNotify.toast('Vui lòng nhập mã trận đấu và mã cứu trợ', ToastType.warning);
      return;
    }
    _open(AudienceLink(_match.text.trim(), id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Tw.blue50, Tw.indigo50, Tw.purple50]),
        ),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: Tw.shadowSm,
                border: Border(bottom: BorderSide(color: Tw.gray200)),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
                  child: Row(
                    children: [
                      IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back, color: Tw.gray700)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: Tw.blue100, borderRadius: BorderRadius.circular(999)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const HeroIcon(HeroIcons.userGroup, size: 20, color: Tw.blue600),
                            const SizedBox(width: 8),
                            Text('Trợ giúp khán giả', style: Tw.sm(c: Tw.blue800, w: Tw.medium)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Tw.gray100),
                      boxShadow: Tw.shadowXl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(gradient: LinearGradient(colors: [Tw.blue600, Tw.indigo600])),
                          child: Column(
                            children: [
                              const HeroIcon(HeroIcons.qrCode, size: 56, color: Colors.white),
                              const SizedBox(height: 12),
                              Text('Quét mã QR trên màn hình trình chiếu',
                                  textAlign: TextAlign.center, style: Tw.xl(c: Colors.white, w: Tw.bold)),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: _scan,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: Tw.shadowLg),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const HeroIcon(HeroIcons.camera, size: 20, color: Tw.indigo600),
                                      const SizedBox(width: 8),
                                      Text('Mở camera', style: Tw.base(c: Tw.indigo600, w: Tw.semibold)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TwInput(
                                label: 'Mã trận đấu hoặc liên kết',
                                icon: HeroIcons.link,
                                controller: _match,
                                placeholder: 'vd: tran-1-vong-loai',
                              ),
                              const SizedBox(height: 24),
                              TwInput(
                                label: 'Mã cứu trợ',
                                icon: HeroIcons.lifebuoy,
                                controller: _rescue,
                                placeholder: 'vd: 12',
                                keyboardType: TextInputType.number,
                                onSubmitted: (_) => _submit(),
                              ),
                              const SizedBox(height: 24),
                              TwPrimaryButton(label: 'Tham gia trợ giúp', onPressed: _submit),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QrScanPage extends StatefulWidget {
  const _QrScanPage();

  @override
  State<_QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<_QrScanPage> {
  final _controller = MobileScannerController(formats: const [BarcodeFormat.qrCode]);
  bool _done = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              if (_done) return;
              final value = capture.barcodes.map((b) => b.rawValue).whereType<String>().firstOrNull;
              if (value == null) return;
              _done = true;
              Navigator.of(context).pop(value);
            },
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 3), borderRadius: BorderRadius.circular(20)),
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close, color: Colors.white)),
                const Spacer(),
                IconButton(onPressed: _controller.toggleTorch, icon: const Icon(Icons.flash_on, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
