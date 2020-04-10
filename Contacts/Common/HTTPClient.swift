//
//  HTTPClient.swift
//  Contacts
//
//  Created by Justine Tabin on 4/10/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

struct HTTPClient {
    var baseUrl: String
    
    struct Request {
        var path: String
        var method: Method
        var headers: [String: String] = [
            "User-Agent": "iOS",
            "Content-Type": "application/json"
        ]
        var params: Any?
    }
    
    struct Response<T> {
        var dictBody: [String: Any]?
        var arrayBody: [[String: Any]]?
        var body: T?
        var headers: [AnyHashable: Any]?
        var statusCode: Int?
        var error: Error?
    }
    
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
}

extension HTTPClient {
    
    func dataTask<T: Codable>(type: T.Type, request: Request, completion: @escaping (Response<T>) -> Void) {
        var urlRequest = URLRequest(url: URL(string: baseUrl + request.path)!)

        request.headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        urlRequest.httpMethod = request.method.rawValue
        if let params = request.params {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            let urlResponse = response as? HTTPURLResponse
            var httpResponse = Response<T>(
                headers: urlResponse?.allHeaderFields,
                statusCode: urlResponse?.statusCode,
                error: error
            )
            if let data = data {
                if let body = try? JSONDecoder().decode(T.self, from: data) {
                    httpResponse.body = body
                }
                if let data = try? JSONSerialization.jsonObject(with: data, options: []) {
                    if let dictBody = data as? [String: Any] {
                        httpResponse.dictBody = dictBody
                    } else if let arrayDict = data as? [[String: Any]] {
                        httpResponse.arrayBody = arrayDict
                    }
                }
            }
            completion(httpResponse)
        }
        task.resume()
    }
    
}
