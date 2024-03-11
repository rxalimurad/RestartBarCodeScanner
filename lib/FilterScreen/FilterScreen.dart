import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:get/get.dart';

import '../Constants/Constants.dart';
import '../ProductsList/ProductsListController.dart';
import '../Widgets/CustomCircleWidget.dart';
import '../Widgets/CustomRectangleWidget.dart';

class FilterScreen extends StatelessWidget implements TickerProvider {
  const FilterScreen({
    Key? key,
    required this.index,
    required this.scanController,
    required this.searchController,
  }) : super(key: key);

  final int index;
  final ProductsListController scanController;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    var tabController = TabController(length: 2, vsync: this);
    tabController.index = index;
    return SafeArea(
      child: Container(
        height: 400,
        child: DefaultTabController(
          length: 2,
          initialIndex: index,
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
                      controller: tabController,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          25.0,
                        ),
                        color: primaryColor,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Tab(
                          child: Text(
                            'Category',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Age',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        Container(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: ListView(
                                scrollDirection:
                                    Axis.vertical, // Use horizontal scrolling
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
                                    .map(
                                      (e) => GestureDetector(
                                        onTap: () {
                                          Get.back();
                                          scanController.searchText.value = "";
                                          searchController.text = "";
                                          scanController.age.value = "";
                                          scanController.category.value =
                                              e.split("/").first;
                                          scanController.pagingController
                                              .refresh();
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: CustomRectangleWidget(
                                            isSelected:
                                                scanController.category.value ==
                                                    e.split("/").first,
                                            rectangleColor:
                                                hexToColor(e.split("/").last),
                                            labelText: e.split("/").first,
                                            width: 500,
                                            height: 50,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: GridView.count(
                              crossAxisCount: 3,
                              children: [
                                "0-18/65ca33/months",
                                "18-36/9b31cc/months",
                                "3-4/febe00/years",
                                "5-6/3398cc/years",
                                "7-8/fc6f05/years",
                                "9-11/ff3334/years"
                              ]
                                  .map(
                                    (e) => GestureDetector(
                                      onTap: () {
                                        Get.back();
                                        scanController.searchText.value = "";
                                        searchController.text = "";
                                        scanController.age.value = e;
                                        scanController.category.value = "";
                                        scanController.pagingController
                                            .refresh();
                                      },
                                      child: CustomCircleWidget(
                                        isSelected:
                                            scanController.age.value == e,
                                        circleColor:
                                            hexToColor(e.split("/")[1]),
                                        upperText: e.split("/").first,
                                        lowerText: e.split("/").last,
                                        size: 100,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Ticker createTicker(onTick) => Ticker(onTick);
}
