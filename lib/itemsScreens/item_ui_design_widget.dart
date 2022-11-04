import 'package:flutter/material.dart';
import 'package:sellers_app/itemsScreens/items_details_screen.dart';
import 'package:sellers_app/itemsScreens/items_screen.dart';
import 'package:sellers_app/models/items.dart';

class ItemsUidesignWidget extends StatefulWidget {
  Items? model;
  BuildContext? context;

  ItemsUidesignWidget({
    this.model,
    this.context,
  });

  @override
  State<ItemsUidesignWidget> createState() => _BrandsUiDesignWidgetState();
}

class _BrandsUiDesignWidgetState extends State<ItemsUidesignWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //send to item details screens
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => ItemDetailsScreen(
              model: widget.model,
            ),
          ),
        );
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: SizedBox(
            height: 270,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const SizedBox(
                  height: 2,
                ),
                Text(
                  widget.model!.itemTitle.toString(),
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Image.network(
                  widget.model!.thumbnailUrl.toString(),
                  height: 220,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  widget.model!.itemInfo.toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
