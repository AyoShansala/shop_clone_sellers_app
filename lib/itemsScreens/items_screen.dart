import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sellers_app/itemsScreens/item_ui_design_widget.dart';
import 'package:sellers_app/itemsScreens/upload_items_screen.dart';
import 'package:sellers_app/models/brands.dart';

import '../global/global.dart';
import '../models/items.dart';
import '../widgets/text_delegate_header_widget.dart';

class ItemsScreen extends StatefulWidget {
  Brands? model;
  ItemsScreen({
    this.model,
  });

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  builder: (c) => UploadItemsScreen(
                    model: widget.model,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.add_box_rounded,
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
              title: "My " + widget.model!.BrandTitle.toString() + "'s Items",
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
                .doc(widget.model!.brandID)
                .collection("items")
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
                    Items itemsModel = Items.fromJson(
                      dataSnapshot.data!.docs[index].data()
                          as Map<String, dynamic>,
                    );
                    return ItemsUidesignWidget(
                      model: itemsModel,
                      context: context,
                    );
                  },
                  itemCount: dataSnapshot.data!.docs.length,
                );
              } else {
                //if brand NOT exixts
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text("No items exists"),
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
