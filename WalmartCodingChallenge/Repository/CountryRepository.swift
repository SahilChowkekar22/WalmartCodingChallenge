//
//  CountryRepository.swift
//  WalmartCodingChallenge
//
//  Created by Sahil ChowKekar on 4/24/25.
//
import Foundation
import Combine

protocol CountryRepositoryProtocol {
    func fetchCountries() -> AnyPublisher<[Country], Error>
}

// Repository to fetch countries using a network service
final class CountryRepository: CountryRepositoryProtocol {
    
    private let networkService: APIServiceProtocol
    private let endpoint: String

    init(networkService: APIServiceProtocol = APIServiceManager(),
         endpoint: String = Endpoints.countriesEndpoint) {
        self.networkService = networkService
        self.endpoint = endpoint
    }

    func fetchCountries() -> AnyPublisher<[Country], Error> {
        return networkService.fetchData(url: endpoint)
    }
}
