import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/sharedPrefrences/sharefPrefernces.dart';

class SigninRegisterServices with ChangeNotifier {
  bool _loading = false;

  Future<dynamic> login(String phoneNumber) async {
    try {
      await Future.delayed(Duration(microseconds: 200));
      _loading = true;
      notifyListeners();

      Uri uri = Uri.parse(loginUrl);
      Map<String, String> header = {"Content-type": "application/json"};
      var body = '{"phone_no": "$phoneNumber"}';
      Response response = await post(uri, headers: header, body: body);
      var responseBody = json.decode(response.body);

      var data = responseBody;
      print('------------------------login data------------');
      print(data);
      // bool status = data['status'].toString().toLowerCase() == 'true';
      bool status = data['status'].toString() == 'true';
      String errorcode = data['errorcode'];
      String message = data['message'];
      if (message == 'success') {
        String uid;
        String fname;
        String lname;
        String mobile;
        String photourl;
        String email;
        String certificate;
        var userData = data['data'];
        uid = userData[0]['uid'];
        for (var u in userData) {
          if (u['key'] == 'fname') {
            fname = u['value'];
          }
          if (u['key'] == 'lname') {
            lname = u['value'];
          }
          if (u['key'] == 'mobile') {
            mobile = u['value'];
          }
          if (u['key'] == 'photourl') {
            photourl = u['value'];
          }
          if (u['key'] == 'email') {
            email = u['value'];
          }
          if (u['key'] == 'certificate') {
            certificate = u['value'];
          }
        }
        _loading = false;

        await saveDataToPreferences(
            uid, fname, lname, mobile, photourl, email, certificate);
      }
      //Save data to preferences
      return message;
    } catch (err) {
      print(err);
      return 500;
    }
  }

  Future<dynamic> signup(String uid, String phoneNumber, String email,
      String fname, String lname, String photoUrl) async {
    try {
      Uri uri = Uri.parse(registerUrl);
      Map<String, String> header = {"Content-type": "application/json"};
      var body =
          '{"uid":"$uid", "mobile": "$phoneNumber", "fname":"$fname", "lname": "$lname", "photourl":"$photoUrl", "email":"$email", "usertype":"trader"}';
      Response response = await post(uri, headers: header, body: body);
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        var data = responseBody;
        bool status = data['status'];
        String errorcode = data['errorcode'];
        if (status) {
          await saveDataToPreferences(
              uid, fname, lname, phoneNumber, photoUrl, email, '');
        }
        //Save data to preference
        return errorcode;
      }
      return response.statusCode;
    } catch (err) {
      return 500;
    }
  }

  Future<bool> saveDataToPreferences(String uid, String fname, String lname,
      String phoneNumber, String url, String email, String certificate) async {
    await SharedPreferenc().setUid(uid);

    await SharedPreferenc().setFName(fname);

    await SharedPreferenc().setLName(lname);

    await SharedPreferenc().setPhoneNumber(phoneNumber);
    SharedPreferenc().setPhotoUrl(url);
    SharedPreferenc().setEmail(email);
    SharedPreferenc().setCertificateNumber(certificate);
    return true;
  }

  bool getLoading() => _loading;
}
