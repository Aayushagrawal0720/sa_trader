// import 'package:cool_alert/cool_alert.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';
// import 'package:trader/Resources/Color.dart';
// import 'package:trader/Services/app_version_service.dart';
// import 'package:trader/Services/profile_info_service.dart';
// import 'package:trader/pages/HomePage.dart';
// import 'package:trader/pages/UpdatePage.dart';
// import 'package:trader/priorityAccess/SpinkClass.dart';
// import 'package:trader/priorityAccess/prority_access_services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:trader/sharedPrefrences/sharefPrefernces.dart';
//
// class SpinHome extends StatefulWidget {
//   @override
//   SpinHomeState createState() => SpinHomeState();
// }
//
// class SpinHomeState extends State<SpinHome> {
//   int i = 0;
//   bool show = false;
//   bool priorShow = false;
//
//   ProcessingDialog() {
//     Dialog dialog = Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//           return Container(
//             height: MediaQuery.of(context).size.height / 4,
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//                 color: Colors.white, borderRadius: BorderRadius.circular(20)),
//             child: Center(
//               child: SpinKitDoubleBounce(
//                 color: ColorsTheme.primaryDark,
//                 size: 32,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//
//     showDialog(
//         context: context,
//         builder: (BuildContext context) => dialog,
//         barrierDismissible: false);
//   }
//
//   void updateFuntion(int points) async {
//     SharedPreferenc().getCount().then((count) {
//       ProcessingDialog();
//
//       if (count == null) {
//         count = 0;
//       }
//
//       PriorityAccessServices()
//           .updatePoints(points,
//               Provider.of<ProfileInfoServices>(context, listen: false).getuid())
//           // ignore: missing_return
//           .then((value) async {
//         Navigator.pop(context);
//         if (value) {
//           SharedPreferenc().setCount(count + 1);
//           SharedPreferenc().setDate(DateTime.now().toString());
//
//           checkDateCount();
//
//           CoolAlert.show(
//               context: context,
//               type: CoolAlertType.success,
//               text: "$points added to you account",
//               title: "Position Updated Successfully",
//               barrierDismissible: false,
//               onConfirmBtnTap: () {
//                 Navigator.pop(context);
//                 // Navigator.pushReplacement(context,
//                 //     fadePageRoute(builder: (context) => MyHomePage()));
//               });
//           SharedPreferenc().getPoints().then((value) {
//             setState(() {
//               if (value != null) {
//                 i = value;
//               } else {
//                 i = 0;
//               }
//             });
//           });
//         } else {
//           checkDateCount();
//
//           CoolAlert.show(
//               context: context,
//               type: CoolAlertType.error,
//               text: "Please come again next time",
//               title: "Failed to update points",
//               barrierDismissible: false,
//               onConfirmBtnTap: () {
//                 Navigator.pop(context);
//                 // Navigator.pushReplacement(context,
//                 //     fadePageRoute(builder: (context) => MyHomePage()));
//               });
//         }
//       });
//     });
//   }
//
//   Widget spinkWheelButton() {
//     return GestureDetector(
//       onTap: () async {
//         int result = await Navigator.push(
//             context, fadePageRoute(builder: (context) => SpinPage()));
//         if (result != 0 && result != null) {
//           updateFuntion(result);
//         }
//       },
//       child: Padding(
//         padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 80),
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height / 6,
//           decoration: BoxDecoration(boxShadow: [
//             BoxShadow(color: Colors.grey, offset: Offset(0, 0), blurRadius: 12)
//           ], borderRadius: BorderRadius.circular(20), color: ColorsTheme.darkred
//               //     gradient: LinearGradient(colors: [
//               //   ColorsTheme.darkred.withAlpha(670),
//               //   ColorsTheme.darkred.withAlpha(725),
//               //   ColorsTheme.darkred.withAlpha(670),
//               // ], stops: [
//               //   0.0,
//               //   0.6,
//               //   1.0
//               // ])
//               ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "Spin The Wheel",
//                   style: TextStyle(color: Colors.white, fontSize: 22),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   "(Click here)",
//                   style: TextStyle(color: Colors.grey.withAlpha(200)),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   "and get chance to improve your priority ranking",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.amber,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget spinkWheelDisableButton() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 80),
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height / 6,
//         decoration: BoxDecoration(boxShadow: [
//           BoxShadow(color: Colors.grey, offset: Offset(0, 0), blurRadius: 12)
//         ], borderRadius: BorderRadius.circular(20), color: ColorsTheme.darkred),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "You can spin wheel upto 5 times a day",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.white, fontSize: 22),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 "Come back tomorrow for 5 more spins",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.amber,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget spinkWheelPriorityButton() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 80),
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height / 6,
//         decoration: BoxDecoration(boxShadow: [
//           BoxShadow(color: Colors.grey, offset: Offset(0, 0), blurRadius: 12)
//         ], borderRadius: BorderRadius.circular(20), color: ColorsTheme.darkred),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "Congratulations!!!",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.white, fontSize: 22),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 "Now you are one of our priority user",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.amber,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   checkDateCount() async {
//     String datee = await SharedPreferenc().getDate();
//     int count = await SharedPreferenc().getCount();
//     int points = await SharedPreferenc().getPoints();
//
//     if (count == null) {
//       count = 0;
//     }
//     if (points == null) {
//       points = 0;
//     }
//
//     if (count < 5) {
//       setState(() {
//         show = true;
//       });
//     } else {
//       String date = datee;
//
//       if (date != "false") {
//         final DateTime dt = DateTime.parse(date);
//         if (dt.day == DateTime.now().day) {
//           setState(() {
//             show = false;
//           });
//         } else {
//           SharedPreferenc().setCount(0);
//           SharedPreferenc().setDate(DateTime.now().toString());
//           setState(() {
//             show = true;
//           });
//         }
//       } else {
//         SharedPreferenc().setDate(DateTime.now().toString());
//         setState(() {
//           show = false;
//         });
//       }
//     }
//
//     if ((1000 - points) <= 0) {
//       setState(() {
//         priorShow = true;
//       });
//     }
//
//     // String date = GetStorageClass().getDate();
//     //
//     // if (date != "false") {
//     //   final DateTime dt = DateTime.parse(date);
//     //   if (dt == DateTime.now()) {
//     //     setState(() {
//     //       show = false;
//     //     });
//     //   } else {
//     //     setState(() {
//     //       show = true;
//     //     });
//     //   }
//     // } else {
//     //   setState(() {
//     //     show = true;
//     //   });
//     // }
//   }
//
//   checkInitDateCount() async {
//     String datee = await SharedPreferenc().getDate();
//     int count = await SharedPreferenc().getCount();
//     int points = await SharedPreferenc().getPoints();
//
//     if (count == null) {
//       count = 0;
//     }
//     if (points == null) {
//       points = 0;
//     }
//
//     if (count < 5) {
//       show = true;
//     } else {
//       String date = datee;
//
//       if (date != "false") {
//         final DateTime dt = DateTime.parse(date);
//         if (dt.day == DateTime.now().day) {
//           show = false;
//         } else {
//           SharedPreferenc().setCount(0);
//           SharedPreferenc().setDate(DateTime.now().toString());
//           show = true;
//         }
//       } else {
//         SharedPreferenc().setDate(DateTime.now().toString());
//         show = false;
//       }
//     }
//
//     if ((1000 - points) <= 0) {
//       priorShow = true;
//     }
//
//     // String date = GetStorageClass().getDate();
//     //
//     // if (date != "false") {
//     //   final DateTime dt = DateTime.parse(date);
//     //   if (dt == DateTime.now()) {
//     //     setState(() {
//     //       show = false;
//     //     });
//     //   } else {
//     //     setState(() {
//     //       show = true;
//     //     });
//     //   }
//     // } else {
//     //   setState(() {
//     //     show = true;
//     //   });
//     // }
//   }
//
//   getcCount() async {
//     var value = await SharedPreferenc().getPoints();
//     setState(() {
//       if (value != null) {
//         i = value;
//       } else {
//         i = 0;
//       }
//     });
//   }
//
//   getcInitCount() async {
//     var value = await SharedPreferenc().getPoints();
//     if (value != null) {
//       i = value;
//     } else {
//       i = 0;
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Widget spinHomeWidgets() {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//           child: Padding(
//         padding: const EdgeInsets.all(14.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pushReplacement(context,
//                       fadePageRoute(builder: (context) => HomePage()));
//                 },
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   child: Text(
//                     "Skip",
//                     textAlign: TextAlign.right,
//                     style: TextStyle(
//                         decoration: TextDecoration.underline,
//                         color: Colors.grey),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(40.0),
//                 child: Image.asset(
//                   "assets/logo/quicktrades.png",
//                   height: 80,
//                 ),
//               ),
//               Text(
//                 "Hey ${Provider.of<ProfileInfoServices>(context, listen: false).getname()},\nthanks for joining the Quicktrades",
//                 textAlign: TextAlign.left,
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 26),
//               ),
//               SizedBox(
//                 height: 60,
//               ),
//               priorShow
//                   ? Container()
//                   : RichText(
//                       textAlign: TextAlign.center,
//                       text: TextSpan(
//                           style: TextStyle(
//                             color: Colors.black.withAlpha(200),
//                           ),
//                           children: [
//                             TextSpan(
//                                 text:
//                                     "You all early birds! Here's a surprise for you .\nYou are just "),
//                             TextSpan(
//                               text: "${1000 - i} peoples ",
//                               style: TextStyle(
//                                   color: Colors.black.withAlpha(200),
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             TextSpan(
//                                 text:
//                                     "away to become Priority Access . SPIN WHEEL KEEP TERMINATING YOUR POSITION! DON'T LOOSE HOPE !\nALL THE BEST."),
//                           ]),
//                     ),
//               SizedBox(
//                 height: 15,
//               ),
//               priorShow
//                   ? spinkWheelPriorityButton()
//                   : show
//                       ? spinkWheelButton()
//                       : spinkWheelDisableButton()
//             ],
//           ),
//         ),
//       )),
//     );
//   }
//
//   initialBatchOperations() async {
//     SharedPreferenc().setPoints(1001);
//
//     await Provider.of<ProfileInfoServices>(context, listen: false).fetchInfo();
//
//     // await PriorityAccessServices().fetchPoints(
//     //     await Provider.of<ProfileInfoServices>(context, listen: false)
//     //         .getuid());
//     SharedPreferenc().getPoints().then((value) {
//       try {
//         if (value != null) {
//           if (value >= 1000) {
//             Navigator.pushReplacement(
//                 context, fadePageRoute(builder: (context) => HomePage()));
//           }
//         }
//       } catch (e) {
//         print(e);
//       }
//     });
//     await checkInitDateCount();
//     await getcInitCount();
//
//     await Provider.of<AppVersionService>(context, listen: false).getVersion();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: initialBatchOperations(),
//         builder: (context, snapshot) {
//           if (ConnectionState.done == snapshot.connectionState) {
//             return Consumer<AppVersionService>(
//                 builder: (context, snapshot, child) {
//               if (snapshot.getHaveVersion() == false) {
//                 return HomePage();
//               } else {
//                 return UpdatePage();
//               }
//             });
//           }
//           return Scaffold(
//             body: Center(
//                 child: Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Flexible(
//                   child: FractionallySizedBox(
//                       heightFactor: 0.1,
//                       child: Image.asset("assets/logo/quicktrades.png")),
//                 ),
//                 SizedBox(height: 20,),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 2,
//                   child: LinearProgressIndicator(
//                     backgroundColor: Colors.grey,
//                     valueColor:
//                         AlwaysStoppedAnimation<Color>(ColorsTheme.darkred),
//                   ),
//                 ),
//               ],
//             )),
//           );
//         });
//   }
// }
