//
//  FilterPopupCell.swift
//  kids-zone
//
//  Created by user on 11.07.2023.
//

import UIKit

class FilterPopupCell: UICollectionViewCell {
    static let reuseIdentifier = "FilterPopupCell"
    
    var isChecked: Bool = false
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .InterRegular400(size: 14)
        return label
    }()
    
    private lazy var checkMark: UIImageView = {
        let icon = UIImageView()
        let image = UIImage(systemName: "checkmark")
        icon.image = image
        icon.tintColor = UIColor(named: "checkmarkColor")
        return icon
    }()
    
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(named: "dividerFilterCell")
        return divider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.backgroundColor = .clear
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkMark)
        contentView.addSubview(divider)
        
        titleLabel.activateAutoLayout()
        checkMark.activateAutoLayout()
        divider.activateAutoLayout()
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.75)
        ])
        
        NSLayoutConstraint.activate([
            trailingAnchor.constraint(equalToSystemSpacingAfter: checkMark.trailingAnchor, multiplier: 1),
            checkMark.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        checkMark.isHidden = true
    }
    
    func configure(with filterElement: FilterElement, selected: Bool) {
        titleLabel.text = "\(filterElement.title) - (\(filterElement.count))"
        checkMark.isHidden = !selected
    }
    
    func updateUI(_ value: Bool) {
        isChecked = value
        checkMark.isHidden = !isChecked
    }
}
