//
//  UIViewController + Extension.swift
//  GoogleSearch
//
//  Created by Egor Mikhalevich on 19.12.21.
//

import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Connection error:", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
