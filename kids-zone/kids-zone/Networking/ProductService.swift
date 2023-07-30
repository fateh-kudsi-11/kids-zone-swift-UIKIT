//
//  ProductService.swift
//  kids-zone
//
//  Created by user on 2.07.2023.
//

import Foundation

struct ProductService {
    static let sahred = ProductService()

    func fetchProducts(_ filterOptions: FilterOptions, completion: @escaping ([Product], FilterElements) -> Void) {
        var components = URLComponents(string: "https://kids-zone-backend-v2.onrender.com/api/v1/products")

        var querys: [URLQueryItem] = []

        if filterOptions.gender.stringValue != "" {
            let queryItem1 = URLQueryItem(name: "gender", value: filterOptions.gender.stringValue)
            querys.append(queryItem1)
        }

        if filterOptions.directory != "" {
            let queryItem2 = URLQueryItem(name: "category", value: filterOptions.directory)
            querys.append(queryItem2)
        }

        if filterOptions.sort.stringValue != "" {
            let queryItem3 = URLQueryItem(name: "sort", value: filterOptions.sort.stringValue)
            querys.append(queryItem3)
        }

        if filterOptions.filterOutput["brand"] != "" {
            let queryItem4 = URLQueryItem(name: "brand", value: filterOptions.filterOutput["brand"])
            querys.append(queryItem4)
        }

        if filterOptions.filterOutput["color"] != "" {
            let queryItem5 = URLQueryItem(name: "color", value: filterOptions.filterOutput["color"])
            querys.append(queryItem5)
        }

        if filterOptions.filterOutput["size"] != "" {
            let queryItem6 = URLQueryItem(name: "size", value: filterOptions.filterOutput["size"])
            querys.append(queryItem6)
        }

        if filterOptions.filterOutput["priceRange"] != "" {
            let queryItem7 = URLQueryItem(name: "priceRange", value: filterOptions.filterOutput["priceRange"])
            querys.append(queryItem7)
        }

        components?.queryItems = querys

        guard let url = components?.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, _, error in
            if error != nil {
                return
            }
            guard let safeData = data else { return }

            let decoder = JSONDecoder()

            do {
                let data = try decoder.decode(ProductsResponse.self, from: safeData)
                completion(data.data, data.filterElements)
            }
            catch {
                print(error)
                print(error.localizedDescription)
                print("@@@ERROR@@@")
            }
        }.resume()
    }
}
