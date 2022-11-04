import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sellers_app/brandsScreens/brands_ui_design_widget.dart';
import 'package:sellers_app/brandsScreens/upload_brands_screen.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/models/brands.dart';
import 'package:sellers_app/push_notifications/push_notifications_system.dart';
import 'package:sellers_app/widgets/text_delegate_header_widget.dart';

import '../functions/functions.dart';
import '../splashScreen/my_splash_screen.dart';
import '../widgets/my_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  getSellerEarningsFromDatabse() {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((dataSnapshot) {
      previousEarnings = dataSnapshot.data()!["earnings"].toString();
    }).whenComplete(() {
      restrictBlockedSellersFromUsingSellersApp();
    });
  }

  restrictBlockedSellersFromUsingSellersApp() async {
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snapshot) {
      if (snapshot.data()!["status"] != "approved") {
        showReusableSnackBar(context, "You are tell by admin.");
        showReusableSnackBar(context, "contact admin: admin@beeshop.com");
        FirebaseAuth.instance.signOut();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => MySplashScreen()),
        );
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PushnotificationsSystem pushnotificationsSystem = PushnotificationsSystem();
    pushnotificationsSystem.whenNotificationRecived(context);
    pushnotificationsSystem.generateDeviceRecognitionToken();
    getSellerEarningsFromDatabse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
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
          "iShop",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => UploadBrandsScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextDelegateHeaderWidget(
              title: "My Brands",
            ),
          ),
          //1.write query
          //2.model
          //3.design widget
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(sharedPreferences!.getString("uid"))
                .collection("brands")
                .orderBy("publisedDate", descending: true)
                .snapshots(),
            builder: (context, dataSnapshot) {
              if (dataSnapshot.hasData) {
                //if brand exists
                //display brands
                return SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                  itemBuilder: (context, index) {
                    Brands brandsModel = Brands.fromJson(
                      dataSnapshot.data!.docs[index].data()
                          as Map<String, dynamic>,
                    );
                    return BrandsUiDesignWidget(
                      model: brandsModel,
                      context: context,
                    );
                  },
                  itemCount: dataSnapshot.data!.docs.length,
                );
              } else {
                //if brand NOT exixts
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text("No brands exists"),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
