import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trader/Resources/Color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:provider/provider.dart';
import 'package:trader/Services/calls_page_service.dart';
import 'package:trader/Services/profile_info_service.dart';
import 'package:trader/Services/trimarketwatch_ltp_service.dart';
import 'package:trader/Services/trimartketwatch_ui_services.dart';
import 'package:trader/Services/wallet_balance_service.dart';
import 'package:trader/dataClasses/CallsClas.dart';
import 'package:trader/widgets/CallsCard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trader/widgets/FilterChip.dart';
import 'package:trader/widgets/TriMarketWatch.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<CallsClass> _activeCalls = List();
  List<CallsClass> _closedCalls = List();
  List<CallsClass> _pendingCalls = List();

  List<Widget> _callTypeList = List();

  final ScrollController scrollController = ScrollController();

  //-------------APP BAR-------------
  Widget _appBar() {
    return Container(
      color: ColorsTheme.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Center(
                  child: Image.asset(
                "assets/other/google_logo.png",
                height: 40,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget pendingCallPage() {
    return Consumer<CallsPageService>(
      builder: (context, cps, child) {
        _pendingCalls = cps.getPendingCalls();
        return _pendingCalls.length == 0
            ? Center(
                child: Text(
                  "No Calls Found",
                  style: TextStyle(color: ColorsTheme.darkred),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: _pendingCalls.length,
                itemBuilder: (context, index) {
                  return CallsCard(_pendingCalls[index], index);
                });
      },
    );
  }

  Widget activeCallPage() {
    return Consumer<CallsPageService>(
      builder: (context, cps, child) {
        _activeCalls = cps.getActiveCalls();
        return _activeCalls.length == 0
            ? Center(
                child: Text(
                  "No Calls Found",
                  style: TextStyle(color: ColorsTheme.darkred),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: _activeCalls.length,
                itemBuilder: (context, index) {
                  return CallsCard(_activeCalls[index], index);
                });
      },
    );
  }

  Widget closedCallPage() {
    return Consumer<CallsPageService>(
      builder: (context, cps, child) {
        // _closedCalls = cps.getClosedCall();
        return _closedCalls.length == 0
            ? Center(
                child: Text(
                  "No Calls Found",
                  style: TextStyle(color: ColorsTheme.darkred),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: _closedCalls.length,
                itemBuilder: (context, index) {
                  return CallsCard(_closedCalls[index], index);
                });
      },
    );
  }

  Widget filterWidget() {
    List<bool> filter;
    return Consumer<CallsPageService>(builder: (context, snapshot, child) {
      filter = snapshot.getFilter();
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomFilterChip(
              label: Strings.pending,
              selected: filter[0],
              // label: Text(Strings.pending),
              onSelected: () {
                snapshot.setFilter(
                    0,
                    Provider.of<ProfileInfoServices>(context, listen: false)
                        .getuid(),
                    _tabController.index == 0
                        ? Strings.intraday
                        : Strings.positional);
              },
              // selectedColor: ColorsTheme.darkred,
              // labelStyle: TextStyle(
              //     color: filter[0] ? Colors.white : Colors.black),
              // checkmarkColor: filter[0] ? Colors.white : Colors.black,
              // backgroundColor: Colors.white,
              // elevation: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomFilterChip(
              label: Strings.active,
              selected: filter[1],
              // label: Text(Strings.active),
              onSelected: () {
                snapshot.setFilter(
                    1,
                    Provider.of<ProfileInfoServices>(context, listen: false)
                        .getuid(),
                    _tabController.index == 0
                        ? Strings.intraday
                        : Strings.positional);
              },
              // selectedColor: ColorsTheme.darkred,
              // labelStyle: TextStyle(
              //     color: filter[1] ? Colors.white : Colors.black),
              // checkmarkColor: filter[1] ? Colors.white : Colors.black,
              // backgroundColor: Colors.white,
              // elevation: 1,
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: FilterChip(
          //     label: Text(Strings.closed),
          //     onSelected: (val) {
          //       snapshot.setFilter(
          //           2,
          //           Provider.of<ProfileInfoServices>(context, listen: false)
          //               .getuid(),
          //           _tabController.index == 0
          //               ? Strings.intraday
          //               : Strings.positional);
          //     },
          //     selected: filter[2],
          //     selectedColor: ColorsTheme.darkred,
          //     labelStyle: TextStyle(
          //         color: filter[2] ? Colors.white : Colors.black),
          //     checkmarkColor: filter[2] ? Colors.white : Colors.black,
          //     backgroundColor: Colors.white,
          //     elevation: 1,
          //   ),
          // ),
        ],
      );
    });
  }

  Widget intradayCalls() {
    List<bool> filter;
    return Consumer<CallsPageService>(
      builder: (context, cps, child) {
        filter = cps.getFilter();
        int index = filter.indexOf(true);
        Widget page;
        page = index == 0
            ? pendingCallPage()
            : index == 1
                ? activeCallPage()
                : closedCallPage();
        return RefreshIndicator(
          onRefresh: refreshPage,
          color: ColorsTheme.themeOrange,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                filterWidget(),
                index == 0
                    ? pendingCallPage()
                    : index == 1
                        ? activeCallPage()
                        : closedCallPage()
              ],
            ),
          ),
        );
      },
    );
  }

  Widget positionalCalls() {
    List<bool> filter;
    return Consumer<CallsPageService>(
      builder: (context, cps, child) {
        filter = cps.getFilter();
        int index = filter.indexOf(true);
        Widget page;
        page = index == 0
            ? pendingCallPage()
            : index == 1
                ? activeCallPage()
                : closedCallPage();
        return RefreshIndicator(
          onRefresh: refreshPage,
          color: ColorsTheme.themeOrange,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                filterWidget(),
                index == 0
                    ? pendingCallPage()
                    : index == 1
                        ? activeCallPage()
                        : closedCallPage()
              ],
            ),
          ),
        );
      },
    );
  }

  tabChnageListner() {
    _tabController.addListener(() {
      Provider.of<CallsPageService>(context, listen: false).refreshFunction(
          Provider.of<ProfileInfoServices>(context, listen: false).getuid(),
          _tabController.index == 0 ? Strings.intraday : Strings.positional);
    });
  }

  Future refreshPage() async {
    await Provider.of<CallsPageService>(context, listen: false).refreshFunction(
        Provider.of<ProfileInfoServices>(context, listen: false).getuid(),
        _tabController.index == 0 ? Strings.intraday : Strings.positional);
    return true;
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(
      length: 2,
      vsync: this,
    );
    tabChnageListner();
    // _callTypeList = [pendingCallPage(), activeCallPage(), closedCallPage()];
    Provider.of<WalletBalanceService>(context, listen: false)
        .fetchBalance('wallet');
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CallsPageService>(context, listen: false).fetchCalls2(
        Provider.of<ProfileInfoServices>(context, listen: false).getuid(),
        _tabController.index == 0 ? Strings.intraday : Strings.positional);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 1,
            backgroundColor: ColorsTheme.offWhite,
            title: TabBar(
              unselectedLabelColor: Colors.black,
              labelColor: Colors.black,
              controller: _tabController,
              tabs: [
                Tab(
                  child: Text(
                    Strings.intraday,
                    textAlign: TextAlign.center,
                  ),
                ),
                Tab(
                  child: Text(
                    Strings.positional,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              indicatorColor: ColorsTheme.themeOrange,
              indicatorSize: TabBarIndicatorSize.label,
            )),
        body: SafeArea(
          child: Stack(
            children: [
              Consumer<CallsPageService>(builder: (context, cps, child) {
                return cps.getLoading()
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SpinKitDoubleBounce(
                              color: ColorsTheme.primaryDark,
                              size: 32,
                            ),
                          ],
                        ),
                      )
                    : TabBarView(
                        physics: BouncingScrollPhysics(),
                        controller: _tabController,
                        children: [
                          intradayCalls(),
                          positionalCalls(),
                          // closedCallPage()
                        ],
                      );
              }),
            ],
          ),
        ));
  }
}
