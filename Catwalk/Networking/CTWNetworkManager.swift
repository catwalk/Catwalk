//
//  CTWNetworkManager.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import Foundation

class CTWNetworkManager {
    
    public enum APIServiceError: Error {
        case apiError
        case invalidEndpoint
        case invalidResponse
        case noData
        case decodeError
    }
    
    public static let shared = CTWNetworkManager()
    
    public func checkIfSKUAvailable(sku: String, result: @escaping (Result<CTWSKUAvailability, APIServiceError>) -> Void) {
        let url = URL(string: "\(GenieAPI.CTWLK_API_ROOT)/sku/availability")!
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(GenieAPI.apiToken, forHTTPHeaderField: "apiToken")
        request.setValue(GenieAPI.bundle, forHTTPHeaderField: "bundle")
        request.setValue(sku, forHTTPHeaderField: "sku")
        
        fetchResources(urlRequest: request, completion: result)
    }
        
    public func fetchLooks(for sku: String, result: @escaping (Result<[CTWLook], APIServiceError>) -> Void) {
        let url = URL(string: "\(GenieAPI.CTWLK_API_ROOT)/combinations?structured=true")!
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(GenieAPI.apiToken, forHTTPHeaderField: "apiToken")
        request.setValue(GenieAPI.bundle, forHTTPHeaderField: "bundle")
        request.setValue(sku, forHTTPHeaderField: "sku")
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    public func fetchSimilars(for sku: String, result: @escaping (Result<[String], APIServiceError>) -> Void) {
        let url = URL(string: "\(GenieAPI.CTWLK_API_ROOT)/similars")!

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(GenieAPI.apiToken, forHTTPHeaderField: "apiToken")
        request.setValue(GenieAPI.bundle, forHTTPHeaderField: "bundle")
        request.setValue(sku, forHTTPHeaderField: "sku")
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    public func availableColors(for sku: String, result: @escaping (Result<[CTWProduct], APIServiceError>) -> Void) {
        let url = URL(string: "\(GenieAPI.CTWLK_API_ROOT)/availableColors")!

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(GenieAPI.apiToken, forHTTPHeaderField: "apiToken")
        request.setValue(GenieAPI.bundle, forHTTPHeaderField: "bundle")
        request.setValue(sku, forHTTPHeaderField: "sku")
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    public func fetchProductsInfo(for productIds: [String], result: @escaping (Result<[CTWProduct], APIServiceError>) -> Void) {
        let url = URL(string: "\(GenieAPI.CTWLK_API_ROOT)/productsInfo?productIds=\(productIds.joined(separator: ","))")!

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(GenieAPI.apiToken, forHTTPHeaderField: "apiToken")
        request.setValue(GenieAPI.bundle, forHTTPHeaderField: "bundle")
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    public func fetchProductInfoBy(sku: String? = nil, productId: String? = nil, result: @escaping (Result<CTWProduct, APIServiceError>) -> Void) {
        var urlString = "\(GenieAPI.CTWLK_API_ROOT)/product"
        if let sku = sku {
            urlString += "?sku=\(sku)"
        } else if let productId = productId {
            urlString += "?productId=\(productId)"
        } else {
            return
        }
        
        let url = URL(string: urlString)!

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(GenieAPI.apiToken, forHTTPHeaderField: "apiToken")
        request.setValue(GenieAPI.bundle, forHTTPHeaderField: "bundle")
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    public func fetchTrendingSKUs(result: @escaping (Result<[String], APIServiceError>) -> Void) {
        let urlString = "\(GenieAPI.CTWLK_API_ROOT)/trending/clothing"
        let url = URL(string: urlString)!

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(GenieAPI.apiToken, forHTTPHeaderField: "apiToken")
        request.setValue(GenieAPI.bundle, forHTTPHeaderField: "bundle")
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    public func fetchAvailableColors(for sku: String, result: @escaping (Result<[String], APIServiceError>) -> Void) {
        let urlString = "\(GenieAPI.CTWLK_API_ROOT)/availableColors"
        let url = URL(string: urlString)!

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(GenieAPI.apiToken, forHTTPHeaderField: "apiToken")
        request.setValue(GenieAPI.bundle, forHTTPHeaderField: "bundle")
        request.setValue(sku, forHTTPHeaderField: "sku")
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    public func fetchTrendingClothingAsLooks(result: @escaping (Result<[CTWLook], APIServiceError>) -> Void) {
        let urlString = "\(GenieAPI.CTWLK_API_ROOT)/trending/clothingInLooks"
        let url = URL(string: urlString)!

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(GenieAPI.apiToken, forHTTPHeaderField: "apiToken")
        request.setValue(GenieAPI.bundle, forHTTPHeaderField: "bundle")
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    public func fetchCombinationsBy(hue: Int, result: @escaping (Result<[CTWLook], APIServiceError>) -> Void) {
        let urlString = "\(GenieAPI.CTWLK_API_ROOT)/combinations?hue=\(hue)"
        let url = URL(string: urlString)!

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(GenieAPI.apiToken, forHTTPHeaderField: "apiToken")
        request.setValue(GenieAPI.bundle, forHTTPHeaderField: "bundle")
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    public func fetchChatMessageResponse(for message: String, with sku: String?, result: @escaping (Result<CTWChatMessage, APIServiceError>) -> Void) {
        let urlString = "\(GenieAPI.CTWLK_API_ROOT)/chat/message"
        let url = URL(string: urlString)!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(GenieAPI.apiToken, forHTTPHeaderField: "apiToken")
        request.setValue(GenieAPI.bundle, forHTTPHeaderField: "bundle")
        
        if let sku = sku {
            request.setValue(sku, forHTTPHeaderField: "sku")
        }
        
        let parameters: [String: Any] = [
            "message": message,
            "sessionId": "TEST_SESSION_ID"
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    public func likeLook(with productIds: [String], result: @escaping (Result<CTWDefaultResponse, APIServiceError>) -> Void) {
        let urlString = "\(GenieAPI.CTWLK_API_ROOT)/combinations/like"
        let url = URL(string: urlString)!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(GenieAPI.apiToken, forHTTPHeaderField: "apiToken")
        request.setValue(GenieAPI.bundle, forHTTPHeaderField: "bundle")
        
        
        let parameters: [String: Any] = [
            "productIds": productIds
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    private func fetchResources<T: Decodable>(urlRequest: URLRequest, completion: @escaping (Result<T, APIServiceError>) -> Void) {
        URLSession.shared.dataTask(with: urlRequest) { (result) in
            switch result {
                case .success(let (response, data)):
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                        completion(.failure(.invalidResponse))
                        return
                    }
                    do {
                        let values = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(values))
                    } catch {
                        completion(.failure(.decodeError))
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(.apiError))
                }
         }.resume()
    }
    
}

extension URLSession {
    func dataTask(with urlRequest: URLRequest, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}
