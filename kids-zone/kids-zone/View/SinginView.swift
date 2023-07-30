//
//  SinginView.swift
//  kids-zone
//
//  Created by user on 16.07.2023.
//

import KeychainSwift
import UIKit

protocol SigninViewDelegate: AnyObject {
    func siginButtonTapped(email: String, password: String)
    func maybeLaterButtonTapped()
}

class SinginView: UIView {
    weak var delegate: SigninViewDelegate?

    private lazy var emailTextInput = TextInputView(
        title: "EMAIL ADDRESS:",
        placeholder: "Please Enter Your Email Address",
        keyboardType: .emailAddress,
        validator: Validation.validateEmail
    )

    private lazy var passwordTextInput = TextInputView(
        title: "PASSWORD:",
        placeholder: "Please Enter Your Password",
        keyboardType: .default,
        validator: Validation.validatePassword,
        returnKeyType: .go,
        isSecureTextEntry: true
    )

    private lazy var siginButton: UIButton = {
        let button = UIButton(type: .system)

        button.setTitle("SIGN IN", for: .normal)
        button.backgroundColor = UIColor(named: "AuthFirstButton")
        button.setTitleColor(UIColor(named: "AuthFirstText"), for: .normal)
        button.addTarget(self, action: #selector(siginTapped), for: .touchUpInside)
        button.titleLabel?.font = .AntonioRegular(size: 24)
        return button
    }()

    private lazy var maybeLaterButton: UIButton = {
        let button = UIButton(type: .system)

        button.setTitle("MAYBE LATER", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "AuthFirstButton"), for: .normal)
        button.addTarget(self, action: #selector(maybeLaterButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = .AntonioRegular(size: 18)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(named: "AuthFirstButton")?.cgColor

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SinginView {
    func setupUI() {
        backgroundColor = .systemBackground

        addSubview(emailTextInput)
        addSubview(passwordTextInput)
        addSubview(siginButton)
        addSubview(maybeLaterButton)

        emailTextInput.activateAutoLayout()
        passwordTextInput.activateAutoLayout()
        siginButton.activateAutoLayout()
        maybeLaterButton.activateAutoLayout()

        emailTextInput.delegate = self
        passwordTextInput.delegate = self

        NSLayoutConstraint.activate([
            emailTextInput.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            emailTextInput.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: emailTextInput.trailingAnchor, multiplier: 2),
            emailTextInput.heightAnchor.constraint(equalToConstant: 60)

        ])

        NSLayoutConstraint.activate([
            passwordTextInput.topAnchor.constraint(equalToSystemSpacingBelow: emailTextInput.bottomAnchor, multiplier: 4),
            passwordTextInput.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: passwordTextInput.trailingAnchor, multiplier: 2),
            passwordTextInput.heightAnchor.constraint(equalToConstant: 60)

        ])

        NSLayoutConstraint.activate([
            siginButton.topAnchor.constraint(equalToSystemSpacingBelow: passwordTextInput.bottomAnchor, multiplier: 4),
            siginButton.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: siginButton.trailingAnchor, multiplier: 2),
            siginButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            maybeLaterButton.topAnchor.constraint(equalToSystemSpacingBelow: siginButton.bottomAnchor, multiplier: 2),
            maybeLaterButton.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: maybeLaterButton.trailingAnchor, multiplier: 2),
            maybeLaterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: - Selector

extension SinginView {
    @objc func siginTapped() {
        let emailVaild = emailTextInput.onSubmission()
        let passwordVaild = passwordTextInput.onSubmission()

        guard emailVaild, passwordVaild else { return }
        guard let emailValue = emailTextInput.textField.text, let passwordValue = passwordTextInput.textField.text else { return }
        delegate?.siginButtonTapped(email: emailValue, password: passwordValue)
    }

    @objc func maybeLaterButtonTapped() {
        delegate?.maybeLaterButtonTapped()
    }
}

extension SinginView: TextInputViewDelegate {
    func textInputDidEndEditing(_ sender: TextInputView) {
        if sender == passwordTextInput {
            siginTapped()
        } else {
            passwordTextInput.textField.becomeFirstResponder()
        }
    }
}
