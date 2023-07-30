import UIKit

protocol FilterPopupButtonDelegate: AnyObject {
    func filterPopupButtonDidTap(_ filterPopupButton: FilterPopupButton)
}

class FilterPopupButton: UIView {
    weak var delegate: FilterPopupButtonDelegate?
    
    var title: String
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .InterRegular400(size: 14)
        return label
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24)
        imageView.image = UIImage(systemName: "chevron.down", withConfiguration: symbolConfiguration)
        imageView.tintColor = UIColor(named: "backButtonColor")
        return imageView
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SortFilterDivder")
        return view
    }()
    
    private var isHighlighted = false {
        didSet {
            updateAppearance()
        }
    }
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        
        titleLabel.text = title
     
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
        
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(iconView)
        addSubview(divider)
        
        titleLabel.activateAutoLayout()
        iconView.activateAutoLayout()
        divider.activateAutoLayout()
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            trailingAnchor.constraint(equalToSystemSpacingAfter: iconView.trailingAnchor, multiplier: 2),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.75)
        ])
    }
    
    @objc private func viewTapped() {
        delegate?.filterPopupButtonDidTap(self)
    }
    
    private func updateAppearance() {
        let alpha: CGFloat = isHighlighted ? 0.3 : 1.0
        titleLabel.alpha = alpha
        iconView.alpha = alpha
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = true
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
    }
}
