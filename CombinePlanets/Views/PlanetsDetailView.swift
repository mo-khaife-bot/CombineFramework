//
//  PlanetsDetailView.swift
//  CombinePlanets
//
//  Created by mohomed Ali on 05/05/2023.
//

import SwiftUI

struct PlanetsDetailView: View {
    
    // containers for where the data will go
    let planetName : String
    let planetOrbitPeriod : String
    let planetClimate : String
    let planetGravity : String
    let planetPopulation : String
    
    let dimensions: Double = 200
    
    var body: some View {
        VStack{
            Text(planetName).font(.system(size: 25, weight: .bold, design: .monospaced)).padding(20)
            AsyncImage(url: URL(string: "https://picsum.photos/200")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: dimensions, height: dimensions)
                                    .clipShape(Circle())
                            } else if phase.error != nil {
                                Text("Failed to load image")
                            } else {
                                ProgressView().frame(width: dimensions, height: dimensions).background(.thinMaterial)
                            }
                    
            }.padding()
            
            
            Text("Orbital Period \(planetOrbitPeriod)")
            Text("Climate: \(planetClimate)")
            Text("Gravity: \(planetGravity)")
            Text("Population: \(planetOrbitPeriod)")
            
        }
    }
}

struct PlanetsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetsDetailView(planetName: "Tatooine", planetOrbitPeriod: "304", planetClimate: "arid", planetGravity: "1 standard", planetPopulation: "200000")
    }
}
