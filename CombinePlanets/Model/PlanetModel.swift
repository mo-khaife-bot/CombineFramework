//
//  PlanetModel.swift
//  CombinePlanets
//
//  Created by mohomed Ali on 05/05/2023.
//

import Foundation

// MARK: - PlanetData
struct PlanetPage: Decodable {

    let count: Int
    let next: String
    let previous: URL?
    let results: [Result]
}

// MARK: - Result for PARSING
struct Result: Decodable,Identifiable, Equatable{
    let id = UUID()

    let name, rotationPeriod, orbitalPeriod, diameter: String
    let climate, gravity, terrain, surfaceWater: String
    let population: String
    let residents, films: [String]
    let created, edited: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case name
        case rotationPeriod = "rotation_period"
        case orbitalPeriod = "orbital_period"
        case diameter, climate, gravity, terrain
        case surfaceWater = "surface_water"
        case population, residents, films, created, edited, url
    }
}

// MARK: - Result - for UI
//struct ResultDetails: Decodable, Identifiable {
//    let id = UUID()
//    let name, rotationPeriod, orbitalPeriod, diameter: String
//    let climate, gravity, terrain, surfaceWater: String
//    let population: String
//    let residents, films: [String]
//    let created, edited: String
//    let url: String
//
//    enum CodingKeys: String, CodingKey {
//        case name
//        case rotationPeriod = "rotation_period"
//        case orbitalPeriod = "orbital_period"
//        case diameter, climate, gravity, terrain
//        case surfaceWater = "surface_water"
//        case population, residents, films, created, edited, url
//    }
//}



