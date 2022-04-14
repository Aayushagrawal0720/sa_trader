
import 'package:flutter/cupertino.dart';

class TriMarketWatchUiServices with ChangeNotifier {

  String title = "Calls";
  bool expanded = false;

  getTitle() => title;

  getExpanded() => expanded;

  setTitle() {
    if (expanded) {
      title = "MarketWatch";
      notifyListeners();
    }
    else {
      title = "Calls";
      notifyListeners();
    }
  }

  ExpandWidget(){
    expanded=!expanded;
    setTitle();
  }


}