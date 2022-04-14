import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trader/Resources/Color.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:provider/provider.dart';
import 'package:trader/Services/advisor_page_service.dart';
import 'package:trader/Services/bottom_navigation_service.dart';
import 'package:trader/Services/profile_info_service.dart';
import 'package:trader/Services/trimartketwatch_ui_services.dart';
import 'package:trader/dataClasses/AdvisorClass.dart';
import 'package:trader/widgets/AdviserCard.dart';
import 'package:trader/widgets/TriMarketWatch.dart';

class ExploreAdvisors extends StatefulWidget {
  @override
  ExploreAdvisorsState createState() => ExploreAdvisorsState();
}

class ExploreAdvisorsState extends State<ExploreAdvisors>
    with TickerProviderStateMixin {
  TabController _tabController;

  List<AdvisorClass> _slist = List();
  List<AdvisorClass> _ulist = List();

  Widget exploreAdviserPage() {
    return Consumer<AdviserPageService>(
      builder: (context, cps, child) {
        _ulist = cps.getAdvisers(false);
        return cps.getrLoading()
            ? Center(
                child: SpinKitDoubleBounce(
                  color: ColorsTheme.primaryDark,
                  size: 32,
                ),
              )
            : _ulist.length == 0
                ? Center(
                    child: Text(
                      "No Analyst Found",
                      style: TextStyle(color: ColorsTheme.darkred),
                    ),
                  )
                : RefreshIndicator(
                  onRefresh: refreshPage,
                  color: ColorsTheme.themeOrange,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: _ulist.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AdviserCard(_ulist[index], context),
                        );
                      }),
                );
      },
    );
  }

  Widget subscribedAdviserPage() {
    return Consumer<AdviserPageService>(
      builder: (context, cps, child) {
        _slist = cps.getAdvisers(true);
        return cps.getsLoading()
            ? Center(
                child: SpinKitDoubleBounce(
                  color: ColorsTheme.primaryDark,
                  size: 32,
                ),
              )
            : _slist.length == 0
                ? Center(
                    child: Text(
                      "No Analyst Found",
                      style: TextStyle(color: ColorsTheme.darkred),
                    ),
                  )
                : RefreshIndicator(
                  onRefresh: refreshPage,
                  color: ColorsTheme.themeOrange,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: _slist.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AdviserCard(_slist[index], context),
                        );
                      }),
                );
      },
    );
  }

  Future<void> refreshPage() async {
    Provider.of<AdviserPageService>(context, listen: false).refreshFunction(
        Provider.of<ProfileInfoServices>(context, listen: false).getuid());
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AdviserPageService>(context, listen: false).fetchAdviser(
        Provider.of<ProfileInfoServices>(context, listen: false).getuid());

    final prv = Provider.of<AdviserPageService>(context, listen: false);
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: prv.getIndex());

    return WillPopScope(
        onWillPop: () {
          Provider.of<BottomNavigationService>(context, listen: false)
              .setPageNumber(0);
          return;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 1,
              backgroundColor: ColorsTheme.offWhite,
              title: TabBar(
                  controller: _tabController,
                  unselectedLabelColor: Colors.black,
                  labelColor: Colors.black,
                  indicatorColor: ColorsTheme.themeOrange,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(
                      child: Text(
                        "Explore",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Subscribed',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ])),
          body: SafeArea(
            child: TabBarView(
              controller: _tabController,
              physics: BouncingScrollPhysics(),
              children: <Widget>[exploreAdviserPage(), subscribedAdviserPage()],
            ),
          ),
        ));
  }
}
