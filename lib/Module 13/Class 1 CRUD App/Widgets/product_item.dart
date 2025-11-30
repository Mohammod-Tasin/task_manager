import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:m_ten_to_inf/Module%2013/Class%201%20CRUD%20App/Pages/update_product_page.dart';

import '../Models/product_model.dart';
import '../utils/urls.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    super.key,
    required this.product,
    required this.refreshProductList,
  });

  final ProductModel product;
  final VoidCallback refreshProductList;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool _deleteInProgress = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Image.network(
          width: 30,
          widget.product.image,
          errorBuilder: (_, __, ___) {
            return Icon(Icons.error_outline);
          },
        ),
      ),
      title: Text(widget.product.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Code: ${widget.product.code}'),
          Row(
            spacing: 16,
            children: [
              Text('Quantity: ${widget.product.quantity}'),
              Text('Unit Price: ${widget.product.unitPrice}'),
            ],
          ),
        ],
      ),
      trailing: Visibility(
        visible: _deleteInProgress == false,
        replacement: CircularProgressIndicator(),
        child: PopupMenuButton<ProductOption>(
          itemBuilder: (context) {
            return [
              PopupMenuItem(value: ProductOption.update, child: Text('Update')),
              PopupMenuItem(value: ProductOption.delete, child: Text('Delete')),
            ];
          },
          onSelected: (ProductOption selectedOption) {
            if (selectedOption == ProductOption.delete) {
              _deleteProduct();
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UpdateProductPage(product: widget.product),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _deleteProduct() async {
    _deleteInProgress = true;
    setState(() {});
    Uri uri = Uri.parse(Urls.deleteProductsUrl(widget.product.id));
    Response response = await get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint(response.body);
    if (response.statusCode == 200) {
      widget.refreshProductList();
    }
    _deleteInProgress = false;
    setState(() {});
  }

  // _deleteInProgress= false . This can't be called here, why?
  /// check that. set state ta ekhanei keno dite hobe?
}

enum ProductOption { update, delete }
