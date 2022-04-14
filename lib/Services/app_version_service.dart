import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';
import 'package:trader/Resources/keywords.dart';

class AppVersionService with ChangeNotifier {
  DatabaseReference _db = FirebaseDatabase.instance.reference();
  String _version;

  bool haveVersion = false;
  bool priorityUpdate = true;

  getHaveVersion() => haveVersion;

  setHaveVersionFalse() {
    haveVersion = false;
    notifyListeners();
  }

  getVersion() async {
    // _db.child(Strings.versions).limitToLast(1).once().then((value) async {
    //   final data = value.value;
    //   await getApplicationVersion();
    //   if (int.parse(data[0][Strings.buildNumber].toString()) >
    //       int.parse(_version)) {
    //     haveVersion = true;
    //
    //     String pr = data[0][Strings.priority];
    //     if (pr == Strings.high) {
    //       priorityUpdate = true;
    //     } else {
    //       priorityUpdate = false;
    //     }
    //
    //     notifyListeners();
    //   } else {
    //     haveVersion = false;
    //     notifyListeners();
    //   }
    // });
  }

  getApplicationVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.buildNumber;
  }
}
