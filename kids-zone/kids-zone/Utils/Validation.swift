//
//  Validation.swift
//  kids-zone
//
//  Created by user on 16.07.2023.
//

import UIKit

class Validation {
    static func validateEmail(_ email: String?) -> String? {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        if emailPredicate.evaluate(with: email) {
            return nil // Valid email
        } else {
            return "Invalid email address" // Invalid email
        }
    }

    static func validatePassword(_ password: String?) -> String? {
        guard let password = password else { return nil }
        if password.count < 6 {
            return "Password must be at least 6 characters long"
        } else {
            return nil
        }
    }

    static func validateFirstName(_ firstName: String?) -> String? {
        guard let firstName = firstName else { return nil }
        if firstName.count < 1 {
            return "First Name are requierd"
        } else {
            return nil
        }
    }

    static func validateLastName(_ lastName: String?) -> String? {
        guard let lastName = lastName else { return nil }
        if lastName.count < 1 {
            return "Last Name are requierd"
        } else {
            return nil
        }
    }
}
