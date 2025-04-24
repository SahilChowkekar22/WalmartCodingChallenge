//
//  MockCountryRepository.swift
//  WalmartCodingChallenge
//
//  Created by Sahil ChowKekar on 4/24/25.
//

import XCTest
import Combine
@testable import WalmartCodingChallenge

// Mock implementation of `CountryRepositoryProtocol` for unit testing
final class MockCountryRepository: CountryRepositoryProtocol {
    
    var countriesToReturn: [Country] = []
    var shouldReturnError: Bool = false

    // Simulates a fetch operation with either success or failure
    func fetchCountries() -> AnyPublisher<[Country], Error> {
        if shouldReturnError {
            return Fail(error: APIServiceError.responseFailure)
                .eraseToAnyPublisher()
        } else {
            return Just(countriesToReturn)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
