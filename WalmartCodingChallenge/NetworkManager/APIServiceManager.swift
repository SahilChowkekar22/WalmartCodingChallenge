//
//  APIServiceManager.swift
//  WalmartCodingChallenge
//
//  Created by Sahil ChowKekar on 4/23/25.
//

import Combine
import Foundation

// Protocol defining a generic network fetch function
protocol APIServiceProtocol {
    func fetchData<T: Decodable>(url: String) -> AnyPublisher<T, Error>
}

// Service responsible for making network requests
struct APIServiceManager:APIServiceProtocol {
    let session: URLSession

    // Injected session
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}

extension APIServiceManager {
    func fetchData<T: Decodable>(url: String) -> AnyPublisher<T, Error> {
        // Validate URL
        guard let url = URL(string: url) else {
            return Fail(error: APIServiceError.invalidURL)
                .eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: url)
            // Validate HTTP response
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw APIServiceError.responseFailure
                }
                return result.data
            }

            // Decode the JSON data
            .decode(type: T.self, decoder: JSONDecoder())

            // Handle errors with specificity
            .catch { error -> AnyPublisher<T, Error> in
                switch error {
                case let urlError as URLError:
                    return Fail(error: APIServiceError.urlError(urlError))
                        .eraseToAnyPublisher()
                case let decodingError as DecodingError:
                    return Fail(error: APIServiceError.decodingError(decodingError))
                        .eraseToAnyPublisher()
                default:
                    return Fail(error: APIServiceError.otherError(error))
                        .eraseToAnyPublisher()
                }
            }

            // Final cleanup
            .eraseToAnyPublisher()
    }
}
