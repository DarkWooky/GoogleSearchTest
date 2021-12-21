//
//  UIView + Extension.swift
//  GoogleSearch
//
//  Created by Egor Mikhalevich on 17.12.21.
//

import Foundation
import UIKit

extension UIView {
    convenience init(_ configurator: (UIView) -> Void) {
        self.init()
        configurator(self)
    }

    func placeInCenter(of view: UIView) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func embedIn(_ view: UIView, inset: CGFloat = 0) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: inset).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset).isActive = true
    }

    func embedIn(_ view: UIView, hInset: CGFloat = 0, vInset: CGFloat = 0) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: hInset).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -hInset).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: vInset).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -vInset).isActive = true
    }

    func embedIn(_ view: UIView, top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: left).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -right).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottom).isActive = true
    }

    func height(_ height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    func width(_ width: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
}
