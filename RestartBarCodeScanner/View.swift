//
//  View.swift
//  RestartBarCodeScanner
//
//  Created by Ali Murad on 02/03/2024.
//

import SwiftUI
extension View {
    func onSubmit(perform action: @escaping () -> Void) -> some View {
        return self.onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardDidHideNotification)) { _ in
            action()
        }
    }
}
