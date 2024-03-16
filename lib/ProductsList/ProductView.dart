import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart_scanner/ProductsList/ProductsListController.dart';

import '../Constants/Constants.dart';
import '../Model/Model.dart';

class ProductView extends StatelessWidget {
  final ProductModel product;

  ProductView({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(10.0), // Set the border radius here
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Set the shadow color here
              spreadRadius: 5, // Set the spread radius of the shadow
              blurRadius: 7, // Set the blur radius of the shadow
              offset: Offset(0, 3), // Set the offset of the shadow
            ),
          ],
          color: Colors.white, // Add a background color if needed
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${product.category}", style: TextStyle(fontSize: 11)),
              SizedBox(
                height: 5,
              ),
              Center(
                child: CachedNetworkImage(
                  // width: 100,
                  height: 100,
                  imageUrl: product.allProductImageURLs?.first ?? "",
                  placeholder: (context, url) => Icon(Icons.hourglass_bottom),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Spacer(),
              getTitle(product),
              if (product.barcode != null && product.barcode?.trim() != "") ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: IntrinsicWidth(
                    child: Container(
                      width: null,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: darkGreenColor, // Set the border color here
                            width: 2.0, // Set the border width here
                          ),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('RESTART',
                                    style: TextStyle(
                                        color: darkRedColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold)),
                                Text(' Certified!',
                                    style: TextStyle(
                                        color: darkBlueColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ]
            ],
            // subtitle:
            //
          ),
        ));
  }

  Text getTitle(ProductModel product) {
    ProductsListController c = Get.find();
    var searchText = c.searchText.value.trim();
    var arr = (product.productName ?? "")
        .toLowerCase()
        .split(searchText.toLowerCase());
    print(arr);
    if (arr.length == 2) {
      return Text.rich(
          TextSpan(text: arr[0], style: TextStyle(fontSize: 13), children: [
        TextSpan(
            text: searchText.toLowerCase(),
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: darkGreenColor)),
        TextSpan(text: arr[1])
      ]));
    } else {
      return Text(
        product.productName ?? "",
        style: TextStyle(fontSize: 13),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }
  }
}
