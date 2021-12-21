//
//  Cell.swift
//  GoogleSearch
//
//  Created by Egor Mikhalevich on 20.12.21.
//

import UIKit

class Cell: UITableViewCell {
    static let reuseId: String = "Cell"

    let titleLabel = UILabel()
    let linkLabel = UILabel()
    let snippetLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with data: Item) {
        titleLabel.text = data.title
        linkLabel.text = data.displayLink
        snippetLabel.text = data.snippet
    }

    func setupCell() {
        let stack = UIStackView(axis: .vertical)
        stack.embedIn(contentView)
        stack.addArrangedSubviews(
            linkLabel,
            titleLabel,
            snippetLabel
        )
        stack.spacing = 5
        titleLabel.font = .systemFont(ofSize: 20)
        linkLabel.textColor = .link
        snippetLabel.numberOfLines = 3
    }
}
