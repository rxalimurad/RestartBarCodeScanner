//
//  ScanScreen.swift
//  RestartBarCodeScanner
//
//  Created by Ali Murad on 02/03/2024.
//

import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI
import CodeScanner
struct ScanScreen: View {
    @State private var searchText = ""
    @State private var isFiltering = true
    @State private var isLoading = false
    @State private var products: [ProductModel] = []
    @State private var isPresentingScanner = false
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                
                VStack {
                    HStack {
                        Text("Total items: ")
                        Text("\(products.count)")
                    }
                    HStack {
                        Text("Scanned items: ")
                        Text("\(products.count)")
                    }
                }
                .padding(.horizontal)
                
                if isLoading {
                    ProgressView()
                }
                List {
                    ForEach(filteredItems, id: \.self) { item in
                        ProductView(product: item).onTapGesture {
                            isPresentingScanner.toggle()
                        }
                    }
                }.listStyle(.plain)
                    .navigationTitle("Scan Barcodes")
            }.onAppear() {
                fetchProducts()
            }
            .navigationBarItems(trailing:
                                    Button(action: {
                isFiltering.toggle()
            }, label: {
                if isFiltering {
                    Text("Show all")
                } else {
                    Text("Show unscanned only")
                }
            }).tint(.black).padding()
            )
            .sheet(isPresented: $isPresentingScanner) {
                CodeScannerView(codeTypes: [.code39]) { response in
                            if case let .success(result) = response {
                                isPresentingScanner = false
                                
                            }
                        }
                    }
        }
    }
        
    
    private func fetchProducts() {
        let prd = RealmManager.fetchProducts()
        if !prd.isEmpty {
            self.products = prd
            return
        }
        //,,..
//        RealmManager.saveProducts([ProductModel(id: UUID(), category: "Maths", productName: "It’s a Snap! Simple Addition CenterSimple Addition CenterSimple Addition Center", allProductImageURLs: ["https://img.lakeshorelearning.com/is/image/OCProduction/tt293?wid=800&fmt=jpeg&qlt=85,1&pscan=auto&op_sharpen=0&resMode=sharp2&op_usm=1,0.65,6,0"], recommendedAge: "4 yrs. - 6 yrs.", recommendedGrade: "Pre-K - 1st gr."),ProductModel(id: UUID(), category: "Maths", productName: "It’s a Snap! Simple Addition CenterSimple Addition CenterSimple Addition Center", allProductImageURLs: ["https://img.lakeshorelearning.com/is/image/OCProduction/tt293?wid=800&fmt=jpeg&qlt=85,1&pscan=auto&op_sharpen=0&resMode=sharp2&op_usm=1,0.65,6,0"], recommendedAge: "4 yrs. - 6 yrs.", recommendedGrade: "Pre-K - 1st gr."),ProductModel(id: UUID(), category: "Maths", productName: "It’s a Snap! Simple Addition CenterSimple Addition CenterSimple Addition Center", allProductImageURLs: ["https://img.lakeshorelearning.com/is/image/OCProduction/tt293?wid=800&fmt=jpeg&qlt=85,1&pscan=auto&op_sharpen=0&resMode=sharp2&op_usm=1,0.65,6,0"], recommendedAge: "4 yrs. - 6 yrs.", recommendedGrade: "Pre-K - 1st gr.")])
        isLoading = true
        let db = Firestore.firestore()
        
        // Fetch products from Firestore
        db.collection("Products").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            // Map Firestore documents to Product model
            let products = documents.compactMap { document -> ProductModel? in
                let data = document.data()
                
                return ProductModel.fromMap(map: data)
            }
            
            // Update the products array
            self.products = products
            RealmManager.saveProducts(products)
            isLoading = false
            print(documents.count)
        }
    }
    private var filteredItems: [ProductModel] {
        if searchText.isEmpty {
            return products
        } else {
            return products.filter {
                ifMeetSearchCriteria(product: $0, searchText: searchText)
            }
        }
    }
    
    private func ifMeetSearchCriteria(product: ProductModel, searchText: String) -> Bool {
        if let name = product.productName {
            if name.lowercased().contains(searchText.lowercased()) {
                return true
            }
        }
        if let category = product.category {
            if category.lowercased().contains(searchText.lowercased()) {
                return true
            }
        }
        return false
    }
    
}


struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(8)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .onSubmit {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            
            
            
        }
    }
}


#Preview {
    ScanScreen()
}
