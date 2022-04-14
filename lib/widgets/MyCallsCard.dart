import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shape_of_view/shape_of_view.dart';
import 'package:trader/Resources/Color.dart';
import 'package:trader/Resources/FadePageRoute.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/Services/my_calls_service.dart';
import 'package:trader/Services/trimarketwatch_ltp_service.dart';
import 'package:trader/dataClasses/CallsClas.dart';
import 'package:trader/pages/AnalysisDetailPage.dart';

class MyCallsCard extends StatefulWidget {
  CallsClass _call;
  int index;

  MyCallsCard(
    this._call,
    this.index,
  );

  @override
  MyCallsCardState createState() => MyCallsCardState(_call, index);
}

class MyCallsCardState extends State<MyCallsCard> {
  CallsClass _call;
  int index;

  MyCallsCardState(this._call, this.index) {
    // CallUpdateService().getLtp(_call.cid, index, widget.context);
  }

  _fetchLtp() async {
    DateTime _currentTime = DateTime.now();
    if (_currentTime.hour >= 16) {
      fetchLastLtp();
    } else {
      Provider.of<TriMarketWatchLtpService>(context, listen: false)
          .subscribe(_call.it);
    }
  }

  fetchLastLtp() {
    Provider.of<TriMarketWatchLtpService>(context, listen: false)
        .fetchBrokerLtp(_call.it, _call.exchange, _call.scriptName);
  }

  @override
  void initState() {
    super.initState();
    _fetchLtp();
    // Provider.of<MyCallsService>(context, listen: false)
    //     .getLtp(_call.cid, index);
    // Provider.of<TriMarketWatchLtpService>(context, listen: false)
    //     .setIts(_call.it);
  }

  // final instance = FirebaseDatabase.instance.reference();

  Widget reco() {
    Widget premium = Container();

    if (_call.aacuracy != null && _call.aacuracy != "null") {
      String accu = _call.aacuracy.replaceAll("%", '');
      double acc = double.parse(accu);
      if (acc < 50) {
        premium = Container();
      } else {
        premium = ShapeOfView(
          shape: CutCornerShape(borderRadius: BorderRadius.circular(6)),
          child: Container(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              // child: Text("Premium", style: TextStyle(color: Colors.white),),
              child: Icon(
                Icons.done,
                color: Colors.white,
                size: 10,
              ),
            ),
          ),
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorsTheme.mazarineblue),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
            child: Text(
              _call.intra_cnc,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        premium
      ],
    );
  }

