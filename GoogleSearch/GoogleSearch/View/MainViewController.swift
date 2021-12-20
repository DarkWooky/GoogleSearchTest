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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }


}

//MARK: - Configure
private extension MainViewController {
    func configure() {
        setView()
        searchBar.delegate = self
    }
    
    func setView() {
        // - ProgressIndicator
        progressIndicator.isHidden.toggle()
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
        view.backgroundColor = .red
        searchBar.endEditing(true)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        // Do work here
    }
}



