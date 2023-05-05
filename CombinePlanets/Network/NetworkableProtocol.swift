//
//  NetworkableProtocol.swift
//  CombinePlanets
//
//  Created by mohomed Ali on 05/05/2023.
//

import Foundation
import Combine

protocol NetworkableProtocol {
    
    func fetchPlantetsFromApi<T:Decodable>(url:URL, type:T.Type) -> AnyPublisher<T, NetworkError>
}
