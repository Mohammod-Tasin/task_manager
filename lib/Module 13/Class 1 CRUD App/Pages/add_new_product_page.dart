import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:m_ten_to_inf/Module%2013/Class%201%20CRUD%20App/Widgets/showSnackBar.dart';

import '../utils/urls.dart'; // Use 'as http' to avoid conflicts

class AddNewProductPage extends StatefulWidget {
  const AddNewProductPage({super.key});

  @override
  State<AddNewProductPage> createState() => _AddNewProductPageState();
}

class _AddNewProductPageState extends State<AddNewProductPage> {
  bool _addProductInProgress = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imgUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Product")),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      (value?.isEmpty ?? true) ? 'Enter a name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _codeController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Product Code',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      (value?.isEmpty ?? true) ? 'Enter a code' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Enter quantity';
                    if (int.tryParse(value!) == null) return 'Enter a number';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Unit Price',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Enter price';
                    if (int.tryParse(value!) == null) return 'Enter a number';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imgUrlController,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Img Url',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      (value?.isEmpty ?? true) ? 'Enter an image URL' : null,
                ),
                const SizedBox(height: 24),
                // Show a loading indicator or the button
                Visibility(
                  visible: _addProductInProgress == false,
                  replacement: Center(child: CircularProgressIndicator()),
                  child: FilledButton(
                    onPressed: _onTapAddProductButton,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text("Add Product"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onTapAddProductButton() async {
    _addProductInProgress = true;
    // 1. Validate the form
    if (!_formkey.currentState!.validate()) {
      return; // If form is not valid, do nothing
    }
    try {
      // 2. Prepare URL
      Uri uri = Uri.parse(Urls.createProductsUrl);
      // 3. Use tryParse for safety
      final int? quantity = int.tryParse(_quantityController.text);
      final int? price = int.tryParse(_priceController.text);

      // This check is good, although validator handles it
      if (quantity == null || price == null) {
        if (mounted) {
          showSnackBarMsg(context, "Invalid quantity or price.");
        }
        return;
      }

      final int totalPrice = quantity * price;

      // 4. Prepare data (FIXED ProductCode)
      Map<String, dynamic> requestBody = {
        "ProductName": _nameController.text,
        "ProductCode": _codeController.text, // <-- THE FIX: Send as String
        "Img": _imgUrlController.text,
        "Qty": quantity, // Send safe-parsed int
        "UnitPrice": price, // Send safe-parsed int
        "TotalPrice": totalPrice,
      };

      // 5. Request the data
      http.Response response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      // 6. Check response and show feedback
      print(response.statusCode);
      print(response.body);
      _addProductInProgress = false;
      setState(() {});

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 'success') {
          // Assuming 'success' is the good status
          if (mounted) {
            showSnackBarMsg(context, 'Product added successfully!');
            Navigator.pop(context, true);
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
    } catch (e) {
      // Handle any other errors (e.g., no internet)
      if (mounted) {
        showSnackBarMsg(context, 'An error occurred: $e');
      }
    } finally {
      setState(() {});
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
