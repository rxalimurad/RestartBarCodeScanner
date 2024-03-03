//
//  FilePickerView.swift
//  RestartBarCodeScanner
//
//  Created by Ali Murad on 03/03/2024.
//

import SwiftUI
import UIKit

struct FilePickerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIDocumentPickerViewController
    
    @Binding var pickedFileURL: URL?
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .open)
        controller.allowsMultipleSelection = false
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(pickedFileURL: $pickedFileURL)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        @Binding var pickedFileURL: URL?
        
        init(pickedFileURL: Binding<URL?>) {
            _pickedFileURL = pickedFileURL
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            pickedFileURL = url
            if pickedFileURL?.pathExtension != "csv" {
                pickedFileURL = nil
                
            }
            
        }
        
        
    }
}
