import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/functions/functions.dart';
import 'package:sellers_app/global/global.dart';

class PushnotificationsSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //notifications arrives/recived
  Future whenNotificationRecived(BuildContext context) async {
    //1.terminated
    //When the app is completely closed and opened directly from the push notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //open app and show notification data

        showNotificationWhenOpenApp(
          remoteMessage.data["userOrderId"],
          context,
        );
      }
    });

    //2.foreground
    //when the app is open and it reveives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //directly show notification data
        showNotificationWhenOpenApp(
          remoteMessage.data["userOrderId"],
          context,
        );
      }
    });

    //3.background
    //when the app is in the background and opened directly from the push notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //open the app - show notification data
        showNotificationWhenOpenApp(
          remoteMessage.data["userOrderId"],
          context,
        );
      }
    });
  }

  //device recognition token for each and every device
  Future generateDeviceRecognitionToken() async {
    String? registrationDeviceToken = await messaging.getToken();

    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .update({
      "sellerDeviceToken": registrationDeviceToken,
    });

    messaging.subscribeToTopic("allSellers");
    messaging.subscribeToTopic("allUsers");
  }

  showNotificationWhenOpenApp(orderID, context) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderID)
        .get()
        .then((snapshot) {
      if (snapshot.data()!["status"] == "ended") {
        showReusableSnackBar(
          context,
          "Order ID # $orderID \n\n has delivered & recived by the user",
        );
      } else {
        showReusableSnackBar(
          context,
          "You have new Order. \nOrder ID # $orderID \n\n Pleace check now.",
        );
      }
    });
  }
}
