//
//  NetworkManager.swift
//  CombinePlanets
//
//  Created by mohomed Ali on 05/05/2023.
//

import Foundation
import Combine


class NetworkManager: NetworkableProtocol {
    
    func fetchPlantetsFromApi<T>(url: URL, type: T.Type) -> AnyPublisher<T, NetworkError> where T : Decodable {
        return URLSession.shared.dataTaskPublisher(for: url)
            .delay(for: .seconds(5.0), scheduler: DispatchQueue.main) // delay added to enable enough time to Cancel
            .tryMap{ (data: Data, response: URLResponse) in
                guard let httpResponse = response as? HTTPURLResponse, 200...209 ~= httpResponse.statusCode else {
                    throw NetworkError.responseError
//                    return Fail<Any, NetworkError>(error: NetworkError.responseError)
//                        .eraseToAnyPublisher()
                    
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError{error in
                switch error{
                case is URLError:
                    return .invalidURL
                case is DecodingError:
                    return .parsingError
//                    case is NetworkError.r:
//                        self.customError = .responseError
                default:
//                    
//                    if ((error as? NetworkError) != nil){
//                        
//                    }
                    return .dataNotFoundError
                }
//                return error as! NetworkError
            }
            .eraseToAnyPublisher()

                    
    }
    
    
}
