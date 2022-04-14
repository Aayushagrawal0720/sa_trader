import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:trader/Resources/Color.dart';
import 'package:provider/provider.dart';
import 'package:trader/Resources/SupportDialogs.dart';
import 'package:trader/Services/payment_services.dart';
import 'package:trader/Services/profile_info_service.dart';

class QrScannerPage extends StatefulWidget {
  @override
  QrScannerPageState createState() => QrScannerPageState();
}

class QrScannerPageState extends State<QrScannerPage> {
  static const flashOn = 'ON';
  static const flashOff = 'OFF';
  static const frontCamera = 'FRONT CAMERA';
  static const backCamera = 'BACK CAMERA';

  String result;
  var flashState = flashOn;
  var cameraState = backCamera;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  sendDataToServer() async {
    if (result != null) {
      controller.pauseCamera();
      openProcessingDialog(context);
      await Provider.of<PaymentService>(context, listen: false)
          .payThroughCoupon(
              Provider.of<ProfileInfoServices>(context, listen: false).getuid(),
              result);
      Navigator.pop(context);
      Navigator.pop(context, true);
    }
  }

  bool _isFlashOn(String current) {
    return flashOn == current;
  }

  bool _isBackCamera(String current) {
    return backCamera == current;
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return NotificationListener<SizeChangedLayoutNotification>(
        onNotification: (notification) {
          Future.microtask(
              () => controller?.updateDimensions(qrKey, scanArea: scanArea));
          return false;
        },
        child: SizeChangedLayoutNotifier(
            key: const Key('qr-size-notifier'),
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: ColorsTheme.themeOrange,
                borderRadius: 6,
                borderLength: 20,
                borderWidth: 10,
                cutOutSize: scanArea,
              ),
            )));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      result = scanData.code;
      sendDataToServer();
    });
  }

  fetchImageFromGallery() async {
    final img = await ImagePicker.pickImage(source: ImageSource.gallery);
    getDateFromFile(img);
  }

  getDateFromFile(File img) async {
    String data = await QrCodeToolsPlugin.decodeFrom(img.path);
    result= data;
    sendDataToServer();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Expanded(child: _buildQrView(context)),
              ],
            ),
            Positioned(
                top: 20,
                left: 20,
                child: GestureDetector(
                    onTap: () {
                      if (controller != null) {
                        controller.toggleFlash();
                        if (_isFlashOn(flashState)) {
                          setState(() {
                            flashState = flashOff;
                          });
                        } else {
                          setState(() {
                            flashState = flashOn;
                          });
                        }
                      }
                    },
                    child: Icon(
                      flashState == flashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                    ))),
            Positioned(
                top: 20,
                left: 60,
                child: GestureDetector(
                    onTap: () {
                      if (controller != null) {
                        controller.flipCamera();
                        if (_isBackCamera(cameraState)) {
                          setState(() {
                            cameraState = frontCamera;
                          });
                        } else {
                          setState(() {
                            cameraState = backCamera;
                          });
                        }
                      }
                    },
                    child: Icon(
                      cameraState == backCamera
                          ? Icons.camera_rear
                          : Icons.camera_front,
                      color: Colors.white,
                    ))),
            Positioned(
                top: 20,
                right: 20,
                child: GestureDetector(
                  onTap: fetchImageFromGallery,
                  child: Icon(
                    Icons.photo,
                    color: Colors.white,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
