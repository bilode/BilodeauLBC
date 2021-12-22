//
//  testOffersViewModel.swift
//  TestBilodeauLBCTests
//
//  Created by Timothée Bilodeau on 20/12/2021.
//

import XCTest
import Combine
@testable import TestBilodeauLBC

struct MockAPIClient<T>: Requestable {
    var mockedData: T
    
    init(input: T) {
        self.mockedData = input
    }
    
    func make<T: Decodable>(
            _ request: URLRequest,
            _ decoder: JSONDecoder = JSONDecoder()
        ) -> AnyPublisher<T, Error> {
            Just(self.mockedData as! T)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
}

class OffersViewModelTest: XCTestCase {
    
    private func createDefaultViewModel() -> OffersViewModel {
        
        let mockCategoryAPIClient = MockAPIClient(input: [
            Category(id: 1, name: "Véhicule"),
            Category(id: 2, name: "Mode"),
            Category(id: 3, name: "Bricolage"),
            Category(id: 4, name: "Maison"),
            Category(id: 5, name: "Loisirs"),
            Category(id: 6, name: "Immobilier")
        ])
        
        let mockOffersAPIClient = MockAPIClient(input: [
            Offer(categoryID: 1, creationDate: Date().addingTimeInterval(-10), description: "0", isUrgent: true),
            Offer(categoryID: 1, creationDate: Date().addingTimeInterval(-9), description: "1", isUrgent: true),
            Offer(categoryID: 1, creationDate: Date().addingTimeInterval(-8), description: "2", isUrgent: false),
            Offer(categoryID: 1, creationDate: Date().addingTimeInterval(1), description: "3", isUrgent: true),
            Offer(categoryID: 1, creationDate: Date().addingTimeInterval(5), description: "4", isUrgent: false),
            Offer(categoryID: 1, creationDate: Date().addingTimeInterval(-7), description: "5", isUrgent: true),
            Offer(categoryID: 2, creationDate: Date().addingTimeInterval(50), description: "6", isUrgent: false),
            Offer(categoryID: 2, creationDate: Date().addingTimeInterval(10), description: "7", isUrgent: false),
            Offer(categoryID: 2, creationDate: Date().addingTimeInterval(8), description: "8", isUrgent: true),
            Offer(categoryID: 2, creationDate: Date().addingTimeInterval(-11), description: "9", isUrgent: false),
            Offer(categoryID: 3, creationDate: Date().addingTimeInterval(-12), description: "10", isUrgent: false),
        ])
        
        let categoriesRepository = CategoriesRepository(apiClient: mockCategoryAPIClient)
        let offersRepository = OffersRepository(apiClient: mockOffersAPIClient)
        
        return OffersViewModel(with: offersRepository, categoriesRepository)
    }

    func testDataSourceUpdateNoFilter() throws {
        
        let viewModel = self.createDefaultViewModel()
        
        var expectation = self.expectation(description: "noFilter")
        var cancellable: AnyCancellable

        cancellable = viewModel.$dataSource
            .dropFirst()
            .sink { offers in
                
                XCTAssertEqual(offers.count, 11)
                
                // Sorting by urgency then date
                XCTAssertEqual(offers.map{$0.isUrgent}, [true, true, true, true, true, false, false, false, false, false, false])
                XCTAssertEqual(offers.map{$0.description}, ["8", "3", "5", "1", "0", "6", "7", "4", "2", "9", "10"])
                
                expectation.fulfill()
            }
                
        viewModel.fetchAll()
        
        waitForExpectations(timeout: 1.0)
        cancellable.cancel()
        
        expectation = self.expectation(description: "filter1")
        
        viewModel.didSelectCategoryFilter(Category(id: 1, name: ""))

        cancellable = viewModel.$dataSource
            .dropFirst()
            .sink { offers in
                
                XCTAssertEqual(offers.count, 6)
                
                // Sorting by urgency then date
                XCTAssertEqual(offers.map{$0.isUrgent}, [true, true, true, true, false, false])
                XCTAssertEqual(offers.map{$0.description}, ["3", "5", "1", "0", "4", "2"])
                
                expectation.fulfill()
            }
                
        viewModel.fetchAll()
        
        waitForExpectations(timeout: 1.0)
        cancellable.cancel()
        
        
        expectation = self.expectation(description: "filter2")

        viewModel.didSelectCategoryFilter(Category(id: 2, name: ""))

        cancellable = viewModel.$dataSource
            .dropFirst()
            .sink { offers in
                
                XCTAssertEqual(offers.count, 4)
                // Sorting by urgency then date
                XCTAssertEqual(offers.map{$0.isUrgent}, [true, false, false, false])
                XCTAssertEqual(offers.map{$0.description}, ["8", "6", "7", "9"])
                
                expectation.fulfill()
            }

        viewModel.fetchAll()

        waitForExpectations(timeout: 1.0)
        cancellable.cancel()
    }

}
