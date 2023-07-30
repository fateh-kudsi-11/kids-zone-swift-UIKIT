//
//  ProductViewController.swift
//  kids-zone
//
//  Created by user on 27.06.2023.
//

import UIKit

class ProductViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?

    let stackView = UIStackView()
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

extension ProductViewController {
    func style() {
        view.backgroundColor = .systemBackground
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ProductViewController"
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
