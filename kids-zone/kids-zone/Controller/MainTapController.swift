//
//  MainViewController.swift
//  kids-zone
//
//  Created by user on 15.06.2023.
//

import Swinject
import UIKit

class MainTabController: UITabBarController {
    // MARK: - Properties

    let container = Container()
    var filterOptions: FilterOptions?
    var products: Products?
    var authManger: AuthManger?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.backgroundColor = UIColor(named: "tapbarBackground")
        tabBar.tintColor = UIColor(named: "tapbarIcon")
        tabBar.isTranslucent = false

        container.register(FilterOptions.self) { _ in
            FilterOptions()
        }
        container.register(Products.self) { _ in
            Products()
        }
        container.register(AuthManger.self) { _ in
            AuthManger()
        }

        filterOptions = container.resolve(FilterOptions.self)!
        products = container.resolve(Products.self)!
        authManger = container.resolve(AuthManger.self)!

        configureViewControllers()
    }

    // MARK: -  Helpers

    func configureViewControllers() {
        let home = HomeViewController()
        home.filterOptions = filterOptions
        let nav1 = templateNavigationController(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill"),
            rootController: home
        )

        let nav2 = UINavigationController()

        nav2.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(named: "search.icon"),
            selectedImage: UIImage(named: "search.icon")
        )

        let productsCoordinator = ProductsCoordinator()
        productsCoordinator.filterOptions = filterOptions
        productsCoordinator.products = products
        productsCoordinator.authManger = authManger
        productsCoordinator.navigationController = nav2
        productsCoordinator.start()

        let bag = BagViewController()
        let nav3 = templateNavigationController(
            title: "Bag",
            image: UIImage(systemName: "bag"),
            selectedImage: UIImage(systemName: "bag.fill"),
            rootController: bag
        )

        let savedItem = SavedItemViewController()
        let nav4 = templateNavigationController(
            title: "Saved Items",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill"),
            rootController: savedItem
        )

        let account = AccountViewController()
        let nav5 = templateNavigationController(
            title: "My Account",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill"),
            rootController: account
        )

        viewControllers = [nav1, nav2, nav3, nav4, nav5]
    }

    func templateNavigationController(title: String, image: UIImage?, selectedImage: UIImage?, rootController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootController)

        nav.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)

        return nav
    }
}
