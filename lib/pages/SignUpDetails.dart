import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';
import 'package:trader/Resources/Color.dart';
import 'package:trader/Resources/FadePageRoute.dart';
import 'package:trader/Resources/SupportDialogs.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/Services/signin_register_services.dart';
import 'package:trader/pages/HomePage.dart';
import 'package:trader/sharedPrefrences/sharefPrefernces.dart';

class SignUpDetails extends StatefulWidget {
  @override
  SignUpDetailsState createState() => SignUpDetailsState();
}

class SignUpDetailsState extends State<SignUpDetails> {
  FirebaseMessaging _fcm = FirebaseMessaging.instance;
  String uid;
  String fname;
  String lname;
  String email;
  String phoneNumber;
  String referedBy;
  String photoUrl;

  final referalForm = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  final emailformKey = GlobalKey<FormState>();

  String phoneNo, verificationId, smsCode;
  bool codeSent = false;
  var referByController = TextEditingController();

  bool verified = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  File _imageFile;
  bool uploading = false;

  //  ------------GET DATA FROM SHARED PREFERENCES---------------
  getDataFromStorage() async {
    SharedPreferenc().getUid().then((value) {
      this.uid = value;
    });
    SharedPreferenc().getFName().then((value) {
      this.fname = value;
    });
    SharedPreferenc().getLName().then((value) {
      this.lname = value;
    });
    SharedPreferenc().getEmail().then((value) {
      this.email = value;
    });
    SharedPreferenc().getPhotoUrl().then((value) {
      this.photoUrl = value;
    });
    SharedPreferenc().getPhoneNumber().then((value) {
      this.phoneNumber = value;
    });

    // this.uid = GetStorageClass().getUid();
    // this.name = GetStorageClass().getName();
    // this.email = GetStorageClass().getEmail();
    // this.photoUrl = GetStorageClass().getPhotoUrl();
    // this.phoneNumber = GetStorageClass().getPhoneNumber();

    if (photoUrl == null) {
      photoUrl = personImage;
    }
  }

