import 'package:flutter/material.dart';
import 'package:sellers_app/assistant_methods/cart_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;

CartMethods cartMethods = CartMethods();
String previousEarnings = "";

String fcmServerToken =
    "key=AAAAcbcWyUE:APA91bEVY1Q8ZqapvD9BSuTEulW_rpxsO69bPQRZDqS9u0EW4S37XNyM0Zsk-AqsZKx6aTqiI0okc9qb4tP799uRvebeBlSrTfQf3toDPLTobNnV3E8pDct2_dPv0W9BvD-4DyMdzlL9";
