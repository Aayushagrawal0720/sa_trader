import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:trader/Resources/FadePageRoute.dart';
import 'package:trader/Resources/SupportDialogs.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/Services/auth/code_resend_timer_service.dart';
import 'package:trader/Services/auth/signin_with_phonenumber.dart';
import 'package:trader/Services/signin_register_services.dart';
import 'package:trader/pages/HomePage.dart';
import 'SignupScreen.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController _otpController = TextEditingController();

  openNextPage() async {
    try {
      await Future.delayed(Duration(milliseconds: 200));
      openProcessingDialog(context);
      await Future.delayed(Duration(milliseconds: 500));
      Navigator.pop(context);

      Provider.of<SigninRegisterServices>(context, listen: false)
          .login(Provider.of<SigninWithPhoneNumber>(context, listen: false)
              .getPhone())
          .then((value) {
        if (value == 'success') {
          Navigator.pushReplacement(
              context, fadePageRoute(context, HomePage()));
          return;
        }
        if (value == Strings.user_not_found) {
          Navigator.pushReplacement(
              context,
              fadePageRoute(
                  context,
                  SignupScreen(
                      Provider.of<SigninWithPhoneNumber>(context, listen: false)
                          .getPhone())));
          return;
        }
        if (value == 'QT3001' || value == 'QT3002') {
          showVeriFailMessage("Please try again after sometime");
        }
      });
    } catch (err) {}
  }

  showVeriFailMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  initTimer() {
    Provider.of<CodeResendTimerService>(context, listen: false).initTime();
  }

  @override
  void initState() {
    super.initState();

    initTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter Otp",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PinCodeTextField(
                    controller: _otpController,
                    length: 6,
                    pinTheme: PinTheme(
                        activeColor: Colors.deepPurple[600],
                        inactiveColor: Colors.black,
                        selectedColor: Colors.deepPurple,
                        borderWidth: 1,
                        borderRadius: BorderRadius.circular(6),
                        shape: PinCodeFieldShape.box),
                    appContext: context,
                    onChanged: (String value) {
                      //verify Otp
                    },
                  ),
                ),
                Consumer<CodeResendTimerService>(
                    builder: (context, snapshot, child) {
                  return Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                      onTap: () {
                        if (snapshot.getTime() <= 0) {
                          openProcessingDialog(context);
                          Provider.of<SigninWithPhoneNumber>(context,
                                  listen: false)
                              .phoneSignin(Provider.of<SigninWithPhoneNumber>(
                                      context,
                                      listen: false)
                                  .getPhone());
                          initTimer();
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        snapshot.getTime() > 0
                            ? "Resend OTP in ${snapshot.getTime()} sec(s)"
                            : "Resend OTP",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: snapshot.getTime() > 0
                                ? Colors.grey
                                : Colors.blue,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              snapshot.getTime() > 0
                                  ? BoxShadow()
                                  : BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: Offset(1, 1))
                            ]),
                      ),
                    ),
                  );
                }),
                Consumer<SigninWithPhoneNumber>(
                    builder: (context, snapshot, child) {
                  if (snapshot.isVerificationComplete()) {
                    openNextPage();
                  }

                  if (snapshot.isVerificationFailed()) {
                    showVeriFailMessage(snapshot.getVerificationFailMessage());
                  }
                  return GestureDetector(
                    onTap: () {
                      if (_otpController.text != null ||
                          _otpController.text != "") {
                        snapshot.verifyCode(_otpController.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Enter otp ")));
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.deepPurple[600],
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black38,
                                offset: Offset(0, 0),
                                blurRadius: 6),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        child: Text(
                          "Verify",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
