import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:trader/Services/BrokerServices/broker_data_services.dart';
import 'package:trader/Services/advisor_calls_services.dart';
import 'package:trader/Services/advisor_profile_fetch_services.dart';
import 'package:trader/Services/analysis_text_service.dart';
import 'package:trader/Services/app_version_service.dart';
import 'package:trader/Services/bottom_navigation_service.dart';
import 'package:trader/Services/calls_page_service.dart';
import 'package:trader/Services/coupons_operation_service.dart';
import 'package:trader/Services/home_page_services.dart';
import 'package:trader/Services/internal_payment_page_services.dart';
import 'package:trader/Services/my_calls_service.dart';
import 'package:trader/Services/package_selector_internal_paymentpage_service.dart';
import 'package:trader/Services/payment_services.dart';
import 'package:trader/Services/profile_page_service.dart';
import 'package:trader/Services/share_button_service.dart';
import 'package:trader/Services/signin_register_services.dart';
import 'package:trader/Services/trimartketwatch_ui_services.dart';
import 'package:trader/Services/wallet_balance_service.dart';
import 'package:trader/pages/MyCalls.dart';
import 'package:trader/pages/SplashScreen/LoadingPage.dart';
import 'package:trader/pages/UserCheck.dart';
import 'package:trader/priorityAccess/prority_access_services.dart';

import 'Resources/Color.dart';
import 'Resources/FadePageRoute.dart';
import 'Services/BrokerServices/broker_login_ui_services.dart';
import 'Services/advisor_page_service.dart';
import 'Services/analysis_title_detail_service.dart';
import 'Services/auth/code_resend_timer_service.dart';
import 'Services/auth/signin_with_phonenumber.dart';
import 'Services/firebase_auth_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'Services/full_analysis_image_service.dart';
import 'Services/profile_info_service.dart';
import 'Services/quicktrades_transaction_service.dart';
import 'Services/trimarketwatch_ltp_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

//---------NOTIFICATION SETUP---------------------------------------------------
FirebaseMessaging _fcm = FirebaseMessaging.instance;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();
final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();
const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

String selectedNotificationPayload;

void main() async {
  Provider.debugCheckInvalidValueType = null;

  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  // await _configureLocalTimeZone();
  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
  }
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('quicktrades');

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification:
              (int id, String title, String body, String payload) async {
            didReceiveLocalNotificationSubject.add(ReceivedNotification(
                id: id, title: title, body: body, payload: payload));
          });
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);
  });

  //FLAG TO SECURE APP AND AVOID USER TO TAKE SCREENSHOT
  // if (!kIsWeb) {
  //   FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  // }
  runApp(MyApp());
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

NotificationDetails platformChannelSpecifics;

Future<dynamic> onMessageFunction(Map<String, dynamic> message) async {
  print(message.toString());
  // return showNotification(message);
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  return showNotification(message);
}

showNotification(Map<String, dynamic> message) async {
  await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: 'qt_money_sound');
}

//FCM CONFIGURATION
initNotificationConfiguration() {
  // _fcm.configure(
  //     onLaunch: myBackgroundMessageHandler,
  //     onMessage: onMessageFunction,
  //     onBackgroundMessage: myBackgroundMessageHandler);
}

Future selectNotification(String payload) async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  initiQuickActionButtons(BuildContext context) async {
    QuickActions _quickActions = QuickActions();
    _quickActions.initialize((type) {
      switch (type) {
        case "my_call":
          {
            Navigator.push(context, fadePageRoute(context, MyCalls()));
          }
      }
    });

    _quickActions.setShortcutItems(<ShortcutItem>[
      ShortcutItem(
          type: "my_call", localizedTitle: "My Calls", icon: "quicktrades")
    ]);
  }

  initFirebaseApps() async {
    await Firebase.initializeApp();
    return;
  }

  @override
  Widget build(BuildContext context) {
    initNotificationConfiguration();

    initiQuickActionButtons(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FirebaseAuthService(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileInfoServices(),
        ),
        ChangeNotifierProvider(
          create: (_) => SigninRegisterServices(),
        ),
        ChangeNotifierProvider(
          create: (_) => BottomNavigationService(),
        ),
        ChangeNotifierProvider(
          create: (_) => CallsPageService(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdviserPageService(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfilePageService(),
        ),
        ChangeNotifierProvider(
          create: (_) => MyCallsService(),
        ),
        ChangeNotifierProvider(
          create: (_) => PaymentService(),
        ),
        ChangeNotifierProvider(
          create: (_) => InternalPaymentPageServices(),
        ),
        ChangeNotifierProvider(
          create: (_) => WalletBalanceService(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomePageServices(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppVersionService(),
        ),
        ChangeNotifierProvider(
          create: (_) => TriMarketWatchUiServices(),
        ),
        ChangeNotifierProvider(
          create: (_) => TriMarketWatchLtpService(),
        ),
        ChangeNotifierProvider(
          create: (_) => BrokerDataServices(),
        ),
        ChangeNotifierProvider(
          create: (_) => BrokerLoginUiServices(),
        ),
        ChangeNotifierProvider(
          create: (_) => PriorityAccessServices(),
        ),
        ChangeNotifierProvider(
          create: (_) => FullAnalysisImageService(),
        ),
        ChangeNotifierProvider(
          create: (_) => AnalysisTitleDetailService(),
        ),
        ChangeNotifierProvider(
          create: (_) => AnalysisTextService(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdvisorProfileFetchServices(),
        ),
        ChangeNotifierProvider(
          create: (_) => AdvisorCallsService(),
        ),
        ChangeNotifierProvider(
          create: (_) => PackageSelectorInternalPayamentPageService(),
        ),
        ChangeNotifierProvider(
          create: (_) => SigninWithPhoneNumber(),
        ),
        ChangeNotifierProvider(
          create: (_) => CodeResendTimerService(),
        ),
        ChangeNotifierProvider(
          create: (_) => QuicktradesTransactionService(),
        ),
        ChangeNotifierProvider(
          create: (_) => CouponOperationService(),
        ),
        ChangeNotifierProvider(
          create: (_) => ShareButtonService(),
        ),
      ],
      child: MaterialApp(
        title: 'QuickTrades',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: ColorsTheme.primaryColor,
          accentColor: ColorsTheme.secondryColor,
          primaryColorDark: ColorsTheme.primaryDark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
            future: initFirebaseApps(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return LoadingPage();
              }
              return Scaffold(
                body: Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: FractionallySizedBox(
                          heightFactor: 0.1,
                          child: Image.asset("assets/logo/quicktrades.png")),
                    ),
                    CircularProgressIndicator(),
                  ],
                )),
              );
            }),
      ),
    );
  }
}
