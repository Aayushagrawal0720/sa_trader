import 'dart:convert';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trader/Resources/Color.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/Services/trimarketwatch_ltp_service.dart';
import 'package:trader/Services/trimartketwatch_ui_services.dart';

class TriMarketWatch extends StatefulWidget {
  int index;

  TriMarketWatch(this.index);

  @override
  TriMarketWatchState createState() => TriMarketWatchState();
}

class TriMarketWatchState extends State<TriMarketWatch>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  SocketIO socketIO;

  @override
  void initState() {
    super.initState();

    var triService =
        Provider.of<TriMarketWatchLtpService>(context, listen: false);

    _controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);

    //Creating the socket
    // socketIO = SocketIOManager().createSocketIO(
    //     'http://15.207.48.223:3300', '/',
    //     socketStatusCallback: (status) {});
    //Call init before doing anything with socket
    // socketIO.init();

    triService.init();

    // socketIO.connect();
  }

  Widget ColumnList() {
    return Consumer<TriMarketWatchLtpService>(
        builder: (context, snapshot, child) {
      return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "NIFTY 50",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                    Text(
                      "${snapshot.getNifty50()}",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Row(
                      children: [
                        Text(
                          snapshot.getNifty50Diff(),
                          style: TextStyle(
                              color: snapshot.getSensexPro()
                                  ? Colors.green
                                  : Colors.red),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: snapshot.getNifty50Pro()
                                        ? Colors.green
                                        : Colors.red),
                                children: [
                              TextSpan(text: snapshot.getNifty50Per()),
                              TextSpan(text: "%")
                            ])),
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "NIFTY BANK",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                    Text(
                      "${snapshot.getBankNiftyLtp()}",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Row(
                      children: [
                        Text(
                          snapshot.getBankNiftyDiff(),
                          style: TextStyle(
                              color: snapshot.getBankNiftyPro()
                                  ? Colors.green
                                  : Colors.red),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: snapshot.getBankNiftyPro()
                                        ? Colors.green
                                        : Colors.red),
                                children: [
                              TextSpan(
                                text: snapshot.getBankNiftyPer(),
                              ),
                              TextSpan(text: "%")
                            ])),
                      ],
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SENSEX",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                ),
                Text(
                  "${snapshot.getSensexLtp()}",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      snapshot.getSensexDiff(),
                      style: TextStyle(
                          color: snapshot.getSensexPro()
                              ? Colors.green
                              : Colors.red),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: snapshot.getSensexPro()
                                    ? Colors.green
                                    : Colors.red),
                            children: [
                          TextSpan(text: snapshot.getSensexPer()),
                          TextSpan(text: "%")
                        ])),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = "";
    switch (widget.index) {
      case 0:
        {
          title = tradingOpportunities;
          break;
        }
      case 1:
        {
          title = exploreAdvisor;
          break;
        }
      case 2:
        {
          title = profile;
          break;
        }
    }
    return Consumer<TriMarketWatchUiServices>(
        builder: (context, snapshot, child) {
      return Container(
        decoration: snapshot.getExpanded()
            ? BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.grey, blurRadius: 12, offset: Offset(0, 3))
              ])
            : BoxDecoration(color: ColorsTheme.offWhite),
        child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      child: RotationTransition(
                        turns: Tween(begin: 0.0, end: 0.5).animate(_controller),
                        child: Icon(Icons.keyboard_arrow_down,
                            size: 32, color: Colors.black),
                      ),
                      onTap: () {
                        snapshot.getExpanded()
                            ? _controller.reverse()
                            : _controller.forward();
                        snapshot.ExpandWidget();
                      },
                    )
                  ],
                ),
                snapshot.getExpanded() ? ColumnList() : Container(),
                SizedBox(
                  height: 10,
                )
              ],
            )),
      );
    });
  }
}
