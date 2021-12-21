//
//  UIStackView + Extension.swift
//  GoogleSearch
//
//  Created by Egor Mikhalevich on 20.12.21.
//

import UIKit

extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis, _ configurator: @escaping (UIStackView) -> Void = { _ in }) {
        self.init()
        self.axis = axis
        configurator(self)
    }

    func addArrangedSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            addArrangedSubview(subview)
        }
    }
}
