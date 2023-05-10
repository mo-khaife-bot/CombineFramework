//
//  PlanetsViewModelTest.swift
//  CombinePlanetsTests
//
//  Created by mohomed Ali on 08/05/2023.
//

import XCTest
@testable import CombinePlanets

final class PlanetsViewModelTest: XCTestCase {
    
    var planetViewModel : PlanetsViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        planetViewModel = PlanetsViewModel(networkAble: FakeNetworkManager())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        planetViewModel = nil
    }

    func testFetchPlanets_when_we_expect_everything_is_fine() throws {
        // Given
        let expectedCount = 10
                
        // When we fetch the planets
        planetViewModel.fetchPlanets(apiUrl: "PlanetsList")
        
        // Then we expect everything to go fine
        let expectation = XCTestExpectation(description: "The URL is valid but the data is not shown")
        let waitDuration = 2.0
        // mimic closure async feature and to run things on Main Thread
        DispatchQueue.main.asyncAfter(deadline: .now() +  waitDuration){
            // Assert that the planetViewModel is not nil
            XCTAssertNotNil(self.planetViewModel)
            
            // Assert that the number of filtered planets matches the expected count
            XCTAssertEqual(self.planetViewModel.filteredPlanetsList.count, expectedCount)
            
            // Assert that there is no custom error
            XCTAssertNil(self.planetViewModel.customError)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: waitDuration )
    }
    
    func testFetchPlanets_when_we_have_invalid_JSON() throws {
                
        // When we fetch the planets
        planetViewModel.fetchPlanets(apiUrl: "PlanetsListEmpty")
        
        // When we fetch the planets
        let expectation = XCTestExpectation(description: "When we call FetchPlanets function but get empty data back")
        let waitDuration = 2.0
        // mimic closure async feature and to run things on Main Thread
        DispatchQueue.main.asyncAfter(deadline: .now() +  waitDuration){
            
            XCTAssertNotNil(self.planetViewModel)
            
            // Assert that the number of filtered planets is 0 since no data is returned
            XCTAssertEqual(self.planetViewModel.filteredPlanetsList.count, 0)
            
            XCTAssertNotNil(self.planetViewModel.customError)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: waitDuration )
    }
    
    
    func testFetchPlanets_when_we_expect_itThrows_InvalidURL() throws {
        // Given
        let expectedError = NetworkError.invalidURL
        
        // When we fetch the planets
        planetViewModel.fetchPlanets(apiUrl: "")
        
        // Then
        let expectation = XCTestExpectation(description: "When we call FetchPlanets function then we are expecting it throws_InvalidURL")
        let waitDuration = 1.0
        // mimic closure async feature and to run things on Main Thread
        DispatchQueue.main.asyncAfter(deadline: .now() +  waitDuration){
            XCTAssertNotNil(self.planetViewModel)
            XCTAssertEqual(self.planetViewModel.filteredPlanetsList.count, 0)
            XCTAssertNotNil(self.planetViewModel.customError)
            XCTAssertEqual(self.planetViewModel.customError, expectedError)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: waitDuration )
    }
    
        
    
    func test_SearchListOfPlanets_with_empty_term() {
            
        // When we fetch the planets
            planetViewModel.fetchPlanets(apiUrl: "PlanetsList")

            // Then
            let expectation = XCTestExpectation(description: "When we call FetchPlanets function with an empty searchTerm then we are expecting the data is sorted and the filteredPlanet is Empty")
            let waitDuration = 1.0
            // mimic closure async feature and to run things on Main Thread
            DispatchQueue.main.asyncAfter(deadline: .now() +  waitDuration){
                // Verify that fetchPlanets completed successfully
                XCTAssertNotNil(self.planetViewModel.filteredPlanetsList)
                
                // Given
                self.planetViewModel.searchListOfPlanets(searchTerm: "")
                
                // Verify that the filtered list is not empty
                XCTAssertFalse(self.planetViewModel.filteredPlanetsList.isEmpty)
                
                // Verify that the filtered list count is equal with the filteredPlanetList count
                let filteredList = self.planetViewModel.filteredPlanetsList
                XCTAssertEqual(filteredList.count, self.planetViewModel.filteredPlanetsList.count)
                
                //confirm that the returned list of filteredPlanetList has the correct count of 10 values when searching empty search term
                XCTAssertEqual(filteredList.count, 10)
                
                // Confirm that the filtered list contains all the planets
                XCTAssertEqual(filteredList.map { $0.name }, ["Alderaan", "Bespin", "Coruscant", "Dagobah", "Endor", "Hoth", "Kamino", "Naboo", "Tatooine", "Yavin IV"])

                expectation.fulfill()
            }
            wait(for: [expectation], timeout: waitDuration )
        }
    
    
    func test_SearchListOfPlanets_with_valid_term() {


        // When we fetch the planets
        planetViewModel.fetchPlanets(apiUrl: "PlanetsList")

        // Then
        let expectation = XCTestExpectation(description: "When we call FetchPlanets function with an empty searchTerm then we are expecting the data is sorted and the filteredPlanet is Empty")
        let waitDuration = 1.0
        // mimic closure async feature and to run things on Main Thread
        DispatchQueue.main.asyncAfter(deadline: .now() +  waitDuration){
            // Verify that fetchPlanets completed successfully
            XCTAssertNotNil(self.planetViewModel.filteredPlanetsList)
            
            // Given
            self.planetViewModel.searchListOfPlanets(searchTerm: "T")
            
            // Verify that the filtered list is not empty
            XCTAssertFalse(self.planetViewModel.filteredPlanetsList.isEmpty)
            
            
            // Verify that the filtered list count is equal with the filteredPlanetList count
            let filteredList = self.planetViewModel.filteredPlanetsList.filter { $0.name.localizedCaseInsensitiveContains("T")}
            
            XCTAssertEqual(filteredList.count, self.planetViewModel.filteredPlanetsList.count)

            //confirm that the returned list of filteredPlanetList has the correct count of 3 values when searching by T
            XCTAssertEqual(filteredList.count, 3)
            
            // Confirm that the filtered list contains the expected planets
            XCTAssertEqual(filteredList.map { $0.name }, ["Coruscant", "Hoth", "Tatooine"])


            expectation.fulfill()
        }
        wait(for: [expectation], timeout: waitDuration )

    }
    
    
    func test_SearchListOfPlanets_with_InvalidTerm() {
        // When we fetch the planets
        planetViewModel.fetchPlanets(apiUrl: "PlanetsList")

        // Then
        let expectation = XCTestExpectation(description: "When we call FetchPlanets function but search data with invalidTerm so returns no data")
        let waitDuration = 1.0
        // mimic closure async feature and to run things on Main Thread
        DispatchQueue.main.asyncAfter(deadline: .now() +  waitDuration){
            
            // Verify that fetchPlanets completed successfully
            XCTAssertNotNil(self.planetViewModel.filteredPlanetsList)
            
            
            // Given following searchTerm
            self.planetViewModel.searchListOfPlanets(searchTerm: "foobar")
            
            // Verify that the filtered list count is equal with the filteredPlanetList count
            let filteredList = self.planetViewModel.filteredPlanetsList.filter { $0.name.localizedCaseInsensitiveContains("foobar")}
            XCTAssertEqual(filteredList.count, self.planetViewModel.filteredPlanetsList.count)
            
            
            //confirm that the returned list of filteredPlanetList has the correct count of 0 values when searching by foobar
            XCTAssertEqual(filteredList.count, 0)
            
            // Verify that the filtered list is empty
            XCTAssertTrue(self.planetViewModel.filteredPlanetsList.isEmpty)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: waitDuration )
    }
    
    func test_cancell_Combine_cancelAPICall() {
        // When we fetch the planets
        planetViewModel.fetchPlanets(apiUrl: "PlanetsList")
        planetViewModel.cancelAPICall()

        // Then
        let expectation = XCTestExpectation(description: "Thsi test expects the list to be empty")
        let waitDuration = 5.0
        // mimic closure async feature and to run things on Main Thread
        DispatchQueue.main.asyncAfter(deadline: .now() +  waitDuration){
            
            // Verify that fetchPlanets completed successfully
            XCTAssertNotNil(self.planetViewModel)
            
            // Verify the list is empty
            XCTAssertEqual(self.planetViewModel.filteredPlanetsList.count, 0)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: waitDuration )
    }
    
    
//    func testCancelAPICall() throws {
//            
//            listViewModel.getPlanetList(apiUrl: "PlanetList")
//            listViewModel.cancelApiCall()
//            
//            let expectation = XCTestExpectation(description: "This test expects the list to be empty")
//            let waitDuration = 5.0
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + waitDuration){
//                XCTAssertNotNil(self.listViewModel)
//                XCTAssertEqual(self.listViewModel.planetsList.count, 0)
//                expectation.fulfill()
//            }
//            
//            wait(for: [expectation], timeout: waitDuration)
//        }
    


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
