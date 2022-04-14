// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart';
// import 'package:line_icons/line_icons.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:trader/Resources/Color.dart';
// import 'package:trader/Resources/title_text.dart';
// import 'package:trader/dataClasses/TransactionHistoryClass.dart';
//
// class TransactionDetailsSheet extends StatefulWidget {
//   TransactionHistoryClass obj;
//   String name;
//   String sName;
//
//   TransactionDetailsSheet(this.obj, this.name,this.sName);
//
//   @override
//   TransactionDetailsSheetState createState() =>
//       TransactionDetailsSheetState(obj,name,sName);
// }
//
// class TransactionDetailsSheetState extends State<TransactionDetailsSheet> {
//   TransactionHistoryClass obej;
//   String name;
//   String secondName;
//   bool isDetails=false;
//   String sName;
//
//
//
//
//   TransactionDetailsSheetState(this.obej, this.name, this.sName){
//   }
//
//
//   Widget heading() {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       child:
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           obej.type == 0
//               ? TitleText(
//                   text: "Money Added",
//                 )
//               : obej.type == 1
//                   ? TitleText(
//                       text: "Money Withdrawn",
//                     )
//                   : TitleText(
//                       text: "Reward Recieved",
//                     ),
//           SizedBox(
//             height: 10,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               Icon(
//                 LineIcons.rupee,
//                 size: 30,
//                 color: ColorsTheme.primaryColor,
//               ),
//               Text(
//                 obej.amount,
//                 style: TextStyle(
//                     color: ColorsTheme.primaryColor,
//                     fontSize: 30,
//                     decoration: TextDecoration.none),
//               )
//             ],
//           ),
//           SizedBox(
//             height: 30,
//           ),
//           Text(
//             obej.date,
//             style: TextStyle(
//                 color: Colors.grey,
//                 decoration: TextDecoration.none,
//                 fontSize: 12),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget center() {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Row(
//             children: <Widget>[
//               Text(
//                 "TxnId:",
//                 style: TextStyle(
//                     color: Colors.grey,
//                     decoration: TextDecoration.none,
//                     fontSize: 14),
//               ),
//               Text(
//                 obej.txnId,
//                 style: TextStyle(
//                     color: Colors.grey,
//                     decoration: TextDecoration.none,
//                     fontSize: 14),
//               )
//             ],
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Column(
//                 children: <Widget>[
//                   CircleAvatar(
//                     backgroundColor: ColorsTheme.primaryColor,
//                     radius: 50,
//                     child: Icon(Icons.account_balance_wallet),
//                   ),
//                   Text(
//                     name,
//                     style: TextStyle(
//                         color: Colors.black,
//                         decoration: TextDecoration.none,
//                         fontSize: 14),
//                   )
//                 ],
//               ),
//               Icon(
//                 obej.type == 1 ? Icons.arrow_right : Icons.arrow_left,
//                 size: 50,
//                 color: obej.type == 0 || obej.type == 2
//                     ? Colors.green
//                     : Colors.red,
//               ),
//               Icon(
//                 obej.type == 1 ? Icons.arrow_right : Icons.arrow_left,
//                 size: 50,
//                 color: obej.type == 0 || obej.type == 2
//                     ? Colors.green
//                     : Colors.red,
//               ),
//               Icon(
//                 obej.type == 1 ? Icons.arrow_right : Icons.arrow_left,
//                 size: 50,
//                 color: obej.type == 0 || obej.type == 2
//                     ? Colors.green
//                     : Colors.red,
//               ),
//               Column(
//                 children: <Widget>[
//                   CircleAvatar(
//                     backgroundColor: ColorsTheme.primaryColor,
//                     radius: 50,
//                     child: Icon(Icons.pages),
//                   ),
//                   Text(
//                     secondName,
//                     style: TextStyle(
//                         color: Colors.black,
//                         decoration: TextDecoration.none,
//                         fontSize: 14),
//                   )
//                 ],
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget statusButton(){
//     return Container(
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(30),
//         color: obej.status==0?Colors.green: obej.status==1?Colors.red:Colors.yellow
//       ),
//       child:
//       Text(obej.status==0?"Success": obej.status==1?"Failed":"Pending",
//       style: TextStyle(
//          color: obej.status==0?Colors.white: obej.status==1?Colors.white:Colors.black,
//         fontSize: 16,
//         decoration: TextDecoration.none
//       ),),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       Container(
//       margin: EdgeInsets.symmetric(horizontal: 20),
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height - 100,
//       child: isDetails? Stack(
//         children: <Widget>[
//           Column(
//             children: <Widget>[
//               SizedBox(
//                 height: 20,
//               ),
//               heading(),
//               SizedBox(
//                 height: 40,
//               ),
//               center()
//             ],
//           ),
//           Positioned(
//             right: 50,
//             top: 50,
//             child: statusButton(),
//           )
//         ],
//       ): Center(
//         child: SpinKitDoubleBounce(
//           color: ColorsTheme.primaryDark,
//           size: 32,
//         ),
//       )
//
//     );
//   }
// }
