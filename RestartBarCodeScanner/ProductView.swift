//
//  ProductView.swift
//  RestartBarCodeScanner
//
//  Created by Ali Murad on 04/03/2024.
//

import SwiftUI
import SDWebImageSwiftUI
struct ProductView: View {
    var product: ProductModel
    var body: some View {
        HStack {
            AnimatedImage(url: URL(string: product.allProductImageURLs?.first ?? ""))
                .resizable()
                .placeholder {
                        Rectangle().foregroundColor(.gray)
                    }
                    .indicator(.activity) // Activity Indicator
                    .transition(.fade(duration: 0.5)) // Fade Transition with duration
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
            VStack(alignment: .leading) {
                Text("Category: \(product.category ?? "")").font(.caption2)
                Text(product.productName ?? "")
                HStack {
                    Text("Scanned")
                    Image(systemName: "checkmark.circle.fill")
                }.foregroundStyle(Color(red: 0, green: 0.5, blue: 0))
            }
        }
    }
}

#Preview {
    ProductView(product: ProductModel(id: UUID(), category: "Maths", productName: "It’s a Snap! Simple Addition CenterSimple Addition CenterSimple Addition Center", allProductImageURLs: ["https://img.lakeshorelearning.com/is/image/OCProduction/tt293?wid=800&fmt=jpeg&qlt=85,1&pscan=auto&op_sharpen=0&resMode=sharp2&op_usm=1,0.65,6,0"], recommendedAge: "4 yrs. - 6 yrs.", recommendedGrade: "Pre-K - 1st gr."))
}
