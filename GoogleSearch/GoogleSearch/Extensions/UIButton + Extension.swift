//
//  UIButton + Extension.swift
//  GoogleSearch
//
//  Created by Egor Mikhalevich on 20.12.21.
//

import UIKit

extension UIButton {
    convenience init(title: String)
    {
        self.init(type: .system)

        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont(name: "System", size: 20)
        self.backgroundColor = .systemBlue
        self.layer.cornerRadius = 10
        self.isEnabled = true
        self.height(40)
    }
}
