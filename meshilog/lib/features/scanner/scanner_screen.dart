import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../utils/theme.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _hasResult = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasResult) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;
    setState(() => _hasResult = true);
    _controller.stop();
    _showProductSheet(barcode!.rawValue!);
  }

  void _showProductSheet(String code) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.card,
      builder: (_) => _ProductSheet(
        janCode: code,
        onClose: () {
          Navigator.pop(context);
          setState(() => _hasResult = false);
          _controller.start();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('バーコードスキャン')),
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          const _ScanOverlay(),
        ],
      ),
    );
  }
}

class _ScanOverlay extends StatelessWidget {
  const _ScanOverlay();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 260,
        height: 140,
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.accent, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text('バーコードをスキャン', style: TextStyle(color: AppTheme.accent, fontSize: 12)),
          ),
        ),
      ),
    );
  }
}

class _ProductSheet extends StatelessWidget {
  final String janCode;
  final VoidCallback onClose;

  const _ProductSheet({required this.janCode, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('JAN: $janCode', style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
          const SizedBox(height: 8),
          const Text('商品を検索中...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onClose,
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
              child: const Text('閉じる', style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }
}
