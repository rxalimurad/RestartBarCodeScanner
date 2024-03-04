import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Constants.dart';
import 'Model/Model.dart';

class ProductView extends StatelessWidget {
  final ProductModel product;

  ProductView({required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedNetworkImage(
        width: 100,
        height: 100,
        imageUrl: product.allProductImageURLs?.first ?? "",
        placeholder: (context, url) => Icon(Icons.hourglass_bottom),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Category: ${product.category}", style: TextStyle(fontSize: 10)),
          Text(product.productName ?? ""),
          Row(
            children: [
              Text("Scanned", style: TextStyle(color: darkGreenColor),),
              Icon(Icons.check, color: darkGreenColor),
            ],
          ),
        ],
      ),
    );
  }
}