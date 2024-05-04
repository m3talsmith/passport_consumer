import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:passport/authentication/authentication.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<StatefulWidget> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String? _qrCode;

  scanQR(BuildContext context) async {
    if (!mounted) return;

    String barcodeScanRes;
    AuthenticationResponse response;
    var messenger = ScaffoldMessenger.of(context);

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      response = await Authentication(url: barcodeScanRes).authenticate();
    } catch (err) {
      barcodeScanRes = 'error: $err';
      response = AuthenticationResponse(error: err.toString());
    }

    if (response.error != null) {
      messenger.showSnackBar(SnackBar(content: Text('Error: ${response.error}'), showCloseIcon: true,));
    }

    setState(() {
      _qrCode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () async {
                  await scanQR(context);
                },
                icon: const Icon(
                  Icons.qr_code_scanner_rounded,
                  size: 200,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
