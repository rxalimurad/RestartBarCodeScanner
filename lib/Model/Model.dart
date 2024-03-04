class ProductModel {
  final String id;
  final String category;
  final String productName;
  final List<String> allProductImageURLs;
  final String recommendedAge;
  final String recommendedGrade;

  ProductModel({
    required this.id,
    required this.category,
    required this.productName,
    required this.allProductImageURLs,
    required this.recommendedAge,
    required this.recommendedGrade,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'productName': productName,
      'allProductImageURLs': allProductImageURLs,
      'recommendedAge': recommendedAge,
      'recommendedGrade': recommendedGrade,
    };
  }
}