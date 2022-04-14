import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:trader/Resources/Color.dart';
import 'package:trader/Resources/FadePageRoute.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/Services/advisor_calls_services.dart';
import 'package:trader/Services/advisor_profile_fetch_services.dart';
import 'package:trader/Services/internal_payment_page_services.dart';
import 'package:trader/Services/package_selector_internal_paymentpage_service.dart';
import 'package:trader/dataClasses/AdvisorClass.dart';
import 'package:trader/pages/AdvisorCallsPage.dart';
import 'dart:developer' as dev;

import 'package:trader/widgets/InternalPaymentPage.dart';

class AdvisorDashboardPage extends StatefulWidget {
  AdvisorClass advisor;

  AdvisorDashboardPage({this.advisor});

  @override
  _AdvisorDashboardPageState createState() => _AdvisorDashboardPageState();
}

class _AdvisorDashboardPageState extends State<AdvisorDashboardPage> {
  Widget aProfile() {
    Color _color;
    String temp1 = widget.advisor.accuracy.replaceAll("%", "");
    double a = double.parse(temp1);
    if (a <= 30) {
      _color = Colors.red;
    } else if (a > 31 && a <= 70) {
      _color = Colors.orange;
    } else if (a > 70) {
      _color = Colors.green;
    }

    String accuracy =
        "${double.parse(widget.advisor.accuracy.replaceAll("%", "")).toStringAsFixed(2)}%";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.network(widget.advisor.url),
              ),
              title: Text(
                widget.advisor.name,
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

  centerCard(
      Color color, String title, String value, double width, String allCalls) {
    Color percentageColor;
    double percentage = (double.parse(value) / double.parse(allCalls)) * 100;
    if (percentage < 33) {
      percentageColor = Colors.red;
    } else if (percentage < 75) {
      percentageColor = Colors.orange;
    } else if (percentage <= 100) {
      percentageColor = Colors.green;
    }

    return Stack(children: [
      Container(
        height: MediaQuery.of(context).size.height / 7,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
              color: Colors.blue.withOpacity(
                0.3,
              ),
              width: 0.25),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                maxLines: 2,
                style: TextStyle(color: Colors.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  // Container(
                  //   height: 15,
                  //   child: VerticalDivider(
                  //     color: Colors.blue.withOpacity(0.9),
                  //   ),
                  // ),
                  // Text(
                  //   "${percentage.toStringAsFixed(2)}%",
                  //   maxLines: 2,
                  //   style: TextStyle(
                  //       color: percentageColor, fontSize: 16),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
      Positioned(
          right: 15,
          top: 15,
          child: Container(
            decoration: BoxDecoration(
                color: ColorsTheme.themeLightOrange.withOpacity(0.3),
                borderRadius: BorderRadius.circular(100)),
            child: Icon(
              Icons.chevron_right,
              color: ColorsTheme.themeOrange,
            ),
          ))
    ]);
  }

  allCallsCard(Color color, String title, String value, Function task) {
    return GestureDetector(
      onTap: task,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
              color: Colors.blue.withOpacity(
                0.3,
              ),
              width: 0.25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    value,
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                    color: ColorsTheme.themeLightOrange.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(100)),
                child: Icon(
                  Icons.chevron_right,
                  color: ColorsTheme.themeOrange,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  centercardsView1(String activeCalls, String pending, String allCalls) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Provider.of<AdvisorCallsService>(context, listen: false)
                    .setTitle(Strings.pending);
                Navigator.push(
                    context,
                    fadePageRoute(
                        context,
                        AdvisorCallsPage(
                          advisor: widget.advisor,
                        )));
              },
              child: centerCard(Colors.white, "Pending calls", pending,
                  MediaQuery.of(context).size.width, allCalls),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Provider.of<AdvisorCallsService>(context, listen: false)
                    .setTitle(Strings.active);
                Navigator.push(
                    context,
                    fadePageRoute(
                        context,
                        AdvisorCallsPage(
                          advisor: widget.advisor,
                        )));
              },
              child: centerCard(Colors.white, "Active calls", activeCalls,
                  MediaQuery.of(context).size.width, allCalls),
            ),
          ),
        ],
      ),
    );
  }

  centercardsView2(String profit, String loss, String allCalls) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Provider.of<AdvisorCallsService>(context, listen: false)
                    .setTitle(Strings.targethit);
                Navigator.push(
                    context,
                    fadePageRoute(
                        context, AdvisorCallsPage(
                              advisor: widget.advisor,
                            )));
              },
              child: centerCard(Colors.white, "Closed calls with profit",
                  profit, MediaQuery.of(context).size.width, allCalls),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Provider.of<AdvisorCallsService>(context, listen: false)
                    .setTitle(Strings.lossBooked);
                Navigator.push(
                    context,
                    fadePageRoute(
                       context, AdvisorCallsPage(
                              advisor: widget.advisor,
                            )));
              },
              child: centerCard(Colors.white, "Closed calls with loss", loss,
                  MediaQuery.of(context).size.width, allCalls),
            ),
          )
        ],
      ),
    );
  }

  callsSection(String activeCalls, String pendingCalls, String targetHit,
      String lossBooked, String allCalls) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: Offset(-1, 1),
                blurRadius: 4)
          ]),
      child: Column(
        children: [
          allCallsCard(Colors.white, "All calls", allCalls, () {
            Provider.of<AdvisorCallsService>(context, listen: false)
                .setTitle(Strings.all);
            Navigator.push(
                context,
                fadePageRoute(
                    context, AdvisorCallsPage(
                          advisor: widget.advisor,
                        )));
          }),
          centercardsView1(activeCalls, pendingCalls, allCalls),
          centercardsView2(targetHit, lossBooked, allCalls),
        ],
      ),
    );
  }

  Widget callsCountSection() {
    return Consumer<AdvisorProfileFetchServices>(
      builder: (context, snapshot, child) {
        if (snapshot.getData() != null) {
          var data = snapshot.getData();
          if (data == "false") {
            return Column(
              children: [
                Container(
                  child: Image.asset("assets/other/error.png"),
                ),
              ],
            );
          } else {
            if (data != null) {
              String amt = data[Strings.wallet].toString();
              String subs = data["subscribers"].toString();
              String targetHit = data['hit_calls'].toString();
              String lossBooked = data["loss_calls"].toString();
              String closedcalls =
                  (int.parse(targetHit) + int.parse(lossBooked)).toString();
              String pendingCalls = data["pending_calls"].toString();
              String activeCalls = data["active_calls"].toString();
              String allCalls = (int.parse(activeCalls) +
                      int.parse(closedcalls) +
                      int.parse(pendingCalls))
                  .toString();
              return Column(
                children: [
                  callsSection(activeCalls, pendingCalls, targetHit, lossBooked,
                      allCalls),
                  SizedBox(
                    height: 30,
                  )
                ],
              );
            } else {
              Toast.show("No Record Found", context,
                  gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
            }
          }
        }
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: SpinKitDoubleBounce(
            color: ColorsTheme.primaryDark,
            size: 32,
          ),
        );
      },
    );
  }

  subsCribeButton() {
    return GestureDetector(
      onTap: () async {
        Provider.of<InternalPaymentPageServices>(context, listen: false)
            .setInitialValues();
        Provider.of<PackageSelectorInternalPayamentPageService>(context,
                listen: false)
            .resetPackageSelection();
        await Future.delayed(Duration(microseconds: 100));
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return FractionallySizedBox(
                heightFactor: 0.8,
                child: InternalPaymentPage(
                  false,
                  widget.advisor.uid,
                ),
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border:
                  Border.all(color: ColorsTheme.themeLightOrange, width: 1)),
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
              child: Text(
                "Subscribe",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ColorsTheme.themeLightOrange,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return Container(
      decoration: BoxDecoration(color: ColorsTheme.offWhite),
      child: Row(
        children: [
          CupertinoNavigationBarBackButton(
            color: Colors.black,
          ),
          Text(
            "Analyst dashboard",
            style: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.black, fontSize: 20),
          ),
          Expanded(child: Container()),
          widget.advisor.subscribed ? Container() : subsCribeButton(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<AdvisorProfileFetchServices>(context, listen: false)
        .fetchHomeScreen(widget.advisor.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_appBar(), aProfile(), callsCountSection()],
          ),
        ),
      )),
    );
  }
}
