//
//  ProductCell.swift
//  kids-zone
//
//  Created by user on 4.07.2023.
//

import SDWebImage
import UIKit
class ProductCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductCell"

    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.textAlignment = .left
        title.font = .InterLight300(size: 14)
        title.numberOfLines = 2
        title.lineBreakMode = .byWordWrapping
        return title
    }()

    private lazy var productImage: UIImageView = {
        let image = UIImageView()

        return image
    }()

    let stackView = UIStackView()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .InterBold700(size: 18)

        return label
    }()

    private lazy var favIcon: UIImageView = {
        let image = UIImageView()
        image.tintColor = UIColor(named: "favIconColor")
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "ProductCellBackground")
        configureCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureCell()
    }

    private func configureCell() {
        titleLabel.activateAutoLayout()
        productImage.activateAutoLayout()
        stackView.activateAutoLayout()
        priceLabel.activateAutoLayout()
        favIcon.activateAutoLayout()

        addSubview(titleLabel)
        addSubview(productImage)
        addSubview(stackView)

        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(favIcon)

        // Configure constraints for the label to fill the cell

        // Product Image constraint
        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: topAnchor),
            productImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            productImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            productImage.heightAnchor.constraint(equalTo: widthAnchor),
        ])

        // stack view constraint
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: productImage.bottomAnchor, multiplier: 1),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1),

        ])
        priceLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        favIcon.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        // titleLabel constraint
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 1),
            bottomAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1),

        ])
    }

    func configure(with product: Product) {
        let url = URL(string: "https://kids-zone-backend-v2.onrender.com/\(product.images[0].images[0])")
        titleLabel.text = product.productName

        productImage.sd_setImage(with: url)

        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24)
        favIcon.image = UIImage(systemName: "heart", withConfiguration: symbolConfiguration)

        priceLabel.text = "$\(product.price / 1000)"
    }
}
