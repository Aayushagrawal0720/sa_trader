import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:trader/Resources/Color.dart';
import 'package:trader/Resources/FadePageRoute.dart';
import 'package:trader/Resources/SupportDialogs.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/Services/coupons_operation_service.dart';
import 'package:trader/Services/internal_payment_page_services.dart';
import 'package:trader/Services/package_selector_internal_paymentpage_service.dart';
import 'package:trader/Services/profile_info_service.dart';
import 'package:trader/dataClasses/Coupons.dart';
import 'package:trader/dataClasses/PackageDataClass.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:trader/pages/MyCalls.dart';
import 'package:trader/Services/advisor_page_service.dart';
import 'package:trader/Services/bottom_navigation_service.dart';

class InternalPaymentPage extends StatefulWidget {
  bool call;
  String uid;
  String accuracy;
  String cid;

  InternalPaymentPage(this.call, this.uid, {this.accuracy, this.cid});

  @override
  InternalPaymentPageState createState() => InternalPaymentPageState();
}

class InternalPaymentPageState extends State<InternalPaymentPage> {
  List<PackageDataClass> packageData = [];
  List<Coupons> _coupons = [];
  String operation;
  double value;

  sendTxn() async {
    final prov =
        Provider.of<InternalPaymentPageServices>(context, listen: false);
    final package_prov =
        Provider.of<PackageSelectorInternalPayamentPageService>(context,
            listen: false);

    if (widget.call == false &&
        packageData[package_prov.getSelectedpackage()].duration ==
            Strings.singleCall) {
      Navigator.pop(context);
      Toast.show("No Package Found", context);

      return;
    } else {
      var result = await prov.sendTransactionToServer(
          widget.uid,
          Provider.of<ProfileInfoServices>(context, listen: false).getuid(),
          widget.cid,
          packageData[package_prov.getSelectedpackage()].pid,
          widget.call,
          Provider.of<CouponOperationService>(context, listen: false)
              .getResult());
      if (result == "Insufficient balance") {
        Navigator.pop(context);
        CoolAlert.show(
            context: context,
            type: CoolAlertType.info,
            text: "Please add balance to your wallet to continue",
            title: "Insufficient Balance",
            barrierDismissible: false,
            onConfirmBtnTap: () {
              Navigator.pop(context);
              Navigator.pop(context);

              // Navigator.pushReplacement(
              //     context, fadePageRoute(builder: (context) => HomePage()));
            });
      } else if (result == "Package already subscribed") {
        Navigator.pop(context);
        CoolAlert.show(
            context: context,
            type: CoolAlertType.info,
            text: "Selected package is already active",
            title: "Package is already active",
            barrierDismissible: false,
            onConfirmBtnTap: () {
              Navigator.pop(context);
            });
      } else if (result == 'success') {
        Navigator.pop(context);

        String callAlertMessage = "Call Purchased";
        String subscriptionAlertMessage = "Analyst Subscribed";
        CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            text: "Success!!!",
            title: widget.call ? callAlertMessage : subscriptionAlertMessage,
            barrierDismissible: false,
            onConfirmBtnTap: () {
              if (widget.call) {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    fadePageRoute(context, MyCalls()));
              } else {
                Provider.of<AdviserPageService>(context, listen: false)
                    .setIndex(1);
                Provider.of<BottomNavigationService>(context, listen: false)
                    .setPageNumber(1);
                Navigator.pop(context);
                Navigator.pop(context);

                // Navigator.pushReplacement(
                //     context, fadePageRoute(builder: (context) => HomePage()));
              }
            });
      } else {
        Navigator.pop(context);
        Toast.show("Error processing your request", context,
            duration: Toast.LENGTH_LONG);
      }
    }
  }

  Widget PackageListTile(int index) {
    String amount = packageData[index].pamt;
    if (widget.accuracy != null && widget.accuracy != "null") {
      double acc = double.parse(widget.accuracy.split("%").first);
      // if (acc < 50) {
      //   amount = "0";
      // }
    }
    Provider.of<CouponOperationService>(context, listen: false)
        .getCouponOperator(double.parse(amount),
            operation: operation, value: value);
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 4,
                  offset: Offset(0, 0))
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: "Rs. ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: amount,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text: "/ ${packageData[index].duration}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold))
                        ])),
                        Text(
                          "Get access to calls at just Rs. ${amount}",
                        )
                      ],
                    )),
                    Consumer<PackageSelectorInternalPayamentPageService>(
                        builder: (context, serv, child) {
                      return Radio(
                          value: index,
                          groupValue: serv.getSelectedpackage(),
                          onChanged: (val) {
                            serv.setSelectedpackage(val);
                          });
                    }),
                  ],
                ),
                _coupons.length == 0
                    ? Container()
                    : Container(
                        padding: EdgeInsets.only(top: 8),
                        child: Consumer<CouponOperationService>(
                            builder: (context, snapshot, child) {
                          double finalAmount = snapshot.getResult();
                          if (finalAmount == null) {
                            finalAmount = double.parse(amount);
                          }
                          return RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'Congratulations!',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green)),
                              TextSpan(
                                  text:
                                      ' You can get this package at Rs.${finalAmount.toString()}',
                                  style: TextStyle(color: Colors.green)),
                            ]),
                          );
                        }))
              ],
            ),
            // title: ,
            // subtitle: ,
            // trailing:
          ),
        ));
  }

  packageList() {
    return Consumer<InternalPaymentPageServices>(
      builder: (context, serv, child) {
        _coupons = serv.getCoupons();
        if (_coupons.length > 0) {
          Coupons _coupon = _coupons.first;
          if (_coupon.application_state == 'default') {
            operation = _coupon.operations;
            value = double.parse(_coupon.value);
          }
        }
        if (serv.getLoading()) {
          return SpinKitDoubleBounce(
            color: ColorsTheme.primaryDark,
            size: 32,
          );
        } else {
          bool error = false;
          if (widget.call) {
            if (serv.getSinglePdc().toString() == "error") {
              error = true;
            } else {
              packageData.clear();
              packageData = serv.getSinglePdc();
            }
          } else {
            if (serv.getPdc().toString() == "error") {
              error = true;
            } else {
              packageData.clear();
              packageData = serv.getPdc();
            }
          }

          if (error) {
            return Text(
              "Some Error Occurred",
              style: TextStyle(color: ColorsTheme.darkred),
            );
          }
          return packageData.length == 0
              ? Text(
                  "No Package Found",
                  style: TextStyle(color: ColorsTheme.darkred),
                )
              : Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: packageData.length,
                        physics: ScrollPhysics(),
                        // ignore: missing_return
                        itemBuilder: (context, index) {
                          return PackageListTile(index);
                        }),
                    SizedBox(
                      height: 50,
                    ),
                    packageData.length > 0
                        ? button()
                        : Container(
                            child: Text(
                              "No Package Found",
                              style: TextStyle(color: ColorsTheme.darkred),
                            ),
                          )
                  ],
                );
        }
      },
    );
  }

  Widget button() {
    return Center(
      child: GestureDetector(
        onTap: () {
          openProcessingDialog(context);
          sendTxn();
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
              color: ColorsTheme.themeLightOrange,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, blurRadius: 12, offset: Offset(-1, 0))
              ],
              borderRadius: BorderRadius.circular(6)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Consumer<CouponOperationService>(
                builder: (context, snapshot, child) {
              return Text(
                "Proceed to pay Rs.${snapshot.getResult()}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<InternalPaymentPageServices>(context, listen: false)
        .getPackageDataFromServer(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select package",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              packageList(),
            ],
          ),
        ),
      ),
    );
  }
}
