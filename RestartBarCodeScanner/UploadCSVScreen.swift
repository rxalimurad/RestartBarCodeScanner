//
//  UploadCSVScreen.swift
//  RestartBarCodeScanner
//
//  Created by Ali Murad on 02/03/2024.
//
import SwiftUI
import UIKit
import SwiftCSV
import FirebaseFirestore

struct UploadCSVScreen: View {
    @State private var pickedFileURL: URL?
    @State private var openFilePicker = false
    @State private var uploadedCount = 0
    @State private var failedCount = 0
    @State private var totalRecords = 0
    @State private var alreadyExist = 0
    @State private var isLoading = false
    
    
    var body: some View {
        VStack {
            Text("Select the scrapped CSV file.")
                .multilineTextAlignment(.center)
                .font(.title)
                .padding(.vertical)
            
            if let fileURL = pickedFileURL {
                Text("Selected File: \(fileURL.lastPathComponent)")
            } else {
                Text("No file selected")
            }
            Button("Select File") {
                openFilePicker.toggle()
                pickedFileURL = nil // Reset picked file URL
            }
            .padding()
            Button(action: {
                Task {
                    if let pickedFileURL {
                        if let products = readFileContent(from: pickedFileURL) {
                            uploadProductsToFirestore(productsList: Array(products[0 ..< 10])) {}
                        }
                    }
                }
            }, label: {
                !isLoading ?
                AnyView( Text("Upload to Server")) : AnyView(
                    ProgressView().tint(.white)
                )
            })
            .padding([.all], 10)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(pickedFileURL == nil ? Color.gray : Color.black)
            .cornerRadius(10)
            .disabled(pickedFileURL == nil)
            Spacer()
            
            if totalRecords != 0 {
                VStack {
                    HStack {
                        Text("Total Records")
                        Spacer()
                        Text("\(totalRecords)")
                    }
                    Divider()
                    HStack {
                        Text("Uploaded")
                        Spacer()
                        Text("\(uploadedCount)")
                    }
                    Divider()
                    HStack {
                        Text("Already Exist")
                        Spacer()
                        Text("\(alreadyExist)")
                    }
                    Divider()
                    HStack {
                        Text("Failed")
                        Spacer()
                        Text("\(failedCount)")
                    }
                    
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .sheet(isPresented: $openFilePicker) {
            FilePickerView(pickedFileURL: $pickedFileURL)
        }
        
    }
    
  
    
    func uploadProductsToFirestore(productsList: [ProductModel], completion: @escaping () -> Void) {
        isLoading = true
        uploadedCount = 0
        alreadyExist = 0
        failedCount = 0
        
        let db = Firestore.firestore()
        let batch = db.batch()
        
        // Recursive function to process products one by one
        func processProduct(index: Int) {
            guard index < productsList.count else {
                // All products processed, commit the batched write operation
                batch.commit { (error) in
                    if let error = error {
                        print("Error committing batch: \(error.localizedDescription)")
                    } else {
                        print("Batch write successful")
                    }
                    
                    // Update loading state and call completion
                    isLoading = false
                    completion()
                }
                return
            }
            
            let product = productsList[index]
            
            // Check if the product already exists
            db.collection("Products")
                .whereField("productName", isEqualTo: product.productName)
                .whereField("category", isEqualTo: product.category)
                .getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error querying document: \(error.localizedDescription)")
                        failedCount += 1
                    } else if let snapshot = snapshot, !snapshot.isEmpty {
                        // Product already exists
                        print("Product \(product.productName) in category \(product.category) already exists")
                        alreadyExist += 1
                    } else {
                        // Product doesn't exist, add it to the batch
                        let productRef = db.collection("Products").document()
                        batch.setData(product.dictionaryRepresentation(), forDocument: productRef)
                        uploadedCount += 1
                    }
                    
                    // Process next product recursively
                    processProduct(index: index + 1)
            }
        }
        
        // Start processing products
        processProduct(index: 0)
    }

    
    
    
    func readFileContent(from url: URL) -> [ProductModel]? {
        var products = [ProductModel]()
        _ = url.startAccessingSecurityScopedResource()
        do {
            let csv = try CSV<Named>(url: url)
            for item in csv.rows {
                let product = ProductModel.new(item)
                if let product {
                    products.append(product)
                }
            }
            totalRecords = products.count
            return products
        }
        catch {
            print("Error parsing CSV: \(error.localizedDescription)")
            return nil
        }
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UploadCSVScreen()
    }
}
