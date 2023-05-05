//
//  ContentView.swift
//  CombinePlanets
//
//  Created by mohomed Ali on 05/05/2023.
//

import SwiftUI
import Combine

struct PlanetsListView: View {
    
    @StateObject var viewModel = PlanetsViewModel(networkAble: NetworkManager())
    
    var body: some View {
        
        NavigationStack{
            VStack {
                
                List(viewModel.planetsList) { planet in
                    NavigationLink{
                        PlanetsDetailView(planetName: planet.name, planetOrbitPeriod: planet.orbitalPeriod, planetClimate: planet.climate, planetGravity: planet.gravity, planetPopulation: planet.population)
                    } label: {
                        Text(planet.name )
                    }
                    
                    
                }
            }.refreshable {
                viewModel.fetchPlanets(apiUrl: APIEndpoint.planetsAPI)
            }.onAppear(){
                viewModel.fetchPlanets(apiUrl: APIEndpoint.planetsAPI)
            }
            .padding()
        }
    }
}

struct PlanetsListView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetsListView()
    }
}
