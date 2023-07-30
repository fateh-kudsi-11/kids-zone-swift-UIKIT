//
//  SingupView.swift
//  kids-zone
//
//  Created by user on 16.07.2023.
//

import UIKit

protocol SingupViewDelegate: AnyObject {
    func sigupButtonTapped()
    func laterButtonTapped()
}

class SingupView: UIView {
    weak var delegate: SingupViewDelegate?

    private lazy var emailTextInput = TextInputView(
        title: "EMAIL ADDRESS:",
        placeholder: "Please Enter Your Email Address",
        keyboardType: .emailAddress,
        validator: Validation.validateEmail
    )

    private lazy var firstNameTextInput = TextInputView(
        title: "First Name:",
        placeholder: "Please Enter Your First Name",
        keyboardType: .default,
        validator: Validation.validateFirstName
    )

    private lazy var lastNameTextInput = TextInputView(
        title: "Last Name:",
        placeholder: "Please Enter Your Last Name",
        keyboardType: .default,
        validator: Validation.validateLastName
    )

    private lazy var passwordTextInput = TextInputView(
        title: "PASSWORD:",
        placeholder: "Please Enter Your Password",
        keyboardType: .default,
        validator: Validation.validatePassword,
        isSecureTextEntry: true
    )

    private lazy var confirmPasswordTextInput = TextInputView(
        title: "Confirm Password:",
        placeholder: "Please Confirm Your Password",
        keyboardType: .default,
        validator: Validation.validatePassword,
        returnKeyType: .go,
        isSecureTextEntry: true,
        typeInput: "confirm",
        password: ""
    )

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()

    private let containerView = UIView()

