import 'package:mongo_dart/mongo_dart.dart';

class ProductModel {
  final ObjectId id;
  final String? category;
  final String? productName;
  final List<String>? allProductImageURLs;
  final int? minAge;
  final int? maxAge;
  final String? minGrade;
  final String? maxGrade;
  final String? desc;
  final String? additionalInfo;
  final String? barcode;

  ProductModel(
      {required this.id,
      required this.category,
      required this.productName,
      required this.allProductImageURLs,
      required this.minAge,
      required this.maxAge,
      required this.minGrade,
      required this.maxGrade,
      required this.additionalInfo,
      required this.desc,
      required this.barcode});

  static ProductModel formJson(Map<String, dynamic> json) {
    return ProductModel(
        id: json['_id'],
        category: json['category'],
        productName: json['productName'],
        allProductImageURLs:
            (json['allProductImageURLs'] as List<dynamic>?)?.cast<String>(),
        minAge: json['minAge'],
        maxAge: json['maxAge'],
        minGrade: json['minGrade'],
        maxGrade: json['maxGrade'],
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
      'minAge': minAge,
      'maxAge': maxAge,
      'minGrade': minGrade,
      'maxGrade': maxGrade,
      'desc': desc,
      'additionalInfo': additionalInfo,
      'barcode': barcode
    };
  }
}
