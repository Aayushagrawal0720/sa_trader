import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trader/Resources/Color.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/Services/my_calls_service.dart';
import 'package:trader/Services/profile_info_service.dart';
import 'package:trader/dataClasses/CallsClas.dart';
import 'package:provider/provider.dart';
import 'package:trader/widgets/MyCallsCard.dart';

class MyCalls extends StatefulWidget {
  @override
  MyClassState createState() => MyClassState();
}

class MyClassState extends State<MyCalls> {
  List<CallsClass> _activeCalls = List();

  Widget allCallPage() {
    Provider.of<MyCallsService>(context, listen: false).fetchCalls2(
        Provider.of<ProfileInfoServices>(context, listen: false).getuid());

    return Consumer<MyCallsService>(
      builder: (context, cps, child) {
        _activeCalls = cps.getCalls();
        bool empty = false;
        if (_activeCalls.length == 0) {
          empty = true;
        }
        return cps.getLoading()
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: SpinKitDoubleBounce(
                    color: ColorsTheme.primaryDark,
                    size: 32,
                  ),
                ),
              )
            : empty
                ? Center(
                    child: Text(
                      "No Subscribed Call Found",
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: _activeCalls.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MyCallsCard(_activeCalls[index], index));
                        }),
                  );
      },
    );
  }


  filterSection() {
    return Consumer<MyCallsService>(
      builder: (context, snapshot, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  snapshot.setFilter(
                      Strings.all_call,
                      Provider.of<ProfileInfoServices>(context, listen: false)
                          .getuid());
                },
                child: Chip(
                  label: Text(
                    Strings.all_call,
                    style: TextStyle(
                        color: snapshot.getSelectedFilter() == Strings.all_call
                            ? Colors.white
                            : Colors.black),
                  ),
                  backgroundColor:
                      snapshot.getSelectedFilter() == Strings.all_call
                          ? ColorsTheme.themeLightOrange
                          : Colors.white,
                  shadowColor: Colors.grey,
                  elevation: 1,
                ),
              ),
              GestureDetector(
                onTap: () {
                  snapshot.setFilter(
                      Strings.ap_call,
                      Provider.of<ProfileInfoServices>(context, listen: false)
                          .getuid());
                },
                child: Chip(
                  label: Text(Strings.ap_call,
                      style: TextStyle(
                          color: snapshot.getSelectedFilter() == Strings.ap_call
                              ? Colors.white
                              : Colors.black)),
                  backgroundColor:
                      snapshot.getSelectedFilter() == Strings.ap_call
                          ? ColorsTheme.themeLightOrange
                          : Colors.white,
                  shadowColor: Colors.grey,
                  elevation: 1,
                ),
              ),
              GestureDetector(
                onTap: () {
                  snapshot.setFilter(
                      Strings.closed_call,
                      Provider.of<ProfileInfoServices>(context, listen: false)
                          .getuid());
                },
                child: Chip(
                  label: Text(Strings.closed_call,
                      style: TextStyle(
                          color: snapshot.getSelectedFilter() ==
                                  Strings.closed_call
                              ? Colors.white
                              : Colors.black)),
                  backgroundColor:
                      snapshot.getSelectedFilter() == Strings.closed_call
                          ? ColorsTheme.themeLightOrange
                          : Colors.white,
                  shadowColor: Colors.grey,
                  elevation: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> refreshPage() async {
    Provider.of<MyCallsService>(context, listen: false).refreshFunction(
        Provider.of<ProfileInfoServices>(context, listen: false).getuid());
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 1,
        backgroundColor: ColorsTheme.offWhite,
        title: Text(
          "My Calls",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshPage,
          color: ColorsTheme.themeOrange,
          child: SingleChildScrollView(
            child: Column(
              children: [filterSection(), allCallPage()],
            ),
          ),
        ),
      ),
    );
  }
}
