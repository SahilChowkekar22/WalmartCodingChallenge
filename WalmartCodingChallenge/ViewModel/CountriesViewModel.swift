//
//  CountriesViewModel.swift
//  WalmartCodingChallenge
//
//  Created by Sahil ChowKekar on 4/23/25.
//

import Combine
import Foundation

// ViewModel to manage country data and search functionality
final class CountriesViewModel: ObservableObject {
    var countries: [Country] = []
    @Published var filteredCountries: [Country] = []
    @Published var searchText: String = ""
    @Published var error: APIServiceError?

    private let countryRepository: CountryRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(countryRepository: CountryRepositoryProtocol = CountryRepository()) {
        self.countryRepository = countryRepository
        setupSearchBinding()
    }

    // Fetches country data from the repository
    func getCountries() {
        countryRepository.fetchCountries()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.error = error as? APIServiceError
                    print("Network error:", error)
                }
            } receiveValue: { [weak self] countries in
                self?.countries = countries
                self?.filteredCountries = countries
            }
            .store(in: &cancellables)
    }

    // Returns total countries count (filtered or full list)
    func numberOfCountries() -> Int {
        return filteredCountries.count
    }

    // Returns a country at the given index
    func country(at index: Int) -> Country {
        return filteredCountries[index]
    }

    // Sets up Combine pipeline to debounce and filter search results
    private func setupSearchBinding() {
        $searchText
            .removeDuplicates()
            .sink { [weak self] text in
                self?.filterCountries(with: text)
            }
            .store(in: &cancellables)
    }

    // Filters countries based on search query 
    func filterCountries(with text: String) {
        let query = text.lowercased()

        filteredCountries = countries.filter {
            ($0.name?.lowercased().contains(query) ?? false)
                || ($0.capital?.lowercased().contains(query) ?? false)
        }
    }
}
