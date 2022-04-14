import 'dart:convert';
import 'package:trader/Resources/keywords.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:http/http.dart';

class TriMarketWatchLtpService with ChangeNotifier {
  final instance = FirebaseDatabase.instance.reference();

  String _apiKey;
  String _accessToken;

  SocketIO socketIO;

  // String id;

  String nifty50LTP = "0.0";
  String bankNiftyLtp = "0.0";
  String sensexLtp = "0.0";

  String nifty50Percent = "0.0";
  String bankNiftyPercent = "0.0";
  String sensexPercent = "0.0";

  String nifty50Diff = "0.0";
  String bankNiftyDiff = "0.0";
  String sensexDiff = "0.0";

  bool nifty50Pro = true;
  bool bankNiftyPro = true;
  bool sensexPro = true;

  Set<int> _instrumentList = {};

  Map its = Map();

  Future<SocketIO> init() async {
    SocketIOManager().destroyAllSocket();
    // id = await PlatformDeviceId.getDeviceId;
    //Creating the socket
    socketIO = SocketIOManager().createSocketIO(websocketUrl, '/',
        socketStatusCallback: (status) {
      if (status.toString() == "connect") {
        socketIO.sendMessage("socket request", jsonEncode({"id": 'id'}));
      }
    });
    //Call init before doing anything with socket
    socketIO.init();
    socketIO.subscribe("tri_ltp", (data) {
      setTicker(data);
    });

    socketIO.connect();
    // fetchAccessToken();
  }

  subscribe(String it) {
    if (!_instrumentList.contains(it)) {
      socketIO.sendMessage('ltp', jsonEncode({"it": it}));
      socketSub(it);
    }
  }

  socketSub(String it) {
    socketIO.subscribe(it, (fData) {
      var jData = json.decode(fData);
      for (var data in jData) {
        var it = data["instrument_token"];
        var ltp = data["last_price"];

        its[it.toString()] = ltp.toString();
        notifyListeners();
      }
    });
  }

  // fetchAccessToken() async {
  //   instance.child('Access_token').once().then((value) {
  //     _accessToken = value.value['access_token'].toString();
  //   }).catchError((err) {
  //     print(err);
  //   });
  //
  //   instance.child('api_key').once().then((value) {
  //     _apiKey = value.value['api_key'].toString();
  //   }).catchError((err) {
  //     print(err);
  //   });
  // }

  setTicker(var data) {
    var dat = json.decode(data);
    var da = dat[0];
    var it = da["instrument_token"];
    var ltp = da["last_price"];
    var change = da["change"];
    var ohlc = da["ohlc"];
    var closed = ohlc["close"];
    double diff =
        double.parse(ltp.toString()) - double.parse(closed.toString());

    if (it == 256265) {
      nifty50LTP = ltp.toString();
      if (double.parse(change.toString()).isNegative) {
        nifty50Pro = false;
      }
      nifty50Percent = double.parse(change.toString()).toStringAsPrecision(3);
      nifty50Diff = diff.toStringAsFixed(2);
      notifyListeners();
    }
    if (it == 260105) {
      bankNiftyLtp = ltp.toString();
      if (double.parse(change.toString()).isNegative) {
        bankNiftyPro = false;
      }
      bankNiftyPercent = double.parse(change.toString()).toStringAsPrecision(3);
      bankNiftyDiff = diff.toStringAsFixed(2);
      notifyListeners();
    }
    if (it == 265) {
      sensexLtp = ltp.toString();
      if (double.parse(change.toString()).isNegative) {
        sensexPro = false;
      }
      sensexPercent = double.parse(change.toString()).toStringAsPrecision(3);
      sensexDiff = diff.toStringAsFixed(2);
      notifyListeners();
    }
  }

  fetchBrokerLtp(String it, String exchange, String tradingsymbol) async {
    Uri url = Uri.parse(getserverltp);
    Map<String, String> header = {
      "Content-type": "application/json",
      "ts": "$tradingsymbol",
    };

    Response response = await get(url, headers: header);
    if (response.statusCode == 200) {
      var resData = json.decode(response.body);
      if(resData.length>0) {
        if (resData[0] != null) {
          its[it] = resData[0]['ltp'];
          notifyListeners();
        }
        else {
          its[it] = '0.0';
          notifyListeners();
        }
      }
    }
  }

  getNormalLtp(String it) {
    return its[it];
  }

  getNifty50() => nifty50LTP;

  getBankNiftyLtp() => bankNiftyLtp;

  getSensexLtp() => sensexLtp;

  getNifty50Per() => nifty50Percent;

  getBankNiftyPer() => bankNiftyPercent;

  getSensexPer() => sensexPercent;

  getNifty50Pro() => nifty50Pro;

  getBankNiftyPro() => bankNiftyPro;

  getSensexPro() => sensexPro;

  getNifty50Diff() => nifty50Diff;

  getBankNiftyDiff() => bankNiftyDiff;

  getSensexDiff() => sensexDiff;
}
