//
//  AlertManager.swift
//  RestartBarCodeScanner
//
//  Created by Ali Murad on 03/03/2024.
//

import SwiftUI

class AlertManager: ObservableObject {
    @Published var showAlert = false
    var alertTitle = ""
    var alertMessage = ""
    
    func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    func hideAlert() {
        showAlert = false
    }
}
