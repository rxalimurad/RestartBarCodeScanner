import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../DBHandler/MongoDbHelper.dart';
import '../Model/Model.dart';

class ProductsListController extends GetxController {
  final searchText = ''.obs;
  var category = 'All Products';
  final showunScannedProductOnly = true.obs;
  final isLoading = false.obs;
  final PagingController<int, ProductModel> pagingController =
      PagingController(firstPageKey: 1);


  void startFetching() {
    print("fetching for category $category");
    pagingController.refresh();
    pagingController.addPageRequestListener((pageKey) {
      print("where page number is $pageKey");
      print("pageKey: $pageKey");
      fetchProducts(pageKey);
    });
  }

  Future<void> fetchProducts(int pageKey) async {
    print("pageKey: $pageKey");
    int pageSize = 20;
    int skip = (pageKey - 1) * pageSize;

    try {
      MongoDbHelper.find(skip, pageSize, searchText.value, this.category).then((value) {
        var products = <ProductModel>[];

        for (var item in value) {
          products.add(ProductModel.formJson(item));
        }
        pagingController.appendPage(products, pageKey + 1);
      });
    } catch (e) {
      pagingController.error = e;
    }
  }
}
