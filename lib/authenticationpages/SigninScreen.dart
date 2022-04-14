import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trader/Resources/AuthPageDesignsRes.dart';
import 'package:trader/Resources/FadePageRoute.dart';
import 'package:trader/Resources/SupportDialogs.dart';
import 'package:trader/Services/auth/signin_with_phonenumber.dart';

import 'OtpScreen.dart';

class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  GlobalKey<FormState> _signinFormKey = GlobalKey();
  TextEditingController _phoneNumber = TextEditingController();

  openOtpPage() async {
    await Future.delayed(Duration(milliseconds: 500));
    Navigator.pop(context);
    Navigator.pushReplacement(context, fadePageRoute(context, OtpScreen()));
  }

  showVeriFailMessage(String message) async {
    await Future.delayed(Duration(milliseconds: 500));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipPath(
              clipper: CurveClipper(),
              child: Container(
                color: Colors.deepPurple,
                height: MediaQuery.of(context).size.height / 2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Quicktrades",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: MediaQuery.of(context).size.width / 5,
                        child: Image.asset('assets/logo/quicktrades.png'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Enter you phone number",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _signinFormKey,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _phoneNumber,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.length > 9 || value.length < 9) {
                                return 'Enter correct phone number';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: 'Phone Number',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                fillColor: Colors.grey,
                                border: InputBorder.none),
                            cursorColor: Colors.black,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Consumer<SigninWithPhoneNumber>(
                      builder: (context, snapshot, child) {
                    if (snapshot.isCodeSent()) {
                      openOtpPage();
                    }
                    if (snapshot.isVerificationFailed()) {
                      showVeriFailMessage(
                          snapshot.getVerificationFailMessage());
                    }
                    return GestureDetector(
                      onTap: () {
                        String number = _phoneNumber.text;
                        if (number.length > 10 || number.length < 10) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Enter correct phone number")));
                          return;
                        }

                        openProcessingDialog(context);

                        number = '+91$number';
                        snapshot.phoneSignin(number);
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
                            "Get Otp",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
