import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/dataClasses/Coupons.dart';
import 'package:trader/dataClasses/PackageDataClass.dart';
import 'package:http/http.dart';

class InternalPaymentPageServices with ChangeNotifier {
  bool error = false;
  List<PackageDataClass> _subscriptionPackage = [];
  List<PackageDataClass> _singleCallPackage = [];
  List<Coupons> _coupons = [];

  // int selectedPackage = 0;
  bool loadingPackage = true;

  bool paymentButtonVisibilty = false;

  getLoading() => loadingPackage;

  // getSelectedpackage() => selectedPackage;

  // setSelectedpackage(int package) {
  //   selectedPackage = package;
  //   notifyListeners();
  // }

  getPdc() => error ? "error" : _subscriptionPackage;

  getSinglePdc() => error ? "error" : _singleCallPackage;

  setInitialValues() {
    error = false;
    _subscriptionPackage.clear();
    // selectedPackage = 0;
    loadingPackage = true;
    notifyListeners();
  }

  getPackageDataFromServer(String uid) async {
    Uri dUrl = Uri.parse(get_package);
    Map<String, String> header = {
      "Content-type": "application/json",
      "${Strings.uid}": "$uid"
    };
    String body = '{"aid":"$uid", "analyst":false}';
    final response = await post(dUrl, headers: header, body: body);
    if (response.statusCode == 200) {
      try {
        _subscriptionPackage.clear();
        _singleCallPackage.clear();

        var responseData = json.decode(response.body);
        bool status = responseData['status'];
        String message = responseData['message'];
        var data = responseData['data'];
        var packageData = data['packages'];
        var discount = data['discount'];
        if (status) {
          if (message == 'no package found') {
            error = false;
            loadingPackage = false;
            notifyListeners();
          } else {
            for (var v in packageData) {
              String packageStatus = v['status'];
              if (packageStatus == 'active') {
                String duration = v['duration'];
                if (duration == 'One call') {
                  _singleCallPackage.add(PackageDataClass(
                      title: duration,
                      duration: duration,
                      pamt: v['amount'],
                      pid: v['pid']));
                } else {
                  _subscriptionPackage.add(PackageDataClass(
                      title: duration,
                      duration: duration,
                      pamt: v['amount'],
                      pid: v['pid']));
                }
              }
            }

            for (var d in discount) {
              print(d);
              print(d['application_state']);
              print(d['enddate']);
              if (d['application_state'] == 'default' && d['enddate'] == null) {
                print('---------------------');
                _coupons.add(Coupons(
                    id: d['id'].toString(),
                    key: d['key'],
                    value: d['value'].toString(),
                    operations: d['operation'],
                    status: d['status'],
                    enddate: d['enddate'],
                    application_state: d['application_state']));

                print('length: ${_coupons.length}');
              }
            }

            error = false;
            loadingPackage = false;
            notifyListeners();
          }
        } else {
          error = true;
          loadingPackage = false;
          notifyListeners();
        }
      } catch (e) {
        loadingPackage = false;
        notifyListeners();
      }
    } else {
      error = true;
    }
  }

  sendTransactionToServer(String uid, String tid, String cid, String pid,
      bool isCall, double amount) async {
    Uri dUrl = Uri.parse(purchasepackage);
    String body;
    Map<String, String> header = {
      "Content-type": "application/json",
    };

    if (isCall) {
      body =
          '{"${Strings.aid}": "$uid","${Strings.pid}": "$pid","${Strings.uid}": "$tid","${Strings.cid}": "$cid","${Strings.amount}": "$amount"}';
    } else {
      body =
          '{"${Strings.aid}": "$uid","${Strings.pid}": "$pid","${Strings.uid}": "$tid","${Strings.amount}": "$amount"}';
    }
    final response = await post(dUrl, headers: header, body: body);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      bool status = responseData['status'];
      String message = responseData['message'];
      return message;
    } else {
      return "false";
    }
  }

  setVisibility(bool visibility) {
    paymentButtonVisibilty = visibility;
    notifyListeners();
  }

  getVisibility() => paymentButtonVisibilty;

  getCoupons() => _coupons;
}
