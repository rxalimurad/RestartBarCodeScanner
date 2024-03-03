//
//  RealmManager.swift
//  RestartBarCodeScanner
//
//  Created by Ali Murad on 04/03/2024.
//

import RealmSwift


class RealmManager {
    static func saveProducts(_ products: [ProductModel]) {
        let realm = try! Realm()
        try! realm.write {
            for product in products {
                let productEntity = ProductEntity()
                productEntity.id = product.id
                productEntity.category = product.category
                productEntity.productName = product.productName
                productEntity.allProductImageURLs.append(objectsIn: product.allProductImageURLs ?? [])
                productEntity.recommendedAge = product.recommendedAge
                productEntity.recommendedGrade = product.recommendedGrade
                productEntity.descriptionText = product.description
                productEntity.additionalInformation = product.additionalInformation
                realm.add(productEntity)
            }
        }
    }

    static func fetchProducts() -> [ProductModel] {
        let realm = try! Realm()
        let productEntities = realm.objects(ProductEntity.self)
        return productEntities.map { productEntity in
            return ProductModel(
                id: productEntity.id,
                category: productEntity.category,
                productName: productEntity.productName,
                allProductImageURLs: productEntity.allProductImageURLs.map { $0 },
                recommendedAge: productEntity.recommendedAge,
                recommendedGrade: productEntity.recommendedGrade,
                description: productEntity.descriptionText,
                additionalInformation: productEntity.additionalInformation
            )
        }
    }

}
