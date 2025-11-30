import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:m_ten_to_inf/Module%2013/Class%201%20CRUD%20App/Models/product_model.dart';

import '../Widgets/showSnackBar.dart';
import '../utils/urls.dart';
class UpdateProductPage extends StatefulWidget {
  const UpdateProductPage({super.key, required this.product});

  final ProductModel product;

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final GlobalKey<FormState> _formkey= GlobalKey<FormState>();
  final TextEditingController _nameController= TextEditingController();
  final TextEditingController _codeController= TextEditingController();
  final TextEditingController _quantityController= TextEditingController();
  final TextEditingController _priceController= TextEditingController();
  final TextEditingController _imgUrlController= TextEditingController();
  bool _updateProductInProgress = false;


  @override
  void initState() {
    super.initState();
    _nameController.text= widget.product.name;
    _codeController.text= widget.product.code.toString();
    _quantityController.text= widget.product.quantity.toString();
    _priceController.text= widget.product.unitPrice.toString();
    _imgUrlController.text= widget.product.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update product"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 20,
              children: [
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder()
                  ),
                  validator: (value)=>
                  (value?.isEmpty?? true) ? 'Enter a name' : null,
                ),
                TextFormField(
                  controller: _codeController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      labelText: 'Product Code',
                      border: OutlineInputBorder()
                  ),
                  validator: (value)=>
                  (value?.isEmpty?? true)?'Enter product code' : null,
                ),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder()
                  ),
                  validator: (value){
                    if(value?.isEmpty??true) return 'Enter quantity';
                    if(int.tryParse(value!)==null) return 'Enter Integer';
                    return null;
                  }
                ),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      labelText: 'Unit Price',
                      border: OutlineInputBorder()
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Enter price';
                    if (int.tryParse(value!) == null) return 'Enter a number';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _imgUrlController,
                  decoration: InputDecoration(
                      labelText: 'Img Url',
                      border: OutlineInputBorder()
                  ),
                  validator: (value) =>
                      (value?.isEmpty ?? true) ? 'Enter an image URL' : null,
                ),
                SizedBox(height: 15,),
                Visibility(
                    visible: _updateProductInProgress==false,
                    replacement: Center(child: CircularProgressIndicator()),
                    child: FilledButton(onPressed: _updateProduct, child: Text("Update Product")))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void>_updateProduct() async{
    _updateProductInProgress=true;
    if(!_formkey.currentState!.validate()){
      return;
    }
    try{
      Uri uri = Uri.parse(Urls.updateProductsUrl(widget.product.id));
      final int? quantity = int.tryParse(_quantityController.text);
      final int? price = int.tryParse(_priceController.text);

      if (quantity == null || price == null) {
        if (mounted) {
          showSnackBarMsg(context, "Invalid quantity or price.");
        }
        return;
      }
      final int totalPrice = quantity * price;

      Map<String, dynamic> requestBody = {
        "ProductName": _nameController.text,
        "ProductCode": _codeController.text, // <-- THE FIX: Send as String
        "Img": _imgUrlController.text,
        "Qty": quantity, // Send safe-parsed int
        "UnitPrice": price, // Send safe-parsed int
        "TotalPrice": totalPrice,
      };

      http.Response response = await http.post(
        uri,
        headers: {
          'Content-Type' : 'application/json'
        },
        body: jsonEncode(requestBody),
      );
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      _updateProductInProgress=false;
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 'success') {
          // Assuming 'success' is the good status
          if (mounted) {
            showSnackBarMsg(context, 'Product updated successfully!');
          }
          // Optionally, clear controllers or pop page
          _nameController.clear();
          _codeController.clear();
          _quantityController.clear();
          _priceController.clear();
          _imgUrlController.clear();
        } else {
          // Handle API's 'fail' status
          if (mounted) {
            showSnackBarMsg(context, 'API Error: ${responseBody['data']}');
          }
        }
      } else {
        // Handle HTTP error
        if (mounted) {
          showSnackBarMsg(context, 'Server Error: ${response.statusCode}');
        }
      }
    }catch(e){
      if (mounted) {
        showSnackBarMsg(context, 'An error occurred: $e');
      }
    }finally {
      setState(() {
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _imgUrlController.dispose();
    super.dispose();
  }
}
