import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trader/Resources/Color.dart';
import 'package:trader/Resources/title_text.dart';
import 'package:trader/Services/advisor_calls_services.dart';
import 'package:trader/Services/profile_info_service.dart';
import 'package:trader/dataClasses/AdvisorClass.dart';
import 'package:trader/dataClasses/CallsClas.dart';
import 'package:trader/widgets/CallsCard.dart';
import 'package:trader/widgets/MyCallsCard.dart';

class AdvisorCallsPage extends StatefulWidget {
  AdvisorClass advisor;

  AdvisorCallsPage({this.advisor});

  @override
  CallsPageState createState() => CallsPageState();
}

class CallsPageState extends State<AdvisorCallsPage> {
  List<CallsClass> _calls = List();

  Widget _appbar() {
    return Consumer<AdvisorCallsService>(
      builder: (context, cps, child) {
        return Row(
          children: <Widget>[
            CupertinoNavigationBarBackButton(
              color: ColorsTheme.primaryColor,
            ),
            SizedBox(width: 20),
            TitleText(
              text: cps.getTitle(),
              color: ColorsTheme.primaryColor,
            )
          ],
        );
      },
    );
  }

  callsListView() {
    return Consumer<AdvisorCallsService>(
      builder: (context, cps, child) {
        _calls = cps.getCalls();
        String _message = cps.getMessage();
        print(_message);
        if (_message == 'No record found') {
          return notRecordFound();
        } else if (_message == 'error') {
          return errorWidget();
        }
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: _calls.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _calls[index].visible == null
                      ? CallsCard(_calls[index], index)
                      : _calls[index].visible
                          ? MyCallsCard(_calls[index], index)
                          : CallsCard(_calls[index], index),
                );
              }),
        );
      },
    );
  }

  Widget notRecordFound() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
          child: Text(
        'No record found',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
    );
  }

  Widget errorWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/other/error.png"),
      ],
    );
  }

  Future<void> refreshPage() async {
    await Provider.of<AdvisorCallsService>(context, listen: false)
        .refreshFunction(
            Provider.of<ProfileInfoServices>(context, listen: false).getuid(),
            widget.advisor);
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<AdvisorCallsService>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 1,
        backgroundColor: ColorsTheme.offWhite,
        title:
            Consumer<AdvisorCallsService>(builder: (context, snapshot, child) {
          return Text(
            snapshot.getTitle(),
            style: TextStyle(color: Colors.black),
          );
        }),
      ),
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: refreshPage,
        color: ColorsTheme.themeOrange,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              FutureBuilder(
                  future: prov.fetchCalls2(
                      Provider.of<ProfileInfoServices>(context, listen: false)
                          .getuid(),
                      widget.advisor),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return callsListView();
                    }
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: SpinKitDoubleBounce(
                        color: ColorsTheme.primaryDark,
                        size: 32,
                      ),
                    );
                  })
            ],
          ),
        ),
      )),
    );
  }
}
