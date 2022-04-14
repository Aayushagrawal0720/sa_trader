import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trader/Services/auth/signin_with_phonenumber.dart';
import 'package:trader/authenticationpages/SigninScreen.dart';

import '../HomePage.dart';

class LoadingPage extends StatefulWidget {
  @override
  LoadingPageState createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  // Animation _animation;
  // AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // _animationController =
    //     AnimationController(vsync: this, duration: Duration(seconds: 1));
    // _animation = Tween<double>(
    //   begin: 0,
    //   end: 150,
    // ).animate(_animationController)
    //   ..addListener(() {
    //     Provider.of<SplashScreenService>(context, listen: false)
    //         .setValue(_animation.value);
    //   });
    //
    // _animationController.forward();

  }

  @override
  void dispose() {
    super.dispose();
    // _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<SigninWithPhoneNumber>(context, listen: true);
    return StreamBuilder<FUser>(
        stream: _auth.initialisingFirebaseAuth,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            FUser user = snapshot.data;
            if (user != null) {
              return HomePage();
            }
            return SigninScreen();
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