  Widget status() {
    Color _color;
    switch (_call.status) {
      case Strings.active:
        {
          _color = Colors.orange;
          break;
        }
      case Strings.pending:
        {
          _color = Colors.amber;
          break;
        }
      case Strings.targethit:
        {
          _color = Colors.green;
          break;
        }
      case Strings.lossBooked:
        {
          _color = Colors.red;
          break;
        }
      case Strings.Cancelled:
        {
          _color = Colors.red;
          break;
        }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: _color,
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8.0, right: 8.0, top: 5, bottom: 5),
            child: Text(
              _call.status,
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
        ),
        Text(
          DateFormat("dd-MM-yyy hh:mm").format(_call.time),
          maxLines: 2,
          style: TextStyle(fontSize: 12, color: Colors.black),
        )
      ],
    );
  }

  Widget aProfile() {
    Color _color;
    String temp1 = _call.aacuracy.replaceAll("%", "");
    double a = double.parse(temp1);
    if (a <= 30) {
      _color = Colors.red;
    } else if (a > 31 && a <= 70) {
      _color = Colors.orange;
    } else if (a > 70) {
      _color = Colors.green;
    }
    String accuracy =
        "${double.parse(_call.aacuracy.replaceAll("%", "")).toStringAsFixed(2)}%";

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.network(
                    _call.uUrl == null ? personImage : _call.uUrl),
              ),
              title: Text(
                _call.uname,
                maxLines: 2,
                style: TextStyle(),
              ),
            ),
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(fontSize: 12, color: Colors.black),
                children: [
                  TextSpan(
                    text: "${Strings.accuracy}: ",
                  ),
                  TextSpan(
                    text: accuracy,
                    style: TextStyle(fontSize: 12, color: _color),
                  )
                ]),
          )
        ],
      ),
    );
  }

  Widget ScriptName() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 30.0, right: 30.0, top: 8.0, bottom: 8.0),
      child: Row(
        children: [
          Container(
            child: Text(
              _call.scriptName,
              maxLines: 2,
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Consumer<TriMarketWatchLtpService>(builder: (context, cps, child) {
            return RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Ltp: ",
                      ),
                      TextSpan(
                        text: cps.getNormalLtp(_call.it) == "null" ||
                                cps.getNormalLtp(_call.it) == null
                            ? "0.0"
                            : cps.getNormalLtp(_call.it),
                      )
                    ]));
          })
        ],
      ),
    );
  }

  Widget maxProLos_rrRatio() {
    double entrry = double.parse(_call.entryPrice);
    double sl = double.parse(_call.sl);
    double target = double.parse(_call.target);
    String rrString;

    if (_call.buySell == 'buy') {
      double n = double.parse((entrry - sl).toString());
      double d = double.parse((target - entrry).toString());
      if (n == 0) {
        n = 1;
      }
      if (d == 0) {
        d = 1;
      }
      if (n > d) {
        n = n / d; //n:d
        d = 1;
        rrString = "${n.toStringAsPrecision(2)} : ${d.toStringAsPrecision(2)}";
      } else {
        d = d / n; //d:n
        n = 1;
        rrString = "${n.toStringAsPrecision(2)} : ${d.toStringAsPrecision(2)}";
      }
    }

    if (_call.buySell == 'sell') {
      double n = double.parse((sl - entrry).toString());
      double d = double.parse((entrry - target).toString());
      if (n == 0) {
        n = 1;
      }
      if (d == 0) {
        d = 1;
      }
      if (n > d) {
        n = n / d; //n:d
        d = 1;
        rrString = "${n.toStringAsPrecision(2)} : ${d.toStringAsPrecision(2)}";
      } else {
        d = d / n; //d:n
        n = 1;
        rrString = "${n.toStringAsPrecision(2)} : ${d.toStringAsPrecision(2)}";
      }
    }

    String maxLoss = (double.parse(_call.entryPrice) - double.parse(_call.sl))
        .toStringAsFixed(2)
        .replaceAll("-", "");
    String maxProf =
        (double.parse(_call.entryPrice) - double.parse(_call.target))
            .toStringAsPrecision(3)
            .replaceAll("-", "");

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      text: TextSpan(
                          style: TextStyle(color: Colors.red),
                          children: [
                            TextSpan(text: "${Strings.maxLoss}: "),
                            TextSpan(text: maxLoss)
                          ])),
                ),
                Expanded(
                  child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      text: TextSpan(
                          style: TextStyle(color: Colors.green),
                          children: [
                            TextSpan(text: "${Strings.maxProf}: "),
                            TextSpan(text: maxProf)
                          ])),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: "${Strings.rrration}: ",
                        ),
                        TextSpan(text: rrString)
                      ])),
            )
          ],
        ),
      ),
    );
  }

  Widget closedWith() {
    String title = "";
    String value = "";
    Color _color = Colors.white;

    if (_call.status == Strings.targethit) {
      title = "Closed with profit: ";
      value = (double.parse(_call.entryPrice) - double.parse(_call.target))
          .toStringAsPrecision(3)
          .replaceAll("-", "");
      _color = Colors.green;
    }
    if (_call.status == Strings.lossBooked) {
      title = "Closed with loss: ";
      value = (double.parse(_call.entryPrice) - double.parse(_call.sl))
          .toStringAsPrecision(3)
          .replaceAll("-", "");
      _color = Colors.red;
    }

    return Container(
      child: RichText(
          text: TextSpan(style: TextStyle(color: _color), children: [
        TextSpan(text: title),
        TextSpan(text: value),
        TextSpan(text: "/Unit"),
      ])),
    );
  }

  Widget pricingDetails() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                        color: _call.buySell == Strings.sell
                            ? Colors.red
                            : Colors.green),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 5),
                    child: Text(
                      _call.buySell,
                      style: TextStyle(
                          color: _call.buySell == Strings.sell
                              ? Colors.red
                              : Colors.green),
                    ),
                  ),
                ),
              ),
              RichText(
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(text: "${Strings.entryPriceo}: "),
                        TextSpan(text: _call.entryPrice),
                      ])),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(text: "${Strings.t1}: \n"),
                            TextSpan(text: _call.target),
                          ])),
                ),
                Expanded(
                  child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(text: "${Strings.t2}: \n"),
                            TextSpan(text: _call.target1),
                          ])),
                ),
                Expanded(
                  child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(text: "${Strings.s1}: \n"),
                            TextSpan(text: _call.sl),
                          ])),
                ),
                Expanded(
                  child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(text: "${Strings.s2}: \n"),
                            TextSpan(text: _call.sl1),
                          ])),
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //
          //     ],
          //   ),
          // ),
          // _call.equityDerivative == Strings.equity
          //     ? Container()
          //     : Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: RichText(
          //             maxLines: 2,
          //             textAlign: TextAlign.center,
          //             text: TextSpan(
          //                 style: TextStyle(color: Colors.black),
          //                 children: [
          //                   TextSpan(
          //                     text: "Expiry Date: ",
          //                   ),
          //                   TextSpan(
          //                     text: _call.expiryDate,
          //                   ),
          //                 ])),
          //       ),
          _call.status == Strings.targethit ||
                  _call.status == Strings.lossBooked
              ? closedWith()
              : Container()
        ],
      ),
    );
  }

  cardUi() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            fadePageRoute(
                context, AnalysisDetailPage(_call, index)));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade500,
                  blurRadius: 15,
                  offset: Offset(4, 4)),
              BoxShadow(
                  color: Colors.white, blurRadius: 15, offset: Offset(-4, -4)),
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              status(),
              aProfile(),
              Divider(
                color: Colors.grey,
              ),
              reco(),
              ScriptName(),
              maxProLos_rrRatio(),
              pricingDetails(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyCallsService>(
        // ignore: missing_return
        builder: (context, snapshot, child) {
      String filterCode = snapshot.getSelectedFilter();
      switch (filterCode) {
        case Strings.all_call:
          {
            return cardUi();
          }
        case Strings.ap_call:
          {
            if (_call.status == Strings.active ||
                _call.status == Strings.pending) {
              return cardUi();
            }

            break;
          }
        case Strings.closed_call:
          {
            if (_call.status == Strings.targethit ||
                _call.status == Strings.lossBooked) {
              return cardUi();
            }
            break;
          }
        default:
          {
            return Container();
          }
      }
      return Container();
    });
  }
}
