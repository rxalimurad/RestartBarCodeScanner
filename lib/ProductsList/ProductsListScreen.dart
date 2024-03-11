import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:restart_scanner/Constants/Constants.dart';
import 'package:restart_scanner/Model/Model.dart';
import 'package:restart_scanner/Widgets/CustomCircleWidget.dart';
import 'package:restart_scanner/Widgets/CustomRectangleWidget.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/screens/io_device.dart';

import '../DBHandler/MongoDbHelper.dart';
import '../ProductDetails/ProductDetailsScreen.dart';
import 'ProductView.dart';
import 'ProductsListController.dart';

var ageRanges = {
  '0-18/65ca33/months': {'min': 0, 'max': 18},
  '18-36/9b31cc/months': {'min': 18, 'max': 36},
  '3-4/febe00/years': {'min': 36, 'max': 48},
  '5-6/3398cc/years': {'min': 60, 'max': 72},
  '7-8/fc6f05/years': {'min': 84, 'max': 96},
  '9-11/ff3334/years': {'min': 108, 'max': 132}
};
var ageRangesLabels = {
  '0-18/65ca33/months': {'label': '0-18 months'},
  '18-36/9b31cc/months': {'label': '18-36 months'},
  '3-4/febe00/years': {'label': '3-4 years'},
  '5-6/3398cc/years': {'label': '5-6 years'},
  '7-8/fc6f05/years': {'label': '7-8 years'},
  '9-11/ff3334/years': {'label': '9-11 years'}
};

class ProductsListScreen extends StatelessWidget {
  var _category = "";
  late final ProductsListController _scanController;
  TextEditingController _searchController = TextEditingController();
  ProductsListScreen() {
    if (Get.arguments != null) {
      _category = Get.arguments['category'];
    }
    _scanController = Get.put(ProductsListController());
    _scanController.category.value = _category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text('RESTART',
                style: TextStyle(
                    color: Color(0xFFC00000), fontWeight: FontWeight.bold)),
            Text(' Education',
                style: TextStyle(
                    color: Color(0xFF3076B5), fontWeight: FontWeight.bold))
          ],
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Obx(() {
            return IconButton(
              onPressed: () {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return filtersView();
                    });
              },
              icon: Icon(
                _scanController.category.value.isEmpty &&
                        _scanController.age.value.isEmpty
                    ? Icons.filter_alt_outlined
                    : Icons.filter_alt,
                color: Colors.black,
                size: 30,
              ),
            );
          }),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: (value) {
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
          Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      "${_scanController.category.value.isEmpty ? _scanController.age.value.isEmpty ? "All" : ageRangesLabels[_scanController.age.value]!['label'] : _scanController.category.value}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  Spacer(),
                  if (_scanController.category.value.isNotEmpty ||
                      _scanController.age.value.isNotEmpty)
                    ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  15.0), // Adjust the value as needed
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor),
                        ),
                        onPressed: () {
                          _scanController.searchText.value = "";
                          _searchController.text = "";
                          _scanController.category.value = "";
                          _scanController.age.value = "";
                          _scanController.pagingController.refresh();
                        },
                        child: Text("Clear")),
                ],
              ),
            );
          }),
          SizedBox(height: 16.0),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
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
                      ),
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
      floatingActionButton: Tooltip(
        message: 'Scan Barcode',
        child: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return BarcodeScanner(
                  lineColor: "#ff6666",
                  cancelButtonText: "Cancel",
                  isShowFlashIcon: true,
                  scanType: ScanType.barcode,
                  appBarTitle: "Scan Barcode",
                  centerTitle: true,
                  onScanned: (res) async {
                    if (res.isEmpty || res == "-1") {
                      Navigator.pop(context);
                      return;
                    }
                    MongoDbHelper.getProduct(res).then(
                      (value) {
                        if (value != null) {
                          Get.to(ProductDetailsScreen(value));
                        } else {
                          Get.snackbar("Error", "Product not found",
                              snackPosition: SnackPosition.BOTTOM);
                        }

                        Navigator.pop(context);
                      },
                    );

                    Navigator.pop(context);
                  },
                );
              },
            );
          },
          child: Icon(Icons.barcode_reader),
        ),
      ),
    );
  }

  SafeArea filtersView() {
    // var _tabController = TabController(length: 4, vsync: this);
    return SafeArea(
      child: Container(
        height: 400,
        child: DefaultTabController(
            length: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Scaffold(
                  body: Column(
                children: [
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                    ),
                    child: TabBar(
                      // isScrollable: true,
                      // controller: _tabController,
                      // give the indicator a decoration (color and border radius)
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          25.0,
                        ),
                        color: Colors.green,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        // first tab [you can add an icon using the icon property]
                        Tab(
                          child: Text('Category', textAlign: TextAlign.center),
                        ),

                        // second tab [you can add an icon using the icon property]

                        Tab(
                          child: Text('Age', textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                    children: [
                      // first tab bar view widget
                      Container(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: GridView.count(
                              crossAxisCount: 4, // Number of columns
                              mainAxisSpacing:
                                  0, // Vertical spacing between cells
                              children: [
                                "Classroom Furniture/68ca33",
                                "Teaching Resources/3398cc",
                                "Classroom Decorations/9a34cc",
                                "Arts & Crafts/ffc432",
                                "Books/fe7a3d",
                                "Language/ff3334",
                                "Math/68ca33",
                                "Science/3398cc",
                                "STEM/9a34cc",
                                "Social Studies/ffc432",
                                "Infants & Toddlers/fe7a3d",
                                "Blocks & Manipulatives/ff3334",
                                "Dramatic Play/68ca33",
                                "Active Play/3398cc",
                                "Sand & Water/9a34cc",
                                "Sensory Exploration/ffc432",
                                "Music/fe7a3d",
                                "Games/ff3334",
                                "Puzzles/68ca33"
                              ]
                                  .map((e) => GestureDetector(
                                        onTap: () {
                                          Get.back();
                                          _scanController.searchText.value = "";
                                          _searchController.text = "";
                                          _scanController.age.value = "";

                                          _scanController.category.value =
                                              e.split("/").first;
                                          _scanController.pagingController
                                              .refresh();
                                        },
                                        child: CustomRectangleWidget(
                                            rectangleColor:
                                                hexToColor(e.split("/").last),
                                            labelText: e.split("/").first,
                                            width: 90,
                                            height: 90),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                      // second tab bar view widget

                      Container(
                        child: Center(
                          child: GridView.count(
                            crossAxisCount: 3, // Number of columns
                            children: [
                              "0-18/65ca33/months",
                              "18-36/9b31cc/months",
                              "3-4/febe00/years",
                              "5-6/3398cc/years",
                              "7-8/fc6f05/years",
                              "9-11/ff3334/years"
                            ]
                                .map((e) => GestureDetector(
                                      onTap: () {
                                        Get.back();
                                        _scanController.searchText.value = "";
                                        _searchController.text = "";
                                        _scanController.age.value = e;
                                        _scanController.category.value = "";
                                        _scanController.pagingController
                                            .refresh();
                                      },
                                      child: CustomCircleWidget(
                                        circleColor:
                                            hexToColor(e.split("/")[1]),
                                        upperText: e.split("/").first,
                                        lowerText: e.split("/").last,
                                        size:
                                            100, // You can adjust the size as needed
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  )),
                ],
              )),
            )),
      ),
    );
  }
}
