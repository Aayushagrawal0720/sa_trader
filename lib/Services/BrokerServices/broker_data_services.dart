import 'package:flutter/cupertino.dart';
import 'package:trader/sharedPrefrences/sharefPrefernces.dart';

class BrokerDataServices with ChangeNotifier {
  int status = 0; //0: Not logged in, 1: Logged in, 2: Some error
  String brokerName;
  String brokerUserName;
  String brokerUserId;
  String brokerUserEmail;

  fetchBrokerDataFromPreferences() {
    SharedPreferenc().getBrokerName().then((value) {
      this.brokerName = value;
    });
    SharedPreferenc().getBrokerUserName().then((value) {
      this.brokerUserName = value;
    });
    SharedPreferenc().getBrokerUserEmail().then((value) {
      this.brokerUserEmail = value;
    });
    SharedPreferenc().getBrokerUserId().then((value) {
      this.brokerUserId = value;
      _checkStatus();
    });
  }

  //Fetchdatafrompreferences and check and set status
  //sendValuesToFrontend
  setData(
    String brokerName,
    String brokerUserName,
    String brokerUserId,
    String brokerUserEmail,
  ) {
    SharedPreferenc().setBrokerName(brokerName);
    SharedPreferenc().setBrokerUserName(brokerUserName);
    SharedPreferenc().setBrokerUserEmail(brokerUserEmail);
    SharedPreferenc().setBrokerUserId(brokerUserId);
    this.brokerName = brokerName;
    this.brokerUserName = brokerUserName;
    this.brokerUserId = brokerUserId;
    this.brokerUserEmail = brokerUserEmail;
    _checkStatus();
  }

  _checkStatus() {
    if (this.brokerUserId == null &&
        this.brokerUserEmail == null &&
        this.brokerUserName == null &&
        this.brokerName == null) {
      status = 0;
    } else if (this.brokerUserId == null ||
        this.brokerUserEmail == null ||
        this.brokerUserName == null ||
        this.brokerName == null) {
      status = 2;
    } else {
      status = 1;
    }
    notifyListeners();
  }

  getBrokerName() => brokerName;

  getBrokerUserName() => brokerUserName;

  getBrokerUserEmail() => brokerUserEmail;

  getBrokerUserId() => brokerUserId;

  getStatus()=>status;
}
