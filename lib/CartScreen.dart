import 'package:flutter/material.dart';
import 'package:flutter_application_centralstorehw/AppColors.dart';
import 'package:flutter_application_centralstorehw/AppStyles.dart';
import 'package:provider/provider.dart';

import 'Product.dart';
import 'main.dart';

//===> class: CartScreen
class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Store store;

  @override
  Widget build(BuildContext context) {
    store = Provider.of<Store>(context);
    //getTotalPrice
    getTotalPrice();
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
          title: const Text("Cart"),
          backgroundColor: AppColors.primaryColor,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  color: AppColors.primaryColor,
                ),
                itemCount: store.carts.length,
                itemBuilder: (BuildContext context, int i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        //product img
                        SizedBox(
                          width: 150,
                          height: 200,
                          child: Image.asset(
                            store.carts[i].image,
                          ),
                        ),
                        //product info
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //productname and remove
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      store.carts[i].name,
                                      style: AppStyle.cartTitleStyle,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          store.removeProduct(store.carts[i]);
                                          getTotalPrice();
                                        });
                                      },
                                      child: const Icon(
                                        Icons.delete_outline,
                                        color: AppColors.primaryColor,
                                      ),
                                    )
                                  ],
                                ),
                                //product price and qty
                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //product price
                                      Text(
                                        "฿${AppStyle.priceFormat.format(store.carts[i].price)}",
                                        style: AppStyle.cartPriceStyle,
                                      ),
                                      //product qty
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                store.decQty(store.carts[i]);
                                                getTotalPrice();
                                              });
                                            },
                                            child: const Icon(
                                              Icons.remove,
                                              color: AppColors.primaryColor,
                                              size: 28,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Text(
                                              store.carts[i].qty.toString(),
                                              style: AppStyle.cartQtyStyle,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                store.incQty(store.carts[i]);
                                                getTotalPrice();
                                              });
                                            },
                                            child: const Icon(
                                              Icons.add,
                                              color: AppColors.primaryColor,
                                              size: 28,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 75,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Price",
                      style: AppStyle.cartTotalPriceLblStyle,
                    ),
                    Text(
                      AppStyle.priceFormat.format(totalPrice).toString(),
                      style: AppStyle.cartTotalPriceStyle,
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

  void getTotalPrice() {
    totalPrice = 0;
    for (var p in store.carts) {
      totalPrice += p.price * p.qty;
    } //eloop
  } //ef
}//ec