import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trader/Services/BrokerServices/broker_login_ui_services.dart';


class BrokersList extends StatefulWidget {
  @override
  BrokersListState createState() => BrokersListState();
}

class BrokersListState extends State<BrokersList> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Consumer<BrokerLoginUiServices>(
          builder: (context, snapshot, child) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: snapshot.getPage(),
        );
      }),
    );
  }
}
