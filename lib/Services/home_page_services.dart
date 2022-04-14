import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:http/http.dart';
import 'package:trader/sharedPrefrences/sharefPrefernces.dart';

class HomePageServices with ChangeNotifier{
  sendTokenToServer(String token, String uid) async {
    Uri url = Uri.parse(sendNotiToken);
    Map<String, String> headers = {
      "Content-type": "application/json",
      "${Strings.tid}": "$uid"
    };
    String jsond = '{"${Strings.token}": "$token"}';

    Response response = await post(url, headers: headers, body: jsond);
    if (response.statusCode == 200) {
    } else {
      sendTokenToServer(token, uid);
    }
  }

  Future<dynamic> checkUserUid() async {
    String uid = await SharedPreferenc().getUid();
    var dUrl = Uri.parse(checkUid);
    Map<String, String> header = {
      "Content-type": "application/json",
      "${Strings.uid}": "$uid"
    };
    String body = '{"uid":"$uid", "usertype":"advisor"}';
    Response response = await post(
        dUrl,
        headers: header,
        body: body
    );
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      bool status = responseData['status'];
      String message = responseData['message'];
      if(message=='user not found'){
        FirebaseAuth.instance.signOut();
      }
      return message;
    } else {
      return false;
    }
  }

}