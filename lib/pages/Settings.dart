import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trader/Resources/Color.dart';
import 'package:trader/Resources/FadePageRoute.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:trader/pages/help/help.dart';

import 'TransactionHistory/TransactionHistory.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  profileOptions() {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: ListTile(
              title: Text(
                Strings.privacyPolicy,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.push(
                    context, fadePageRoute(context, TransactionHistory()));
              },
              trailing: Icon(Icons.arrow_right),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: ListTile(
              title: Text(
                Strings.termsOfUse,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Toast.show("Help", context, duration: Toast.LENGTH_LONG);
              },
              trailing: Icon(Icons.arrow_right),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: ListTile(
              title: Text(
                Strings.help,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.push(context, fadePageRoute(context, HelpPage()));
              },
              trailing: Icon(Icons.arrow_right),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          elevation: 1,
          backgroundColor: ColorsTheme.offWhite,
          title: Text(
            "Connect",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [profileOptions()],
          ),
        )));
  }
}
