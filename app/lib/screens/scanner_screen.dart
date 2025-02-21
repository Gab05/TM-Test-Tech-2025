import 'dart:async';

import 'package:app/services.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:app/screens/event_detail_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver {
  final MobileScannerController _controller = MobileScannerController(
    autoStart: false,
  );

  StreamSubscription<Object?>? _subscription;

  bool _isBarcodeFound = false;

  @override
  void initState() {
    super.initState();
    _subscription = _controller.barcodes.listen(_handleBarcode);
    unawaited(_controller.start());
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    _isBarcodeFound = false;
    _subscription = null;
    super.dispose();
    _controller.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = _controller.barcodes.listen(_handleBarcode);
        _isBarcodeFound = false;
        unawaited(_controller.start());
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(_controller.stop());
    }
  }
  
  void _handleBarcode(BarcodeCapture barcodes) {
    if (_isBarcodeFound) {
      return;
    }

    Barcode? barcode = barcodes.barcodes.firstOrNull;

    if (barcode != null && barcode.rawValue != null) {
      _isBarcodeFound = true;
      String eventID = barcode.rawValue!;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EventDetailScreen(eventID: eventID, ticketmasterEventsApi: ticketmasterEventsApi),
        ),
      ).then((result) => {
        _isBarcodeFound = false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live scanner')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(controller: _controller, fit: BoxFit.contain),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: const Color.fromRGBO(2, 77, 223, 0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'Waiting for barcode...',
                        overflow: TextOverflow.fade,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
