//
//  AuthService.swift
//  kids-zone
//
//  Created by user on 18.07.2023.
//

import Foundation
import KeychainSwift

struct AuthService {
    static let sahred = AuthService()
    
    func signin(email: String, password: String, completion: @escaping (Error?) -> Void) {
        let url = URL(string: "https://kids-zone-backend-v2.onrender.com/api/v1/user/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = ["email": email, "password": password]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200 ... 299).contains(httpResponse.statusCode)
            else {
                completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Something went wrong. Please try again later."]))
                return
            }
            
            do {
                if let data = data,
                   let extractedData = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let token = extractedData["token"] as? String
                {
                    completion(nil)
                    
                    let keychain = KeychainSwift()
                    keychain.set(token, forKey: "token")
                } else {
                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Something went wrong. Please try again later."])
                }
            } catch {
                completion(error)
            }
        }
        
        task.resume()
    }
    
    func checkAuth(completion: @escaping (User) -> Void) {
        let keychain = KeychainSwift()
        guard let token = keychain.get("token") else {
            // Token not found in keychain
            return
        }
        
        let url = URL(string: "https://kids-zone-backend-v2.onrender.com/api/v1/user/me")!
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let data = data, let response = response as? HTTPURLResponse else {
                // Handle error
                return
            }
            
            if response.statusCode == 200 {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonData = json as? [String: Any], let userData = jsonData["data"] as? [String: Any] {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let user = try JSONSerialization.data(withJSONObject: userData)
                        let userModel = try decoder.decode(User.self, from: user)
                        
                        completion(userModel)
                    }
                } catch {
                    // Handle decoding error
                }
            } else {
                // Handle HTTP error
            }
        }
        
        task.resume()
    }
}
