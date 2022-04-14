import 'package:flutter/cupertino.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/sharedPrefrences/sharefPrefernces.dart';

class ProfilePageService with ChangeNotifier {
  String fName = "";
  String lName = "";
  String uid = "";
  String email = "";
  String phone = "";
  String url = "";

  bool back = false;

  setBack(bool b) {
    this.back = b;
    notifyListeners();
  }

  getBack() => back;

  Future fetchProfile()  async {

    // this.uid =  GetStorageClass().getUid();
    // this.name =   GetStorageClass().getName();
    // this.email =  GetStorageClass().getEmail();
    // this.url =   GetStorageClass().getPhotoUrl();
    // this.phone =   GetStorageClass().getPhoneNumber();

    uid = await SharedPreferenc().getUid();
    fName= await SharedPreferenc().getFName();
    lName = await SharedPreferenc().getLName();
    email = await SharedPreferenc().getEmail();
    url= await SharedPreferenc().getPhotoUrl();
    phone = await SharedPreferenc().getPhoneNumber();
    notifyListeners();
  }

  getProfile() => {
    Strings.fname: fName,
    Strings.lname: lName,
    Strings.email: email,
    Strings.phone: phone,
    Strings.uid: uid,
    Strings.url: url,
  };
}
