import 'package:flutter/material.dart';
import 'package:flutter_application_centralstorehw/AppColors.dart';
import 'package:intl/intl.dart';

class AppStyle {
  static const gridPadding = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 15,
  );
  static const productTitlePadding = EdgeInsets.only(
    top: 10,
  );

  static const productTitleStyle = TextStyle(
    fontSize: 17,
  );
  static const productPriceStyle = TextStyle(
    fontSize: 17,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.bold,
  );

  //detailed screen
  static const detailedTitleStyle = TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.bold,
  );

  static const detailedPriceStyle = TextStyle(
    fontSize: 21,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.bold,
  );

  static const detailedQtyStyle = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );

  //cart styles
  static const cartTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const cartPriceStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );

  static const cartQtyStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const cartTotalPriceLblStyle = TextStyle(
    fontSize: 21,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const cartTotalPriceStyle = TextStyle(
    fontSize: 21,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  //price format
  static var priceFormat = NumberFormat('#,##0.00');
}//ec
