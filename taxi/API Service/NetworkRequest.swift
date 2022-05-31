//
//  NetworkRequest.swift
//  taxi
//
//  Created by Viacheslav Yakymenko on 23.05.2022.
//

import Foundation

class NetworkRequest {
    
    static let shared = NetworkRequest()
    
    func makeRequest(url: String, completion: @escaping ( Result<Data, Error> ) -> Void) -> URLSessionDataTask {
        guard let requestUrl = URL(string: url) else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            guard let response = response as? HTTPURLResponse,
                  let data = data,
                  error == nil else {
                      completion(.failure(error ?? NetworkError.unknown))
                      return
            }
            
            if response.statusCode != 200 {
                completion(.failure(NetworkError.response(response.statusCode) ))
            } else {
                completion(.success(data))
            }

            return
        }
        task.resume()
        return task
    }

}
