//
//  MainViewController.swift
//  kids-zone
//
//  Created by user on 15.06.2023.
//

import UIKit

class MainTabController: UITabBarController {
    // MARK: - Properties

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.backgroundColor = UIColor.systemBackground
        tabBar.tintColor = UIColor(named: "tapbarIcon")
        tabBar.isTranslucent = false
        // view.backgroundColor = .systemRed

        configureViewControllers()
    }

    // MARK: - API

    // MARK: - Selectors

    // MARK: -  Helpers

    func configureViewControllers() {
        let home = HomeViewController()
        let nav1 = templateNavigationController(title: "Home", image: UIImage(systemName: "house"),
                                                selectedImage: UIImage(systemName: "house.fill"),
                                                rootController: home)

        let products = ProductsViewController()
        let nav2 = templateNavigationController(title: "Search", image: UIImage(named: "search.icon"),
                                                selectedImage: UIImage(named: "search.icon"),
                                                rootController: products)

        let bag = BagViewController()
        let nav3 = templateNavigationController(title: "Bag", image: UIImage(systemName: "bag"),
                                                selectedImage: UIImage(systemName: "bag.fill"),
                                                rootController: bag)

        let savedItem = SavedItemViewController()
        let nav4 = templateNavigationController(title: "Saved Items", image: UIImage(systemName: "heart"),
                                                selectedImage: UIImage(systemName: "heart.fill"),
                                                rootController: savedItem)

        let account = AccountViewController()
        let nav5 = templateNavigationController(title: "My Account", image: UIImage(systemName: "person"),
                                                selectedImage: UIImage(systemName: "person.fill"),
                                                rootController: account)

        viewControllers = [nav1, nav2, nav3, nav4, nav5]
    }

    func templateNavigationController(title: String, image: UIImage?, selectedImage: UIImage?, rootController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootController)

        nav.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)

        return nav
    }
}
