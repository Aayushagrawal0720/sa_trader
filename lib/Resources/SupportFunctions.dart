import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity/connectivity.dart';


class SupportFunctions {
  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkpermissions() async {
    var status = false;

    if (await Permission.location.isPermanentlyDenied &&
        await Permission.storage.isPermanentlyDenied) {
      status = true;
    } else if (!await Permission.location.isGranted ||
        !await Permission.storage.isGranted) {
      status = false;
    } else {
      status = true;
    }

    return status;
  }

  getAmenityImage(String title) {
    switch (title) {
    }
  }

  String splitString(String url) {
    var d = url.split("/");
    return d.last;
  }
}
