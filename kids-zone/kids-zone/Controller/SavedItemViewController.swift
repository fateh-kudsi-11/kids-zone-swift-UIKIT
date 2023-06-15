//
//  SavedItemViewController.swift
//  kids-zone
//
//  Created by user on 15.06.2023.
//

import UIKit

class SavedItemViewController: UIViewController {
    let stackView = UIStackView()
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

extension SavedItemViewController {
    func style() {
        view.backgroundColor = .systemBackground
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Saved Item"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
    }

    func layout() {
        stackView.addArrangedSubview(label)
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
