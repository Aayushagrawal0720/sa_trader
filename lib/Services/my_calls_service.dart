import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/dataClasses/CallsClas.dart';
import 'package:http/http.dart';
import 'dart:developer' as developer;

class MyCallsService with ChangeNotifier {
  List<CallsClass> _calls = List();
  List<String> ltps;
  bool loading = true;
  String filterCode = Strings.all_call;
  final instance = FirebaseDatabase.instance.reference();
  List<bool> filter = [true, false, false];

  //FILTER
  setFilter(String code, String uid) {
    switch (code) {
      case Strings.all_call:
        {
          filterCode = Strings.all_call;
          loading = true;
          notifyListeners();
          fetchCalls2(uid);

          break;
        }
      case Strings.ap_call:
        {
          filterCode = Strings.ap_call;
          loading = true;
          notifyListeners();
          fetchCalls2(uid);

          break;
        }
      case Strings.closed_call:
        {
          filterCode = Strings.closed_call;
          loading = true;
          notifyListeners();
          fetchCalls2(uid);

          break;
        }
    }
  }

  getSelectedFilter() => filterCode;

  getLtp(String cid, int index) {
    instance.child("Calls").child(cid).child("ltp").onValue.listen((event) {
      updateList(index, event.snapshot.value.toString());
    });
  }

  updateList(int index, String value) {
    ltps[index] = value;
    notifyListeners();
  }

  getLtps(int index) {
    return ltps[index];
  }

  refreshFunction(String uid) async {
    ltps.clear();
    _calls.clear();
    loading = true;
    notifyListeners();
    await fetchCalls2(uid);
    return;
  }

  fetchCalls2(String uid) async {
    Uri dUrl = Uri.parse(tradercalls);
    Map<String, String> header = {
      "Content-type": "application/json",
    };
    String body = '{"uid": "$uid","${Strings.status}": "$filterCode"}';
    Response response = await post(dUrl, headers: header, body: body);
    // StreamedRequest request = StreamedRequest('POST', Uri.parse(dUrl))
    //     ..headers.addAll(header);
    //
    // StreamedResponse res = await request.send();
    // res.stream.listen((value) {
    //
    // });
    if (response.statusCode == 200) {
      try {
        var responseData = json.decode(response.body);
        bool status = responseData['status'];
        String message = responseData['message'];
        var data = responseData['data'];
        if (status) {
          if (message == "no record found") {
            loading = false;
            notifyListeners();
          } else {
            _calls.clear();
            for (var d in data) {
              var serDate = d[Strings.date].toString();
              // int timestamp = int.parse(d[Strings.date].toString());
              DateTime dateU = DateTime.parse(serDate).toLocal();
              // DateTime dateU =
              //     DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
              String date = DateFormat('hh:mm | dd-MM-yyyy').format(dateU);
              var advisor = d['advisor'];
              _calls.add(CallsClass(
                  cid: d[Strings.cid].toString(),
                  uid: d[Strings.uid].toString(),
                  intra_cnc: d[Strings.recordType].toString(),
                  equityDerivative: d[Strings.subRecordType].toString(),
                  status: d[Strings.status].toString(),
                  uname: advisor[Strings.fname].toString() +
                      ' ' +
                      advisor[Strings.lname].toString(),
                  uUrl: advisor[Strings.url] == null
                      ? personImage
                      : advisor[Strings.url],
                  scriptName: d[Strings.scriptname].toString(),
                  aacuracy: advisor[Strings.aaccuracy].toString() + '%',
                  time: dateU,
                  buySell: d[Strings.tradetype].toString(),
                  entryPrice: d[Strings.entryPrice].toString(),
                  target: d[Strings.target0],
                  target1: d[Strings.target1],
                  sl: d[Strings.sl0],
                  sl1: d[Strings.sl1],
                  closedPercentage: d['closedpercentage'].toString(),
                  it: d[Strings.instrument_token],
                  analysisImageUrl: d[Strings.analysisImageUrl] != null
                      ? d[Strings.analysisImageUrl]
                      : "",
                  analysisTitle: d[Strings.analysisTitle] != null
                      ? d[Strings.analysisTitle]
                      : "",
                  description: d[Strings.description] != null
                      ? d[Strings.description]
                      : "",
                  exchange:
                      d[Strings.exchange] != null ? d[Strings.exchange] : "",
                  visible: d['visible'] == null ? false : d['visible']));
            }
            _calls.sort((a, b) => b.time.compareTo(a.time));

            ltps = List.generate(_calls.length, (index) => "0.00");
            loading = false;
            notifyListeners();
          }
        } else {
          return "false";
        }
      } catch (e) {
        print(
            "--------------------------------MAY CALLS SERVICE: FETCH CALLS 2-----------------------");
        print(e);
        return "false";
      }

      return response.body.toString();
    } else {
      return "false";
    }
  }

  updateProfile(String uid, List<CallsClass> list, int index) {
    FirebaseDatabase.instance
        .reference()
        .child("/admin/Users/$uid")
        .once()
        .then((event) async {
      var proff = event.value;
      list[index].uname = proff[Strings.name];
      list[index].uUrl = proff[Strings.url];

      list[index].aacuracy = proff[Strings.accuracy] == null
          ? "0%"
          : "${proff[Strings.accuracy]}%";
      await Future.delayed(Duration(milliseconds: 200));
      notifyListeners();
    });
  }

  getCalls() => _calls;

  getLoading() => loading;
}
