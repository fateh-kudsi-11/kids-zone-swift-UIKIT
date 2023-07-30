//
//  Category.swift
//  kids-zone
//
//  Created by user on 22.06.2023.
//

import UIKit

class Category {
    let title: String
    let image: String

    init(title: String, image: String) {
        self.title = title
        self.image = image
    }
}

enum CategorySelect {
    static let boysCategory: [Category] = [
        Category(title: "Activewear", image: "cb1"),
        Category(title: "Jackets", image: "cb2"),
        Category(title: "Outfits", image: "cb3"),
        Category(title: "Suits", image: "cb4"),
        Category(title: "Shoes", image: "cb5")
    ]

    static let girlsCategory: [Category] = [
        Category(title: "Activewear", image: "gb1"),
        Category(title: "Jackets", image: "gb2"),
        Category(title: "Dresses", image: "gb3"),
        Category(title: "Skirts", image: "gb4"),
        Category(title: "Shoes", image: "cb5")
    ]
}
