import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trader/Resources/AuthPageDesignsRes.dart';
import 'package:trader/Resources/FadePageRoute.dart';
import 'package:trader/Resources/SupportDialogs.dart';
import 'package:trader/Services/auth/signin_with_phonenumber.dart';
import 'package:trader/Services/signin_register_services.dart';
import 'package:trader/pages/HomePage.dart';

class SignupScreen extends StatefulWidget {
  String phoneNumber;

  SignupScreen(this.phoneNumber);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignupScreen> {
  User _user;

  TextEditingController _firstname = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  TextEditingController _email = TextEditingController();
  GlobalKey<FormState> _nameForm = GlobalKey();

  signupAndNext() {
    Provider.of<SigninRegisterServices>(context, listen: false)
        .signup(_user.uid, widget.phoneNumber, _email.text, _firstname.text,
            _lastname.text, '')
        .then((value) async {
      if (value == "") {
        Navigator.pop(context);
        await Future.delayed(Duration(milliseconds: 200));
        Navigator.pushReplacement(context, fadePageRoute(context, HomePage()));
      } else {
        showVeriFailMessage("Please try again after sometime");
      }
    });
  }

  showVeriFailMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    _user =
        Provider.of<SigninWithPhoneNumber>(context, listen: false).getUser();
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
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: ClipPath(
                clipper: CurveClipper(),
                child: Container(
                  color: Colors.deepPurple[400],
                  height: MediaQuery.of(context).size.height / 3,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Please enter your name first",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height / 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _nameForm,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                controller: _firstname,
                                autofocus: true,
                                keyboardType: TextInputType.name,
                                enableSuggestions: true,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter your first name';
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: 'First Name',
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    fillColor: Colors.grey,
                                    border: InputBorder.none),
                                cursorColor: Colors.black,
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                controller: _lastname,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter your last name';
                                  }

                                  return null;
                                },
                                keyboardType: TextInputType.name,
                                enableSuggestions: true,
                                decoration: InputDecoration(
                                    hintText: 'Last Name',
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    fillColor: Colors.black,
                                    border: InputBorder.none),
                                cursorColor: Colors.black,
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                controller: _email,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter your email address';
                                  }

                                  return null;
                                },
                                keyboardType: TextInputType.name,
                                enableSuggestions: true,
                                decoration: InputDecoration(
                                    hintText: 'Email address',
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    fillColor: Colors.black,
                                    border: InputBorder.none),
                                cursorColor: Colors.black,
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_nameForm.currentState.validate()) {
                              openProcessingDialog(context);
                              signupAndNext();
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
                                "Proceed",
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ),
      )),
    );
  }
}
