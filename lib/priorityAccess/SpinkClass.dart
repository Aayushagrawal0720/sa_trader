// import 'dart:async';
// import 'dart:math';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';
// import 'package:shake/shake.dart';
// import 'package:trader/Resources/Color.dart';
// import 'package:trader/priorityAccess/SpinHome.dart';
// import 'package:cool_alert/cool_alert.dart';
// import 'package:trader/sharedPrefrences/sharefPrefernces.dart';
//
// class SpinPage extends StatefulWidget {
//   @override
//   SpinPageState createState() => SpinPageState();
// }
//
// class SpinPageState extends State<SpinPage> {
//   final StreamController _dividerController = StreamController<int>();
//
//   final _wheelNotifier = StreamController<double>();
//   bool correct = false;
//   double velocity = 2.0;
//
//   double _generateRandomVelocity() {
//     double val = (velocity * 6000) + 2000;
//     velocity++;
//     return val;
//   }
//
//   double _generateRandomAngle() => Random().nextDouble() * pi * 2;
//
//   endFuntion(int h) async {
//     if (correct) {
//       if (h != 2) {
//         int points = 0;
//         if (h != 7) {
//           points = int.parse(Spintext.labels[h].toString());
//           Navigator.pop(context, points);
//         } else {
//           SharedPreferenc().setCount(await SharedPreferenc().getCount() + 1);
//           correct = false;
//           CoolAlert.show(
//               context: context,
//               type: CoolAlertType.info,
//               text: "Come again to win",
//               title: "Better luck next time",
//               barrierDismissible: false,
//               onConfirmBtnTap: () {
//                 Navigator.pushAndRemoveUntil(
//                     context,
//                     fadePageRoute(builder: (context) => SpinHome()),
//                     (Route<dynamic> route) => route.isFirst);
//                 // Navigator.pushReplacement(context,
//                 //     fadePageRoute(builder: (context) => MyHomePage()));
//               });
//         }
//       }
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
//       _wheelNotifier.sink.add(
//         _generateRandomVelocity(),
//       );
//       correct = true;
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _dividerController.close();
//     _wheelNotifier.close();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SpinningWheel(
//               Image.asset(
//                 'assets/spin/wheel.png',
//               ),
//               width: MediaQuery.of(context).size.width-30,
//               height: MediaQuery.of(context).size.width-30,
//               initialSpinAngle: _generateRandomAngle(),
//               spinResistance: 0.6,
//               canInteractWhileSpinning: false,
//               dividers: 8,
//               onUpdate: _dividerController.add,
//               onEnd: endFuntion,
//               secondaryImage: Image.asset('assets/spin/pointer.png'),
//               secondaryImageHeight: 60,
//               secondaryImageWidth: 60,
//               shouldStartOrStop: _wheelNotifier.stream,
//             ),
//             SizedBox(height: 30),
//             StreamBuilder(
//               stream: _dividerController.stream,
//               builder: (context, snapshot) {
//                 if (correct)
//                   return snapshot.hasData
//                       ? RouletteScore(snapshot.data)
//                       : Container();
//                 return Container();
//               },
//             ),
//             SizedBox(height: 30),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   "assets/spin/shake.png",
//                   height: 60,
//                 ),
//                 Text("Shake your phone to spin the wheel"),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class RouletteScore extends StatelessWidget {
//   final int selected;
//
//   RouletteScore(this.selected);
//
//   @override
//   Widget build(BuildContext context) {
//     return Text('${Spintext.labels[selected]} Points',
//         style: TextStyle(color: ColorsTheme.primaryDark, fontSize: 24.0));
//   }
// }
//
// class Spintext {
//   static final Map<int, String> labels = {
//     1: Spintext.jb50,
//     2: Spintext.oms,
//     3: Spintext.jb1,
//     4: Spintext.jb10,
//     5: Spintext.pa,
//     6: Spintext.jb20,
//     7: Spintext.blnt,
//     8: Spintext.jb100,
//   };
//
//   static String jb100 = "100";
//   static String jb1 = "1";
//   static String jb10 = "10";
//   static String jb50 = "50";
//   static String jb20 = "20";
//   static String blnt = "Better Luck Next Time";
//   static String oms = "One More Spin";
//   static String pa = "150";
// }
