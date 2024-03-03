//
//  ProductModel.swift
//  RestartBarCodeScanner
//
//  Created by Ali Murad on 03/03/2024.
//

import Foundation
import RealmSwift

struct ProductModel: Codable, Identifiable, Hashable {
    var id = UUID()
    var category: String?
    var productName: String?
    var allProductImageURLs: [String]?
    var recommendedAge: String?
    var recommendedGrade: String?
    var description: String?
    var additionalInformation: String?
    
    
    static func new(_ item: [String: String]?) -> ProductModel? {
        var imageURLs = [String]()
        if let imgURL = item?["All Product Image URL(s)"] {
            let arrURL = imgURL.split(separator: ",")
            for url in arrURL {
                imageURLs.append(String(url).replacingOccurrences(of: " ", with: ""))
            }
        }
        
        var recomendedAgee: String?
        var recomendedGrade: String?
        
        if let raage = item?["Recommended Age"], !raage.isEmpty {
            let arrURL = raage.split(separator: "/")
            recomendedAgee = String(arrURL[0]).trimmingCharacters(in: .whitespacesAndNewlines)
            if arrURL.count > 1 {
                recomendedGrade = String(arrURL[1]).trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        guard let item else { return nil }
        let product = ProductModel(
            category: item["Category"] ,
            productName: item["Product Name"],
            allProductImageURLs: imageURLs,
            recommendedAge: recomendedAgee,
            recommendedGrade: recomendedGrade,
            description: item["Description"],
            additionalInformation: item["Additional Information"]
        
        )
        return product
    }
    
    static func fromMap(map: [String: Any]) -> Self {
        return ProductModel (
            id: map["id"] as! UUID,
            category: map["category"] as? String,
            productName: map["productName"] as? String,
            allProductImageURLs: map["allProductImageURLs"] as? Array,
            recommendedAge: map["recommendedAge"] as? String,
            recommendedGrade: map["recommendedGrade"] as? String,
            description: map["description"] as? String,
            additionalInformation: map["additionalInformation"]  as? String
        )
    }
    
    func dictionaryRepresentation() -> [String: Any] {
        var dict = [String: Any]()
        dict["category"] = category
        dict["id"] = id
        dict["productName"] = productName
        dict["allProductImageURLs"] = allProductImageURLs
        dict["recommendedAge"] = recommendedAge
        dict["recommendedGrade"] = recommendedGrade
        dict["description"] = description
        dict["additionalInformation"] = additionalInformation
        return dict
    }

}
class ProductEntity: Object {
    @Persisted var id = UUID()
    @Persisted var category: String?
    @Persisted var productName: String?
    @Persisted var allProductImageURLs: List<String>
    @Persisted var recommendedAge: String?
    @Persisted var recommendedGrade: String?
    @Persisted var descriptionText: String?
    @Persisted var additionalInformation: String?
}
