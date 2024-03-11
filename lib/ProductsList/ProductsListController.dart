import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../DBHandler/MongoDbHelper.dart';
import '../Model/Model.dart';

class ProductsListController extends GetxController {
  final searchText = ''.obs;
  var category = ''.obs;
  var age = ''.obs;
  final isLoading = false.obs;
  final PagingController<int, ProductModel> pagingController =
      PagingController(firstPageKey: 1);

  @override
  void onInit() {
    print("fetchingg for category $category");
    // pagingController.refresh();
    pagingController.addPageRequestListener((pageKey) {
      print("where page number is $pageKey");
      print("pageKey: $pageKey");
      fetchProducts(pageKey);
    });
    super.onInit();
  }

  Future<void> fetchProducts(int pageKey) async {
    print("pageKey: $pageKey");
    int pageSize = 20;
    int skip = (pageKey - 1) * pageSize;

    try {
      MongoDbHelper.find(skip, pageSize, searchText.value, this.category.value,
              this.age.value)
          .then((value) {
        var products = <ProductModel>[];

        for (var item in value) {
          products.add(ProductModel.formJson(item));
          print("min grade: ${item['minGrade']}");
        }
        pagingController.appendPage(products, pageKey + 1);
      });
    } catch (e) {
      pagingController.error = e;
    }
  }

  updateProduct(ProductModel updatedItem) {
    var existingList = pagingController.itemList;
    final index = existingList?.indexWhere((item) => item.id == updatedItem.id);
    if (index != null && index >= 0) {
      existingList![index] = updatedItem;
      pagingController.itemList = existingList;
    }
  }
}
