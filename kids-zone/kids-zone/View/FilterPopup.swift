//
//  FilterPopup.swift
//  kids-zone
//
//  Created by user on 8.07.2023.
//

import UIKit

protocol FilterPopupDelegate: AnyObject {
    func filterPopupApplayDidTaped()
}

class FilterPopup: UIViewController {
    // MARK: - Properties

    var filterElements: [FilterElement] = []
    var filterOptions: FilterOptions?
    var filterTitle: String = ""
    var collectionView: UICollectionView!
    var selectedItem: [String] = []
    weak var delegate: FilterPopupDelegate?

    private lazy var pageTitle: UILabel = {
        let label = UILabel()
        label.font = .AntonioRegular(size: 18)
        return label
    }()

    private lazy var closedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear", for: .normal)
        button.backgroundColor = UIColor(named: "CloseBackground")
        button.tintColor = UIColor(named: "normalSortPopupText")
        button.titleLabel?.font = .AntonioRegular(size: 14)
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var spacerView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 20)
        return v
    }()

    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View Items", for: .normal)
        button.backgroundColor = UIColor(named: "filterButton")
        button.titleLabel?.font = .AntonioRegular(size: 18)
        button.tintColor = UIColor(named: "activeSortPopupText")
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(applyFilter), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "FilterPopupBackground")
        setupUI()
    }
}

// MARK: - SetupUI

extension FilterPopup {
    func setupUI() {
        view.addSubview(pageTitle)
        view.addSubview(closedButton)
        view.addSubview(applyButton)

        pageTitle.text = filterTitle

        pageTitle.activateAutoLayout()
        closedButton.activateAutoLayout()
        applyButton.activateAutoLayout()

        NSLayoutConstraint.activate([
            pageTitle.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 4),
            pageTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        NSLayoutConstraint.activate([
            closedButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 4),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: closedButton.trailingAnchor, multiplier: 1),
            closedButton.heightAnchor.constraint(equalToConstant: 35),
            closedButton.widthAnchor.constraint(equalToConstant: 70),
        ])

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.bounds.width - 50, height: 50)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FilterPopupCell.self, forCellWithReuseIdentifier: FilterPopupCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        let bottomInset = spacerView.bounds.height
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)

        view.addSubview(collectionView)
        collectionView.activateAutoLayout()

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: pageTitle.bottomAnchor, multiplier: 3),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: applyButton.topAnchor),
        ])

        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: applyButton.bottomAnchor, multiplier: 2),
            applyButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: applyButton.trailingAnchor, multiplier: 2),
            applyButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

// MARK: - Selector

extension FilterPopup {
    @objc func dismissButtonTapped() {
        filterOptions?.filterOutput[filterTitle.lowercased()] = ""
        dismiss(animated: true) {
            self.delegate?.filterPopupApplayDidTaped()
        }
    }

    @objc func applyFilter() {
        let value = selectedItem.joined(separator: ",")
        filterOptions?.filterOutput[filterTitle.lowercased()] = value

        dismiss(animated: true) {
            self.delegate?.filterPopupApplayDidTaped()
        }
    }
}

// MARK: - Helpers

extension FilterPopup {
    func onSelect(_ item: String) -> Bool {
        if let index = selectedItem.firstIndex(of: item) {
            selectedItem.remove(at: index)
            return false
        } else {
            selectedItem.append(item)
            return true
        }
    }
}

// MARK: - UICollectionViewDataSource

extension FilterPopup: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterElements.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterPopupCell.reuseIdentifier, for: indexPath) as! FilterPopupCell
        let cellData = filterElements[indexPath.item]
        guard let filterOut = filterOptions?.filterOutput[filterTitle.lowercased()] else { return cell }

        let separatedFilterOut = filterOut.components(separatedBy: ",")

        let selected: Bool = {
            if separatedFilterOut.contains(cellData.title) {
                return true
            } else {
                return false
            }
        }()

        cell.configure(with: cellData, selected: selected)

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension FilterPopup: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let isSelected = onSelect(filterElements[indexPath.row].title)
        if let cell = collectionView.cellForItem(at: indexPath) as? FilterPopupCell {
            cell.updateUI(isSelected)
        }
    }
}
