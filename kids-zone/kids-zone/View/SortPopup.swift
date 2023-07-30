//
//  SortPopup.swift
//  kids-zone
//
//  Created by user on 6.07.2023.
//

import UIKit

class SortPopupPresentationController: UIPresentationController {
    private var dimmingView: UIView?

    override var frameOfPresentedViewInContainerView: CGRect {
        let containerBounds = containerView?.bounds ?? CGRect.zero
        let popupHeight: CGFloat = 200 // Customize the height of the popup

        return CGRect(x: 0, y: containerBounds.height - popupHeight, width: containerBounds.width, height: popupHeight)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }

        // Create a dimming view and add it as a subview to the container view
        dimmingView = UIView(frame: containerView.bounds)
        dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmingView?.alpha = 0.0
        containerView.insertSubview(dimmingView!, at: 0)

        // Add a tap gesture recognizer to the dimming view to handle dismissal
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped(_:)))
        dimmingView?.addGestureRecognizer(tapGesture)

        // Animate the dimming view to fade in
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView?.alpha = 1.0
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        // Animate the dimming view to fade out
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView?.alpha = 0.0
        }, completion: { [weak self] _ in
            // Remove the dimming view from the container view after dismissal
            self?.dimmingView?.removeFromSuperview()
        })
    }

    @objc private func dimmingViewTapped(_ sender: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}

protocol SortPopupDelegate: AnyObject {
    func sortDidChnged(sort: Sort)
}

class SortPopup: UIViewController {
    // MARK: - Properties

    weak var delegate: SortPopupDelegate?
    var filterOptions: FilterOptions

    private lazy var newButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("What's new", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        button.layer.cornerRadius = 10

        return button
    }()

    private lazy var highPriceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Price high to low", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        button.layer.cornerRadius = 10

        return button
    }()

    private lazy var lowPriceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Price low to high", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        button.layer.cornerRadius = 10

        return button
    }()

    private let stack = UIStackView()

    // MARK: - Lifecycle

    init(_ filterOptions: FilterOptions) {
        self.filterOptions = filterOptions
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .opaqueSeparator.withAlphaComponent(0.95)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        setupUI()
    }
}

// MARK: - SetupUI & UpdateUI

extension SortPopup {
    func setupUI() {
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillEqually

        view.addSubview(stack)

        stack.activateAutoLayout()
        newButton.activateAutoLayout()
        highPriceButton.activateAutoLayout()
        lowPriceButton.activateAutoLayout()

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 2),
            stack.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stack.trailingAnchor, multiplier: 2),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: stack.bottomAnchor, multiplier: 4)
        ])

        stack.addArrangedSubview(newButton)
        stack.addArrangedSubview(highPriceButton)
        stack.addArrangedSubview(lowPriceButton)

        updateUI(with: filterOptions)
    }

    func updateUI(with filter: FilterOptions) {
        filterOptions = filter
        let sort = filterOptions.sort

        newButton.setTitleColor(UIColor(named: sort == .new ? "activeSortPopupText" : "normalSortPopupText"), for: .normal)

        newButton.backgroundColor = UIColor(named: sort == .new ? "activeSortPopupBackground" : "normalSortPopupBackground")

        highPriceButton.setTitleColor(UIColor(named: sort == .highToLow ? "activeSortPopupText" : "normalSortPopupText"), for: .normal)
        highPriceButton.backgroundColor = UIColor(named: sort == .highToLow ? "activeSortPopupBackground" : "normalSortPopupBackground")

        lowPriceButton.setTitleColor(UIColor(named: sort == .lowToHigh ? "activeSortPopupText" : "normalSortPopupText"), for: .normal)
        lowPriceButton.backgroundColor = UIColor(named: sort == .lowToHigh ? "activeSortPopupBackground" : "normalSortPopupBackground")
        view.setNeedsLayout()
    }
}

// MARK: - Selector

extension SortPopup {
    @objc func buttonTapped(_ sender: UIButton) {
        if sender == newButton {
            delegate?.sortDidChnged(sort: .new)
        } else if sender == highPriceButton {
            delegate?.sortDidChnged(sort: .highToLow)
        } else {
            delegate?.sortDidChnged(sort: .lowToHigh)
        }
    }
}
