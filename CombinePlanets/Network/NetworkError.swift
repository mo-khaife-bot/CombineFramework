//
//  NetworkError.swift
//  CombinePlanets
//
//  Created by mohomed Ali on 05/05/2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case dataNotFoundError
    case parsingError
    case responseError
}

extension NetworkError: LocalizedError{
    var errorDescription: String?{
        switch self{
            
        case .invalidURL:
            return  NSLocalizedString("API endpoint is Invalid", comment: "invalidURL")
        case .dataNotFoundError:
            return  NSLocalizedString("Failed to get Data from API", comment: "dataNotFoundError")
        case .parsingError:
            return  NSLocalizedString("Failed to parse Data from API", comment: "parsingError")
        case .responseError:
            return  NSLocalizedString("Invalid response from API", comment: "responseError")
        }
    }
}
