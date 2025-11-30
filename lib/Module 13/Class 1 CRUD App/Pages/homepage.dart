import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:m_ten_to_inf/Module%2013/Class%201%20CRUD%20App/Pages/add_new_product_page.dart';
import 'package:m_ten_to_inf/Module%2013/Class%201%20CRUD%20App/Widgets/product_item.dart';
import '../Models/product_model.dart';
import '../utils/urls.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<ProductModel> _productList = [];
  bool _getProductInProgress = false;

  @override
  void initState() {
    super.initState();
    _getProductList();
  }

  Future<void> _getProductList() async {
    _productList.clear();
    _getProductInProgress = true;
    setState(() {});
    Uri uri = Uri.parse(Urls.getProductsUrl);
    Response response = await get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint(response.body);
    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      for (Map<String, dynamic> productJson in decodedJson['data']) {
        // Product product = Product();
        // product.id= productJson['_id'];
        // product.name= productJson['ProductName'];
        // product.code= productJson['ProductCode'];
        // product.image= productJson['Img'];
        // product.quantity= productJson['Qty'];
        // product.unitPrice= productJson['UnitPrice'];
        // product.totalPrice= productJson['TotalPrice'];
        ProductModel productModel = ProductModel.fromJson(productJson);
        _productList.add(productModel);
      }
    }
    _getProductInProgress = false;
    setState(() {});

    /// check that. set state ta ekhanei keno dite hobe?
  }

  void _navigateToAddProductPage() async {
    // Wait for the AddNewProductPage to pop
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNewProductPage()),
    );

    // If the page popped with 'true', it means we should refresh
    if (result == true) {
      // Call your function that fetches products from the API
      _getProductList(); // Or whatever your refresh function is named
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: Text("Product List"),
        actions: [
          IconButton(
            onPressed: () {
              _getProductList();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Visibility(
        visible: _getProductInProgress == false,
        replacement: Center(child: CircularProgressIndicator()),
        child: ListView.separated(
          itemCount: _productList.length,
          itemBuilder: (context, index) {
            return ProductItem(
              product: _productList[index],
              refreshProductList: () {
                _getProductList();
              },
            );
          },
          separatorBuilder: (context, index) {
            return Divider(indent: 70);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProductPage,
        child: Icon(Icons.add),
      ),
    );
  }
}
