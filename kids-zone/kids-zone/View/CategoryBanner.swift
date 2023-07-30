//
//  CategoryBanner.swift
//  kids-zone
//
//  Created by user on 18.06.2023.
//

import UIKit

protocol CategoryBannerDelegate: AnyObject {
    func CategoryBannerTapped(_ directory: String)
}

class CategoryBanner: UIView {
    // MARK: - Properties

    weak var delegate: CategoryBannerDelegate?
    var directory: String?

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
        directory = nil
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)

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
        directory = title
        imageView.image = image
        label.text = title
    }
}

// MARK: - Selector

extension CategoryBanner {
    @objc func handleTap() {
        guard let directory = directory else { return }
        delegate?.CategoryBannerTapped(directory.lowercased())
    }
}
