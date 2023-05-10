//
//  ContentView.swift
//  CombinePlanets
//
//  Created by mohomed Ali on 05/05/2023.
//

import SwiftUI
import Combine

struct PlanetsListView: View {
    
    enum ViewState {
        case list, cancelConfirmation
    }
    
    @StateObject var viewModel = PlanetsViewModel(networkAble: NetworkManager())
    @State var searchText : String = ""
    
    @State var viewState: ViewState = .list
    
    var body: some View {
        
        NavigationStack{
            VStack {
                switch viewState {
                case .list:
                    Button("Cancel Ongoing Request"){
                        viewState = .cancelConfirmation
                    }
                case .cancelConfirmation:
                    Text("Are you sure you want to cancel the request?")
                        .padding()
                    HStack {
                        Button("Yes") {
                            viewModel.cancelAPICall()
                            viewState = .list
                        }
                        Button("No") {
                            viewState = .list
                        }
                    }
                }
                
                if viewState == .list {
                    List(viewModel.filteredPlanetsList) { planet in
                        NavigationLink{
                            PlanetsDetailView(planetName: planet.name, planetOrbitPeriod: planet.orbitalPeriod, planetClimate: planet.climate, planetGravity: planet.gravity, planetPopulation: planet.population)
                        } label: {
                            HStack{
                                AsyncImage(url: URL(string: "https://picsum.photos/200")) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    } else if phase.error != nil {
                                        Text("Failed to load image")
                                    } else {
                                        ProgressView().frame(width: 50, height: 50).background(.thinMaterial)
                                    }
                                }.padding(.trailing, 20)
                                Text(planet.name )
                            }
                        }
                    }
                }
            }.refreshable {
                viewModel.fetchPlanets(apiUrl: APIEndpoint.planetsAPI)
            }.onAppear(){
                viewModel.fetchPlanets(apiUrl: APIEndpoint.planetsAPI)
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onChange(of: searchText, perform: { searchWord in
                print(searchWord)
                viewModel.searchListOfPlanets(searchTerm: searchWord)
            })
            .padding()
        }
    }
}

struct PlanetsListView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetsListView()
    }
}
