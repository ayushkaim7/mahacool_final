import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/mount_file.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanIn extends StatefulWidget {
  final String pid;
  final String sid;
  final int box;

  final Function() onsuccess;
  final int position;
  final String rname;

  const ScanIn({
    Key? key,
    required this.pid,
    required this.position,
    required this.sid,
    required this.rname,
    required this.box,
    required this.onsuccess,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<ScanIn> {
  late Barcode result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    result = Barcode(widget.pid, BarcodeFormat.aztec, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                _buildQrView(context),
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        result != null
                            ? 'Type: ${describeEnum(result.format)}\nData: ${result.code}'
                            : 'Scan a code',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _buildControlButton(
                          context,
                          icon: Icons.flash_on,
                          label: 'Flash',
                          onPressed: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                          futureBuilder: FutureBuilder(
                            future: controller?.getFlashStatus(),
                            builder: (context, snapshot) {
                              return Text(
                                'Flash: ${snapshot.data}',
                                style: TextStyle(fontSize: 16),
                              );
                            },
                          ),
                        ),
                        _buildControlButton(
                          context,
                          icon: Icons.cameraswitch,
                          label: 'Flip Camera',
                          onPressed: () async {
                            await controller?.flipCamera();
                            setState(() {});
                          },
                          futureBuilder: FutureBuilder(
                            future: controller?.getCameraInfo(),
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.data != null
                                    ? 'Facing: ${describeEnum(snapshot.data!)}'
                                    : 'Loading...',
                                style: TextStyle(fontSize: 16),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _buildActionButton(
                          label: 'Pause',
                          color: Colors.redAccent,
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                        ),
                        _buildActionButton(
                          label: 'Resume',
                          color: Colors.greenAccent,
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildControlButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onPressed, required FutureBuilder futureBuilder}) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(15),
            backgroundColor: Colors.blueAccent,
          ),
          onPressed: onPressed,
          child: Icon(icon, size: 30, color: Colors.white),
        ),
        SizedBox(height: 10),
        futureBuilder,
      ],
    );
  }

  Widget _buildActionButton({required String label, required Color color, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }



  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;

        print("result ${result.code} and pid ${widget.pid}");

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MountDetails(
              pid: result.code!,
              rname: widget.rname,
              onsuccess: widget.onsuccess,
              position: widget.position,
              rid: widget.pid,
              box: widget.box,
              sid: widget.sid),
        ));
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
