import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/dataClasses/CallsClas.dart';
import 'package:http/http.dart';

class CallsPageService with ChangeNotifier {
  List<CallsClass> _targetHitCalls = [];
  List<CallsClass> _lossBookedCalls = [];

  List<CallsClass> _activeCalls = [];

  // List<CallsClass> _closedCalls = [];
  List<CallsClass> _pendingCalls = [];

  bool loading = true;
  List<String> ltpsP = [];
  List<String> ltpsA = [];
  List<String> ltpsC = [];

  List<bool> filter = [true, false, false];

  final DatabaseReference ref = FirebaseDatabase.instance.reference();

  setFilter(int index, String uid, String recordType) {
    filter.clear();
    filter = List.generate(2, (index) => false);
    filter[index] = true;
    refreshFunction(uid, recordType);
  }

  getFilter() => filter;

  setInitialValues() {
    loading = true;

    _activeCalls.clear();
    _pendingCalls.clear();
    // _closedCalls.clear();
    ltpsP.clear();
    ltpsA.clear();
    ltpsC.clear();
    notifyListeners();
  }

  refreshFunction(String uid, String recordType) async {
    await setInitialValues();
    await fetchCalls2(uid, recordType);
    return true;
  }

  fetchCalls2(String uid, String recordType) async {
    _activeCalls.clear();
    _pendingCalls.clear();
    // _closedCalls.clear();
    ltpsP.clear();
    ltpsA.clear();
    ltpsC.clear();

    String status = filter[0] ? 'Pending' : 'Active';

    var dUrl = Uri.parse(randomCalls);
    Map<String, String> header = {
      "Content-type": "application/json",
      "${Strings.uid}": "$uid",
      "${Strings.recordType}": "$recordType",
    };
    Response response = await get(
      dUrl,
      headers: header,
    );
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      bool status = responseData['status'];
      String message = responseData['message'];
      var data = responseData['data'];
      if (status) {
        _activeCalls.clear();
        _pendingCalls.clear();

        if (message == 'no record found') {
          loading = false;
          notifyListeners();
        } else {
          for (var d in data) {
            if (d[Strings.status].toString() != Cancelled &&
                d[Strings.status].toString() != Strings.targethit &&
                d[Strings.status].toString() != Strings.lossBooked) {
              String rawdate = d['date'];
              DateTime datee = DateTime.parse(rawdate);
              datee = datee.toLocal();
              String date = DateFormat("dd-MM-yyy hh:mm").format(datee);
              String bS = d[Strings.buySell].toString() == "0"
                  ? Strings.buy
                  : Strings.sell;

              var advisor = d['advisor'];
              getList(d[Strings.status].toString()).add(
                CallsClass(
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
                    time: datee,
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
                    visible: d['visible'] == null ? false : d['visible']),
              );

              // updateProfile(
              //     d[Strings.uid].toString(),
              //     getList(d[Strings.status].toString()),
              //     (getList(d[Strings.status].toString()).length - 1));
            }
          }
          _pendingCalls.sort((a, b) => b.time.compareTo(a.time));
          _activeCalls.sort((a, b) => b.time.compareTo(a.time));
          // _pendingCalls = _pendingCalls.reversed.toList();
          // _activeCalls = _activeCalls.reversed.toList();
          // _closedCalls = _closedCalls.reversed.toList();

          ltpsP = List.generate(_pendingCalls.length, (index) => "0.00");
          ltpsA = List.generate(_activeCalls.length, (index) => "0.00");
        }
      }

      // if (response.body != 'No record found') {
      //   var data = json.decode(response.body);
      //   _activeCalls.clear();
      //   _pendingCalls.clear();
      //   // _closedCalls.clear();
      //
      //   // ltpsC = List.generate(_closedCalls.length, (index) => "0.00");
      // }
      loading = false;
      notifyListeners();

      return response.body.toString();
    } else {
      return "false";
    }
  }

  List<CallsClass> getList(String status) {
    switch (status) {
      case Strings.pending:
        {
          return _pendingCalls;
        }
      case Strings.active:
        {
          return _activeCalls;
        }
      // case Strings.targethit:
      //   {
      //     return _closedCalls;
      //   }
      // case Strings.lossBooked:
      //   {
      //     return _closedCalls;
      //   }
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

  getLoading() => loading;

  getActiveCalls() => _activeCalls;

  // getClosedCall() => _closedCalls;

  getLossBooked() => _lossBookedCalls;

  getTargetHit() => _targetHitCalls;

  getPendingCalls() => _pendingCalls;
}
