import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:http/http.dart' as http;

class AnalysisTitleDetailService with ChangeNotifier {
  String _details;
  String _imgUrl;
  bool _isLoading = true;
  bool _error = false;

  fetchDetails(String title) async {
    await Future.delayed(Duration(milliseconds: 200));
    _isLoading = true;
    notifyListeners();

    Uri url = Uri.parse(gettitledeatils);
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', url);
    request.body = json.encode({"title": "$title"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseData = json.decode(await response.stream.bytesToString());
      bool status = responseData['status'];
      String message = responseData['message'];
      var data = responseData['data'];
      print('--------------------------------');
      print(data);
      if (status) {
        if (message != 'no record found') {
          var analysisData = data[0];
          _details = analysisData['description'];
          _imgUrl = analysisData['image'];
          _isLoading = false;
          _error = false;
        } else {
          _isLoading = false;
          _error = true;
        }
      } else {
        _isLoading = false;
        _error = true;
      }
      notifyListeners();
    } else {
      print(response.reasonPhrase);
    }
  }

  String getDetails() => _details;

  String getImg() => _imgUrl;

  bool isLoading() => _isLoading;

  bool getError() => _error;
}
