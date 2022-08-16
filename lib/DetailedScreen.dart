import 'package:flutter/material.dart';
import 'package:flutter_application_centralstorehw/AppColors.dart';
import 'package:flutter_application_centralstorehw/AppStyles.dart';
import 'package:provider/provider.dart';

import 'Product.dart';
import 'main.dart';

class DetailedScreen extends StatelessWidget {
  Product product;
  DetailedScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  late Store store;

  @override
  Widget build(BuildContext context) {
    store = Provider.of<Store>(context);
    return WillPopScope(
      onWillPop: () {
        //update totalqty
        store.updateTotalQty();

        //trigger leaving and use own data
        Navigator.pop(context, false);

        //we need to return a future
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.name),
          backgroundColor: AppColors.primaryColor,
        ),
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: AppColors.productBgColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  )),
              width: double.infinity,
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Hero(
                  tag: "${product.id}",
                  child: Image.asset(
                    product.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.name,
                          style: AppStyle.detailedTitleStyle,
                        ),
                        Text(
                          "฿${AppStyle.priceFormat.format(product.price)}",
                          style: AppStyle.detailedPriceStyle,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            store.decQty(product);
                          },
                          child: const CircleAvatar(
                            radius: 23,
                            backgroundColor: AppColors.primaryColor,
                            child: Icon(
                              Icons.remove,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            product.qty.toString(),
                            style: AppStyle.detailedQtyStyle,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            store.incQty(product);
                          },
                          child: const CircleAvatar(
                            radius: 23,
                            backgroundColor: AppColors.primaryColor,
                            child: Icon(
                              Icons.add,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  } //ef
} //ec