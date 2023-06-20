import UIKit

protocol GenderSelectorDelegate: AnyObject {
    func genderSelectorDidChange()
}

class GenderSelector: UIView {
    // MARK: - Properties

    var filterOptions: FilterOptions

    private var lineViewCenterXConstraint: NSLayoutConstraint!

    weak var delegate: GenderSelectorDelegate?

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

    init(_ filterOptions: FilterOptions) {
        self.filterOptions = filterOptions
        super.init(frame: .zero)
        backgroundColor = UIColor(named: "genderSelector")
        print(filterOptions.gender)
        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    func layout() {
        addSubview(boysButton)
        addSubview(girlsButton)
        addSubview(selectedLine)

        // Disable autoresizing masks
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

        // Girls button constraint
        NSLayoutConstraint.activate([
            girlsButton.leadingAnchor.constraint(equalTo: boysButton.trailingAnchor),
            girlsButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            girlsButton.topAnchor.constraint(equalTo: topAnchor),
            girlsButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Selected line constraint
        NSLayoutConstraint.activate([
            selectedLine.heightAnchor.constraint(equalToConstant: 2),
            selectedLine.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            selectedLine.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Create centerXAnchor constraint for line view
        lineViewCenterXConstraint = selectedLine.centerXAnchor.constraint(equalTo: boysButton.centerXAnchor)

        // Adjust the constraint based on the filterOptions.gender value
        if filterOptions.gender == .girls {
            lineViewCenterXConstraint = selectedLine.centerXAnchor.constraint(equalTo: girlsButton.centerXAnchor)
        }
        lineViewCenterXConstraint.isActive = true
    }

    // MARK: - Selectors

    @objc func buttonTapped(_ sender: UIButton) {
        animateLine(to: sender, withDuration: 0.5) {
            self.delegate?.genderSelectorDidChange()
        }
    }

    // MARK: - Helpers

    func animateLine(to targetButton: UIButton, withDuration duration: TimeInterval, completion: @escaping () -> Void) {
        UIView.animate(withDuration: duration, animations: {
            if targetButton == self.boysButton {
                self.lineViewCenterXConstraint.isActive = false
                self.lineViewCenterXConstraint = self.selectedLine.centerXAnchor.constraint(equalTo: self.boysButton.centerXAnchor)
                self.lineViewCenterXConstraint.isActive = true
            } else {
                self.lineViewCenterXConstraint.isActive = false
                self.lineViewCenterXConstraint = self.selectedLine.centerXAnchor.constraint(equalTo: self.girlsButton.centerXAnchor)
                self.lineViewCenterXConstraint.isActive = true
            }

            self.layoutIfNeeded()
        }) { _ in

            completion()
        }
    }
}
