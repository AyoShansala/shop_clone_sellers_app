import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellers_app/global/global.dart';
import '../models/address.dart';
import '../splashScreen/my_splash_screen.dart';
import 'package:http/http.dart' as http;

class AddressDesign extends StatelessWidget {
  Address? model;
  String? orderStatus;
  String? orderId;
  String? sellerId;
  String? orderByUser;
  String? totalAmount;

  AddressDesign({
    super.key,
    this.model,
    this.orderStatus,
    this.orderId,
    this.sellerId,
    this.orderByUser,
    this.totalAmount,
  });

  //notification sending to seller method
  sendNotificationToUser(userUID, orderID) async {
    String userDeviceToken = "";

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userUID)
        .get()
        .then((snapshot) {
      if (snapshot.data()!["userDeviceToken"] != null) {
        userDeviceToken = snapshot.data()!["userDeviceToken"].toString();
        print("Device Token of that seller =" + userDeviceToken);
        print("Device Token of that seller =" + orderID);
      }
    });
    notificationFormat(
      userDeviceToken,
      orderID,
      sharedPreferences!.getString("name"),
    );
  }

  notificationFormat(userDeviceToken, orderID, sellerName) {
    Map<String, String> headerNotification = {
      'Content-Type': 'application/json',
      'Authorization': fcmServerToken,
    };
    Map bodyNotification = {
      'body':
          "Dear user, Your Parcel (# $orderID) has been shifted Successfully by seller $sellerName. \nPleace Check Now",
      'title': "Parcel Shifted",
    };
    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "userOrderId": orderID,
    };

    Map officialNotificationFormat = {
      'notification': bodyNotification,
      'data': dataMap,
      'priority': 'high',
      'to': userDeviceToken,
    };

    http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Shipping Details: ",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 6.0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              //name display
              TableRow(
                children: [
                  const Text(
                    "Name",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    model!.name.toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
              const TableRow(
                children: [
                  SizedBox(
                    height: 2,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                ],
              ),
              //phone Number
              TableRow(
                children: [
                  const Text(
                    "Phone Number",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    model!.phoneNumber.toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            model!.completeAddress.toString(),
            textAlign: TextAlign.justify,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (orderStatus == "normal") {
              //update earnings
              FirebaseFirestore.instance
                  .collection("sellers")
                  .doc(sharedPreferences!.getString("uid"))
                  .update({
                "earnings": (double.parse(previousEarnings)) +
                    (double.parse(totalAmount!)),
              }).whenComplete(() {
                //change the order status to shifted
                FirebaseFirestore.instance
                    .collection("orders")
                    .doc(orderId)
                    .update({
                  "status": "shifted",
                }).whenComplete(() {
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(orderByUser)
                      .collection("orders")
                      .doc(orderId)
                      .update({
                    "status": "shifted",
                  }).whenComplete(() {
                    //send notification to user.......
                    sendNotificationToUser(orderByUser, orderId);
                    Fluttertoast.showToast(msg: "Confirmed Successfully.");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MySplashScreen(),
                      ),
                    );
                  });
                });
              });
            } else if (orderStatus == "shifted") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MySplashScreen(),
                ),
              );
            } else if (orderStatus == "ended") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MySplashScreen(),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MySplashScreen(),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.pinkAccent,
                    Colors.purpleAccent,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
              width: MediaQuery.of(context).size.width - 40,
              height: orderStatus == "ended"
                  ? 60
                  : MediaQuery.of(context).size.height * .12,
              child: Center(
                child: Text(
                  orderStatus == "ended"
                      ? "Go Back"
                      : orderStatus == "shifted"
                          ? "Go Back"
                          : orderStatus == "normal"
                              ? "Parcel Pacekd & \nShifted to Nearest PickUp Point. \nClick to Confirm"
                              : "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
