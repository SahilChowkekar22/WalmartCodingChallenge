//
//  MockNetworkLayer.swift
//  WalmartCodingChallengeTests
//
//  Created by Sahil ChowKekar on 4/24/25.
//

import Combine
import Foundation
@testable import WalmartCodingChallenge

final class MockNetworkLayer: APIServiceProtocol {
    let fileName: String
    init(fileName: String) {
        self.fileName = fileName
    }
    func fetchData<T: Decodable>(url: String) -> AnyPublisher<T, Error> {
        if let path = Bundle(for: type(of: self)).url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                let jsonDecoder = JSONDecoder()
                let jsonModel = try jsonDecoder.decode(T.self, from: data)
                return Just(jsonModel)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
                
            } catch {
                return Fail(error: APIServiceError.otherError(error))
                    .eraseToAnyPublisher()
            }
        }
        return Fail(error: APIServiceError.responseFailure)
            .eraseToAnyPublisher()
    }
    
}

