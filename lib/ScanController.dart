import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'Model/Model.dart';

class ScanController extends GetxController {
  final searchText = ''.obs;
  final isFiltering = true.obs;
  final isLoading = false.obs;
  final products = <ProductModel>[].obs;
  final isPresentingScanner = false.obs;

  @override
  void onInit() {
    // super.onInit();
    fetchProducts();
  }

  void fetchProducts() {
    // You can implement your logic to fetch products here
    // For now, let's simulate some data
    isLoading.value = true;
    products.assignAll(
      List.generate(
        10,
            (index) => ProductModel(
          id: index.toString(),
          category: "Toys",
          productName: "Game for kids not for adults",
          allProductImageURLs: ["https://m.media-amazon.com/images/I/71ND51QZAuL._AC_SL1500_.jpg"],
          recommendedAge: "4 yrs. - 6 yrs.",
          recommendedGrade: "Pre-K - 1st gr.",
        ),
      ),
    );
    isLoading.value = false;
  }

  List<ProductModel> get filteredItems {
    if (searchText.value.isEmpty) {
      return products;
    } else {
      return products.where((item) {
        return item.productName.toLowerCase().contains(searchText.value.toLowerCase()) ||
            item.category.toLowerCase().contains(searchText.value.toLowerCase());
      }).toList();
    }
  }
}