//
//  ProductsViewController.swift
//  kids-zone
//
//  Created by user on 15.06.2023.
//

import Foundation
import UIKit

class ProductsViewController: UIViewController {
    let stackView = UIStackView()
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

extension ProductsViewController {
    func style() {
        view.backgroundColor = .systemBackground
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ProductsViewController"
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
