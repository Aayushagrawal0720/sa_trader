import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:trader/Resources/keywords.dart';

class PaymentService with ChangeNotifier {
  static const String none = "none";
  static const String waiting = "waiting";
  static const String success = "success";
  static const String failed = "failed";
  static const String redeemed = "redeemed";
  static const String wrong = "wrong";

  //none: no code request  | waiting: request has been send to user | success: successfully added coupon amount to wallet | failed: Failed to add money
  //redeemed: coupon already redeemed | wrong: wrong coupon code
  String couponPaymentStatus = none;

  addMoneyToWallet(String uid, String amount, String status, String type,
      String dfrom, String gateway_result) async {
    try {
      Uri url = Uri.parse(addmoney);
      Map<String, String> header = {"Content-type": "application/json"};
      String body =
          '{"uid":"$uid", "amount":"$amount", "status":"$status", "type":"$type", "dfrom":"$dfrom", "gateway_result":"$gateway_result"}';
      Response response = await post(url, headers: header, body: body);
      if (response.statusCode == 200) {
        var dat = json.decode(response.body);
        bool status = dat['status'];
        return status;
      }
      return false;
    } catch (e) {
      print(e);

      return false;
    }
  }

  sendErrorPaymentToServer(
      PaymentFailureResponse res, String uid, int amount, String status) async {
    Uri dUrl = Uri.parse('addBalance');
    var headers = {
      'tid': uid,
      'oid': res.message,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var request = http.Request('POST', dUrl);
    request.bodyFields = {'amount': amount.toString(), 'status': status};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  getCOuponStatus() => couponPaymentStatus;

  setCouponStatus() async{
    await Future.delayed(Duration(milliseconds: 200));
    couponPaymentStatus = none;
    notifyListeners();
  }

  payThroughCoupon(String uid, String couponData) async {
    Uri url = Uri.parse('couponPayment');
    var headers = {
      'tid': uid,
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    var data = jsonDecode(couponData);
    Map<String, String> body = {
      'code': data['code'].toString(),
      'amount': data['amount'].toString(),
      'offerid': data['offerid'].toString(),
      'vid': data['vid'].toString(),
    };

    var request = http.Request('POST', url);
    request.bodyFields = body;
    request.headers.addAll(headers);

    couponPaymentStatus = waiting;
    notifyListeners();

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final st = await response.stream.bytesToString();
      switch (st) {
        case 'redeemed':
          {
            couponPaymentStatus = redeemed;
            notifyListeners();
            break;
          }
        case 'done':
          {
            couponPaymentStatus = success;
            notifyListeners();
            break;
          }
        case 'wrong':
          {
            couponPaymentStatus = failed;
            notifyListeners();
            break;
          }
      }
    }
  }
}
