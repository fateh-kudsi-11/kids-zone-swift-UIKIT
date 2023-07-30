//
//  TextInputView.swift
//  kids-zone
//
//  Created by user on 16.07.2023.
//

import UIKit

protocol TextInputViewDelegate: AnyObject {
    func textInputDidEndEditing(_ sender: TextInputView)
}

class TextInputView: UIView {
    weak var delegate: TextInputViewDelegate?
    
    let validator: ((String?) -> String?)?
    var password: String?
    var typeInput: String?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .InterBold700(size: 14)
        label.textAlignment = .left
        return label
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.textAlignment = .left
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(named: "TextInputDivider")
        return divider
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .InterBold700(size: 14)
        label.textAlignment = .left
        label.textColor = UIColor.systemRed.withAlphaComponent(0)
        label.text = "This is test error message"
        return label
    }()
    
    init(
        title: String,
        placeholder: String,
        keyboardType: UIKeyboardType,
        validator: ((String?) -> String?)?,
        initialValue: String? = nil,
        returnKeyType: UIReturnKeyType = .next,
        isSecureTextEntry: Bool = false,
        typeInput: String? = nil,
        password: String? = nil
      
    ) {
        self.validator = validator
        self.password = password
        self.typeInput = typeInput
        super.init(frame: .zero)
        
        titleLabel.text = title
        textField.keyboardType = keyboardType
        textField.returnKeyType = returnKeyType
        textField.isSecureTextEntry = isSecureTextEntry
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor(named: "TextinputPlaceholder") ?? UIColor.gray
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
        textField.attributedPlaceholder = attributedPlaceholder
        
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Additional methods and event handlers
    
    @objc func textFieldEditingChanged() {}
}

// MARK: - SetupUI

extension TextInputView {
    func setupUI() {
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(divider)
        addSubview(errorLabel)
        
        titleLabel.activateAutoLayout()
        textField.activateAutoLayout()
        divider.activateAutoLayout()
        errorLabel.activateAutoLayout()
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalToSystemSpacingBelow: textField.bottomAnchor, multiplier: 1),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.75)
        ])
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalToSystemSpacingBelow: divider.bottomAnchor, multiplier: 0.5),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            
        ])
    }
    
    func onSubmission() -> Bool {
        errorLabel.textColor = UIColor.systemRed.withAlphaComponent(0)
        divider.backgroundColor = UIColor(named: "TextInputDivider")
        if typeInput == "confirm" {
            let value = textField.text
            guard let value = value else { return true }
            
            if value != password {
                divider.backgroundColor = .systemRed
                errorLabel.text = "Passwords Do Not Match!"
                errorLabel.textColor = UIColor.systemRed.withAlphaComponent(1)
            }
            return false
        }
        else {
            if let validator = validator {
                let value = validator(textField.text)
                guard let value = value else { return true }
                divider.backgroundColor = .systemRed
                errorLabel.text = value
                errorLabel.textColor = UIColor.systemRed.withAlphaComponent(1)

                return false
            }
        }
        
        return true
    }
}

// MARK: - UITextFieldDelegate

extension TextInputView: UITextFieldDelegate {
    // UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Handle return key pressed
        textField.resignFirstResponder()
        delegate?.textInputDidEndEditing(self)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Handle text field value changed
        errorLabel.textColor = UIColor.systemRed.withAlphaComponent(0)
        divider.backgroundColor = UIColor(named: "TextInputDivider")
        
        if typeInput == "confirm" {
            let value = textField.text
            guard let value = value else { return }
            
            if value != password {
                divider.backgroundColor = .systemRed
                errorLabel.text = "Passwords Do Not Match!"
                errorLabel.textColor = UIColor.systemRed.withAlphaComponent(1)
            }
        }
        else {
            if let validator = validator {
                let value = validator(textField.text)
                guard let value = value else { return }
                divider.backgroundColor = .systemRed
                errorLabel.text = value
                errorLabel.textColor = UIColor.systemRed.withAlphaComponent(1)
            }
        }
    }
}
