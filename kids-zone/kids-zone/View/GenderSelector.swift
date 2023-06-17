//
//  GenderSelector.swift
//  kids-zone
//
//  Created by user on 16.06.2023.
//

import UIKit

class GenderSelector: UIView {
    // MARK: - Properties

    private var lineViewCenterXConstraint: NSLayoutConstraint!

    private lazy var boysButton: UIButton = {
        let button = UIButton(type: .system)
        let dynamicFont = UIFont.preferredFont(forTextStyle: .body)

        button.setTitle("BOYS", for: .normal)
        button.setTitleColor(UIColor(named: "genderSelectorButton"), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.titleLabel?.font = .AntonioRegular(size: dynamicFont.pointSize)

        return button
    }()

    private lazy var girlsButton: UIButton = {
        let button = UIButton(type: .system)
        let dynamicFont = UIFont.preferredFont(forTextStyle: .body)

        button.setTitle("GIRLS", for: .normal)
        button.setTitleColor(UIColor(named: "genderSelectorButton"), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.titleLabel?.font = .AntonioRegular(size: dynamicFont.pointSize)

        return button
    }()

    private lazy var selectedLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "genderSelectorButton")
        return view
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "genderSelector")
        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout

extension GenderSelector {
    func layout() {
        addSubview(boysButton)
        addSubview(girlsButton)
        addSubview(selectedLine)
        boysButton.activateAutoLayout()
        girlsButton.activateAutoLayout()
        selectedLine.activateAutoLayout()

        // Boys button constraint
        NSLayoutConstraint.activate([
            boysButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            boysButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            boysButton.topAnchor.constraint(equalTo: topAnchor),
            boysButton.bottomAnchor.constraint(equalTo: bottomAnchor)

        ])

        // girls button constraint
        NSLayoutConstraint.activate([
            girlsButton.leadingAnchor.constraint(equalTo: boysButton.trailingAnchor),
            girlsButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            girlsButton.topAnchor.constraint(equalTo: topAnchor),
            girlsButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        // selectedLine constraint
        NSLayoutConstraint.activate([
            selectedLine.heightAnchor.constraint(equalToConstant: 2),
            selectedLine.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            selectedLine.bottomAnchor.constraint(equalTo: bottomAnchor)

        ])

        // Create and activate centerXAnchor constraint for line view
        // TODO: update constraint  according of gender value
        lineViewCenterXConstraint = selectedLine.centerXAnchor.constraint(equalTo: boysButton.centerXAnchor)
        lineViewCenterXConstraint.isActive = true
    }
}

// MARK: - Selectors

extension GenderSelector {
    @objc func buttonTapped(_ sender: UIButton) {
        animateLine(to: sender, withDuration: 0.5)
    }
}

// MARK: - Helpers

extension GenderSelector {
    func animateLine(to targetButton: UIButton, withDuration duration: TimeInterval) {
        if targetButton == boysButton {
            UIView.animate(withDuration: duration) {
                self.lineViewCenterXConstraint.constant = 0
                self.layoutIfNeeded()
            }
        } else if targetButton == girlsButton {
            UIView.animate(withDuration: duration) {
                self.lineViewCenterXConstraint.constant = self.girlsButton.frame.width
                self.layoutIfNeeded()
            }
        }
    }
}
