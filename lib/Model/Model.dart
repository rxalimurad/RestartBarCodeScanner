class ProductModel {
  final String id;
  final String? category;
  final String? productName;
  final List<String>? allProductImageURLs;
  final String? recommendedAge;
  final String? recommendedGrade;
  final String? desc;
  final String? additionalInfo;
  final String? barcode;

  ProductModel(
      {required this.id,
      required this.category,
      required this.productName,
      required this.allProductImageURLs,
      required this.recommendedAge,
      required this.recommendedGrade,
      required this.additionalInfo,
      required this.desc,
      required this.barcode});

  static ProductModel formJson(Map<String, dynamic> json) {
    return ProductModel(
        id: json['_id'].toString(),
        category: json['category'],
        productName: json['productName'],
        allProductImageURLs:
            (json['allProductImageURLs'] as List<dynamic>?)?.cast<String>(),
        recommendedAge: json['recommendedAge'],
        recommendedGrade: json['recommendedGrade'],
        desc: json['description'],
        additionalInfo: json['additionalInformation'],
        barcode: json['barcode']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'productName': productName,
      'allProductImageURLs': allProductImageURLs ?? [],
      'recommendedAge': recommendedAge,
      'recommendedGrade': recommendedGrade,
      'desc': desc,
      'additionalInfo': additionalInfo,
      'barcode': barcode
    };
  }
}
