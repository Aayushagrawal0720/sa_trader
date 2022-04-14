import 'dart:io';

import 'package:flutter/cupertino.dart';

class FullAnalysisImageService with ChangeNotifier {
  bool _fullScreen = false;
  bool _landscape=false;
  Image _imgFile;

  setFullScreen(bool fullScreen) {
    this._fullScreen = fullScreen;
    notifyListeners();
  }

  setOrientation(bool landscape) {
    _landscape=landscape;
    notifyListeners();
  }

  setImgFile(Image file){
    _imgFile=file;
    notifyListeners();
  }

  Image getImgFile()=>_imgFile;

  getOrientation()=>_landscape;

  getFullScreen() => _fullScreen;
}
