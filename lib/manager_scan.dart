import 'package:flutter/material.dart';
import 'package:inventory_app/scanned_detailedpage.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert';

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isFlashOn = false;
  bool isFrontCamera = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        controller.pauseCamera(); // Prevent scanning multiple times
        _navigateToDetailPage(result!.code!); // Pass the scanned data
      });
    });
  }

  void _toggleFlash() async {
    await controller?.toggleFlash();
    setState(() {
      isFlashOn = !isFlashOn;
    });
  }

  void _switchCamera() async {
    await controller?.flipCamera();
    setState(() {
      isFrontCamera = !isFrontCamera;
    });
  }

  void _navigateToDetailPage(String data) {
    final decodedData = jsonDecode(data);
    print("Scanned data is this ###: $decodedData"); // Decode JSON from QR code
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          customerData: decodedData,
        ),
      ),
    ).then((_) => controller?.resumeCamera()); // Resume camera after returning
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'QR Scanner',
          style: TextStyle(
            fontFamily: 'helvetica',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            right: 20,
            child: Column(
              children: [
                IconButton(
                  icon: Icon(
                    isFlashOn ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: _toggleFlash,
                ),
                SizedBox(height: 10),
                IconButton(
                  icon: Icon(
                    isFrontCamera ? Icons.camera_front : Icons.camera_rear,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: _switchCamera,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.7),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10,
                ),
                onPressed: () {
                  controller?.resumeCamera(); // Manual camera resume button
                },
                child: Text(
                  'Start Scanning Again',
                  style: TextStyle(
                    fontFamily: 'helvetica',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
