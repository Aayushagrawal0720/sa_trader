import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:trader/Resources/keywords.dart';

class AnalysisTextService with ChangeNotifier {
  List<String> _texts = [];
  List<String> _tempTexts = [];

  bool _isLoading = false;

  String _selected;

  setSelected(String selected) {
    _selected = selected;
    notifyListeners();
  }

  fetchData() async {
    await Future.delayed(Duration(microseconds: 200));
    _isLoading = true;

    _texts.clear();
    _tempTexts.clear();
    Uri url = Uri.parse(analysisText);
    Response response = await get(url);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      bool status = responseData['status'];
      String message = responseData['message'];
      var data = responseData['data'];
      if (status) {
        for (var d in data) {
          _tempTexts.add(d['title']);
          _texts.add(d['title']);
        }
        _selected = _texts.first;
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  searchTitle(String search) {
    List<String> _title = _tempTexts;
    _texts.clear();
    _title.forEach((element) {
      if (element.toLowerCase().contains(search.toLowerCase())) {
        _texts.add(element);
      }
    });
    notifyListeners();
  }

  bool isLoading() => _isLoading;

  List<String> texts() => _texts;

  String getSelectedText() => _selected;
}
