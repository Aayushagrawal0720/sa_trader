import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trader/widgets/BrokerListHomePage.dart';
import 'package:trader/widgets/BrokerLoginPage.dart';

class BrokerLoginUiServices with ChangeNotifier {
  static const String home = "home"; // brokers list
  static const String five_paisa = "5paisa"; // 5paisa login page

  Widget page = BrokerListHomePage();

  // setUIPage(String page, {BuildContext context}) {
  //   print("called");
  //   switch (page) {
  //     case home:
  //       {
  //         this.page = BrokerListHomePage();
  //         notifyListeners();
  //         break;
  //       }
  //     case five_paisa:
  //       {
  //         this.page = BrokerLoginPage("5paisa");
  //         notifyListeners();
  //         break;
  //       }
  //   }
  // }

  getPage() => page;
}
