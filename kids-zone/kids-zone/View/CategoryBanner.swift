//
//  CategoryBanner.swift
//  kids-zone
//
//  Created by user on 18.06.2023.
//

import UIKit

class CategoryBanner: UIView {
    // MARK: - Properties

    lazy var label: UILabel = {
        let label = UILabel()

        label.textColor = UIColor.white
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.font = .AntonioRegular(size: 24)

        return label
    }()

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout & Update

extension CategoryBanner {
    func layout() {
        addSubview(imageView)
        addSubview(label)

        // Disable autoresizing masks
        imageView.activateAutoLayout()
        label.activateAutoLayout()

        //  image view constraint

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

        ])

        //  label  constraint

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            label.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    func update(withImage image: UIImage?, andTitle title: String) {
        imageView.image = image
        label.text = title
    }
}
