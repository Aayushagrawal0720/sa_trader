import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_card/sliding_card.dart';
import 'package:trader/Resources/Color.dart';
import 'package:trader/Resources/FadePageRoute.dart';
import 'package:trader/Resources/keywords.dart';
import 'package:trader/Services/internal_payment_page_services.dart';
import 'package:trader/Services/package_selector_internal_paymentpage_service.dart';
import 'package:trader/dataClasses/AdvisorClass.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trader/pages/AdvisorProfilePage.dart';
import 'package:trader/widgets/InternalPaymentPage.dart';
import 'package:provider/provider.dart';

class AdviserCard extends StatefulWidget {
  AdvisorClass advisor;
  BuildContext context;

  AdviserCard(this.advisor, this.context);

  @override
  AdviserCardState createState() => AdviserCardState(advisor, context);
}

class AdviserCardState extends State<AdviserCard> {
  AdvisorClass advisor;
  BuildContext context;

  SlidingCardController controller = SlidingCardController();

  AdviserCardState(this.advisor, this.context);

  Widget aProfile() {
    Color _color;
    String temp1 = advisor.accuracy.replaceAll("%", "");
    double a = double.parse(temp1);
    if (a <= 30) {
      _color = Colors.red;
    } else if (a > 31 && a <= 70) {
      _color = Colors.orange;
    } else if (a > 70) {
      _color = Colors.green;
    }
    String accuracy =
        "${double.parse(advisor.accuracy.replaceAll("%", "")).toStringAsFixed(2)}%";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.network(advisor.url),
                ),
                title: Text(
                  advisor.name,
                  maxLines: 2,
                  style: TextStyle(),
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  children: [
                    TextSpan(
                      text: "${Strings.accuracy}: ",
                    ),
                    TextSpan(
                      text: accuracy,
                      style: TextStyle(fontSize: 12, color: _color),
                    )
                  ]),
            ),
          ],
        ),
        // RichText(
        //   text: TextSpan(children: [
        //     TextSpan(
        //       text: "${Strings.certificate}: ",
        //       style: TextStyle(fontSize: 12, color: Colors.black),
        //     ),
        //     TextSpan(
        //       text: advisor.certificateNumber,
        //       style: TextStyle(fontSize: 12, color: Colors.green),
        //     )
        //   ]),
        // ),
      ],
    );
  }

  frontCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
                color: ColorsTheme.secondryColor.withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 0))
          ]),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            aProfile(),
            SizedBox(height: 10),
            Divider(
              color: Colors.grey,
            ),
            subscribers(),
          ],
        ),
      ),
    );
  }

  subscribers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Active Subscribers",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Text(
              advisor.current_subscribers,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Total subscriptions",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Text(
              advisor.subscribers,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  active_closedCalls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(
              Strings.activeCall,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            Text(
              advisor.activeCalls,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              Strings.closedCall,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            Text(
              advisor.closedCall,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  targetHitLossBooked() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(
              Strings.targethit,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            Text(
              advisor.targethit,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              Strings.lossBooked,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            Text(
              advisor.lossBooked,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  subsCribeButton() {
    return GestureDetector(
      onTap: () async {
        Provider.of<InternalPaymentPageServices>(context, listen: false)
            .setInitialValues();
        Provider.of<PackageSelectorInternalPayamentPageService>(context,
                listen: false)
            .resetPackageSelection();
        await Future.delayed(Duration(microseconds: 100));
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return InternalPaymentPage(
                false,
                advisor.uid,
              );
            });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        decoration: BoxDecoration(
            color: ColorsTheme.primaryDark,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: ColorsTheme.secondryColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: Offset(0, 0))
            ]),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8, bottom: 8, right: 15, left: 15),
          child: Text(
            "Subscribe",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  backCard() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
                color: ColorsTheme.secondryColor.withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 0))
          ]),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            active_closedCalls(),
            SizedBox(
              height: 10,
            ),
            targetHitLossBooked(),
            advisor.subscribed ? Container() : Expanded(child: Container()),
            advisor.subscribed ? Container() : subsCribeButton(),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              fadePageRoute(
                  context,
                  AdvisorDashboardPage(
                    advisor: advisor,
                  )));
          // if (controller.isCardSeparated == true) {
          //   controller.collapseCard();
          // } else {
          //   controller.expandCard();
          // }
        },
        child: frontCard()
        // SlidingCard(
        //   slimeCardElevation: 6,
        //   cardsGap: 7,
        //   slimeCardBorderRadius: 10,
        //   //The controller is necessary to animate the opening and closing of the card
        //   controller: controller,
        //   slidingCardWidth: MediaQuery.of(context).size.width,
        //   visibleCardHeight: 200,
        //   hiddenCardHeight: 180,
        //   showColors: false,
        //   //Configure your front card here
        //   frontCardWidget: frontCard(),
        //   //configure your rear card here
        //   backCardWidget: backCard(),
        //   slidingAnimmationForwardCurve: Curves.slowMiddle,
        //   slidingAnimationReverseCurve: Curves.slowMiddle,
        // ),
        );
  }
}
