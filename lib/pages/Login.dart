import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trader/Resources/FadePageRoute.dart';
import 'package:trader/Resources/SupportDialogs.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/Services/auth/signin_with_phonenumber.dart';
import 'package:trader/Services/signin_register_services.dart';

import 'HomePage.dart';
import 'SignUpDetails.dart';

class LoginPage extends StatefulWidget {
  @override
  HomePageStateClass createState() => HomePageStateClass();
}

class HomePageStateClass extends State<LoginPage> {
  GlobalKey<ScaffoldState> _scaffold = GlobalKey();
  final formKey = new GlobalKey<FormState>();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _otp = TextEditingController();
  String fName;
  String lName;
  final nameFormKey = new GlobalKey<FormState>();
  bool nameExist = false;

  sendDataToServer() async {
    try {
      await Future.delayed(Duration(milliseconds: 200));
      openProcessingDialog(context);
      await Future.delayed(Duration(milliseconds: 500));
      Navigator.pop(context);

      Provider.of<SigninRegisterServices>(context, listen: false)
          .login(Provider.of<SigninWithPhoneNumber>(context, listen: false)
          .getPhone())
          .then((value) {
        if (value == '') {
          Navigator.pushReplacement(
              context, fadePageRoute(context, HomePage()));
          return;
        }
        if (value == Strings.user_not_found) {
          Navigator.pushReplacement(context,
              fadePageRoute(context, SignUpDetails()));
          return;
        }
        if (value == 'QT3001' || value == 'QT3002') {
          showVeriFailMessage("Please try again after sometime");
        }
      });
    } catch (err) {}
  }

  //----------PHONE SIGN IN WIDGET------------
  Widget _phoneSignin() {
    return Consumer<SigninWithPhoneNumber>(builder: (context, snapshot, child) {
      return Container(
          child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  !snapshot.isCodeSent()
                      ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 8.0, right: 8),
                          child: TextFormField(
                            style: TextStyle(color: Colors.black),
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.phone,
                            enabled: false,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey),
                              fillColor: Colors.black,
                              focusColor: Colors.black,
                              hoverColor: Colors.black,
                              hintText: 'India (+91)',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 8.0, right: 8),
                          child: TextFormField(
                            controller: _phoneNumber,
                            style: TextStyle(color: Colors.black),
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey),
                              fillColor: Colors.black,
                              focusColor: Colors.black,
                              hoverColor: Colors.black,
                              hintText: 'Enter phone number',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),

                            // ignore: missing_return
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Enter Phone Number";
                              }
                              if (value.length != 10) {
                                return "Please Enter 10 digit mobile number";
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                      : Container(
                    decoration: BoxDecoration(
                      // color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: Padding(
                        padding: EdgeInsets.only(left: 25.0, right: 25.0),
                        child: TextFormField(
                          controller: _otp,
                          style: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey),
                            hintText: 'Enter OTP',
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            fillColor: Colors.black,
                            focusColor: Colors.black,
                            hoverColor: Colors.black,
                          ),
                          // ignore: missing_return
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Enter OTP";
                            }
                            if (value.length != 6) {
                              return "Please Enter 6 Digit OTP Number";
                            }
                          },
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _sendButton()
                ],
              )));
    });
  }

  //---------VERIFY/LOGIN BUTTON
  Widget _sendButton() {
    return Consumer<SigninWithPhoneNumber>(builder: (context, snapshot, child) {
      if (snapshot.isVerificationFailed()) {
        showVeriFailMessage(snapshot.getVerificationFailMessage());
      }
      if (snapshot.isVerificationComplete()) {
        sendDataToServer();
      }
      return GestureDetector(
        onTap: () async {
          if (!snapshot.isCodeSent()) {
            String phoneNo = _phoneNumber.text;
            openProcessingDialog(context);

            await Future.delayed(Duration(seconds: 1));
            Navigator.pop(context);
            snapshot.phoneSignin("+91${phoneNo}");
          } else {
            String otp = _otp.text;
            openProcessingDialog(context);
            await Future.delayed(Duration(seconds: 1));
            Navigator.pop(context);

            snapshot.verifyCode(otp);
          }
        },
        child: Container(
            padding: EdgeInsets.only(bottom: 12, top: 12),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.deepPurple[600],
                borderRadius: BorderRadius.circular(3),
                // border: Border.all(color: Colors.white, width: 1),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: Offset(0, 0),
                      blurRadius: 6)
                ]),
            child: Center(
              child: Text(
                snapshot.isCodeSent() ? "LOGIN" : "VERIFY",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )),
      );
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget loginWidget() {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 1, child: Container()),
            Text(
              "LOGIN",
              overflow: TextOverflow.visible,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
              maxLines: 4,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Login to access expert analysis for indian stock market",
              overflow: TextOverflow.visible,
              style: TextStyle(
                color: Colors.black,
              ),
              maxLines: 4,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            _phoneSignin(),
            Expanded(flex: 2, child: Container()),
          ],
        ),
      ),
    );
  }

  showVeriFailMessage(String message) async {
    await Future.delayed(Duration(milliseconds: 500));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffold,
        backgroundColor: Colors.deepPurple,
        resizeToAvoidBottomInset: true,
        body: SafeArea(child: loginWidget()));
  }
}