  saveToServer() async {
    if (photoUrl == null) {
      photoUrl = personImage;
    }
    if (uploading) {
      Navigator.pop(context);
      Toast.show("Please wait while your image is being uploaded", context,
          gravity: Toast.TOP, duration: Toast.LENGTH_LONG);
    } else {
      final prov = Provider.of<SigninRegisterServices>(context, listen: false);
      prov
          .signup(uid, phoneNumber, email, fname, lname, photoUrl)
          .then((value) async {
        Navigator.pop(context);
        if (value == "") {
          Navigator.pop(context);
          await Future.delayed(Duration(milliseconds: 200));
          Navigator.pushReplacement(context,
              fadePageRoute(context, HomePage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Please try again after sometime")));
        }
      });
    }
  }

  // sendDataToServer() async {
  //   debugPrint("send data to server");
  //   SupportDialogs().ProcessingDialog(context);
  //   var connection = await SupportFunctions().checkInternetConnection();
  //   if (connection) {
  //     var dUrl = DBURL().register;
  //     Map<String, String> header = {"Content-type": "application/json"};
  //     debugPrint(uid);
  //
  //     String userData =
  //         '{"${DBKeywords.mobile}":"$phoneNumber" , "${DBKeywords.email}":"$email", "${DBKeywords.uid}":"$uid" , "${DBKeywords.name}":"$name" , "${DBKeywords.photoUrl}":"${photoUrl == null ? "" : photoUrl}","${DBKeywords.code}":"$referedBy"}';
  //     Response response = await post(dUrl, headers: header, body: userData);
  //     debugPrint(response.body.toString());
  //     debugPrint(response.statusCode.toString());
  //     if (response.statusCode == 200) {
  //       try {
  //         var data = json.decode(response.body);
  //         if (data[DBKeywords.msg].toString() ==
  //             "Email or Mobile already exist") {
  //           Navigator.pop(context);
  //           _scaffold.currentState.showSnackBar(SnackBar(
  //             content: Text(
  //                 "${emailb ? "Mobile Number Is Already In Use" : "Email Is Already In Use"}"),
  //           ));
  //           await Future.delayed(Duration(seconds: 1));
  //           Navigator.pushReplacement(
  //               context, fadePageRoute(builder: (context) => Login()));
  //         } else if (data[DBKeywords.msg].toString() ==
  //             "Invalid referral code") {
  //           Navigator.pop(context);
  //           _scaffold.currentState.showSnackBar(SnackBar(
  //             content: Text("${"Invalid Referral Code"}"),
  //           ));
  //         } else {
  //           Navigator.pop(context);
  //           setState(() {
  //             verified = true;
  //           });
  //           Navigator.pushReplacement(
  //               context, fadePageRoute(builder: (context) => HomePage()));
  //         }
  //       } catch (e) {}
  //     } else {
  //       Navigator.pop(context);
  //       _scaffold.currentState.showSnackBar(SnackBar(
  //         content: Text("Some Error Occurred, Please try After Sometime"),
  //       ));
  //     }
  //   } else {
  //     Navigator.pop(context);
  //     SupportDialogs().NoInternetDialog(context);
  //   }
  // }

  Widget appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text("COMPLETE SIGNUP PROCESS",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
            ))
      ],
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 40);

    setState(() {
      _imageFile = File(image.path);
    });
    firebase_storage.Reference ref = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child(Strings.profile_photo)
        .child(uid);

    firebase_storage.UploadTask _uploadTask = ref.putFile(_imageFile);

    setState(() {
      uploading = true;
    });

    await _uploadTask.then((value) {
      value.ref.getDownloadURL().then((value) {
        setState(() {
          uploading = false;
        });
        photoUrl = value;
      });
    });
  }

  // Future<String> verifyEmail(String email, String password) async {
  //   openProcessingDialog(context);
  //   try {
  //     AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     FirebaseUser user = result.user;
  //     user.sendEmailVerification().then((value) {
  //       SharedPreferenc().setEmail(user.email);
  //       SharedPreferenc().setFName(fname);
  //       SharedPreferenc().setLName(lname);
  //
  //       // SharedPref().setEmail(user.email);
  //       // SharedPref().setName(name);
  //       saveToServer();
  //     });
  //
  //     return user.uid;
  //   } on PlatformException catch (e) {
  //     print("An error occured while trying to send email verification");
  //     print(e.message);
  //     switch (e.code) {
  //       case 'ERROR_EMAIL_ALREADY_IN_USE':
  //         Toast.show("Email Already In Use By Other User", context,
  //             gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
  //         Navigator.pushReplacement(
  //             context, fadePageRoute(builder: (context) => LoginPage()));
  //         break;
  //     }
  //     Navigator.pop(context);
  //   }
  // }

  //---------VERIFY/LOGIN BUTTON
  Widget _emailSendButton() {
    return GestureDetector(
      onTap: () {
        if (emailformKey.currentState.validate()) {
          openProcessingDialog(context);
          // verifyEmail(email, "password");
          saveToServer();
        }
      },
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(bottom: 12, top: 12),
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                codeSent ? "LOGIN" : "VERIFY",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )),
    );
  }

  Widget emailVerificationField() {
    return Column(
      children: <Widget>[
        Stack(fit: StackFit.loose, children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                fit: StackFit.loose,
                children: [
                  Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: new BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: _imageFile == null
                              ? NetworkImage(
                              photoUrl == null ? personImage : photoUrl)
                              : FileImage(_imageFile),
                          fit: BoxFit.cover,
                        ),
                      )),
                  uploading
                      ? Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: new BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: SpinKitDoubleBounce(
                      color: ColorsTheme.primaryDark,
                      size: 24,
                    ),
                  )
                      : Container(),
                ],
              ),
            ],
          ),
          Padding(
              padding: EdgeInsets.only(top: 70.0, right: 90.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: Colors.deepPurple[600],
                      radius: 25.0,
                      child: Icon(
                        Icons.photo_library,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      getImage();
                    },
                  )
                ],
              )),
        ]),
        SizedBox(
          height: 20,
        ),
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey, width: 1)),
            child: Form(
                key: emailformKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.black,
                          focusColor: Colors.black,
                          hoverColor: Colors.black,
                          hintText: 'First name',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        onChanged: (val) {
                          setState(() {
                            this.fname = val;
                          });
                        },
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Last name";
                          }
                        },
                      ),
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.black,
                          focusColor: Colors.black,
                          hoverColor: Colors.black,
                          hintText: 'Last name',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        onChanged: (val) {
                          setState(() {
                            this.lname = val;
                          });
                        },
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter Your Name";
                          }
                        },
                      ),
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.black,
                          focusColor: Colors.black,
                          hoverColor: Colors.black,
                          hintText: 'Email ID',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        onChanged: (val) {
                          setState(() {
                            this.email = val;
                          });
                        },
                        // ignore: missing_return
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Enter Email Id";
                          }
                          if (!value.contains("@") && !value.contains(".")) {
                            return "Please Enter Correct Email Id";
                          }
                        },
                      ),
                    )
                  ],
                ))),
        SizedBox(
          height: 20,
        ),
        _emailSendButton()
      ],
    );
  }

  Widget referalCodeField() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
              "Have A Referal Code? Enter Here",
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xfff1f1f3),
                      borderRadius: BorderRadius.circular(10)),
                  child: Form(
                    key: referalForm,
                    child: TextFormField(
                      controller: referByController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Referal Code",
                        disabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                      ),
                      onChanged: (val) {
                        setState(() {
                          this.referedBy = val;
                        });
                      },
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Please Enter Code Before Proceeding";
                        }
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: GestureDetector(
                  child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ColorsTheme.primaryColor),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Proceed",
                            style: TextStyle(
                              color: ColorsTheme.primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      )),
                  onTap: () {
                    if (referalForm.currentState.validate()) {
                      if (verified) {
                        // sendDataToServer();
                      } else {
                        Toast.show("Complete SignUp To Continue", context,
                            gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
                      }
                    }
                  },
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                "Skip->",
                style: TextStyle(
                    color: Colors.grey, decoration: TextDecoration.underline),
                textAlign: TextAlign.center,
              ),
            ),
            onTap: () async {
              referedBy = null;
              if (verified) {
                // sendDataToServer();
              } else {
                Toast.show("Complete SignUp To Continue", context,
                    gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
              }
            },
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _fcm.subscribeToTopic("test");
    getDataFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(flex: 1, child: Container()),
                  appBar(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Please Fill Missing Details",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  emailVerificationField(),
                  Expanded(flex: 2, child: Container()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
