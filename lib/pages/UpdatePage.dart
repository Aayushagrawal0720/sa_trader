import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trader/Resources/Color.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/Services/app_version_service.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePage extends StatefulWidget {
  @override
  UpdatePageState createState() => UpdatePageState();
}

class UpdatePageState extends State<UpdatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(child: Container()),
                FractionallySizedBox(
                  widthFactor: 0.4,
                  child: Image.asset('assets/logo/quicktrades.png'),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("New Update Available."),
                SizedBox(
                  height: 20,
                ),
                FractionallySizedBox(
                  widthFactor: 0.5,
                  child: InkWell(
                    highlightColor: Colors.red,
                    splashColor: Colors.red,
                    onTap: () {
                      launch(appUrl);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: ColorsTheme.themeOrange,
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                            )
                          ]),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                        child: Text(
                          'Update',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Consumer<AppVersionService>(
                    builder: (context, snapshot, child) {
                  if (snapshot.priorityUpdate) {
                    return Container();
                  }
                  return FractionallySizedBox(
                    widthFactor: 0.5,
                    child: InkWell(
                      highlightColor: Colors.red,
                      splashColor: Colors.red,
                      onTap: () {
                        snapshot.setHaveVersionFalse();
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                        child: Text(
                          'Skip',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  );
                }),
                Expanded(child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
