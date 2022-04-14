import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trader/Resources/Color.dart';
import 'package:trader/Resources/SupportDialogs.dart';
import 'package:trader/Resources/SupportFunctions.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/Resources/title_text.dart';
import 'package:trader/Services/profile_info_service.dart';
import 'package:trader/sharedPrefrences/sharefPrefernces.dart';

class EditProfile extends StatefulWidget {
  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  bool _notEditMode = false;

  String name;
  String email;
  String phoneNumber;
  String photoUrl = Strings.profile_photo;
  bool data = false;
  String uid;
  GlobalKey<ScaffoldState> _scaffold = GlobalKey();

  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  saveProfileToServer() async {
    openProcessingDialog(context);
    var connection = await SupportFunctions().checkInternetConnection();
    if (connection) {
      String url = editProfile;
      Map<String, String> header = {"Content-type": "application/json"};
      String body =
          '{"${Strings.uid}":"$uid","${Strings.fname}":"${fNameController.text}","${Strings.lname}":"${lNameController.text}"}';
      Response response =
          await post(Uri.parse(url), headers: header, body: body);
      var data = json.decode(response.body);
      if (data["msg"].toString() == "true") {
        SharedPreferenc().setFName(fNameController.text);
        SharedPreferenc().setLName(lNameController.text);
        int count = 0;

        Navigator.of(context).popUntil((_) => count++ >= 2);
      } else {
        Navigator.pop(context);
        _scaffold.currentState.showSnackBar(SnackBar(
            content: Text(
          "Some Error Occurred, Please Try After Sometime",
          style: TextStyle(),
        )));
      }
    } else {
      Navigator.pop(context);
      _scaffold.currentState.showSnackBar(SnackBar(
          content: Text(
        "Some Error Occurred, Please Try after Sometime",
        style: TextStyle(),
      )));
    }
  }

//  File _imageFile;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
//      _imageFile = image;
    });
  }

  Widget _getActionButtons() {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
        child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      if (fNameController.text == "" ||
                          fNameController.text.isEmpty ||
                          lNameController.text == "" ||
                          lNameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Name Field Can't Be Empty"),
                        ));
                      } else {
                        saveProfileToServer();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: ColorsTheme.themeOrange,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0, 0),
                                blurRadius: 6)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10),
                        child: Center(
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0, 0),
                                blurRadius: 6)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10),
                        child: Center(child: Text("Cancel")),
                      ),
                    ),
                  ),
                ),
              )
            ]));
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: ColorsTheme.teal,
        radius: 16.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _notEditMode = false;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      body: SafeArea(
        child:
            Consumer<ProfileInfoServices>(builder: (context, snapshot, child) {
          fNameController.text = snapshot.getFName();
          lNameController.text = snapshot.getLName();
          emailController.text = snapshot.getemail();
          phoneNumberController.text = snapshot.getphone();

          return Container(
              child: ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: <Widget>[
              Row(
                children: <Widget>[
                  CupertinoNavigationBarBackButton(
                    color: Colors.black,
                  ),
                  TitleText(
                    text: "Edit Profile",
                    color: Colors.black,
                  )
                ],
              ),
              new Container(
                height: MediaQuery.of(context).size.width / 2,
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Stack(fit: StackFit.loose, children: <Widget>[
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                                width: 140.0,
                                height: 140.0,
                                decoration: new BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(photoUrl),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 90.0, right: 100.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new GestureDetector(
                                  child: CircleAvatar(
                                    backgroundColor: ColorsTheme.amber,
                                    radius: 25.0,
                                    child: new Icon(
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
                    )
                  ],
                ),
              ),
              new Container(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 25.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    "Personal Information",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  _notEditMode
                                      ? _getEditIcon()
                                      : new Container(),
                                ],
                              )
                            ],
                          )),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: Text(
                          'Name',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: new TextField(
                          controller: fNameController,
                          decoration: const InputDecoration(
                            hintText: "First name",
                          ),
                          enabled: _notEditMode,
                          autofocus: !_notEditMode,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: new TextField(
                          controller: lNameController,
                          decoration: const InputDecoration(
                            hintText: "Last name",
                          ),
                          enabled: _notEditMode,
                          autofocus: !_notEditMode,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: Text(
                          'Email ID',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: TextField(
                          controller: emailController,
                          decoration:
                              const InputDecoration(hintText: "Enter Email ID"),
                          enabled: _notEditMode,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: Text(
                          'Mobile',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: TextField(
                          controller: phoneNumberController,
                          decoration: const InputDecoration(
                              hintText: "Enter Mobile Number"),
                          enabled: _notEditMode,
                        ),
                      ),
                      !_notEditMode ? _getActionButtons() : new Container(),
                    ],
                  ),
                ),
              )
            ],
          ));
        }),
      ),
    );
  }
}
