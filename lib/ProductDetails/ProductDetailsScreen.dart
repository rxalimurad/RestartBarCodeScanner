import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:restart_scanner/Constants/Constants.dart';
import 'package:restart_scanner/LocalDataHandler/LocalDataHandler.dart';
import 'package:restart_scanner/Model/Model.dart';
import 'package:restart_scanner/ProductsList/ProductsListController.dart';
import 'package:restart_scanner/Widgets/CustomAlert.dart';
import 'package:simple_barcode_scanner/enum.dart';

import '../DBHandler/MongoDbHelper.dart';
import '../Widgets/BarcodeScannerRevamp.dart';

const titleFontSize = 15.0;

class ProductDetailsScreen extends StatelessWidget {
  var currentIndexPage = 0.obs;
  final PageController controller = PageController();
  ProductModel product;
  ProductDetailsScreen(this.product);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Product Details"),
          backgroundColor: primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: CarouselSlider.builder(
                    itemCount: product.allProductImageURLs?.length,
                    itemBuilder: (BuildContext context, int itemIndex,
                            int pageViewIndex) =>
                        Container(
                      color: Colors.white12,
                      child: CachedNetworkImage(
                        // width: 100,
                        height: 100,
                        imageUrl: product.allProductImageURLs?[itemIndex] ?? "",
                        placeholder: (context, url) =>
                            Icon(Icons.hourglass_bottom),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    options: CarouselOptions(
                      height: 200,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 1000),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.5,
                      onPageChanged: (index, r) {
                        currentIndexPage.value = index;
                      },
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
                Obx(() {
                  return DotsIndicator(
                    dotsCount: product.allProductImageURLs?.length ?? 0,
                    position: currentIndexPage.value,
                    decorator: DotsDecorator(
                      activeColor: primaryColor,
                      size: const Size.square(7.0),
                      activeSize: const Size(15.0, 7.0),
                      activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  );
                }),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Title",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: titleFontSize),
                    ),
                    Text(product.productName ?? ""),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
                    if (getRecommendedAge(product).isNotEmpty) ...[
                      Text("Recommended Age",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: titleFontSize)),
                      Text(getRecommendedAge(product)),
                      SizedBox(height: 10),
                      Divider(),
                      SizedBox(height: 10),
                    ],
                    if (product.additionalInfo != null &&
                        product.additionalInfo!.removeAllWhitespace
                            .isNotEmpty) ...[
                      Text("Additional Information",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: titleFontSize)),
                      Text(product.additionalInfo?.trim() ?? "N/A"),
                      SizedBox(height: 10),
                      Divider(),
                      SizedBox(height: 10),
                    ],
                    if (product.desc != null &&
                        product.desc!.removeAllWhitespace.isNotEmpty) ...[
                      Text("Description",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: titleFontSize)),
                      ReadMoreText(
                        product.desc ?? "",
                        trimLines: 2,
                        colorClickableText: Colors.pink,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: 'Show less',
                        moreStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Divider(),
                      SizedBox(height: 10),
                      if (product.barcode == null || product.barcode == "") ...[
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              var isLoggedIn =
                                  (await LocalDataHandler.getUserData()) !=
                                      null;
                              if (isLoggedIn) {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Stack(
                                      children: [
                                        BarcodeScannerRevamped(
                                          lineColor: "#ff6666",
                                          cancelButtonText: "Cancel",
                                          isShowFlashIcon: true,
                                          scanType: ScanType.barcode,
                                          appBarTitle: "Scan Barcode",
                                          centerTitle: true,
                                          loadingWidget: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 5),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text('RESTART',
                                                        style: TextStyle(
                                                            color: darkRedColor,
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text(' Certified!',
                                                        style: TextStyle(
                                                            color:
                                                                darkBlueColor,
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          onScanned: (res) async {
                                            if (res.isEmpty || res == "-1") {
                                              Navigator.pop(context);
                                              return;
                                            }
                                            print("Barcode: $res");

                                            var newProduct = await MongoDbHelper
                                                .updateBarcode(product.id, res);
                                            if (newProduct != null) {
                                              product = newProduct;
                                              SnackBar snackBar = SnackBar(
                                                content:
                                                    Text('Barcode updated'),
                                                duration: Duration(seconds: 3),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                              ProductsListController c =
                                                  Get.find();
                                              c.updateProduct(product);
                                              this.product = product;
                                              c.pagingController.refresh();
                                              Get.back();
                                            } else {
                                              Get.snackbar("Error",
                                                  "Failed to update barcode");
                                            }

                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
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
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: darkRedColor,
                            ),
                            child: Text('Scan Barcode',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                      if (product.barcode != null && product.barcode != "") ...[
                        Padding(
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
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                  Text(' Certified!',
                                      style: TextStyle(
                                          color: darkBlueColor,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold))
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ]
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getRecommendedAge(ProductModel? model) {
    var result = "";
    var minAge = model?.minAge ?? -1;
    var maxAge = model?.maxAge ?? -1;
    var minGrade = model?.minGrade ?? "";
    var maxGrade = model?.maxGrade ?? "";
    if (minAge != -1) {
      result += getAgeString(minAge) + " ";
    }
    if (maxAge != -1) {
      result += "- ${getAgeString(maxAge)}";
    }
    if (minGrade.isNotEmpty) {
      result += " / $minGrade ";
    }
    if (maxGrade.isNotEmpty) {
      result += "- $maxGrade";
    }

    return result.trim();
  }

  getAgeString(int minAge) {
    var app = "";
    if (minAge == 0) {
      app = "Birth";
    } else if (minAge <= 36) {
      app = "$minAge mos";
    } else if (minAge == 216) {
      app = "Adult";
    } else {
      app = "${(minAge / 12).toInt()} yrs";
    }
    return app;
  }
}
