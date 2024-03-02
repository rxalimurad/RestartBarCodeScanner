//
//  UploadCSVScreen.swift
//  RestartBarCodeScanner
//
//  Created by Ali Murad on 02/03/2024.
//
import SwiftUI
import UIKit
import SwiftCSV

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
            readFileContent(from: url)
        }
        
        func readFileContent(from url: URL) {
            
            do {
                let csv = try CSV<Named>(url: url)
                print(csv)
                //                    persons = try csv.namedRows.map { row in
                //                        return Person(name: row["Name"] ?? "", age: Int(row["Age"] ?? "") ?? 0, email: row["Email"] ?? "")
            }
            //                    print("Parsed Persons: \(persons)")
            catch {
                print("Error parsing CSV: \(error.localizedDescription)")
            }
            
            
            
        }
    }
}

struct UploadCSVScreen: View {
    @State private var pickedFileURL: URL?
    @State private var openFilePicker = false
    
    var body: some View {
        VStack {
            if let fileURL = pickedFileURL {
                Text("Selected File: \(fileURL.lastPathComponent)")
            } else {
                Text("No file selected")
            }
            Button("Select File") {
                openFilePicker.toggle()
                pickedFileURL = nil // Reset picked file URL
            }
            .sheet(isPresented: $openFilePicker) {
                FilePickerView(pickedFileURL: $pickedFileURL)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UploadCSVScreen()
    }
}
