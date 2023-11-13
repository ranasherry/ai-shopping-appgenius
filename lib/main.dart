import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/app/provider/google_sign_in.dart';
import 'package:shopping_app/app/utills/ThemeNotifier.dart';

import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

   await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.landscapeRight,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const fatalError = true;

  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };


  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };


  // runApp(const MyApp());

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Message Title: ${message.notification!.title.toString()}");
  print("Message body: ${message.notification!.body.toString()}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    // EasyLoading.init();
    observer.analytics.setAnalyticsCollectionEnabled(kReleaseMode);
    return ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
          },
          child: GetMaterialApp(
            navigatorObservers: <NavigatorObserver>[observer],
            // navigatorObservers: <NavigatorObserver>[MyApp.observer],

            builder: EasyLoading.init(),

            // theme: ThemeData(
            //     useMaterial3: true,
            //     appBarTheme: AppBarTheme(
            //       color: Color(0xFF000C1A),
            //       foregroundColor: Colors.white,
            //     ),
            //     scaffoldBackgroundColor: Color(0xFF000C1A)),
            // theme: ThemeData.light(), // Default light theme
            theme: ThemeData.light(), // Default light theme
            // darkTheme: ThemeData.dark(), // Default dark theme

            darkTheme: ThemeData(
              useMaterial3: true,
              appBarTheme: AppBarTheme(
                color: Color(0xFF000C1A),
                foregroundColor: Colors.white,
              ),
              scaffoldBackgroundColor: Color(0xFF000C1A),
            ),

            themeMode: themeNotifier.themeMode,

            debugShowCheckedModeBanner: false,
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
          ),
        )
        //   theme:
        //   ThemeData(

        //     primarySwatch: Colors.blue,

        //   ),
        //   debugShowCheckedModeBanner: false,
        //   initialRoute: AppPages.INITIAL,
        //   getPages: AppPages.routes,
        // ),
        );
  }


}


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
//   static FirebaseAnalyticsObserver observer =
//       FirebaseAnalyticsObserver(analytics: analytics);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     analytics.setAnalyticsCollectionEnabled(kReleaseMode);
//     // analytics.setAnalyticsCollectionEnabled(true);
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () {
//         FocusScopeNode currentFocus = FocusScope.of(context);

//         if (!currentFocus.hasPrimaryFocus &&
//             currentFocus.focusedChild != null) {
//           FocusManager.instance.primaryFocus!.unfocus();
//         }
//       },
//       child: GetMaterialApp(
//         debugShowCheckedModeBanner: false,
//         navigatorObservers: <NavigatorObserver>[observer],
//         theme: ThemeData(
//           useMaterial3: true,
//         ),
//         builder: EasyLoading.init(),
//         initialRoute: AppPages.INITIAL,
//         getPages: AppPages.routes,
//       ),
//     );
//   }
// }
