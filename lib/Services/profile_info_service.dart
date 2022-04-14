import 'package:flutter/cupertino.dart';
import 'package:trader/sharedPrefrences/sharefPrefernces.dart';

class ProfileInfoServices with ChangeNotifier {
  String uid;
  String fName;
  String lName;
  String email;
  String photoUrl;
  String phoneNumber;

  Future<dynamic> fetchInfo() async {
    uid = await SharedPreferenc().getUid();
    fName= await SharedPreferenc().getFName();
    lName = await SharedPreferenc().getLName();
    email = await SharedPreferenc().getEmail();
    photoUrl= await SharedPreferenc().getPhotoUrl();
    phoneNumber = await SharedPreferenc().getPhoneNumber();
  }

  getuid() => uid;

  getFName() => fName;

  getLName() => lName;

  getemail() => email;

  getphone() => phoneNumber;

  geturl() => photoUrl;
}
