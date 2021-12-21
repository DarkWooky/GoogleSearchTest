//
//  MainViewModel.swift
//  GoogleSearch
//
//  Created by Egor Mikhalevich on 20.12.21.
//

import Foundation

class SearchService {
    var results: [Item]?
    var isActive: Bool = false

    private let network = NetworkManager.shared

    weak var delegate: MainDelegate?

    func getResults(with request: String) {
        delegate?.showProgress()
        network.fetchSearchData(with: request) { result in
            switch result {
            case .success(let data):
                self.results = data.items
                self.delegate?.hideProgress()
                self.delegate?.fetchFinished()
            case .failure(let error):
                self.delegate?.showError(text: error.localizedDescription)
                self.delegate?.hideProgress()
                self.delegate?.fetchFinished()
            }
        } progress: { progress in
            self.delegate?.didChangeProgress(progress: progress)
        }
    }
}
