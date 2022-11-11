//
//  APIProvider.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/24.
//

import Foundation
import Alamofire

protocol APIProvider {
    func fetchResponse<T: Codable>(requestURL: URLRequestConvertible ,completion: @escaping (Result<T, APIError>) -> ())
}
extension APIProvider {
    func fetchResponse<T: Codable>(requestURL: URLRequestConvertible ,completion: @escaping (Result<T, APIError>) -> ()) {
        AF.request(requestURL)
            .responseData { (response) in
                let result: Result<T, APIError> = self.getResult(response: response)
                completion(result)
            }
    }
    
    private func getResult<T: Codable>(response: AFDataResponse<Data>) -> Result<T, APIError> {
        let result = response.result
        switch result {
        case .success(let data):
            do {
                let statusCode: Int = response.response?.statusCode ?? 0
                if (statusCode >= 200 && statusCode < 300) {
                    let json = try JSONDecoder().decode(CommonResponseEntity<T>.self, from: data)
                    switch json.status {
                    case "0000":
                        return .success(json.data)
                    default:
                        let json = try JSONDecoder().decode(ErrorEnity.self, from: data)
                        return .failure(.bithumbDefinedError(error: json))
                    }
                } else {
                    let json = try JSONDecoder().decode(ErrorEnity.self, from: data)
                    return .failure(.bithumbDefinedError(error: json))
                }
            } catch(_) {
                print(String(decoding: data, as: UTF8.self))
                return .failure(.incorrectFormat)
            }
        case .failure(let error):
            return .failure(.failureResponse(error: error))
        }
    }
}
