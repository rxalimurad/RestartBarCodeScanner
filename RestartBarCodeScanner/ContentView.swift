//
//  ContentView.swift
//  RestartBarCodeScanner
//
//  Created by Ali Murad on 02/03/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ScanScreen()
                .tabItem {
                    Image(systemName: "barcode.viewfinder")
                    Text("Scan")
                }
                .tag(0)
            
            UploadCSVScreen()
                .tabItem {
                    Image(systemName: "square.and.arrow.up")
                    Text("Upload new CSV")
                }
                .tag(1)
        }
    }
}

#Preview {
    ContentView()
}
