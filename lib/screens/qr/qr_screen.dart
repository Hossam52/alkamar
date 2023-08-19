import 'dart:developer';

import 'package:alqamar/screens/qr/widgets/attend_manual_widget.dart';
import 'package:alqamar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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

class _QrScreenState extends State<QrScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

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
          if (widget.showManual)
            AttendManual(
              actionsWidget: widget.actionsWidget,
              onLoad: (val) async {
                controller?.pauseCamera();

                await widget.onManual(val);
                controller?.resumeCamera();
              },
            )
        ],
      ),
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
