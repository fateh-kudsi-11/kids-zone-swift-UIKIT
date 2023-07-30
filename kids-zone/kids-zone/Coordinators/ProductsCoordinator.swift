////
////  ProductsCoordinator.swift
////  kids-zone
////
////  Created by user on 27.06.2023.

import UIKit

class ProductsCoordinator: Coordinator {
    var navigationController: UINavigationController?
    var filterOptions: FilterOptions?
    var products: Products?
    var authManger: AuthManger?

    func navigate(to type: String) {
        switch type {
        case "products":
            let vc = ProductsViewController()
            vc.coordinator = self
            vc.filterOptions = filterOptions
            vc.products = products
            vc.authManger = authManger
            vc.navigationItem.titleView = setupPageTitle(filterOptions?.directory.capitalized ?? "")

            // Create a custom back button with an empty title and custom image
            let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backButtonTapped))
            let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 18)
            backButton.image = UIImage(systemName: "chevron.left", withConfiguration: symbolConfiguration)
            backButton.tintColor = UIColor(named: "backButtonColor")

            // Set the custom back button as the leftBarButtonItem of the navigationItem
            vc.navigationItem.leftBarButtonItem = backButton

            // Hide the default back button label
            navigationController?.navigationBar.topItem?.title = ""

            navigationController?.pushViewController(vc, animated: true)

        case "product":
            var vc: UIViewController & Coordinating = ProductViewController()
            vc.coordinator = self
            navigationController?.pushViewController(vc, animated: true)

        case "filters":
            let vc = FiltersViewController()
            vc.coordinator = self
            vc.filterOptions = filterOptions
            vc.products = products

            vc.navigationItem.titleView = setupPageTitle("Filters")

            // Create a custom back button with an empty title and custom image
            let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backButtonTapped))
            let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 18)
            backButton.image = UIImage(systemName: "chevron.left", withConfiguration: symbolConfiguration)
            backButton.tintColor = UIColor(named: "backButtonColor")

            // Set the custom back button as the leftBarButtonItem of the navigationItem
            vc.navigationItem.leftBarButtonItem = backButton

            // Hide the default back button label
            navigationController?.navigationBar.topItem?.title = ""
            navigationController?.pushViewController(vc, animated: true)

        default:
            break
        }
    }

    func start() {
        let vc = CategoryListViewController()
        vc.coordinator = self
        vc.filterOptions = filterOptions
        navigationController?.setViewControllers([vc], animated: false)
    }

    func presentAuth() {
        let vc = AuthViewController()
        vc.coordinator = self
        vc.authManger = authManger
        navigationController?.setViewControllers([vc], animated: true)
    }

    func hideAuth() {
        let vc = CategoryListViewController()
        vc.coordinator = self
        vc.filterOptions = filterOptions
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    

    func setupPageTitle(_ title: String) -> UILabel {
        let label = UILabel()
        let letterSpacing: CGFloat = 1.0

        label.font = .AntonioLight(size: 18)

        let attributedString = NSMutableAttributedString(string: title)

        attributedString.addAttribute(.kern, value: letterSpacing, range: NSRange(location: 0, length: attributedString.length))

        label.attributedText = attributedString

        return label
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
