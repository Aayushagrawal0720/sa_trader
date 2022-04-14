import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:trader/Resources/Color.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 1,
        backgroundColor: ColorsTheme.offWhite,
        title: Text(
          "Help",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              leading: Icon(
                Icons.email,
                color: Colors.deepPurple[800],
              ),
              title: Text('quicktradesqt@gmail.com'),
            ),
            ListTile(
              leading: Icon(
                Icons.phone,
                color: Colors.deepPurple[800],
              ),
              title: Text('+91 97706 02703'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    launch('http://facebook.com/quicktradesqt');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 3,
                              offset: Offset(0, 0))
                        ]),
                    child: CircleAvatar(
                      foregroundColor: Colors.deepPurple[800],
                      child: Icon(LineIcons.facebook),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launch('http://instagram.com/quick_trades_qt');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 3,
                              offset: Offset(0, 0))
                        ]),
                    child: CircleAvatar(
                      foregroundColor: Colors.deepPurple[800],
                      child: Icon(LineIcons.instagram),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    launch('http://twitter.com/QuicktradesI');
                  },
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                      BoxShadow(
                          color: Colors.grey, blurRadius: 3, offset: Offset(0, 0))
                    ]),
                    child: CircleAvatar(
                      foregroundColor: Colors.deepPurple[800],
                      child: Icon(LineIcons.twitter),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
