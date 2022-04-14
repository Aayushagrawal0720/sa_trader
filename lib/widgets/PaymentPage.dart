import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:trader/Resources/Color.dart';
import 'package:trader/Resources/FadePageRoute.dart';
import 'package:trader/Resources/SupportDialogs.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:provider/provider.dart';
import 'package:trader/Services/payment_services.dart';
import 'package:trader/Services/profile_info_service.dart';
import 'package:trader/pages/HomePage.dart';
import 'package:trader/pages/QrScannerPage.dart';

class PaymentPage extends StatefulWidget {
  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  TextEditingController _amount = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  var _razorpay = Razorpay();


  void listnerCouponStatus() async {
    final prov =
        Provider.of<PaymentService>(context, listen: false).getCOuponStatus();

    switch (prov) {
      case PaymentService.none:
        {
          break;
        }
      case PaymentService.waiting:
        {
          openProcessingDialog(context);
          break;
        }
      case PaymentService.success:
        {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              text: "Success!!!",
              title: "Balance Updated Successfully",
              barrierDismissible: false,
              onConfirmBtnTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    fadePageRoute(context, HomePage()),
                    (Route<dynamic> route) => route.isFirst);
                // Navigator.pushReplacement(context,
                //     fadePageRoute(builder: (context) => MyHomePage()));
              });
          break;
        }
      case PaymentService.failed:
        {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              text: "Failed!",
              title: "Failed To Update Balance",
              barrierDismissible: false,
              onConfirmBtnTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    fadePageRoute(context, HomePage()),
                    (Route<dynamic> route) => route.isFirst);
                // Navigator.pushReplacement(context,
                //     fadePageRoute(builder: (context) => MyHomePage()));
              });
          break;
        }
      case PaymentService.redeemed:
        {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.info,
              text: "Failed!",
              title: "Coupon already redeemed!",
              barrierDismissible: false,
              onConfirmBtnTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    fadePageRoute(context, HomePage()),
                    (Route<dynamic> route) => route.isFirst);
                // Navigator.pushReplacement(context,
                //     fadePageRoute(builder: (context) => MyHomePage()));
              });
          break;
        }
      case PaymentService.wrong:
        {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.info,
              text: "Failed!",
              title: "Wrong coupon code",
              barrierDismissible: false,
              onConfirmBtnTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    fadePageRoute(context, HomePage()),
                    (Route<dynamic> route) => route.isFirst);
                // Navigator.pushReplacement(context,
                //     fadePageRoute(builder: (context) => MyHomePage()));
              });
          break;
        }
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Provider.of<PaymentService>(context, listen: false)
        .addMoneyToWallet(
            Provider.of<ProfileInfoServices>(context, listen: false).getuid(),
            _amount.text,
            "Success",
            "wallet",
            "Bank",
            {
              "razorpay_payment_id": response.paymentId,
              "razorpay_order_id": response.orderId,
              "razorpay_signature": response.signature
            }.toString())
        .then((value) {
      if (value) {
        Navigator.pop(context);
        CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            text: "Success!!!",
            title: "Balance Updated Successfully",
            barrierDismissible: false,
            onConfirmBtnTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  fadePageRoute(context, HomePage()),
                  (Route<dynamic> route) => route.isFirst);
              // Navigator.pushReplacement(context,
              //     fadePageRoute(builder: (context) => MyHomePage()));
            });
      } else {
        Navigator.pop(context);
        CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text: "Failed!",
            title: "Failed To Update Balance",
            barrierDismissible: false,
            onConfirmBtnTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  fadePageRoute(context, HomePage()),
                  (Route<dynamic> route) => route.isFirst);
              // Navigator.pushReplacement(context,
              //     fadePageRoute(builder: (context) => MyHomePage()));
            });
      }
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _razorpay.clear();
    if (response.code == Razorpay.PAYMENT_CANCELLED) {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: "Failed!!!",
          title: "Payment Cancelled By User",
          barrierDismissible: false,
          onConfirmBtnTap: () {
            Navigator.pop(context);
            // Navigator.pushReplacement(context,
            //     fadePageRoute(builder: (context) => MyHomePage()));
          });
    }
    if (response.code == Razorpay.NETWORK_ERROR) {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: "Failed!!!",
          title: "Network Error",
          barrierDismissible: false,
          onConfirmBtnTap: () {
            Navigator.pop(context);
            // Navigator.pushReplacement(context,
            //     fadePageRoute(builder: (context) => MyHomePage()));
          });
    }
// // Do something when payment fails
  }

  startPayment() async {
    int amt = int.parse(_amount.text.toString()) * 100;

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    var options = {
      'key': 'rzp_live_DXG9WVb77zkv1r',
      'amount': amt,
      'name': 'Quicktrades',
      "currency": "INR",
      'description': Strings.walletpayment,
      'prefill': {
        'name': Provider.of<ProfileInfoServices>(context, listen: false)
            .getuid()
            .toString(),
        'contact': Provider.of<ProfileInfoServices>(context, listen: false)
            .getphone()
            .toString(),
        'email': Provider.of<ProfileInfoServices>(context, listen: false)
            .getemail()
            .toString(),
      },
    };
    _razorpay.open(options);
  }

  Widget upperColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            "Amount",
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.5),
          ),
          child: Row(
            children: [
              Icon(
                LineIcons.rupee,
                size: 20,
                color: Colors.black,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _key,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _amount,
                      decoration: InputDecoration(
                        hintText: "Enter Amount",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      // ignore: missing_return
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Enter Amount";
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // GestureDetector(
        //   onTap: () async {
        //     var result = await Navigator.push(context,
        //         fadePageRoute(builder: (context) => QrScannerPage()));
        //
        //     if (result) {
        //       listnerCouponStatus();
        //     }
        //   },
        //   child: RichText(
        //       maxLines: 3,
        //       text: TextSpan(children: [
        //         TextSpan(
        //           text: "Have a coupon code? ",
        //           style: TextStyle(color: Colors.black),
        //         ),
        //         TextSpan(
        //             text: "Scan here", style: TextStyle(color: Colors.blue))
        //       ])),
        // )
      ],
    );
  }

  Widget button() {
    return Center(
      child: GestureDetector(
        onTap: () {
          if (_key.currentState.validate()) {
            openProcessingDialog(context);
            startPayment();
          }
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
            child: Text(
              "Proceed to pay",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<PaymentService>(context, listen: false).setCouponStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: ListView(
          children: [
            upperColumn(),
            SizedBox(
              height: 50,
            ),
            button(),
          ],
        ),
      ),
    );
  }
}
