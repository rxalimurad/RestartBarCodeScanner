import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:restart_scanner/Constants/Constants.dart';
import 'package:restart_scanner/Model/Model.dart';

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
        body: Column(children: [
        Container(
          child: CarouselSlider.builder(
          itemCount: product.allProductImageURLs?.length,
            itemBuilder: (BuildContext context, int itemIndex,
                int pageViewIndex) =>
                Container(
                  child: CachedNetworkImage(
                    // width: 100,
                    height: 100,
                    imageUrl: product.allProductImageURLs?[itemIndex] ?? "",
                    placeholder: (context, url) => Icon(Icons.hourglass_bottom),
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
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 3000),
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
          Text("Title"),
          Text(product.productName ?? ""),
          Text("Recommended Age"),
          Text("${product.minAge} - ${product.maxAge} / ${product.minGrade} - ${product.maxGrade}"),
          Text("Additional Information"),
          Text(product.additionalInfo ?? ""),
          Text("Description"),
        ReadMoreText(
          product.desc ?? "",
          trimLines: 2,
          colorClickableText: Colors.pink,
          trimMode: TrimMode.Line,
          trimCollapsedText: 'Show more',
          trimExpandedText: 'Show less',
          moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),




        ],),
    ),);

  }
}