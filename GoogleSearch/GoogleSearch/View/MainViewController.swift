//
//  ViewController.swift
//  GoogleSearch
//
//  Created by Egor Mikhalevich on 17.12.21.
//

import UIKit

class MainViewController: UIViewController {
    private let stackView = UIStackView(axis: .vertical)

    private let searchBar = UISearchBar()
    private let searchButton = UIButton(title: "Google Search")
    private let progressIndicator = UIProgressView()

    private let resultList = UITableView()

    private let network = NetworkManager.shared
    private let searchService = SearchService()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

}

private extension MainViewController {
    @objc func searchButtonTapped() {
        updateButton()
    }

    func showProgressIndicator() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.progressIndicator.alpha = 1
            self?.progressIndicator.isHidden.toggle()
        }
    }

    func hideProgressIndicator() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.progressIndicator.alpha = 0
            self?.progressIndicator.isHidden.toggle()
        }
    }

    func updateButton() {
        guard let text = searchBar.text, !text.isEmpty else { return }
        if searchService.isActive {
            searchService.isActive = false
            network.cancelTask()
            searchButton.backgroundColor = .red
            searchButton.setTitle(Text.search, for: .normal)
            searchService.results?.removeAll()
            resultList.reloadData()
        } else {
            searchService.isActive = true
            searchButton.backgroundColor = .systemBlue
            searchButton.setTitle(Text.stop, for: .normal)
            searchService.getResults(with: text)
            resultList.reloadData()
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let results = searchService.results else { return 0}
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let results = searchService.results else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseId, for: indexPath) as! Cell
        cell.configure(with: results[indexPath.row])
        return cell
    }
}

extension MainViewController: MainDelegate {
    func didChangeProgress(progress: Progress) {
        progressIndicator.observedProgress = progress
    }

    func showProgress() {
        showProgressIndicator()
    }

    func hideProgress() {
        hideProgressIndicator()
        resultList.reloadData()
    }

    func showError(text: String) {

    }

    func fetchFinished() {
        searchService.isActive = false
        searchButton.backgroundColor = .systemBlue
        searchButton.setTitle(Text.search, for: .normal)
    }


}

//MARK: - Configure
private extension MainViewController {
    func configure() {
        setView()
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        searchBar.delegate = self
        resultList.register(Cell.self, forCellReuseIdentifier: Cell.reuseId)
        resultList.dataSource = self
        searchService.delegate = self
    }

    func setView() {
        view.backgroundColor = .white
        progressIndicator.alpha = 0
        progressIndicator.setProgress(0, animated: true)
        // - SearchBar
        searchBar.searchBarStyle = .minimal
        searchBar.showsBookmarkButton = false
        let micImage = UIImage(systemName: "mic.fill")
        searchBar.setImage(micImage, for: .bookmark, state: .normal)

        // - StackView
        stackView.embedIn(view, top: 40, left: 10, right: 10)
        stackView.addArrangedSubviews(
            progressIndicator,
            searchBar,
            searchButton,
            resultList
        )
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateButton()
        searchBar.endEditing(true)
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        // Do work here
    }
}

private extension MainViewController {
    enum Text {
        static let textIsEmpty = "Print search request"
        static let placeholder = "Listening..."
        static let search = "Google Search"
        static let stop = "Stop"
    }
}

// MARK: - SwiftUI
import SwiftUI

struct VCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {

        let mvc = MainViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<VCProvider.ContainerView>) -> UIViewController {
            return mvc
        }

        func updateUIViewController(_ uiViewController: VCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<VCProvider.ContainerView>) {

        }
    }
}

