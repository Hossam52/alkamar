import 'dart:developer';

import 'package:alqamar/screens/qr/widgets/attend_manual_widget.dart';
import 'package:alqamar/shared/presentation/resourses/color_manager.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../shared/presentation/resourses/font_manager.dart';

class QrScreen extends StatefulWidget {
  const QrScreen(
      {super.key,
      required this.onQr,
      required this.onManual,
      required this.actionsWidget,
      this.title = '',
      this.showManual = true});
  final String title;
  final Future<void> Function(String? data) onQr;
  final Future<void> Function(String? data) onManual;
  final Widget actionsWidget;
  final bool showManual;
  @override
  State<QrScreen> createState() => _QrScreenState();
}

enum _ActionEnum { manual, qr }

class _QrScreenState extends State<QrScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  _ActionEnum? action = _ActionEnum.qr;
  Barcode? result;

  QRViewController? controller;

  // // In order to get hot reload to work we need to pause the camera if the platform
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(label: widget.title),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: _customListTile(_ActionEnum.qr, 'استخدام QR'),
                ),
                Expanded(
                  child: _customListTile(_ActionEnum.manual, 'تحضير يدوي'),
                )
              ],
            ),
          ),
          if (action == _ActionEnum.qr)
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 10,
                ),
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          if (widget.showManual && action == _ActionEnum.manual)
            AttendManual(
              actionsWidget: widget.actionsWidget,
              onLoad: (val) async {
                await widget.onManual(val);
              },
            )
        ],
      ),
    );
  }

  RadioListTile<_ActionEnum> _customListTile(_ActionEnum val, String title,
      {VoidCallback? onToggle}) {
    return RadioListTile.adaptive(
      title: TextWidget(
        label: title,
        fontSize: FontSize.s14,
      ),
      selectedTileColor: ColorManager.accentColor,
      activeColor: ColorManager.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      selected: val == action,
      value: val,
      groupValue: action,
      onChanged: (val) {
        setState(() {
          action = val;
        });
        if (onToggle != null) onToggle();
      },
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      log('Done Scanning');
      controller.pauseCamera();
      await widget.onQr(scanData.code);
      controller.resumeCamera();
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
