import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trader/Services/auth/signin_with_phonenumber.dart';
import 'HomePage.dart';
import 'Login.dart';

class UserCheck extends StatefulWidget {
  @override
  UserCheckClass createState() => UserCheckClass();
}

class UserCheckClass extends State<UserCheck> {
  var dataLoaded = false;
  var userExist = false;
  Widget page;
  bool optionPage = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<SigninWithPhoneNumber>(context, listen: true);
    return FutureBuilder<FUser>(
      // future: _auth.initialisingFirebaseAuth,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            FUser user = snapshot.data;
            if (user != null) {
              return HomePage();
            }
            return LoginPage();
          }
          return Scaffold(
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Center(
                  child: Image.asset(
                    'assets/logo/quicktrades.png',
                    scale: 150,
                  ),
                )),
          );
        });
  }
}
