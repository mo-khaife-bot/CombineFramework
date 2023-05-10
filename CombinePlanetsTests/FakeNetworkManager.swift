//
//  FakeNetworkManager.swift
//  CombinePlanetsTests
//
//  Created by mohomed Ali on 08/05/2023.
//

import Foundation
import Combine
@testable import CombinePlanets

/**
 The FakeNetworkManager class implements the NetworkableProtocol and overrides the fetchPlantetsFromApi method.  The protocol requires a function called fetchPlantetsFromApi that takes a URL and a type, and returns an AnyPublisher that emits a value of the given type, or an error of type CombinePlanets.NetworkError. The given type is expected to conform to Decodable.
 
 Inside the fetchPlantetsFromApi function, the code first tries to read JSON data from a file specified by the URL, using a guard statement to return an error if the file path is invalid. If the data is successfully read, it is decoded to an instance of the given type using a JSONDecoder.
 
 If the decoding succeeds, an instance of Just is used to create a publisher that emits the decoded value. setFailureType is called to change the error type from Error to NetworkError, and mapError is used to map any errors to a specific type of NetworkError called parsingError. Finally, eraseToAnyPublisher is called to convert the publisher to the required AnyPublisher type.

 If the decoding fails, the function returns a publisher created by Fail, which emits an error of type NetworkError.dataNotFoundError.
 
 */

class FakeNetworkManager:NetworkableProtocol {
    func fetchPlantetsFromApi<T>(url: URL, type: T.Type) -> AnyPublisher<T, CombinePlanets.NetworkError> where T : Decodable {
        // read the data from JSON
        do{
            let bundle = Bundle(for: FakeNetworkManager.self)
            guard let path = bundle.url(forResource: url.absoluteString, withExtension: "json") else {
                return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
            }
            let data = try Data(contentsOf: path)
            let planetList = try JSONDecoder().decode(T.self, from: data)
            return Just(planetList).setFailureType(to: NetworkError.self).mapError { _ in
                NetworkError.responseError }.eraseToAnyPublisher()
        } catch {
            return Fail(error: NetworkError.dataNotFoundError).eraseToAnyPublisher()
            
        }
    }
    

}
