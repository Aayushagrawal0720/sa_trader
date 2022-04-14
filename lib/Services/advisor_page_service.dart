import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/dataClasses/AdvisorClass.dart';
import 'package:http/http.dart';
import 'dart:developer' as dev;

String _devLog = "Advisor Page Services";

class AdviserPageService with ChangeNotifier {
  List<AdvisorClass> _slist = List();
  List<AdvisorClass> _ulist = List();
  bool sloading = true;
  bool rloading = true;

  int index = 0;

  getsLoading() => sloading;

  getrLoading() => rloading;

  refreshFunction(String uid) async {
    await setInitialValues();
    await fetchAdviser(uid);
    // await fetchSubAdviser(uid);
  }

  setInitialValues() {
    _slist.clear();
    sloading = true;

    _ulist.clear();
    rloading = true;
    notifyListeners();
  }

  // fetchSubAdviser(String uid) async {
  //   _slist.clear();
  //
  //   Uri dUrl = Uri.parse("subsAdviser");
  //   Map<String, String> header = {
  //     "Content-type": "application/json",
  //     "tid": "$uid"
  //   };
  //   Response response = await get(
  //     dUrl,
  //     headers: header,
  //   );
  //
  //   if (response.statusCode == 200) {
  //     try {
  //       if (response.body.toString() != Strings.no_subscribed_adviser) {
  //         var data = json.decode(response.body);
  //         _slist.clear();
  //
  //         for (var d in data) {
  //           _slist.add(AdvisorClass(
  //               uid: d[Strings.uid],
  //               name: d[Strings.name],
  //               url: d[Strings.url],
  //               // certificateNumber: "32qtwefwqr4rweqrf",
  //               accuracy: d[Strings.accuracy] == null
  //                   ? "0%"
  //                   : d[Strings.accuracy].toString(),
  //               activeCalls: "Loading...",
  //               targethit: "Loading...",
  //               lossBooked: "Loading...",
  //               closedCall: "Loading...",
  //               subscribers: "Loading...",
  //               subscribed: true));
  //
  //           updateProfile(_slist, _slist.length - 1, d[Strings.uid].toString());
  //         }
  //       }
  //       sloading = false;
  //       notifyListeners();
  //     } catch (e) {
  //       print(e);
  //       return "false";
  //     }
  //
  //     return response.body.toString();
  //   } else {
  //     return "false";
  //   }
  // }

  fetchAdviser(String uid) async {
    _ulist.clear();

    Uri dUrl = Uri.parse(analyst);
    Map<String, String> header = {
      "Content-type": "application/json",
      "tid": "$uid",
      "subscribed": ""
    };
    Response response = await get(
      dUrl,
      headers: header,
    );
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      bool status = responseData['status'];
      String message = responseData['message'];
      if (status) {
        var advisorData = responseData['data'];
        var subscribed = advisorData['subscribed'];
        var random = advisorData['random'];

        if (message != "No Advisors Present") {
          _ulist.clear();
          _slist.clear();

          if (random.length > 0) {
            Map<String, dynamic> _userMap = {};

            for (var d in random) {
              if (d['uid'] != null) {
                _userMap[d['uid']] = {"uid": "${d['uid']}"};
              }
            }
            for (var d in random) {
              if (d['uid'] != null) {
                Map<String, dynamic> _temp =
                    _userMap[d['uid']] as Map<String, dynamic>;
                _temp[d['key']] = d['value'].toString();
              }
              if (d['vid'] != null) {
                if (d['key'] == 'uid') {
                  String uid = d['value'];
                  Map<String, dynamic> _temp =
                      _userMap[uid] as Map<String, dynamic>;
                  _temp['vid'] = d['vid'];
                }
              }
            }

            for (var d in _userMap.values) {
              print(d);
              _ulist.add(AdvisorClass(
                  uid: d[Strings.uid],
                  name: d[Strings.fname] + ' ' + d[Strings.lname],
                  url: d[Strings.url] == null ? personImage : d[Strings.url],
                  // certificateNumber: "32qtwefwqr4rweqrf",
                  accuracy: d["accuracy"] == null
                      ? "0%"
                      : "${d["accuracy"].toString()}%",
                  activeCalls: "Loading...",
                  targethit: "Loading...",
                  lossBooked: "Loading...",
                  closedCall: "Loading...",
                  subscribers: "Loading...",
                  current_subscribers: "Loading...",
                  subscribed: false));
              updateProfile(
                  _ulist, _ulist.length - 1, d[Strings.uid].toString());
            }
          }
          if (subscribed.length > 0) {
            Map<String, dynamic> _userMap = {};

            for (var d in subscribed) {
              if (d['uid'] != null) {
                _userMap[d['uid']] = {"uid": "${d['uid']}"};
              }
            }
            for (var d in subscribed) {
              if (d['uid'] != null) {
                Map<String, dynamic> _temp =
                    _userMap[d['uid']] as Map<String, dynamic>;
                _temp[d['key']] = d['value'].toString();
              }
              if (d['vid'] != null) {
                if (d['key'] == 'uid') {
                  String uid = d['value'];
                  Map<String, dynamic> _temp =
                      _userMap[uid] as Map<String, dynamic>;
                  _temp['vid'] = d['vid'];
                }
              }
            }

            for (var d in _userMap.values) {
              _slist.add(AdvisorClass(
                  uid: d[Strings.uid],
                  name: d[Strings.fname] + ' ' + d[Strings.lname],
                  url: d[Strings.url] == null ? personImage : d[Strings.url],
                  // certificateNumber: "32qtwefwqr4rweqrf",
                  accuracy: d["accuracy"] == null
                      ? "0%"
                      : "${d["accuracy"].toString()}%",
                  activeCalls: "Loading...",
                  targethit: "Loading...",
                  lossBooked: "Loading...",
                  closedCall: "Loading...",
                  subscribers: "Loading...",
                  current_subscribers: "Loading...",
                  subscribed: true));
              updateProfile(
                  _slist, _slist.length - 1, d[Strings.uid].toString());
            }
          }

          // _ulist.sort((ab, b) => int.parse(b.accuracy.replaceAll("%", ""))
          //     .compareTo(int.parse(ab.accuracy.replaceAll("%", ""))));
        }
      }

      rloading = false;
      sloading = false;
      notifyListeners();

      return response.body.toString();
    } else {
      return "false";
    }
  }

  updateProfile(List<AdvisorClass> list, int index, String uid) async {
    Uri dUrl = Uri.parse(advisorcountprofile);
    Map<String, String> header = {
      "Content-type": "application/json",
    };
    String body = '{"aid":"$uid"}';
    Response response = await post(dUrl, headers: header, body: body);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      bool status = responseData['status'];
      String message = responseData['message'];
      var data = responseData['data'];
      list[index].subscribers = data[Strings.subscribersCount].toString();
      list[index].current_subscribers =
          data[Strings.current_subscribers].toString();
      list[index].activeCalls = data[Strings.activeCalls].toString();
      list[index].targethit = data[Strings.closedCallsWithProfit].toString();
      list[index].lossBooked = data[Strings.closedCallsWithloss].toString();
      list[index].closedCall =
          (int.parse(list[index].targethit) + int.parse(list[index].lossBooked))
              .toString();

      notifyListeners();
    } else {
      return "false";
    }
  }

  getAdvisers(bool subscribed) {
    if (subscribed) return _slist;
    return _ulist;
  }

  setIndex(int ind) {
    index = ind;
    notifyListeners();
  }

  getIndex() => index;
}
