import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:trader/Resources/Color.dart';
import 'package:provider/provider.dart';
import 'package:trader/Resources/FadePageRoute.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/Services/BrokerServices/broker_data_services.dart';
import 'package:trader/Services/advisor_page_service.dart';
import 'package:trader/Services/bottom_navigation_service.dart';
import 'package:trader/Services/firebase_auth_services.dart';
import 'package:trader/Services/profile_info_service.dart';
import 'package:trader/Services/profile_page_service.dart';
import 'package:trader/Services/trimartketwatch_ui_services.dart';
import 'package:trader/Services/wallet_balance_service.dart';
import 'package:trader/authenticationpages/SigninScreen.dart';
import 'package:trader/pages/Login.dart';
import 'package:trader/pages/MyCalls.dart';
import 'package:trader/pages/Settings.dart';
import 'package:trader/pages/TransactionHistory/TransactionHistory.dart';
import 'package:trader/pages/patterns/AllPatterns.dart';
import 'package:trader/widgets/BrokersList.dart';
import 'package:trader/widgets/PaymentPage.dart';
import 'package:trader/widgets/TriMarketWatch.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String cardNumber = "Rs. 50,000";
  String expiryDate = "1234567890";
  String cvvCode = "123";

  creditCardView() {
    return Consumer<WalletBalanceService>(builder: (context, snapshot, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                    color: ColorsTheme.bg_lightgrey.withOpacity(0.6),
                    blurRadius: 12,
                    offset: Offset(0, 0))
              ]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Balance",
                    style: TextStyle(color: ColorsTheme.bg_grey, fontSize: 20),
                  ),
                  Text(
                    "INR",
                    style: TextStyle(color: ColorsTheme.bg_grey, fontSize: 20),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(LineIcons.rupee),
                    Text(
                      snapshot.getWallet(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 30),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              addFundButton()
            ]),
          ),
        ),
      );
    });
  }

  addFundButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: ColorsTheme.themeOrange),
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: Offset(-1, 0),
                blurRadius: 12,
              )
            ]),
        child: InkWell(
          splashColor: ColorsTheme.secondryColor,
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return PaymentPage();
                });
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  Text(
                    "Add Fund",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  profileSegment() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                  color: ColorsTheme.bg_lightgrey.withOpacity(0.6),
                  blurRadius: 12,
                  offset: Offset(0, 0))
            ]),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Consumer<ProfileInfoServices>(
            builder: (context, pps, child) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 1,
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white,
                          child: Image.network(
                              pps.geturl() == null || pps.geturl() == "null"
                                  ? personImage
                                  : pps.geturl()),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                pps.getFName() + ' ' + pps.getLName(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                pps.getemail(),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                pps.getphone(),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  // Divider(),
                  // Consumer<BrokerDataServices>(
                  //     builder: (context, snapshot, child) {
                  //       return snapshot.getStatus() == 0
                  //           ? GestureDetector(
                  //         onTap: () {
                  //           showModalBottomSheet(
                  //             context: context,
                  //             useRootNavigator: true,
                  //             isScrollControlled: true,
                  //             builder: (context) {
                  //               return BrokersList();
                  //             },
                  //           );
                  //         },
                  //         child: Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Row(
                  //               children: [
                  //                 Text(
                  //                   "Connect Broker Account",
                  //                   style: TextStyle(
                  //                       color: Colors.black, fontSize: 18),
                  //                 ),
                  //                 Icon(Icons.arrow_right)
                  //               ],
                  //             )),
                  //       )
                  //           : snapshot.getStatus() == 2
                  //           ? GestureDetector(
                  //         onTap: () {
                  //           showModalBottomSheet(
                  //             context: context,
                  //             useRootNavigator: true,
                  //             isScrollControlled: true,
                  //             builder: (context) {
                  //               return BrokersList();
                  //             },
                  //           );
                  //         },
                  //         child: Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Row(
                  //               children: [
                  //                 Text(
                  //                   "Some error occurred, \nplease login again with your broker",
                  //                   maxLines: 3,
                  //                   overflow: TextOverflow.visible,
                  //                   style: TextStyle(
                  //                       color: Colors.red, fontSize: 18),
                  //                 ),
                  //                 Icon(Icons.arrow_right)
                  //               ],
                  //             )),
                  //       )
                  //           : Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Container(
                  //           child: ListTile(
                  //             leading: Image.asset("assets/brokers/5paisa.png"),
                  //             title: Text(snapshot.getBrokerUserName(),
                  //               style: TextStyle(),),
                  //             subtitle:
                  //             Text(snapshot.getBrokerUserEmail(),
                  //               style: TextStyle(),),
                  //           ),
                  //         ),
                  //       );
                  //     }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  profileOptions() {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: ListTile(
              title: Text(
                patterns,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.push(context, fadePageRoute(context, AllPatterns()));
              },
              trailing: Icon(Icons.arrow_right),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: ListTile(
              title: Text(
                Strings.txnHistory,
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
                Strings.adviser,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Provider.of<AdviserPageService>(context, listen: false)
                    .setIndex(1);
                Provider.of<BottomNavigationService>(context, listen: false)
                    .setPageNumber(1);
              },
              trailing: Icon(Icons.arrow_right),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: ListTile(
              title: Text(
                Strings.calls,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.push(context, fadePageRoute(context, MyCalls()));
              },
              trailing: Icon(Icons.arrow_right),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: ListTile(
              title: Text(
                Strings.connect,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.push(context, fadePageRoute(context, Settings()));
              },
              trailing: Icon(Icons.arrow_right),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: ListTile(
              title: Text(
                Strings.logout,
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Provider.of<FirebaseAuthService>(context, listen: false)
                    .signOut();
                Navigator.pushAndRemoveUntil(context,
                    fadePageRoute(context, SigninScreen()), (route) => false);
              },
              trailing: Icon(Icons.arrow_right),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ProfilePageService>(context, listen: false).fetchProfile();
  }

  Future<void> refresh() async {
    Provider.of<WalletBalanceService>(context, listen: false)
        .fetchBalance('wallet');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Provider.of<BottomNavigationService>(context, listen: false)
            .setPageNumber(0);
        return;
      },
      child: Consumer<TriMarketWatchUiServices>(
          builder: (context, snapshot, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: RefreshIndicator(
              color: Colors.deepPurple[800],
              onRefresh: refresh,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    creditCardView(),
                    profileSegment(),
                    profileOptions()
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
