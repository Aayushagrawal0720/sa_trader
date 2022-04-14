import 'package:flutter/cupertino.dart';

class PackageSelectorInternalPayamentPageService with ChangeNotifier{
  int selectedPackage = 0;

  setSelectedpackage(int package) {
    selectedPackage = package;
    notifyListeners();
  }

  getSelectedpackage() => selectedPackage;

  resetPackageSelection(){
    selectedPackage=0;
    notifyListeners();
  }
}