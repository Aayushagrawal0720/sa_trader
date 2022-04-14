import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/dataClasses/AdvisorClass.dart';
import 'package:trader/dataClasses/CallsClas.dart';
import 'dart:developer' as dev;

class AdvisorCallsService with ChangeNotifier {
  String title;
  List<CallsClass> _calls = [];
  List<String> ltps;
  String _message = '';

  final instance = FirebaseDatabase.instance.reference();

  refreshFunction(String tid, AdvisorClass advisor) async {
    _calls.clear();
    ltps.clear();
    notifyListeners();
    await fetchCalls2(tid, advisor);
  }

  getLtp(String cid, int index, String tid) {
    try {
      instance.child("Calls").child(cid).child("ltp").onValue.listen((event) {
        var ltp = event.snapshot.value.toString();
        if (ltp == "null") {
          ltp = '0.0';
        }
        updateList(index, ltp, cid);
      });
    } catch (err) {
      print(err);
    }
  }

  updateList(int index, String value, String cid) {
    try {
      if (cid == _calls[index].cid) {
        ltps[index] = value;
        notifyListeners();
      }
    } catch (err) {
      print(err);
    }
  }

  getLtps(int index) {
    return ltps[index];
  }

  setTitle(String _title) {
    title = _title;
    notifyListeners();
  }

  getTitle() => title;

  fetchCalls2(String tid, AdvisorClass advisor) async {
    await Future.delayed(Duration(milliseconds: 200));
    _calls.clear();
    notifyListeners();

    Uri dUrl = Uri.parse(calls);
    Map<String, String> header = {
      "Content-type": "application/json",
    };
    title.replaceAll(" Calls", "");
    String bodyData =
        '{"${Strings.status}":"$title","${Strings.uid}": "${advisor.uid}","tid": "$tid"}';
    Response response = await post(dUrl, headers: header, body: bodyData);
    if (response.statusCode == 200) {
      try {
        var responseData = json.decode(response.body);
        bool status = responseData['status'];
        if (status) {
          String message = responseData['message'];
          if (message == 'No record found') {
            _message = 'No record found';
            notifyListeners();
          } else {
            var data = responseData['data'];
            for (var d in data) {
              var serDate = d[Strings.date].toString();
              // int timestamp = int.parse(d[Strings.date].toString());
              DateTime dateU = DateTime.parse(serDate).toLocal();
              // DateTime dateU =
              //     DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
              String date = DateFormat('hh:mm | dd-MM-yyyy').format(dateU);

              _calls.add(CallsClass(
                  cid: d[Strings.cid].toString(),
                  uid: d[Strings.uid].toString(),
                  intra_cnc: d[Strings.recordType].toString(),
                  equityDerivative: d[Strings.subRecordType].toString(),
                  status: d[Strings.status].toString(),
                  uname: advisor.name,
                  uUrl: advisor.url,
                  scriptName: d[Strings.scriptname].toString(),
                  aacuracy: advisor.accuracy,
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
            _message = '';
          }
          notifyListeners();
        } else {
          _message = 'error';
          notifyListeners();
        }
      } catch (e) {
        print(e);

        _message = 'error';
        notifyListeners();
      }
    } else {
      _message = 'error';
      notifyListeners();
    }
  }

  getCalls() => _calls;

  getMessage() => _message;
}
