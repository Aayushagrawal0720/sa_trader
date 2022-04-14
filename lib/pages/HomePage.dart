import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trader/NavigationPages/ExploreAdvisors.dart';
import 'package:trader/NavigationPages/HomeScreen.dart';
import 'package:trader/NavigationPages/ProfilePage.dart';
import 'package:trader/Resources/Color.dart';
import 'package:trader/Resources/FadePageRoute.dart';
import 'package:trader/Services/advisor_page_service.dart';
import 'package:trader/Services/bottom_navigation_service.dart';
import 'package:trader/Services/calls_page_service.dart';
import 'package:trader/Services/home_page_services.dart';
import 'package:trader/Services/internal_payment_page_services.dart';
import 'package:trader/Services/package_selector_internal_paymentpage_service.dart';
import 'package:trader/Services/profile_info_service.dart';
import 'package:trader/Services/trimartketwatch_ui_services.dart';
import 'package:trader/sharedPrefrences/sharefPrefernces.dart';
import 'package:trader/widgets/TriMarketWatch.dart';
import 'MyCalls.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String uid;
  String name;
  String email;
  String phoneNumber;
  String photoUrl;

  FirebaseMessaging _fcm = FirebaseMessaging.instance;

  var pages = [HomeScreen(), ExploreAdvisors(), ProfilePage()];
  Offset position;

  GlobalKey<ScaffoldState> _key = GlobalKey();

  Widget bnb() {
    var bnbSelector =
        Provider.of<BottomNavigationService>(context, listen: true);

    return FlashyTabBar(
        backgroundColor: ColorsTheme.offWhite,
        selectedIndex: bnbSelector.getPage(),
        onItemSelected: (int index) {
          if (Provider.of<AdviserPageService>(context, listen: false)
                  .getIndex() ==
              1) {
            Provider.of<AdviserPageService>(context, listen: false).setIndex(0);
          }

          //INITIALISING DEFAULT VALUES IN ADVISOR PAGE
          if (Provider.of<BottomNavigationService>(context, listen: false)
                  .getPage() !=
              1) {
            Provider.of<AdviserPageService>(context, listen: false)
                .setInitialValues();
            Provider.of<InternalPaymentPageServices>(context, listen: false)
                .setInitialValues();
            Provider.of<PackageSelectorInternalPayamentPageService>(context,
                    listen: false)
                .resetPackageSelection();
          }
          //INITIALISING DEFAULT VALUES IN CALL PAGE
          if (Provider.of<BottomNavigationService>(context, listen: false)
                  .getPage() !=
              0) {
            Provider.of<CallsPageService>(context, listen: false)
                .setInitialValues();
            Provider.of<InternalPaymentPageServices>(context, listen: false)
                .setInitialValues();
            Provider.of<PackageSelectorInternalPayamentPageService>(context,
                    listen: false)
                .resetPackageSelection();
          }

          Provider.of<BottomNavigationService>(context, listen: false)
              .setPageNumber(index);
        },
        items: [
          FlashyTabBarItem(
              title: Text("Home"),
              icon: Icon(
                Icons.home,
              ),
              activeColor: ColorsTheme.themeOrange,
              inactiveColor: Colors.black),
          FlashyTabBarItem(
              activeColor: ColorsTheme.themeOrange,
              inactiveColor: Colors.black,
              title: Text("Explore Analyst"),
              icon: Icon(
                Icons.group,
              )),
          FlashyTabBarItem(
              title: Text("Profile"),
              icon: Icon(Icons.person),
              activeColor: ColorsTheme.themeOrange,
              inactiveColor: Colors.black)
        ]);
  }

  Widget fab() {
    return FloatingActionButton.extended(
        backgroundColor: ColorsTheme.themeLightOrange,
        label: Text(
          "My Calls",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        icon: Icon(
          Icons.thumb_up,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
              context, fadePageRoute(context, MyCalls()));
        });
  }

  getToken() async {
    String token = await _fcm.getToken();
    if (token != null) {
      SharedPreferenc().getUid().then((String uid) {
        Provider.of<HomePageServices>(context, listen: false)
            .sendTokenToServer(token, uid);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
    Provider.of<ProfileInfoServices>(context, listen: false).fetchInfo();
    Provider.of<HomePageServices>(context, listen: false).checkUserUid();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationService>(
        builder: (context, bnbSelector, child) {
      return SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(
                  Provider.of<TriMarketWatchUiServices>(context, listen: true)
                          .getExpanded()
                      ? MediaQuery.of(context).size.height / 3
                      : MediaQuery.of(context).size.height / 16),
              child: Container(
                color: ColorsTheme.offWhite,
                child: TriMarketWatch(bnbSelector.getPage()),
              )),
          floatingActionButton: fab(),
          key: _key,
          bottomNavigationBar: bnb(),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: pages[bnbSelector.getPage()],
          ),
        ),
      );
    });
  }
}
