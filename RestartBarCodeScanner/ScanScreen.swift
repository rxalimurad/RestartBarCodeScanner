//
//  ScanScreen.swift
//  RestartBarCodeScanner
//
//  Created by Ali Murad on 02/03/2024.
//

import SwiftUI


struct ScanScreen: View {
    @State private var searchText = ""
    @State private var isFiltering = false
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                
                Toggle(isOn: $isFiltering) {
                    Text("Don't show already\nscanned products")
                }
                .padding(.horizontal)
                
                List {
                    ForEach(filteredItems, id: \.self) { item in
                        Text(item)
                    }
                }
                .navigationTitle("Scan Barcodes")
            }
        }
    }
    
    private var filteredItems: [String] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.contains(searchText) }
        }
    }
    
    private let items = ["Apple", "Banana", "Orange", "Grapes", "Pineapple", "Watermelon"]
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
