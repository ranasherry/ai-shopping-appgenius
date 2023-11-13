// import 'dart:js';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shopping_app/app/routes/app_pages.dart';

// import '../modules/routes/app_pages.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance ;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  void requestNotificationPermission()async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

          if(settings.authorizationStatus == AuthorizationStatus.authorized){
        print('user granted permission');
        }
      else if (settings. authorizationStatus == AuthorizationStatus.provisional){
        print('user granted provisional permission');
      }
      else {
        print('user denied permission');
      }
    }

    
    void initLocalNotification(BuildContext context,RemoteMessage message)async{
      
        var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/launcher_icon');
        var initializationSettings =  InitializationSettings(
          android: androidInitializationSettings
        );
        
    
        await _flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
          onDidReceiveNotificationResponse: (payload){

            print("payload: $payload");

            handleMessage(context, message);
          }
        );
    }

    Future<void> firebaseInit(BuildContext context) async {
      //?
      var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/launcher_icon');
        var initializationSettings =  InitializationSettings(
          android: androidInitializationSettings
        );
        
    
        await _flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
          onDidReceiveNotificationResponse: (payload){
            print("payload: $payload");
          }
        );
        //?
        
      // initLocalNotification(context, message)
      await FirebaseMessaging.onMessage.listen((Message) {
        if (kDebugMode) {
        print("Message Title: ${Message.notification!.title.toString()}");
        print("Message body: ${Message.notification!.body.toString()}");
        print("Message data: ${Message.data.toString()}");
        print("Message data: ${Message.data["type"]}");
        print("Message data: ${Message.data["text"]}");
        // print("Message data: ${Message.data.toString()}");
      }
        initLocalNotification(context,Message);
        showNotification(Message);
      });
      
    }

    Future<void> showNotification(RemoteMessage message) async {

      AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(), 
        "High importance Notifications",
        importance: Importance.max
        );

      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(), 
        channel.name.toString(), 
        channelDescription: "your channel description",
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
        );

        NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails
        );

      Future.delayed(Duration.zero, (){
        _flutterLocalNotificationsPlugin.show(
        0, 
        message.notification!.title.toString(), 
        message.notification!.body.toString(), 
        notificationDetails
      );
      });
      
    }
    
    Future<String> getDeviceToken()async{
      String? token = await messaging.getToken();
      return token!;
    }

    void isTokenRefresh()async{
      messaging.onTokenRefresh.listen((event) {
        event.toString();
        print("token refreshed: $event");
      });
    }

    Future<void> setupInterMessage(BuildContext context)async {

      // for kill state
      RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if(initialMessage!= null){
        handleMessage(context, initialMessage);
      }

      //for background state
      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        handleMessage(context, event);
      });
    }

    Rx<String> title = "".obs;

    void handleMessage(BuildContext context,RemoteMessage message){
      if(message.data['type'] == 'prompt'){
        title.value = message.data['type'];
        // Get.toNamed(Routes.ChatScreen);
        // Get.toNamed(Routes.ChatScreen, arguments: [message.data['text'],title]);
        Get.toNamed(Routes.SplashScreen);
        Future.delayed(Duration(seconds: 5),(){
          // print(object);
          Get.toNamed(Routes.ShoppingView, arguments: [message.data['text'],title]);
        });
        
      }
    }

}