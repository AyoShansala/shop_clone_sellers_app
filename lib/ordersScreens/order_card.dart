import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/ordersScreens/order_details_screen.dart';

import '../models/items.dart';

class OrderCard extends StatefulWidget {
  int? itemCount;
  List<DocumentSnapshot>? data;
  String? orderId;
  List<String>? seperateQuantitiesList;

  OrderCard({
    super.key,
    this.itemCount,
    this.data,
    this.orderId,
    this.seperateQuantitiesList,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => OrderDetailsScreen(
              orderID: widget.orderId,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.black,
        elevation: 10,
        shadowColor: Colors.white54,
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          height: widget.itemCount! * 125,
          child: ListView.builder(
            itemCount: widget.itemCount,
            itemBuilder: (context, index) {
              Items model = Items.fromJson(
                  widget.data![index].data() as Map<String, dynamic>);
              return placedOrdersitemDesignWidget(
                  model, context, widget.seperateQuantitiesList![index]);
            },
          ),
        ),
      ),
    );
  }
}

Widget placedOrdersitemDesignWidget(
    Items items, BuildContext context, itemQuentity) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 120,
    color: Colors.transparent,
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            items.thumbnailUrl.toString(),
            width: 110,
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                //title and the price.........
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        items.itemTitle.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    const Text(
                      "Rs ",
                      style: TextStyle(
                        color: Colors.purpleAccent,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      items.price.toString(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                //X sign with quantity number
                Row(
                  children: [
                    const Text(
                      "X ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      itemQuentity,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
