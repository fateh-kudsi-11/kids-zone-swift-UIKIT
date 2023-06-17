//
//  UIFont+Utils.swift
//  kids-zone
//
//  Created by user on 17.06.2023.
//

import UIKit

extension UIFont {
    static func AntonioRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Antonio-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func AntonioLight(size: CGFloat) -> UIFont {
        return UIFont(name: "Antonio-Light", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func AntonioBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Antonio-Bold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func InterLight300(size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Light", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func InterRegular400(size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func InterMedium500(size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Medium", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func InterBold700(size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Bold", size: size) ?? .systemFont(ofSize: size)
    }
}
