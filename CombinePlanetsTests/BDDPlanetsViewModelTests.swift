//
//  BDDPlanetsViewModelTests.swift
//  CombinePlanetsTests
//
//  Created by mohomed Ali on 15/05/2023.
//

import Foundation
import Quick
import Nimble
@testable import CombinePlanets

class BDDPlanetsViewModelTests: QuickSpec{
    
    override class func spec() {
        describe("Testing Buisness Logic for PokemonViewModel"){ //the class/ struct for whichwe are writing test cases
            context("Instead of API call we are reading local json files") { // which context/condition ur testing PokemonviewModel
                
                beforeEach {
                    print("beforeEach")
                }
                
                afterEach {
                    print("afterEach")
                }
                //1
                it("When calling getListOfPokemons func with corrct URLs it should populate pokemonList with data on successful response") {
            
                        // Arrange
                        let planetViewModel =  PlanetsViewModel(networkAble: FakeNetworkManager())
                        
                        
                        // Act
                        planetViewModel.fetchPlanets(apiUrl: "PlanetsList")
                        
                        
                        // Assert
                    DispatchQueue.main.async {
                        let planetList =  planetViewModel.filteredPlanetsList
                        expect(planetViewModel).toNot(beNil()) // confirm fetching worked
                        expect(planetList.count).to(equal(10))
                        expect(planetList.first?.name).to(equal("Alderaan"))
                        expect(planetList).toNot(beEmpty())
                        
                        
                        let error =  planetViewModel.customError
                        expect(error).to(equal(nil))
                        expect(error).to(beNil())
                    }
                        
                        
           
                }
                
                //2
                it("should set customError to .parsingError on parsing Error") {

                        // Arrange
                        let planetViewModel =  PlanetsViewModel(networkAble: FakeNetworkManager())


                        // Act
                        planetViewModel.fetchPlanets(apiUrl: "PlanetsListParsingError")
                       

                        // Assert
                    DispatchQueue.main.async {
                        let planetList =  planetViewModel.filteredPlanetsList
                        expect(planetViewModel).toNot(beNil()) // confirm fetching worked
                        expect(planetList.count).to(equal(0))
                        expect(planetList).to(beEmpty())
                        
                        
                        let error =  planetViewModel.customError
                        expect(error).to(equal(NetworkError.parsingError))
                        
                    }
                }
                
            }
        }
    }
    
}

    

