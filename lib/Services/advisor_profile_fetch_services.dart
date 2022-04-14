import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:trader/Resources/keywords.dart';

class AdvisorProfileFetchServices with ChangeNotifier {
  refreshPage(String uid) async {
    await fetchHomeScreen(uid);
  }

  var _data;

  Future<String> fetchHomeScreen(String uid) async {
    Uri dUrl = Uri.parse(advisorcountprofile);
    Map<String, String> header = {
      "Content-type": "application/json",
    };
    String body = '{"aid":"$uid"}';
    Response response = await post(dUrl, headers: header, body: body);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      bool status = responseData['status'];
      String message = responseData['message'];

      if(status){
        _data = responseData['data'];
      }else{
        _data= 'false';
      }
      notifyListeners();
    } else {
      return "false";
    }
  }

  getData() => _data;
}
