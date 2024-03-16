import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:restart_scanner/Constants/Constants.dart';
import 'package:restart_scanner/FilterScreen/FilterScreen.dart';
import 'package:restart_scanner/LocalDataHandler/LocalDataHandler.dart';
import 'package:restart_scanner/Model/Model.dart';
import 'package:simple_barcode_scanner/enum.dart';

import '../DBHandler/MongoDbHelper.dart';
import '../ProductDetails/ProductDetailsScreen.dart';
import '../Widgets/BarcodeScannerRevamp.dart';
import '../Widgets/CustomAlert.dart';
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
                      color: darkRedColor, fontWeight: FontWeight.bold)),
              Text(' Education',
                  style: TextStyle(
                      color: darkBlueColor, fontWeight: FontWeight.bold))
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
                        var index = 0;
                        if (_scanController.category.value.isNotEmpty) {
                          index = 0;
                        } else if (_scanController.age.value.isNotEmpty) {
                          index = 1;
                        }

                        return FilterScreen(
                            index: index,
                            scanController: _scanController,
                            searchController: _searchController);
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                      child: RefreshIndicator(
                        onRefresh: () {
                          if (_scanController.pagingController != null) {
                            _scanController.pagingController.refresh();
                            return Future.value(true);
                          } else {
                            return Future.value(
                                false); // or handle the case where pagingController is null
                          }
                        },
                        child: PagedGridView<int, ProductModel>(
                          showNewPageProgressIndicatorAsGridChild: false,
                          pagingController: _scanController.pagingController,
                          builderDelegate:
                              PagedChildBuilderDelegate<ProductModel>(
                            itemBuilder: (context, item, index) =>
                                GestureDetector(
                              child: ProductView(product: item),
                              onTap: () {
                                Get.to(ProductDetailsScreen(item));
                              },
                            ),
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.80,
                          ),
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
            onPressed: () async {
              var isLoggedIn = (await LocalDataHandler.getUserData()) != null;
              if (isLoggedIn) {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return BarcodeScannerRevamped(
                      lineColor: "#ff6666",
                      cancelButtonText: "Cancel",
                      isShowFlashIcon: true,
                      loadingWidget: Text(
                        "Verifying Product...",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
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
                              Navigator.pop(context);
                              Get.to(ProductDetailsScreen(value));
                            } else {
                              Navigator.pop(context);
                              SnackBar snackBar = SnackBar(
                                content: Text("Product not found"),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                        );
                      },
                    );
                  },
                );
              } else {
                Get.dialog(CustomAlertDialog(
                    title: "You are not logged in",
                    message: "Please login to scan barcode",
                    OKTitle: "Login",
                    onOkPressed: () {
                      Get.back();
                      Get.toNamed("/LoginScreen");
                    }));
              }
            },
            child: Icon(Icons.barcode_reader),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('RESTART',
                        style: TextStyle(
                            color: darkRedColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30)),
                    Text(' Education',
                        style: TextStyle(
                            color: darkBlueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30))
                  ],
                ),
              ),
              FutureBuilder(
                  future: LocalDataHandler.getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          ListTile(
                            minLeadingWidth: 10,
                            title: Text('Profile'),
                            leading: Icon(Icons
                                .person), // Add icon to the leading property
                            onTap: () {
                              Navigator.pop(context);
                              Future.delayed(Duration(milliseconds: 500), () {
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');
                              });
                              Get.toNamed('/profileScreen');
                            },
                          ),
                          ListTile(
                            minLeadingWidth: 10,
                            title: Text('Change Password'),
                            leading: Icon(Icons
                                .password), // Add icon to the leading property
                            onTap: () {
                              Navigator.pop(context);
                              Future.delayed(Duration(milliseconds: 500), () {
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');
                              });
                              Get.toNamed('/changePassword', arguments: {
                                'email': snapshot.data?.email,
                                'postLogin': true
                              });
                            },
                          ),
                          ListTile(
                            minLeadingWidth: 10,
                            title: Text('Logout'),
                            leading: Icon(Icons
                                .exit_to_app), // Add icon to the leading property
                            onTap: () async {
                              await LocalDataHandler.removeUserData();
                              SnackBar snackBar = SnackBar(
                                content: Text('Logged out successfully'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              Get.offAllNamed('/LoginScreen');
                            },
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          ListTile(
                            minLeadingWidth: 10,
                            title: Text('Login'),
                            leading: Icon(Icons
                                .login), // Add icon to the leading property
                            onTap: () {
                              Navigator.pop(context);
                              Future.delayed(Duration(milliseconds: 500), () {
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');
                              });
                              Get.toNamed('/LoginScreen');
                            },
                          ),
                          ListTile(
                            minLeadingWidth: 10,
                            title: Text('Create new Account'),
                            leading: Icon(Icons
                                .person_add), // Add icon to the leading property
                            onTap: () {
                              Navigator.pop(context);
                              Future.delayed(Duration(milliseconds: 500), () {
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');
                              });
                              Get.toNamed('/SignupScreen');
                            },
                          ),
                        ],
                      );
                    }
                    return Container();
                  }),
            ],
          ),
        ));
  }
}
