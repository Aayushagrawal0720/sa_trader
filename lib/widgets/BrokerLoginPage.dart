import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trader/Resources/Color.dart';
import 'package:trader/Services/BrokerServices/broker_data_services.dart';
import 'package:trader/widgets/BrokersList.dart';

class BrokerLoginPage extends StatefulWidget{

  String brokerName;
  BrokerLoginPage(this.brokerName);
  @override
  BrokerLoginPageState createState() =>BrokerLoginPageState();
}

class BrokerLoginPageState extends State<BrokerLoginPage>{
  Widget fivePaisaLogin() {
    TextEditingController userNameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController dobController = TextEditingController();
    return Container(
      child: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          Row(
            children: [
              Image.asset(
                "assets/brokers/5paisa.png",
                height: 50,
              ),
              Text("5Paisa")
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: userNameController,
              decoration: InputDecoration(
                hintText: "Email/Client Code/Mobile",
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: ColorsTheme.darkred)),
                disabledBorder: InputBorder.none,
              ),
              // ignore: missing_return
              validator: (String value) {
                if (value.isEmpty) {
                  return "Enter Your Email/Client Code/Mobile";
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: "Password",
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: ColorsTheme.darkred)),
                disabledBorder: InputBorder.none,
              ),
              // ignore: missing_return
              validator: (String value) {
                if (value.isEmpty) {
                  return "Enter Your Password";
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: dobController,
              decoration: InputDecoration(
                hintText: "Date of Birth (DDMMYYYY)",
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: ColorsTheme.darkred)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: ColorsTheme.darkred)),
                disabledBorder: InputBorder.none,
              ),
              // ignore: missing_return
              validator: (String value) {
                if (value.isEmpty) {
                  return "Enter Your Correct DOB";
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {

                Provider.of<BrokerDataServices>(context, listen: false).setData(
                    "brokerName", "brokerUserName", "brokerUserID", "brokerUserEmail");
                Navigator.pop(context, true);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: ColorsTheme.darkred,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                          color: ColorsTheme.bg_lightgrey.withOpacity(0.3),
                          offset: Offset(0, 0),
                          blurRadius: 6)
                    ]),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  getLoginPage(){
    switch(widget.brokerName){
      case "5paisa":{
        return fivePaisaLogin();
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: getLoginPage(),
      ),
    );
  }

}
