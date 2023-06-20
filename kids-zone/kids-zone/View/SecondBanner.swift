import UIKit

class SecondBanner: UIView {
    // MARK: - Properties

    private var gradientLayer: CAGradientLayer?
    private var filterOptions: FilterOptions

    private lazy var firstImage: UIImageView = {
        let image = UIImageView()
        return image
    }()

    private lazy var secondImage: UIImageView = {
        let image = UIImageView()
        return image
    }()

    private lazy var firstLable: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .AntonioRegular(size: 32)
        label.textAlignment = .center

        return label
    }()

    private lazy var secondLable: UILabel = {
        let label = UILabel()
        label.text = "Activewear"
        label.textColor = UIColor(named: "SecondBannerText")
        label.font = .AntonioRegular(size: 32)
        label.textAlignment = .center

        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 20
        stack.axis = .vertical

        return stack
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

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
}

// MARK: - Layout & Update

extension SecondBanner {
    func layout() {
        addSubview(firstImage)
        addSubview(secondImage)
        addSubview(stackView)
        stackView.addArrangedSubview(firstLable)
        stackView.addArrangedSubview(secondLable)

        // Disable autoresizing masks
        firstImage.activateAutoLayout()
        secondImage.activateAutoLayout()
        stackView.activateAutoLayout()
        firstLable.activateAutoLayout()
        secondLable.activateAutoLayout()

        // first image constraint
        NSLayoutConstraint.activate([
            firstImage.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            firstImage.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2)
        ])

        // second image constraint
        NSLayoutConstraint.activate([
            secondImage.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: secondImage.trailingAnchor, multiplier: 2)
        ])

        // stack view constraint

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    func update(with filterOptions: FilterOptions) {
        self.filterOptions = filterOptions

        if filterOptions.gender == .boys {
            firstImage.image = UIImage(named: "92")
            secondImage.image = UIImage(named: "223")
            firstLable.text = "BOYS"

        } else {
            firstImage.image = UIImage(named: "33")
            secondImage.image = UIImage(named: "34")
            firstLable.text = "GIRLS"
        }
    }
}

// MARK: - Helpers

extension SecondBanner {
    private func setupGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = bounds
        gradientLayer?.colors = [
            UIColor(named: "SecondBannerFirstColor")?.cgColor ?? UIColor.black.cgColor,
            UIColor(named: "SecondBannerSecondColor")?.cgColor ?? UIColor.gray.cgColor
        ]
        gradientLayer?.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer?.endPoint = CGPoint(x: 1.0, y: 1.0)

        if let gradientLayer = gradientLayer {
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}
