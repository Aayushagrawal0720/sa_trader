import 'package:flutter/cupertino.dart';

class CouponOperationService with ChangeNotifier {
  double _result = 0;

  getCouponOperator(double amount, {String operation, double value}) async {
    await Future.delayed(Duration(milliseconds: 200));
    if (operation == null) {
      _result = amount;
      notifyListeners();
    } else {
      if (operation == 'per') {
        double temp = (amount / 100) * value;
        _result = amount - temp;
        notifyListeners();
      }
    }
  }

  getResult() => _result;
}
