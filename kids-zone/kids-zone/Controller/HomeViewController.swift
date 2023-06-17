//
//  HomeViewController.swift
//  kids-zone
//
//  Created by user on 15.06.2023.
//

import UIKit

class HomeViewController: UIViewController {
    lazy var logo: UIImageView = {
        let imageView = UIImageView()

        imageView.image = UIImage(named: "logoLight")

        return imageView

    }()

    let genderSelector = GenderSelector()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
}

extension HomeViewController {
    func layout() {
        view.backgroundColor = .systemBackground

        view.addSubview(logo)
        view.addSubview(genderSelector)

        logo.activateAutoLayout()

        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 10)
        ])

        genderSelector.activateAutoLayout()

        NSLayoutConstraint.activate([
            genderSelector.topAnchor.constraint(equalToSystemSpacingBelow: logo.bottomAnchor, multiplier: 2.5),
            genderSelector.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: genderSelector.trailingAnchor, multiplier: 2),
            genderSelector.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
