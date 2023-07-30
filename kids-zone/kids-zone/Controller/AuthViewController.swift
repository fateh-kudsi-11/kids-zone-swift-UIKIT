//
//  AuthViewController.swift
//  kids-zone
//
//  Created by user on 15.07.2023.
//

import UIKit

enum AuthMode {
    case signin
    case signup
    var stringValue: String {
        switch self {
        case .signin:
            return "signin"
        case .signup:
            return "signup"
        }
    }
}

class AuthViewController: UIViewController, Coordinating, UIGestureRecognizerDelegate {
    var coordinator: Coordinator?
    var auth: AuthMode = .signin
    var authManger: AuthManger?

    private var authSelector: AuthSelector!
    private lazy var signinView = SinginView()
    private lazy var signupView = SingupView()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logoLight")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()

    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundPage")

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))

        tapGesture.delegate = self

        view.addGestureRecognizer(tapGesture)
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        extendedLayoutIncludesOpaqueBars = true
    }
}

// MARK: - SetupUI

extension AuthViewController {
    func setupUI() {
        let closeImage = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(navigateToProducts))
        closeButton.tintColor = UIColor(named: "authCloseBackground")
        navigationItem.leftBarButtonItem = closeButton

        navigationItem.titleView = logoImageView

        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 90),
            logoImageView.heightAnchor.constraint(equalToConstant: 30)
        ])

        view.addSubview(activityIndicator)
        activityIndicator.activateAutoLayout()
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        view.addSubview(container)
        container.activateAutoLayout()

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

        ])

        authSelector = AuthSelector(auth)
        authSelector.delegate = self
        authSelector.activateAutoLayout()
        container.addSubview(authSelector)

        signinView.activateAutoLayout()
        signinView.delegate = self
        signupView.activateAutoLayout()
        signupView.delegate = self

        container.addSubview(signinView)
        container.addSubview(signupView)

        NSLayoutConstraint.activate([
            authSelector.topAnchor.constraint(equalToSystemSpacingBelow: container.topAnchor, multiplier: 3),
            authSelector.leadingAnchor.constraint(equalToSystemSpacingAfter: container.leadingAnchor, multiplier: 1),
            container.trailingAnchor.constraint(equalToSystemSpacingAfter: authSelector.trailingAnchor, multiplier: 1),
            authSelector.heightAnchor.constraint(equalToConstant: 48)
        ])

        NSLayoutConstraint.activate([
            signinView.topAnchor.constraint(equalToSystemSpacingBelow: authSelector.bottomAnchor, multiplier: 2),
            signinView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            signinView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            signinView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            signupView.topAnchor.constraint(equalToSystemSpacingBelow: authSelector.bottomAnchor, multiplier: 2),
            signupView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            signupView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            signupView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        signupView.isHidden = true
    }

    func updateUI() {
        authSelector.update(with: auth)

        if auth == .signin {
            signinView.isHidden = false
            signupView.isHidden = true
        } else {
            signinView.isHidden = true
            signupView.isHidden = false
        }

        // Refresh the layout if needed
        view.setNeedsLayout()
    }
}

// MARK: - Selector

extension AuthViewController {
    @objc func navigateToProducts() {
        coordinator?.hideAuth()
    }

    @objc private func handleTapGesture() {
        view.endEditing(true)
    }
}

// MARK: - AuthSelectorDelegate

extension AuthViewController: AuthSelectorDelegate {
    func authSelectorDidChange() {
        auth = auth == .signin ? .signup : .signin
        updateUI()
    }
}

// MARK: - SigninViewDelegate

extension AuthViewController: SigninViewDelegate {
    func siginButtonTapped(email: String, password: String) {
        guard let authManger = authManger else { return }
        container.isHidden = true
        activityIndicator.startAnimating()
        AuthService.sahred.signin(email: email, password: password) { error in
            if let error = error {
                DispatchQueue.main.async {
                    // Handle the error, for example, show an alert with the error message.
                    let alertController = UIAlertController(title: "Invalid credentails", message: "Please check your email or your password", preferredStyle: .alert)

                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        self.activityIndicator.stopAnimating()
                        self.container.isHidden = false
                    }
                    alertController.addAction(okAction)

                    self.present(alertController, animated: true)
                    print(error)
                }
            } else {
                // Sign in successful, perform any additional actions here.

                AuthService.sahred.checkAuth { user in
                    DispatchQueue.main.async {
                        authManger.user = user
                        authManger.isAuht = true
                        let alertController = UIAlertController(title: "Signin Success", message: "Welcome Back", preferredStyle: .alert)

                        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                            self.coordinator?.hideAuth()
                        }
                        alertController.addAction(okAction)

                        self.present(alertController, animated: true)
                    }
                }
            }
        }
    }

    func maybeLaterButtonTapped() {
        coordinator?.hideAuth()
    }
}

// MARK: - SigupViewDelegate

extension AuthViewController: SingupViewDelegate {
    func sigupButtonTapped() {
        print("sigup")
    }

    func laterButtonTapped() {
        coordinator?.hideAuth()
    }
}
