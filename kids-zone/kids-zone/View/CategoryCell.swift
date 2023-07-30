//
//  CategoryCell.swift
//  kids-zone
//
//  Created by user on 22.06.2023.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    static let reuseIdentifier = "CategoryCell"
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .AntonioRegular(size: 32)
        return label
    }()

    let categoryImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = UIColor(named: "CategoryCellBackground")
        
        contentView.addSubview(categoryLabel)
        contentView.addSubview(categoryImage)
        
        categoryLabel.activateAutoLayout()
        categoryImage.activateAutoLayout()
        
        // Add constraints for the nameLabel
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: categoryImage.trailingAnchor, multiplier: 2),
            categoryImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func configure(with category: Category?) {
        guard let category = category else { return }
        categoryLabel.text = category.title
        categoryImage.image = UIImage(named: category.image)
    }
}
