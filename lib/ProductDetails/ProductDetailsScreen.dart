import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:restart_scanner/Constants/Constants.dart';
import 'package:restart_scanner/Model/Model.dart';

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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
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
                      product
                          .additionalInfo!.removeAllWhitespace.isNotEmpty) ...[
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
                      moreStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
                    if (product.barcode == null) ...[
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Add your code to handle barcode scanning here
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: primaryColor,
                          ),
                          child: Text('Scan Barcode',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ]
                  ]
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String getRecommendedAge(ProductModel? model) {
    var result = "";
    var minAge = model?.minAge ?? "";
    var maxAge = model?.maxAge ?? "";
    var minGrade = model?.minGrade ?? "";
    var maxGrade = model?.maxGrade ?? "";
    if (minAge.isNotEmpty) {
      result += minAge + " ";
    }
    if (maxAge.isNotEmpty) {
      result += "- $maxAge";
    }
    if (minGrade.isNotEmpty) {
      result += " / $minGrade ";
    }
    if (maxGrade.isNotEmpty) {
      result += "- $maxGrade";
    }

    return result.trim();
  }
}
