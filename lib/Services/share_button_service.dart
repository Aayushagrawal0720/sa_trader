import 'package:flutter/cupertino.dart';

class ShareButtonService with ChangeNotifier {
  bool sharing = false;
  int index;

  setSharingMode(bool share, int ind) {
    sharing = share;
    index = ind;
    notifyListeners();
  }

  getSharingMode() {
    return {sharing, index};
  }
}
