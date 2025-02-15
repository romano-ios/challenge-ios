//
//  NetworkProvider.swift
//  Test.AmeDigitalLodjinha
//
//  Created by Leandro Romano on 14/06/19.
//  Copyright © 2019 Leandro Romano. All rights reserved.
//

import Foundation
import PromiseKit

class NetworkProvider {
    
    private init() { }
    
    static let shared: NetworkProvider = NetworkProvider()
    
    func request<T: Decodable>(_ endpoint: Endpoint) -> Promise<T> {
        return Promise { seal in
            guard let url = endpoint.url else { return seal.reject(NetworkError.badUrl) }
            
            let urlRequest = self.getUrlRequest(url: url, httpMethod: endpoint.method.rawValue)
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let data = data else { return seal.reject(NetworkError.emptyResponseDataError) }
                
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                
                if 200...299 ~= statusCode {
                    do {
                        let decodableObject = try JSONDecoder().decode(T.self, from: data)
                        return seal.fulfill(decodableObject)
                    } catch {
                        return seal.reject(NetworkError.mappingError)
                    }
                }
                
                return seal.reject(self.parseErrorFor(statusCode: statusCode))
            }.resume()
        }
    }
    
    private func parseErrorFor(statusCode: Int) -> NetworkError {
        if statusCode == 401 { return .unauthorized }
        if statusCode == 403 { return .forbidden }
        if statusCode == 404 { return .notFound }
        return .unknownError
    }
    
    private func getUrlRequest(url: URL, httpMethod: String, data: Data? = nil) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        urlRequest.httpBody = data
        urlRequest.addValue(
            R.string.networking.header_value_application_json(),
            forHTTPHeaderField: R.string.networking.header_key_content_type())
        urlRequest.addValue(
            R.string.networking.header_value_application_json(),
            forHTTPHeaderField: R.string.networking.header_key_accept())
        return urlRequest
    }
    
}
