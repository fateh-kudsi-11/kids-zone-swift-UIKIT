import UIKit

class FirstBanner: UIView {
    // MARK: - Properties

    private var gradientLayer: CAGradientLayer?
    private var filterOptions: FilterOptions

    private lazy var firstLabel: UILabel = {
        let label = UILabel()
        label.font = .InterMedium500(size: 24)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor(named: "FirstbannerTextColor")
        return label
    }()

    private lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.text = "CHECK OUT WINTER \nCOLLECTION"
        label.font = .AntonioRegular(size: 32)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.textColor = UIColor(named: "FirstbannerTextColor")
        return label
    }()

    // MARK: - Lifecycle

    init(_ filterOptions: FilterOptions) {
        self.filterOptions = filterOptions
        super.init(frame: .zero)
        setupGradientLayer()
        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        // Handle appearance changes
        gradientLayer = nil
        layer.sublayers = nil
        setupGradientLayer()
        layout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
}

// MARK: - Layout & Update

extension FirstBanner {
    func layout() {
        addSubview(firstLabel)
        addSubview(secondLabel)

        // Disable autoresizing masks
        firstLabel.activateAutoLayout()
        secondLabel.activateAutoLayout()

        // first label constraint
        NSLayoutConstraint.activate([
            firstLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 4),
            firstLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        // second label constraint
        NSLayoutConstraint.activate([
            secondLabel.topAnchor.constraint(equalToSystemSpacingBelow: firstLabel.bottomAnchor, multiplier: 2),
            secondLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    func update(with filterOptions: FilterOptions) {
        self.filterOptions = filterOptions

        if filterOptions.gender == .boys {
            firstLabel.text = "50% OFF ALL BOYS WEAR"
        } else {
            firstLabel.text = "50% OFF ALL GIRLS WEAR"
        }
    }
}

// MARK: - Helpers

extension FirstBanner {
    private func setupGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = bounds
        gradientLayer?.colors = [
            UIColor(named: "bannerFirstColor")?.cgColor ?? UIColor.black.cgColor,
            UIColor(named: "bannerSecondColor")?.cgColor ?? UIColor.gray.cgColor
        ]
        gradientLayer?.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer?.endPoint = CGPoint(x: 1.0, y: 1.0)

        if let gradientLayer = gradientLayer {
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}
