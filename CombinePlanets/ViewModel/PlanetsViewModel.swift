//
//  PlanetsViewModel.swift
//  CombinePlanets
//
//  Created by mohomed Ali on 05/05/2023.
//

import Foundation
import Combine

//final class PlanetsViewModel: ObservableObject {
//
//    // Source of truth load up as empty array in the biginning
//    @Published var planetsList: [Result] = []
//
//
//    let networkAble : NetworkableProtocol
//    private var cancelable = Set<AnyCancellable>()
//
//    init(networkAble: NetworkableProtocol) {
//        self.networkAble = networkAble
//    }
//
//    func fetchPlanets(apiUrl: String) {
//        guard let url = URL(string: apiUrl) else {
//            return
//        }
//
//        self.networkAble.fetchPlantetsFromApi(url: url, type: Result.self)
//            .receive(on: RunLoop.main)
//            .sink { completion in
//                switch completion{
//
//                case .finished:
//                    print("done")
//
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//
//            } receiveValue: { result  in
//                if let planets = result {
//                    print(planets)
//                    self.planetsList = [planets]
//                } else {
//                    // Handle empty response here
//                           print("Empty response received")
//                }
//
//            }.store(in: &cancelable)
//
//    }
//
//}

final class PlanetsViewModel: ObservableObject {
    
    // Source of truth load up as empty array in the beginning
    @Published var planetsList: [Result] = []
    @Published var customError: NetworkError?
    
    let networkAble: NetworkableProtocol
    private var cancelable = Set<AnyCancellable>()
    
    init(networkAble: NetworkableProtocol) {
        self.networkAble = networkAble
    }
    
    func fetchPlanets(apiUrl: String) {
        guard let url = URL(string: apiUrl) else {
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
                    print(self.customError?.localizedDescription)
                    
                    
                    
                }
                
            }, receiveValue: { response in
                
                if !response.results.isEmpty {
                    
                    print(response.results)
                    
                    self.planetsList = response.results
                    
                } else {
                    
                    // Handle empty response here
                    print("Empty response received")
                }
                
            })
            .store(in: &cancelable)
    }
}
