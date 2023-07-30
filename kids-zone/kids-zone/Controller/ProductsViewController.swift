//
//  ProductsViewController.swift
//  kids-zone
//
//  Created by user on 27.06.2023.
//

import UIKit

class ProductsViewController: UIViewController, Coordinating {
    // MARK: - Properties

    var coordinator: Coordinator?
    var filterOptions: FilterOptions?
    var products: Products?
    var authManger: AuthManger?
    var popupViewController: SortPopup!

    var collectionView: UICollectionView!

    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    private let sortFilter = SortFilter()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .InterLight300(size: 16)
        label.backgroundColor = UIColor(named: "backgroundPage")

        return label

    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "tapbarBackground")

        setupUI()
        makeRequest()
    }

    override func viewWillAppear(_ animated: Bool) {
        updateUI()

        super.viewWillAppear(animated)
    }
}

extension ProductsViewController {
    func setupUI() {
        view.addSubview(activityIndicator)
        view.addSubview(sortFilter)
        view.addSubview(label)

        sortFilter.delgate = self

        // Disable autoresizing masks
        activityIndicator.activateAutoLayout()
        sortFilter.activateAutoLayout()
        label.activateAutoLayout()

        // activity Indicator constraint

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        // Label constraint

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalToSystemSpacingBelow: sortFilter.bottomAnchor, multiplier: 0.1),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 47)
        ])

        // sortFilter constraint

        NSLayoutConstraint.activate([
            sortFilter.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            sortFilter.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sortFilter.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sortFilter.heightAnchor.constraint(equalToConstant: 47)
        ])

        // collectionView constraint
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        let availableWidth = UIScreen.main.bounds.width - layout.sectionInset.left - layout.sectionInset.right - layout.minimumInteritemSpacing
        let itemWidth = availableWidth / 2
        layout.itemSize = CGSize(width: itemWidth, height: 280)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.activateAutoLayout()
        collectionView.backgroundColor = UIColor(named: "backgroundPage")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseIdentifier)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: label.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func updateUI() {
        collectionView.reloadData()
    }

    func makeRequest() {
        // Show the activity indicator and hide the label
        activityIndicator.startAnimating()
        label.isHidden = true
        sortFilter.isHidden = true
        collectionView.isHidden = true

        // Perform your network request using URLSession or a networking library like Alamofire
        // Upon receiving the response, update the label with the received data

        ProductService.sahred.fetchProducts(filterOptions!) {
            products, filterElements in
            self.products?.products = products
            self.products?.filterElements = filterElements

            DispatchQueue.main.async {
                // Stop animating the activity indicator
                self.activityIndicator.stopAnimating()

                // Update the label with the received data
                self.label.text = "(\(self.products?.products.count ?? 0) items)"

                // Show the label
                self.label.isHidden = false
                self.sortFilter.isHidden = false
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.products.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.reuseIdentifier, for: indexPath) as! ProductCell

        guard let product = products?.products[indexPath.item] else { return cell }
        cell.configure(with: product)

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let authManger = authManger else { return }

        guard !authManger.isAuht else { return }
        coordinator?.presentAuth()
    }
}

extension ProductsViewController: SortFilterDelgate {
    func sortButtonTapped() {
        showPopup()
    }

    func filterButtonTapped() {
        coordinator?.navigate(to: "filters")
    }
}

extension ProductsViewController: UIViewControllerTransitioningDelegate {
    func showPopup() {
        popupViewController = SortPopup(filterOptions!)
        popupViewController.modalPresentationStyle = .custom
        popupViewController.transitioningDelegate = self
        popupViewController.delegate = self

        present(popupViewController, animated: true, completion: nil)
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SortPopupPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension ProductsViewController: SortPopupDelegate {
    func sortDidChnged(sort: Sort) {
        filterOptions?.sort = sort
        popupViewController.updateUI(with: filterOptions!)
        makeRequest()
    }
}
