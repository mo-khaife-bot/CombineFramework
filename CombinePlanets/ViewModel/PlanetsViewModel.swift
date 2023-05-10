//
//  PlanetsViewModel.swift
//  CombinePlanets
//
//  Created by mohomed Ali on 05/05/2023.
//

import Foundation
import Combine


final class PlanetsViewModel: ObservableObject {
    
    // Source of truth load up as empty array in the beginning
    private var planetsList: [Result] = []
    
    @Published var filteredPlanetsList: [Result] = []
    
    
    @Published var customError: NetworkError?
    
    
    let networkAble: NetworkableProtocol
    private var cancelable = Set<AnyCancellable>()
    
    init(networkAble: NetworkableProtocol) {
        self.networkAble = networkAble
    }
    
    func fetchPlanets(apiUrl: String) {
        guard let url = URL(string: apiUrl) else {
            self.customError = .invalidURL

            self.filteredPlanetsList = []

            return
        }
        
        //need to access the big data then inside that find the array with the results we want
        self.networkAble.fetchPlantetsFromApi(url: url, type: PlanetPage.self)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                
                switch completion {
                    
                    
                case .finished:
                    print("done")
                    
                    
                case .failure(let error):
                    
                    switch error{
                    case .invalidURL:
                        self.customError = .invalidURL
                    case .parsingError:
                        self.customError = .parsingError
                    case .responseError:
                        self.customError = .responseError
                    default:
                        
//                        if ((error as? NetworkError) != nil){
//                            
//                        }
                        self.customError = .dataNotFoundError
                    }
                    print(self.customError?.localizedDescription as Any)
                    
                    
                    
                }
                
            }, receiveValue: { response in
                
                if !response.results.isEmpty {
                    
                    print(response.results)
                    self.filteredPlanetsList = response.results.sorted(by: {$0.name < $1.name})
                    self.planetsList = response.results
                    
                } else {
                    
                    // Handle empty response here
                    print("Empty response received")
                }
                
            })
            .store(in: &cancelable)
    }
    
    func searchListOfPlanets(searchTerm: String) {
        if (searchTerm.isEmpty){
            self.filteredPlanetsList = self.planetsList.sorted(by: {$0.name < $1.name})
            print("Search term is empty, populating filteredPlanetsList with all planets: \(self.filteredPlanetsList)")
            
        } else {
            let filteredList = self.planetsList.filter{ user in
                return user.name.localizedCaseInsensitiveContains(searchTerm)
            }
            self.filteredPlanetsList = filteredList.sorted(by: {$0.name < $1.name})
            
        }
       
      
    }
    
    // cancel Combine
    func cancelAPICall(){
        print("cancelAPICall")
        cancelable.first?.cancel()
    }
        
    
}
