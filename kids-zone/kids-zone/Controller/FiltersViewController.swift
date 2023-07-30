//
//  FiltersViewController.swift
//  kids-zone
//
//  Created by user on 6.07.2023.
//

import UIKit

class FiltersViewController: UIViewController, Coordinating {
    // MARK: - Properties

    var coordinator: Coordinator?
    var filterOptions: FilterOptions?
    var products: Products?
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    private lazy var closedButton: UIButton = {
        let cButton = UIButton(type: .system)
        cButton.setTitle("Clear All", for: .normal)
        cButton.tintColor = UIColor(named: "normalSortPopupText")
        cButton.titleLabel?.font = .AntonioRegular(size: 14)
        cButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        return cButton
    }()

    private lazy var topDivider: UIView = {
        let topDivider = UIView()

        topDivider.backgroundColor = UIColor(named: "normalSortPopupBackground")

        return topDivider

    }()

    private lazy var divider1: UIView = createDivider()

    private lazy var brandTapView: FilterPopupButton = {
        let tapView = FilterPopupButton(title: "Brand")
        tapView.delegate = self
        return tapView

    }()

    private lazy var colorTapView: FilterPopupButton = {
        let tapView = FilterPopupButton(title: "Color")
        tapView.delegate = self
        return tapView

    }()

    private lazy var sizeTapView: FilterPopupButton = {
        let tapView = FilterPopupButton(title: "Size")
        tapView.delegate = self
        return tapView

    }()

    private lazy var priceTapView: FilterPopupButton = {
        let tapView = FilterPopupButton(title: "Price")
        tapView.delegate = self
        return tapView

    }()

    private let stack = UIStackView()

    private lazy var divider2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "normalSortPopupBackground")
        return view
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "FiltersPageBackground")

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - SetupUI

extension FiltersViewController {
    func setupUI() {
        let closeButton = UIBarButtonItem(customView: closedButton)
        navigationItem.rightBarButtonItem = closeButton

        view.addSubview(topDivider)
        view.addSubview(divider1)
        view.addSubview(stack)
        view.addSubview(divider2)
        view.addSubview(activityIndicator)

        topDivider.activateAutoLayout()
        divider1.activateAutoLayout()
        stack.activateAutoLayout()
        brandTapView.activateAutoLayout()
        colorTapView.activateAutoLayout()
        sizeTapView.activateAutoLayout()
        priceTapView.activateAutoLayout()
        divider2.activateAutoLayout()
        activityIndicator.activateAutoLayout()

        stack.addArrangedSubview(brandTapView)
        stack.addArrangedSubview(colorTapView)
        stack.addArrangedSubview(sizeTapView)
        stack.addArrangedSubview(priceTapView)
        stack.axis = .vertical
        stack.spacing = 10
        stack.backgroundColor = UIColor(named: "FiltersOptionsContainer")

        NSLayoutConstraint.activate([
            topDivider.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            topDivider.heightAnchor.constraint(equalToConstant: 20),
            topDivider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topDivider.trailingAnchor.constraint(equalTo: view.trailingAnchor),

        ])

        NSLayoutConstraint.activate([
            divider1.topAnchor.constraint(equalTo: topDivider.bottomAnchor),
            divider1.heightAnchor.constraint(equalToConstant: 0.75),
            divider1.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            divider1.trailingAnchor.constraint(equalTo: view.trailingAnchor),

        ])

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: divider1.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),

        ])

        NSLayoutConstraint.activate([
            brandTapView.heightAnchor.constraint(equalToConstant: 50),
            colorTapView.heightAnchor.constraint(equalToConstant: 50),
            sizeTapView.heightAnchor.constraint(equalToConstant: 50),
            priceTapView.heightAnchor.constraint(equalToConstant: 50),
        ])

        NSLayoutConstraint.activate([
            divider2.topAnchor.constraint(equalToSystemSpacingBelow: stack.bottomAnchor, multiplier: 2),
            divider2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            divider2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            divider2.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        ])

        // activity Indicator constraint

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

// MARK: - Helpers

extension FiltersViewController {
    func createDivider() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SortFilterDivder")

        return view
    }
}

// MARK: - API

extension FiltersViewController {
    @objc func requestProduct() {
        activityIndicator.startAnimating()
        stack.isHidden = true

        ProductService.sahred.fetchProducts(filterOptions!) {
            products, filterElements in
            self.products?.products = products
            self.products?.filterElements = filterElements

            DispatchQueue.main.async {
                // Stop animating the activity indicator
                self.activityIndicator.stopAnimating()

                // Update the label with the received data

                // Show the label
                self.stack.isHidden = false
            }
        }
    }
}

extension FiltersViewController: FilterPopupButtonDelegate {
    func filterPopupButtonDidTap(_ tapView: FilterPopupButton) {
        presentPopup(tapView.title)
    }
}

extension FiltersViewController: UIViewControllerTransitioningDelegate {
    func presentPopup(_ title: String) {
        guard let products = products else { return }
        guard let filterElements = products.filterElements else { return }

        if title == "Price" {
            let popupViewController = FilterPricePopup()
            popupViewController.maxPrice = filterElements.price["maxPrice"]
            popupViewController.minPrice = filterElements.price["minPrice"]
            popupViewController.filterOptions = filterOptions
            popupViewController.delegate = self
            popupViewController.modalPresentationStyle = .custom
            popupViewController.transitioningDelegate = self

            if let sheetPresentationController = popupViewController.presentationController as? UISheetPresentationController {
                sheetPresentationController.detents = [.large()]
                sheetPresentationController.prefersGrabberVisible = true
            }

            present(popupViewController, animated: true, completion: nil)
        }
        else {
            let filter: [FilterElement] = {
                var filters: [FilterElement] = []
                switch title {
                case "Brand":
                    filters = filterElements.brands
                case "Color":
                    filters = filterElements.colors
                case "Size":
                    filters = filterElements.sizes

                default:
                    filters = []
                }

                return filters
            }()

            let popupViewController = FilterPopup()
            popupViewController.filterElements = filter
            popupViewController.filterOptions = filterOptions
            popupViewController.filterTitle = title
            popupViewController.delegate = self

            popupViewController.modalPresentationStyle = .custom
            popupViewController.transitioningDelegate = self

            if let sheetPresentationController = popupViewController.presentationController as? UISheetPresentationController {
                sheetPresentationController.detents = [.large()]
                sheetPresentationController.prefersGrabberVisible = true
            }

            present(popupViewController, animated: true, completion: nil)
        }
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return UISheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension FiltersViewController {
    @objc func dismissButtonTapped() {
        let filter = ["brand": "", "color": "", "size": "", "priceRange": ""]
        filterOptions?.filterOutput = filter
        requestProduct()
    }
}

extension FiltersViewController: FilterPopupDelegate {
    func filterPopupApplayDidTaped() {
        requestProduct()
    }
}
