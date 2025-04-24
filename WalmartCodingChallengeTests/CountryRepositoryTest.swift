//
//  CountryRepositoryTest.swift
//  WalmartCodingChallengeTests
//
//  Created by Sahil ChowKekar on 4/24/25.
//


import XCTest
import Combine
@testable import WalmartCodingChallenge

final class CountryRepositoryTest: XCTestCase {
    
    private var cancelable: Set<AnyCancellable> = .init()
    private var repo: CountryRepositoryProtocol!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        self.cancelable.removeAll()
        repo =  nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWhenWeAreExpectingCorrectDataFromAPI() throws {
        let mockNetworkLayer = MockNetworkLayer(fileName: "mockdata")
        repo = CountryRepository(networkService: mockNetworkLayer)

        let expectation = expectation(description: "call finished")
        repo.fetchCountries()
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state {
                    case .failure(_):
                        assert(false)
                    default:
                        return
                }
            } receiveValue: { countries in
                XCTAssertTrue(countries.count == 2)
                expectation.fulfill()

            }
            .store(in: &cancelable)
        
        waitForExpectations(timeout: 5)

    }
    
    func testWhenWeAreGettingNODataFromAPI() throws {
        let mockNetworkLayer = MockNetworkLayer(fileName: "wrongFile")
        repo = CountryRepository(networkService: mockNetworkLayer)

        let expectation = expectation(description: "call finished")
        repo.fetchCountries()
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state {
                case .failure(let error):
                        XCTAssertNotNil(error)
                    expectation.fulfill()
                    default:
                        return
                }
            } receiveValue: { countries in
                XCTAssertEqual(countries.count,0)
                expectation.fulfill()

            }
            .store(in: &cancelable)
        
        waitForExpectations(timeout: 5)

    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
