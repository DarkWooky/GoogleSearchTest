//
//  MainDelegate.swift
//  GoogleSearch
//
//  Created by Egor Mikhalevich on 20.12.21.
//

import UIKit

protocol MainDelegate: AnyObject {
    func fetchFinished()
    func didChangeProgress(progress: Progress)
    func showProgress()
    func hideProgress()
    func showError(text: String)
    func scrollViewDidScroll(y: CGFloat)
}
