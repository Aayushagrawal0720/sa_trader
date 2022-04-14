import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:trader/sharedPrefrences/sharefPrefernces.dart';

class PriorityAccessServices with ChangeNotifier {
  // final _ref = FirebaseDatabase.instance.reference().child("priorityAccess");
  //
  // setAccount(String uid) {
  //   Map<String, dynamic> _data = {
  //     "uid": uid,
  //     "points": 0,
  //     "priority_access": false
  //   };
  //   _ref.child(uid).set(_data);
  // }
  //
  // Future<bool> updatePoints(int points, String uid) async {
  //   bool returnS;
  //   int prePoints;
  //   await SharedPreferenc().getPoints().then((value) async {
  //     if (value != null) {
  //       prePoints = value;
  //     } else {
  //       prePoints = 0;
  //     }
  //
  //     int newPoint = prePoints + points;
  //     await _ref.child("$uid/points").set(newPoint).catchError((e) {
  //       returnS = false;
  //     });
  //     SharedPreferenc().setPoints(newPoint);
  //     returnS = true;
  //   });
  //
  //   return returnS;
  // }
  //
  // Future fetchPoints(String uid) async {
  //   final data = await _ref.child("$uid/points").once();
  //   SharedPreferenc().setPoints(data.value);
  // }
}
