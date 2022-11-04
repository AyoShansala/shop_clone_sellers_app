import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';

class CartMethods {
  //23452367890:5 ==> 23452367890 seperate the id............................
  seperateItemIDsFromUserCartList() {
    List<String>? userCartList = sharedPreferences!.getStringList("userCart");
    List<String> itemsIDsList = [];

    for (int i = 1; i < userCartList!.length; i++) {
      //4732972902:6
      String item = userCartList[i].toString();
      var lastCharaterPositionOfItemBeforeColon = item.lastIndexOf(':');
      //4732972902
      String getItemID =
          item.substring(0, lastCharaterPositionOfItemBeforeColon);
      itemsIDsList.add(getItemID);
    }

    return itemsIDsList;
  }

  //23452367890:5 ==> 5 seperate the quantities............................
  seperateItemQuantitiesFromUserCartList() {
    List<String>? userCartList = sharedPreferences!.getStringList("userCart");
    List<int> itemsQuantitiesList = [];

    print("UserCartList =");
    print(userCartList);

    for (int i = 1; i < userCartList!.length; i++) {
      //4732972902:6
      String item = userCartList[i].toString();

      //:5 split perform this
      var colonAfterCharatersList = item.split(':').toList(); // 0=[:] 1=[5]
      //5 quentity number
      var quentityNumber = int.parse(colonAfterCharatersList[1].toString());

      itemsQuantitiesList.add(quentityNumber);
    }
    print("ItemQuentitiessList =");
    print(itemsQuantitiesList);
    return itemsQuantitiesList;
  }

  //23452367890:5 ==> 23452367890 seperate the id............................
  seperateOrderItemIDs(productIDs) {
    List<String>? userCartList = List<String>.from(productIDs);
    List<String> itemsIDsList = [];

    for (int i = 1; i < userCartList.length; i++) {
      //4732972902:6
      String item = userCartList[i].toString();
      var lastCharaterPositionOfItemBeforeColon = item.lastIndexOf(':');
      //4732972902
      String getItemID =
          item.substring(0, lastCharaterPositionOfItemBeforeColon);
      itemsIDsList.add(getItemID);
    }

    return itemsIDsList;
  }

  //23452367890:5 ==> 5 seperate the quantities............................
  seperateOrderItemsQuantities(productIDs) {
    List<String>? userCartList = List<String>.from(productIDs);
    List<String> itemsQuantitiesList = [];

    print("UserCartList =");
    print(userCartList);

    for (int i = 1; i < userCartList.length; i++) {
      //4732972902:6
      String item = userCartList[i].toString();

      //:5 split perform this
      var colonAfterCharatersList = item.split(':').toList(); // 0=[:] 1=[5]
      //5 quentity number
      var quentityNumber = int.parse(colonAfterCharatersList[1].toString());

      itemsQuantitiesList.add(quentityNumber.toString());
    }
    print("ItemQuentitiessList =");
    print(itemsQuantitiesList);
    return itemsQuantitiesList;
  }
}
