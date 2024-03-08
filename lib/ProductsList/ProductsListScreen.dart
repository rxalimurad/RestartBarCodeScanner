import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:restart_scanner/Model/Model.dart';
import 'package:restart_scanner/Widgets/CustomCircleWidget.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/screens/io_device.dart';

import '../ProductDetails/ProductDetailsScreen.dart';
import 'ProductView.dart';
import 'ProductsListController.dart';

class ProductsListScreen extends StatelessWidget {
  var _category =  "All Products";
  late final ProductsListController _scanController;
  ProductsListScreen() {
    if (Get.arguments != null) {
      _category = Get.arguments['category'];
    }
    _scanController = Get.put(ProductsListController());
    _scanController.category = _category;
    _scanController.startFetching();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this._category),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: (value) {
                _scanController.searchText.value = value;
                _scanController.pagingController.refresh();
              },
              decoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     Obx(() =>
          //     //    Text("Total items: ${_scanController.products.length}")),
          //     Obx(() => Text(
          //         //"Scanned items: ${_scanController.products.where((element) => element.barcode != null && element.barcode!.isNotEmpty).length}")),
          //   ],
          // ),
          CustomCircleWidget(circleColor: Colors.red, upperText: "18-36", lowerText: "months", size: 100,),
          SizedBox(height: 16.0),
          Expanded(
            child: Column(
              children: [
                
                Expanded(
                  child:  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PagedGridView<int, ProductModel>(
                      showNewPageProgressIndicatorAsGridChild: false,
                      pagingController: _scanController.pagingController,
                      builderDelegate: PagedChildBuilderDelegate<ProductModel>(
                        itemBuilder: (context, item, index) => GestureDetector(
                          child: ProductView(product: item),
                          onTap: () {
                            Get.to(ProductDetailsScreen(item));
            
                          },
                        ),
                      ) ,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.80,
                        ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// showModalBottomSheet(
//   context: context,
//   builder: (BuildContext context) {
//     return BarcodeScanner(
//       lineColor: "#ff6666",
//       cancelButtonText: "Cancel",
//       isShowFlashIcon: true,
//       scanType: ScanType.barcode,
//       appBarTitle: "Scan Barcode",
//       centerTitle: true,
//       onScanned: (res) async {
//         if (res.isEmpty || res == "-1") {
//           Navigator.pop(context);
//           return;
//         }
//         print("Barcode: $res");
//         Fluttertoast.showToast(
//             msg: "Barcode: $res",
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 3,
//             backgroundColor: Colors.black,
//             textColor: Colors.white,
//             fontSize: 16.0);
//         // await _scanController.updateBarCode(
//         //   barcode: res, id: item.id);
//         Navigator.pop(context);
//       },
//     );
//   },
// );