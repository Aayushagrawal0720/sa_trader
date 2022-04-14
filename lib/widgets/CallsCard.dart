import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shape_of_view/shape_of_view.dart';
import 'package:trader/Resources/Color.dart';
import 'package:trader/Resources/FadePageRoute.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/Services/internal_payment_page_services.dart';
import 'package:trader/Services/package_selector_internal_paymentpage_service.dart';
import 'package:trader/Services/trimarketwatch_ltp_service.dart';
import 'package:trader/dataClasses/CallsClas.dart';
import 'package:sliding_card/sliding_card.dart';
import 'package:trader/pages/AnalysisDetailPage.dart';
import 'package:trader/pages/PatternDescriptionPage.dart';
import 'package:trader/widgets/InternalPaymentPage.dart';

class CallsCard extends StatefulWidget {
  CallsClass _call;
  int index;

  CallsCard(
    this._call,
    this.index,
  );

  @override
  CallsCardState createState() => CallsCardState(_call, index);
}

class CallsCardState extends State<CallsCard> {
  CallsClass _call;
  int index;
  SlidingCardController controller = SlidingCardController();

  CallsCardState(
    this._call,
    this.index,
  );


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

  Widget status() {
    Color _color;
    switch (_call.status) {
      case Strings.active:
        {
          _color = Colors.orange.shade900;
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
          _color = Colors.red.shade900;
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
    print('---------------------------');
    print(temp1);
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
                child: Image.network(_call.uUrl),
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              child: Text(
                _call.scriptName,
                maxLines: 2,
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Consumer<TriMarketWatchLtpService>(
                builder: (context, cps, child) {
              return RichText(
                  textAlign: TextAlign.right,
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
            }),
          )
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
              padding: const EdgeInsets.all(8.0),
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
          .toString()
          .replaceAll("-", "");
      _color = Colors.green;
    }
    if (_call.status == Strings.lossBooked) {
      title = "Closed with loss: ";
      value = (double.parse(_call.entryPrice) - double.parse(_call.sl))
          .toString()
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: _call.buySell == Strings.sell
                      ? Colors.red
                      : Colors.green),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _call.buySell,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          RichText(
              textAlign: TextAlign.center,
              maxLines: 2,
              text: TextSpan(style: TextStyle(color: Colors.black), children: [
                TextSpan(text: "${Strings.entryPrice}: "),
                TextSpan(text: _call.entryPrice),
              ])),
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
                            TextSpan(text: "${Strings.t2}: \n"),
                            TextSpan(text: _call.target2),
                          ])),
                ),
              ],
            ),
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
                            TextSpan(text: "${Strings.s1}: \n"),
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
                            TextSpan(text: "${Strings.s2}: \n"),
                            TextSpan(text: _call.target2),
                          ])),
                ),
              ],
            ),
          ),
          _call.equityDerivative == Strings.equity
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "Expiry Date: ",
                            ),
                            TextSpan(
                              text: _call.expiryDate,
                            ),
                          ])),
                ),
          _call.status == Strings.targethit ||
                  _call.status == Strings.lossBooked
              ? closedWith()
              : Container()
        ],
      ),
    );
  }

  Widget reco() {
    Widget premium = Container();

    if (_call.aacuracy != null && _call.aacuracy != "null") {
      double acc = double.parse(_call.aacuracy.replaceAll("%", ""));
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

  Widget frontCard() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
                color: ColorsTheme.secondryColor.withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 0))
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
            _call.status == Strings.targethit ||
                    _call.status == Strings.lossBooked
                ? Container()
                : buyPackageButton()
          ],
        ),
      ),
    );
  }

  Widget backCard() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
                color: ColorsTheme.secondryColor.withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 0))
          ]),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _call.visible ? pricingDetails() : buyPackageButton()),
    );
  }

  buyPackageButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Buy pick to see full details",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        GestureDetector(
          onTap: () async {
            Provider.of<InternalPaymentPageServices>(context, listen: false)
                .setInitialValues();
            Provider.of<PackageSelectorInternalPayamentPageService>(context,
                    listen: false)
                .resetPackageSelection();
            await Future.delayed(Duration(microseconds: 100));
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return InternalPaymentPage(true, _call.uid,
                      accuracy: _call.aacuracy, cid: _call.cid);
                });
          },
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: ColorsTheme.primaryDark,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                        color: ColorsTheme.secondryColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 0))
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 8, left: 15, right: 15),
                child: Text(
                  "Buy Pick",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    // Provider.of<CallsPageService>(context, listen: false)
    //     .getLtp(_call.cid, index, _call.status);
    _fetchLtp();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_call.status == Strings.targethit ||
            _call.status == Strings.lossBooked) {
          Navigator.push(
              context,
              fadePageRoute(
                  context, AnalysisDetailPage(_call, index)));
        } else if (controller.isCardSeparated == true) {
          controller.collapseCard();
        } else {
          controller.expandCard();
        }
      },
      child: SlidingCard(
        slimeCardElevation: 1,
        cardsGap: 7,
        slimeCardBorderRadius: 10,
        //The controller is necessary to animate the opening and closing of the card
        controller: controller,
        slidingCardWidth: MediaQuery.of(context).size.width,
        visibleCardHeight: _call.status == Strings.targethit ||
                _call.status == Strings.lossBooked
            ? 270
            : 340,
        hiddenCardHeight: 0,
        showColors: false,
        //Configure your front card here
        frontCardWidget: frontCard(),
        //configure your rear card here
        backCardWidget: backCard(),
        slidingAnimmationForwardCurve: Curves.ease,
        slidingAnimationReverseCurve: Curves.ease,
      ),
    );
  }
}