    private lazy var sigupButton: UIButton = {
        let button = UIButton(type: .system)

        button.setTitle("SIGN UP", for: .normal)
        button.backgroundColor = UIColor(named: "AuthFirstButton")
        button.setTitleColor(UIColor(named: "AuthFirstText"), for: .normal)
        button.addTarget(self, action: #selector(sigupTapped), for: .touchUpInside)
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

extension SingupView {
    func setupUI() {
        backgroundColor = .systemBackground
        addSubview(scrollView)
        scrollView.addSubview(containerView)

        containerView.addSubview(emailTextInput)
        containerView.addSubview(firstNameTextInput)
        containerView.addSubview(lastNameTextInput)
        containerView.addSubview(passwordTextInput)
        containerView.addSubview(confirmPasswordTextInput)
        containerView.addSubview(sigupButton)
        containerView.addSubview(maybeLaterButton)

        scrollView.activateAutoLayout()
        containerView.activateAutoLayout()
        emailTextInput.activateAutoLayout()
        firstNameTextInput.activateAutoLayout()
        lastNameTextInput.activateAutoLayout()
        passwordTextInput.activateAutoLayout()
        confirmPasswordTextInput.activateAutoLayout()
        sigupButton.activateAutoLayout()
        maybeLaterButton.activateAutoLayout()

        emailTextInput.delegate = self
        passwordTextInput.delegate = self
        firstNameTextInput.delegate = self
        lastNameTextInput.delegate = self
        passwordTextInput.delegate = self
        confirmPasswordTextInput.delegate = self

        // Scroll View
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)

        ])

        // Container view
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 600)
        ])
        NSLayoutConstraint.activate([
            emailTextInput.topAnchor.constraint(equalToSystemSpacingBelow: containerView.topAnchor, multiplier: 2),
            emailTextInput.leadingAnchor.constraint(equalToSystemSpacingAfter: containerView.leadingAnchor, multiplier: 2),
            containerView.trailingAnchor.constraint(equalToSystemSpacingAfter: emailTextInput.trailingAnchor, multiplier: 2),
            emailTextInput.heightAnchor.constraint(equalToConstant: 60)

        ])

        NSLayoutConstraint.activate([
            firstNameTextInput.topAnchor.constraint(equalToSystemSpacingBelow: emailTextInput.bottomAnchor, multiplier: 4),
            firstNameTextInput.leadingAnchor.constraint(equalToSystemSpacingAfter: containerView.leadingAnchor, multiplier: 2),
            containerView.trailingAnchor.constraint(equalToSystemSpacingAfter: firstNameTextInput.trailingAnchor, multiplier: 2),
            firstNameTextInput.heightAnchor.constraint(equalToConstant: 60)

        ])

        NSLayoutConstraint.activate([
            lastNameTextInput.topAnchor.constraint(equalToSystemSpacingBelow: firstNameTextInput.bottomAnchor, multiplier: 4),
            lastNameTextInput.leadingAnchor.constraint(equalToSystemSpacingAfter: containerView.leadingAnchor, multiplier: 2),
            containerView.trailingAnchor.constraint(equalToSystemSpacingAfter: lastNameTextInput.trailingAnchor, multiplier: 2),
            lastNameTextInput.heightAnchor.constraint(equalToConstant: 60)

        ])

        NSLayoutConstraint.activate([
            passwordTextInput.topAnchor.constraint(equalToSystemSpacingBelow: lastNameTextInput.bottomAnchor, multiplier: 4),
            passwordTextInput.leadingAnchor.constraint(equalToSystemSpacingAfter: containerView.leadingAnchor, multiplier: 2),
            containerView.trailingAnchor.constraint(equalToSystemSpacingAfter: passwordTextInput.trailingAnchor, multiplier: 2),
            passwordTextInput.heightAnchor.constraint(equalToConstant: 60)

        ])

        NSLayoutConstraint.activate([
            confirmPasswordTextInput.topAnchor.constraint(equalToSystemSpacingBelow: passwordTextInput.bottomAnchor, multiplier: 4),
            confirmPasswordTextInput.leadingAnchor.constraint(equalToSystemSpacingAfter: containerView.leadingAnchor, multiplier: 2),
            containerView.trailingAnchor.constraint(equalToSystemSpacingAfter: confirmPasswordTextInput.trailingAnchor, multiplier: 2),
            confirmPasswordTextInput.heightAnchor.constraint(equalToConstant: 60)

        ])

        NSLayoutConstraint.activate([
            sigupButton.topAnchor.constraint(equalToSystemSpacingBelow: confirmPasswordTextInput.bottomAnchor, multiplier: 4),
            sigupButton.leadingAnchor.constraint(equalToSystemSpacingAfter: containerView.leadingAnchor, multiplier: 2),
            containerView.trailingAnchor.constraint(equalToSystemSpacingAfter: sigupButton.trailingAnchor, multiplier: 2),
            sigupButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            maybeLaterButton.topAnchor.constraint(equalToSystemSpacingBelow: sigupButton.bottomAnchor, multiplier: 2),
            maybeLaterButton.leadingAnchor.constraint(equalToSystemSpacingAfter: containerView.leadingAnchor, multiplier: 2),
            containerView.trailingAnchor.constraint(equalToSystemSpacingAfter: maybeLaterButton.trailingAnchor, multiplier: 2),
            maybeLaterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: - Selector

extension SingupView {
    @objc func sigupTapped() {
        print("something")
        let emailVaild = emailTextInput.onSubmission()
        let passwordVaild = passwordTextInput.onSubmission()
        let firstNameVaild = firstNameTextInput.onSubmission()
        let lastNameVaild = lastNameTextInput.onSubmission()
        //  let confirmPasswordVaild = confirmPasswordTextInput.onSubmission()
        print(emailVaild)
        print(passwordVaild)
        print(firstNameVaild)
        print(lastNameVaild)
        //   print(confirmPasswordVaild)

        guard emailVaild, passwordVaild, firstNameVaild, lastNameVaild else { return }
        guard let emailValue = emailTextInput.textField.text, let passwordValue = passwordTextInput.textField.text, let firstNameValue = firstNameTextInput.textField.text, let lastNameValue = lastNameTextInput.textField.text else { return }

        print("OK")
        print(emailValue)
        print(firstNameValue)
        print(lastNameValue)
        print(passwordValue)
    }

    @objc func maybeLaterButtonTapped() {
        delegate?.laterButtonTapped()
    }
}

extension SingupView: TextInputViewDelegate {
    func textInputDidEndEditing(_ sender: TextInputView) {
        if sender == emailTextInput {
            firstNameTextInput.textField.becomeFirstResponder()
        }
        else if sender == firstNameTextInput {
            lastNameTextInput.textField.becomeFirstResponder()
        }
        else if sender == lastNameTextInput {
            passwordTextInput.textField.becomeFirstResponder()
        }
        else if sender == passwordTextInput {
            confirmPasswordTextInput.password = passwordTextInput.textField.text
            confirmPasswordTextInput.textField.becomeFirstResponder()
        }
        else {
            sigupTapped()
        }
    }
}
