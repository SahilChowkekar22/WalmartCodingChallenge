//
//  CountriesViewModelTests.swift
//  WalmartCodingChallengeTests
//
//  Created by Sahil ChowKekar on 4/24/25.
//

import Combine
import XCTest

@testable import WalmartCodingChallenge

final class CountriesViewModelTests: XCTestCase {

    var viewModel: CountriesViewModel!
    var mockRepo: MockCountryRepository!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        super.setUp()
        mockRepo = MockCountryRepository()
        viewModel = CountriesViewModel(countryRepository: mockRepo)
        cancellables = []
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockRepo = nil
        cancellables = nil
        super.tearDown()
    }

    func test_fetchCountries_success() {
        // Given
        let india = Country(
            capital: "Delhi",
            code: "IN",
            currency: .init(code: "INR", name: "Rupee", symbol: "₹"),
            flag: "",
            language: .init(code: "hi", name: "Hindi"),
            name: "India",
            region: "Asia"
        )

        let usa = Country(
            capital: "Washington, D.C.",
            code: "US",
            currency: .init(code: "USD", name: "Dollar", symbol: "$"),
            flag: "",
            language: .init(code: "en", name: "English"),
            name: "United States",
            region: "North America"
        )

        mockRepo.countriesToReturn = [india, usa]

        // When
        let expectation = XCTestExpectation(description: "Fetch two countries successfully")
        
        viewModel.getCountries()
        
        viewModel.$filteredCountries
            .dropFirst()
            .sink { countries in
                // Then
                XCTAssertEqual(countries.count, 2)
                XCTAssertEqual(countries[0].name, "India")
                XCTAssertEqual(countries[1].name, "United States")
                expectation.fulfill()
            }
            .store(in: &cancellables)


        wait(for: [expectation], timeout: 2)
    }


    func test_fetchCountries_failure() {
        // Given
        mockRepo.shouldReturnError = true

        // When
        let expectation = XCTestExpectation(
            description: "Handle error gracefully"
        )
        
        viewModel.getCountries()

        viewModel.$error
            .dropFirst()
            .sink { error in
                // Then
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
            .store(in: &cancellables)


        wait(for: [expectation], timeout: 2)
    }

    func test_filterCountries_searchText() {
        // Given
        let india = Country(
            capital: "Delhi",
            code: "IN",
            currency: nil,
            flag: nil,
            language: nil,
            name: "India",
            region: "Asia"
        )

        let usa = Country(
            capital: "Washington",
            code: "US",
            currency: nil,
            flag: nil,
            language: nil,
            name: "United States",
            region: "North America"
        )

        mockRepo.countriesToReturn = [india, usa]
        viewModel = CountriesViewModel(countryRepository: mockRepo)
        viewModel.countries = mockRepo.countriesToReturn

        viewModel.getCountries()
        // When
        viewModel.searchText = "india"
        viewModel.filterCountries(with: "india")

        // Then
        XCTAssertEqual(viewModel.filteredCountries.count, 1)
        XCTAssertEqual(viewModel.filteredCountries.first?.name, "India")
    }
}
