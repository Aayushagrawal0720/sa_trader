import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trader/Resources/Color.dart';
import 'package:trader/Resources/FadePageRoute.dart';
import 'file:///C:/Users/nikhi/AndroidStudioProjects/CreateWealth/sa/sa_trader/trader/lib/Services/BrokerServices/broker_login_ui_services.dart';
import 'package:trader/widgets/BrokerLoginPage.dart';

class BrokerListHomePage extends StatefulWidget {
  @override
  BrokerListHomePageState createState() => BrokerListHomePageState();
}

class BrokerListHomePageState extends State<BrokerListHomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Connect With Your Broker",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 15),
        Text(
          "Click on broker's logo and start investing in, tracking and managing calls",
          style: TextStyle(
              color: ColorsTheme.bg_lightgrey, fontSize: 18),
        ),
        Expanded(
            child: Center(
                child: Container(
                  // height: 100,
                  decoration: BoxDecoration(),
                  child: GestureDetector(
                      onTap: () async {
                        bool result= await Navigator.push(context, MaterialPageRoute(
                            builder: (context) => BrokerLoginPage("5paisa")
                        ));
                        if(result!=null) {
                          if (result) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: Image.asset("assets/brokers/5paisa.png")),
                )))
      ],
    );
  }
}
