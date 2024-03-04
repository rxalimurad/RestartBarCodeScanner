import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Model/Model.dart';

class ProductView extends StatelessWidget {
  final ProductModel product;

  ProductView({required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        product.allProductImageURLs.first,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Category: ${product.category}", style: TextStyle(fontSize: 12)),
          Text(product.productName),
          Row(
            children: [
              Text("Scanned"),
              Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
        ],
      ),
    );
  }
}