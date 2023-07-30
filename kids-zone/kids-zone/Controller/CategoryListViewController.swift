

import Foundation
import UIKit

class CategoryListViewController: UIViewController, Coordinating {
    // MARK: - Properties

    var filterOptions: FilterOptions?
    var coordinator: Coordinator?
    var categorys: [Category]?

    var collectionView: UICollectionView!

    private lazy var logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logoLight")
        return imageView
    }()

    private lazy var spacerView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 20)
        return v
    }()

//

    private var genderSelector: GenderSelector!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        updateUI()
        tabBarController?.tabBar.isHidden = false
        super.viewWillAppear(animated)
    }
}

// MARK: - Setup UI & UpdateUI

extension CategoryListViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground

        // Logo
        logo.activateAutoLayout()
        view.addSubview(logo)
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 10)
        ])

        guard let filterOptions = filterOptions else { return }

        genderSelector = GenderSelector(filterOptions)
        genderSelector.delegate = self
        genderSelector.activateAutoLayout()
        view.addSubview(genderSelector)
        NSLayoutConstraint.activate([
            genderSelector.topAnchor.constraint(equalToSystemSpacingBelow: logo.bottomAnchor, multiplier: 2.5),
            genderSelector.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: genderSelector.trailingAnchor, multiplier: 2),
            genderSelector.heightAnchor.constraint(equalToConstant: 48)
        ])

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.bounds.width - 30, height: 100)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        let bottomInset = spacerView.bounds.height
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)

        view.addSubview(collectionView)
        collectionView.activateAutoLayout()

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: genderSelector.bottomAnchor, multiplier: 3),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        updateUI()
    }

    private func updateUI() {
        guard let filterOptions = filterOptions else { return }
        // Update the genderSelector
        genderSelector.update(with: filterOptions)

        if filterOptions.gender == .boys {
            categorys = CategorySelect.boysCategory
        } else {
            categorys = CategorySelect.girlsCategory
        }
        collectionView.reloadData()

        // Refresh the layout if needed
        view.setNeedsLayout()
    }
}

// MARK: - GenderSelectorDelegate

extension CategoryListViewController: GenderSelectorDelegate {
    func genderSelectorDidChange() {
        guard let filterOptions = filterOptions else { return }
        filterOptions.gender = filterOptions.gender == .boys ? .girls : .boys
        updateUI()
    }
}

// MARK: - UICollectionViewDataSource

extension CategoryListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categorys?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as! CategoryCell

        let category = categorys?[indexPath.item]
        cell.configure(with: category)

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CategoryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let directory = categorys?[indexPath.item].title.lowercased()
        filterOptions?.directory = directory ?? ""
        coordinator?.navigate(to: "products")
    }
}
