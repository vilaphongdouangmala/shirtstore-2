import 'dart:convert';

import 'package:flutter/material.dart';
import 'AppColors.dart';
import 'AppStyles.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

import 'CartScreen.dart';
import 'DetailedScreen.dart';
import 'Product.dart';

main() {
  return runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => Store(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
        ),
        home: HomePage(),
      ),
    ),
  );
} //ef

class Store extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  List<Product> _carts = [];
  List<Product> get carts => _carts;

  Future<Object> get(url) async {
    //1. convert param dict to json

    //2. send post request
    var res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return res.body;
    }
    //no success
    else {
      print(res.statusCode);
      return Future<Null>.value(null);
    }
  } //ef

  void getProducts() async {
    if (first) {
      var url = "http://192.168.182.173:1880/shirtstore2";
      var jsonText = await get(url);
      var list = json.decode(jsonText.toString()) as List;
      _products = list.map((e) => Product.fromMap(e)).toList();
    }
    notifyListeners();
  } //ef

  void incQty(Product product) {
    product.qty += 1;

    //check if the product is in the cart
    var found = _carts.firstWhereOrNull((e) => e.id == product.id);
    if (found == null) {
      _carts.add(product);
    } //end if
    else {
      found.qty = product.qty;
    }
    notifyListeners();
  } //ef

  void decQty(Product product) {
    if (product.qty > 0) {
      product.qty -= 1;
    }

    if (product.qty == 0) {
      _carts.remove(product);
    }
    notifyListeners();
  } //ef

  void removeProduct(Product product) {
    carts.remove(product);
    notifyListeners();
  } //ef

  void updateTotalQty() {
    totalQty = 0;
    for (Product p in carts) {
      totalQty += p.qty;
    } //eloop
  } //ef
} //ec

bool first = true;
double totalPrice = 0;
int totalQty = 0;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Store store;
  List<Product> displayedProducts = [];
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //store reference
    store = Provider.of<Store>(context);
    store.getProducts();

    //check if the search box is empty
    if (searchController.text.isEmpty) {
      displayedProducts = store.products;
    } //end if

    return Scaffold(
      //appBar
      appBar: AppBar(
        title: const Text("Pirada's Clothing"),
        backgroundColor: AppColors.primaryColor,
        actions: [
          GestureDetector(
            onTap: () {
              //move to new creen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Badge(
                //shape: BadgeShape.square,
                //badgeColor: Colors.green,
                //borderRadius: BorderRadius.circular(4),
                badgeContent: Text(
                  totalQty.toString(),
                ),
                child: const Icon(Icons.shopping_bag),
              ),
            ),
          )
        ],
      ),
      //body
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: SizedBox(
              height: 45,
              child: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: AppColors.primaryColor,
                ),
                child: TextField(
                  controller: searchController,
                  style: TextStyle(color: Colors.grey[800]),
                  onChanged: (String query) {
                    getSearchedProducts(query);
                  },
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(top: 25),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    hintText: "Search...",
                    prefixIcon: Icon(
                      Icons.search,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              //section to define column number, x andy spacing
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0, //x spacing
                mainAxisSpacing: 0, //y spacing
                childAspectRatio: 0.6,
              ),
              itemCount: displayedProducts.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: AppStyle.gridPadding,
                  child: GestureDetector(
                    onTap: () {
                      //move to new creen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailedScreen(
                            product: displayedProducts[i],
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.productBgColor,
                            ),
                            child: Hero(
                              tag: "${displayedProducts[i].id}",
                              child: Image.asset(
                                displayedProducts[i].image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: AppStyle.productTitlePadding,
                          child: Text(
                            displayedProducts[i].name,
                            style: AppStyle.productTitleStyle,
                          ),
                        ),
                        Text(
                          "฿${AppStyle.priceFormat.format(displayedProducts[i].price)}",
                          style: AppStyle.productPriceStyle,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  } //ef

  void getSearchedProducts(String searchedProduct) {
    // List<Product> searchedProducts = [];
    // displayedProducts.clear();
    // for (var p in store.products) {
    //   if (p.name.toLowerCase().contains(searchedProduct.toLowerCase())) {
    //     print(p.name);
    //     searchedProducts.add(p);
    //   } //end if
    // } //eloop
    // displayedProducts = searchedProducts;
    // setState(() {});

    List<Product> products = store.products.where((p) {
      final productName = p.name.toLowerCase();
      final query = searchedProduct.toLowerCase();

      return productName.contains(query);
    }).toList();

    setState(() => displayedProducts = products);
  } //ef
} //ec

