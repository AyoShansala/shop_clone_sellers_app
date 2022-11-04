import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/ordersScreens/order_card.dart';

import '../global/global.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
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
        ),
        title: const Text(
          "Shifted Parcels Screen",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("status", isEqualTo: "ended")
            .where("sellerUID", isEqualTo: sharedPreferences!.getString("uid"))
            .orderBy("orderTime", descending: true)
            .snapshots(),
        builder: (c, AsyncSnapshot dataSnapshot) {
          if (dataSnapshot.hasData) {
            //display data
            return ListView.builder(
              itemCount: dataSnapshot.data.docs.length,
              itemBuilder: (c, index) {
                return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("items")
                      .where(
                        "itemID",
                        whereIn: cartMethods.seperateOrderItemIDs(
                            (dataSnapshot.data.docs[index].data()
                                as Map<String, dynamic>)["productIDs"]),
                      )
                      .where("sellerUID",
                          whereIn: (dataSnapshot.data.docs[index].data()
                              as Map<String, dynamic>)["uid"])
                      .orderBy("publisedDate", descending: true)
                      .get(),
                  builder: (c, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return OrderCard(
                        itemCount: snapshot.data.docs.length,
                        data: snapshot.data.docs,
                        orderId: dataSnapshot.data.docs[index].id,
                        seperateQuantitiesList:
                            cartMethods.seperateOrderItemsQuantities(
                                (dataSnapshot.data.docs[index].data()
                                    as Map<String, dynamic>)["productIDs"]),
                      );
                    } else {
                      return const Center(
                        child: Text("No Data Exists"),
                      );
                    }
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text("No Data exists."),
            );
          }
        },
      ),
    );
  }
}
