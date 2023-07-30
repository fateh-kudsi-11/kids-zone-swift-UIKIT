//
//  FilterPricePopup.swift
//  kids-zone
//
//  Created by user on 13.07.2023.
//

import MultiSlider
import UIKit

class FilterPricePopup: UIViewController {
    var maxPrice: Int!
    var minPrice: Int!
    var min: Int = 0
    var max: Int = 0

    weak var delegate: FilterPopupDelegate?
    var filterOptions: FilterOptions?

    private lazy var pageTitle: UILabel = {
        let label = UILabel()
        label.font = .AntonioRegular(size: 18)
        label.text = "Price"
        return label
    }()

    private lazy var closedButton: UIButton = {
        let cButton = UIButton(type: .system)
        cButton.setTitle("Clear", for: .normal)
        cButton.backgroundColor = UIColor(named: "CloseBackground")
        cButton.tintColor = UIColor(named: "normalSortPopupText")
        cButton.titleLabel?.font = .AntonioRegular(size: 14)
        cButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        return cButton
    }()

    private lazy var slider: MultiSlider = {
        let slider = MultiSlider()
        slider.orientation = .horizontal // default is .vertical
        slider.isVertical = false // same effect, but accessible from Interface Builder

        slider.minimumValue = CGFloat(minPrice)
        slider.maximumValue = CGFloat(maxPrice)

        slider.value = [CGFloat(minPrice), CGFloat(maxPrice)]

        // Set the thumb and track color
        slider.thumbTintColor = UIColor(named: "activeSortPopupBackground")
        slider.tintColor = UIColor(named: "activeSortPopupBackground")
        slider.trackWidth = 3

        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()

    private lazy var minPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .AntonioRegular(size: 16)

        return label
    }()

    private lazy var maxPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .AntonioRegular(size: 16)
        return label
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "FilterPopupBackground")
        setupUI()
    }
}

// MARK: - SetupUI

extension FilterPricePopup {
    func setupUI() {
        view.addSubview(pageTitle)
        view.addSubview(closedButton)
        view.addSubview(slider)
        view.addSubview(minPriceLabel)
        view.addSubview(maxPriceLabel)
        view.addSubview(applyButton)

        pageTitle.activateAutoLayout()
        closedButton.activateAutoLayout()
        slider.activateAutoLayout()
        minPriceLabel.activateAutoLayout()
        maxPriceLabel.activateAutoLayout()
        applyButton.activateAutoLayout()

        minPriceLabel.text = String(minPrice / 1000)
        maxPriceLabel.text = String(maxPrice / 1000)

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

        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalToSystemSpacingBelow: pageTitle.bottomAnchor, multiplier: 4),
            slider.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: slider.trailingAnchor, multiplier: 2),
        ])
        NSLayoutConstraint.activate([
            minPriceLabel.topAnchor.constraint(equalToSystemSpacingBelow: slider.bottomAnchor, multiplier: 2),
            minPriceLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
        ])

        NSLayoutConstraint.activate([
            maxPriceLabel.topAnchor.constraint(equalToSystemSpacingBelow: slider.bottomAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: maxPriceLabel.trailingAnchor, multiplier: 2),
        ])

        NSLayoutConstraint.activate([
            applyButton.topAnchor.constraint(equalToSystemSpacingBelow: maxPriceLabel.bottomAnchor, multiplier: 2),
            applyButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: applyButton.trailingAnchor, multiplier: 2), applyButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

// MARK: - Selector

extension FilterPricePopup {
    @objc func dismissButtonTapped() {
        filterOptions?.filterOutput["priceRange"] = ""
        dismiss(animated: true) {
            self.delegate?.filterPopupApplayDidTaped()
        }
    }

    @objc func sliderValueChanged(_ slider: MultiSlider) {
        if slider.draggedThumbIndex == 0 {
            min = Int(slider.value[0] / 1000)
            minPriceLabel.text = String(min)
        } else if slider.draggedThumbIndex == 1 {
            max = Int(slider.value[1] / 1000)
            maxPriceLabel.text = String(max)
        }
    }

    @objc func applyFilter() {
        let minValue = String(min != 0 ? min : minPrice / 1000)
        let maxValue = String(max != 0 ? max : maxPrice / 1000)

        let value = "\(minValue),\(maxValue)"

        filterOptions?.filterOutput["priceRange"] = value
        dismiss(animated: true) {
            self.delegate?.filterPopupApplayDidTaped()
        }
    }
}
