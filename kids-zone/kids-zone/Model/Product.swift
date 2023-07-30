//
//  Product.swift
//  kids-zone
//
//  Created by user on 2.07.2023.
//

import Foundation

struct Product: Codable {
    var _id: String
    var gender: String
    var productName: String
    var brand: String
    var price: Double
    var size: [String]
    var availableColor: [String]
    var colors: [ColorModel]
    var images: [ImageModel]
    var description: String
    var details: [String]
    var category: String
    var productType: String
    var productNumber: Int
    var watchCount: Int
}

struct ImageModel: Codable {
    var imagesColor: String
    var images: [String]
}

struct ColorModel: Codable {
    var colorName: String
    var colorCode: String
}

struct ProductsResponse: Decodable {
    let success: Bool
    let filterElements: FilterElements
    let count: Int
    let data: [Product]
}

struct FilterElements: Codable {
    let brands: [FilterElement]
    let colors: [FilterElement]
    let sizes: [FilterElement]
    let price: [String: Int]
}

struct FilterElement: Codable {
    var title: String
    var count: Int
}
