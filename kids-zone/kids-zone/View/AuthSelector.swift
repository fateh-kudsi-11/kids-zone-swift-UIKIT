//
//  AuthSelector.swift
//  kids-zone
//
//  Created by user on 15.07.2023.
//

import UIKit

protocol AuthSelectorDelegate: AnyObject {
    func authSelectorDidChange()
}

class AuthSelector: UIView {
    // MARK: - Properties

    var auth: AuthMode

    private var lineViewCenterXConstraint: NSLayoutConstraint!

    weak var delegate: AuthSelectorDelegate?

    private lazy var siginInButton: UIButton = {
        let button = UIButton(type: .system)
        let dynamicFont = UIFont.preferredFont(forTextStyle: .body)

        button.setTitle("SIGNIN", for: .normal)
        button.setTitleColor(UIColor(named: "genderSelectorButton"), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.titleLabel?.font = .AntonioRegular(size: dynamicFont.pointSize)

        return button
    }()

    private lazy var siginUpButton: UIButton = {
        let button = UIButton(type: .system)
        let dynamicFont = UIFont.preferredFont(forTextStyle: .body)

        button.setTitle("SIGNUP", for: .normal)
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

    init(_ auth: AuthMode) {
        self.auth = auth
        super.init(frame: .zero)
        backgroundColor = UIColor(named: "genderSelector")

        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    func layout() {
        addSubview(siginInButton)
        addSubview(siginUpButton)
        addSubview(selectedLine)

        // Disable autoresizing masks
        siginInButton.activateAutoLayout()
        siginUpButton.activateAutoLayout()
        selectedLine.activateAutoLayout()

        // Boys button constraint
        NSLayoutConstraint.activate([
            siginInButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            siginInButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            siginInButton.topAnchor.constraint(equalTo: topAnchor),
            siginInButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Girls button constraint
        NSLayoutConstraint.activate([
            siginUpButton.leadingAnchor.constraint(equalTo: siginInButton.trailingAnchor),
            siginUpButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            siginUpButton.topAnchor.constraint(equalTo: topAnchor),
            siginUpButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Selected line constraint
        NSLayoutConstraint.activate([
            selectedLine.heightAnchor.constraint(equalToConstant: 2),
            selectedLine.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            selectedLine.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Create centerXAnchor constraint for line view
        lineViewCenterXConstraint = selectedLine.centerXAnchor.constraint(equalTo: siginInButton.centerXAnchor)

        // Adjust the constraint based on the filterOptions.gender value
        if auth == .signup {
            lineViewCenterXConstraint = selectedLine.centerXAnchor.constraint(equalTo: siginUpButton.centerXAnchor)
        }
        lineViewCenterXConstraint.isActive = true
    }

    func update(with auth: AuthMode) {
        self.auth = auth

        if auth == .signin {
            lineViewCenterXConstraint.isActive = false
            lineViewCenterXConstraint = selectedLine.centerXAnchor.constraint(equalTo: siginInButton.centerXAnchor)
            lineViewCenterXConstraint.isActive = true
        } else {
            lineViewCenterXConstraint.isActive = false
            lineViewCenterXConstraint = selectedLine.centerXAnchor.constraint(equalTo: siginUpButton.centerXAnchor)
            lineViewCenterXConstraint.isActive = true
        }
    }

    // MARK: - Selectors

    @objc func buttonTapped(_ sender: UIButton) {
        guard let senderLabel = sender.titleLabel?.text?.lowercased() else { return }

        guard senderLabel != auth.stringValue else { return }
        animateLine(to: sender, withDuration: 0.5) {
            self.delegate?.authSelectorDidChange()
        }
    }

    // MARK: - Helpers

    func animateLine(to targetButton: UIButton, withDuration duration: TimeInterval, completion: @escaping () -> Void) {
        UIView.animate(withDuration: duration, animations: {
            if targetButton == self.siginInButton {
                self.lineViewCenterXConstraint.isActive = false
                self.lineViewCenterXConstraint = self.selectedLine.centerXAnchor.constraint(equalTo: self.siginInButton.centerXAnchor)
                self.lineViewCenterXConstraint.isActive = true
            } else {
                self.lineViewCenterXConstraint.isActive = false
                self.lineViewCenterXConstraint = self.selectedLine.centerXAnchor.constraint(equalTo: self.siginUpButton.centerXAnchor)
                self.lineViewCenterXConstraint.isActive = true
            }

            self.layoutIfNeeded()
        }) { _ in

            completion()
        }
    }
}
