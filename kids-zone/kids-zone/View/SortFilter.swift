//
//  SortFilter.swift
//  kids-zone
//
//  Created by user on 4.07.2023.
//

import UIKit

protocol SortFilterDelgate: AnyObject {
    func sortButtonTapped()
    func filterButtonTapped()
}

class SortFilter: UIView {
    // MARK: - Properties

    private let topDivider = createDivider()

    weak var delgate: SortFilterDelgate?

    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SORT", for: .normal)
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = .AntonioRegular(size: 18)
        button.setTitleColor(UIColor(named: "sortFilterrButton"), for: .normal)

        return button
    }()

    private let middleDivider = createDivider()

    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("FILTER", for: .normal)
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = .AntonioRegular(size: 18)
        button.setTitleColor(UIColor(named: "sortFilterrButton"), for: .normal)

        return button
    }()

    private let bottomDivider = createDivider()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetupUI

extension SortFilter {
    func setupUI() {
        addSubview(topDivider)
        addSubview(sortButton)
        addSubview(middleDivider)
        addSubview(filterButton)
        addSubview(bottomDivider)

        // Disable autoresizing masks
        topDivider.activateAutoLayout()
        sortButton.activateAutoLayout()
        middleDivider.activateAutoLayout()
        filterButton.activateAutoLayout()
        bottomDivider.activateAutoLayout()

        // top divider  constraint
        NSLayoutConstraint.activate([
            topDivider.topAnchor.constraint(equalTo: topAnchor),
            topDivider.heightAnchor.constraint(equalToConstant: 0.5),
            topDivider.leadingAnchor.constraint(equalTo: leadingAnchor),
            topDivider.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        // Sort button constraint
        NSLayoutConstraint.activate([
            sortButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            sortButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            sortButton.topAnchor.constraint(equalTo: topAnchor),
            sortButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // middle divider  constraint
        NSLayoutConstraint.activate([
            middleDivider.centerXAnchor.constraint(equalTo: centerXAnchor),
            middleDivider.centerYAnchor.constraint(equalTo: centerYAnchor),
            middleDivider.heightAnchor.constraint(equalToConstant: 20),
            middleDivider.widthAnchor.constraint(equalToConstant: 1)
        ])

        // Sort button constraint
        NSLayoutConstraint.activate([
            filterButton.leadingAnchor.constraint(equalTo: sortButton.trailingAnchor),
            filterButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            filterButton.topAnchor.constraint(equalTo: topAnchor),
            filterButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // bottom divider  constraint
        NSLayoutConstraint.activate([
            bottomDivider.topAnchor.constraint(equalTo: bottomAnchor),
            bottomDivider.heightAnchor.constraint(equalToConstant: 0.5),
            bottomDivider.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomDivider.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - Helpers

func createDivider() -> UIView {
    let view = UIView()
    view.backgroundColor = UIColor(named: "SortFilterDivder")

    return view
}

// MARK: - Selectors

extension SortFilter {
    @objc func sortButtonTapped() {
        delgate?.sortButtonTapped()
    }

    @objc func filterButtonTapped() {
        delgate?.filterButtonTapped()
    }
}
