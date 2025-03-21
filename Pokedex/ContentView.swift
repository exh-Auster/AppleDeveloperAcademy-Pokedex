//
//  ContentView.swift
//  Pokedex
//
//  Created by Felipe Ribeiro on 19/03/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var store = PokemonStore()
    @State var isPresented = true
    @State var user: User = .ash
    
    var body: some View {
//        TabView {
//            Tab("Pokedex", systemImage : "magazine") {
//                PokedexView()
//            }
//            Tab("Estatisticas", systemImage : "chart.xyaxis.line") {
//                StatisticsView()
//            }
//        }
        
        TabView {
            PokedexView()
                .tabItem {
                    Label("Pokédex", systemImage: "magazine")
                }
            
            StatisticsView()
                .tabItem {
                    Label("Estatísticas", systemImage: "chart.xyaxis.line")
                }
        }
        .environmentObject(store)
        .sheet(isPresented: $isPresented) {
            VStack(spacing: 20) {
                let caughtPokemons = store.pokemons.filter { user.presetCaughtPokemons.contains($0.id) }
                let randomPokemonID = caughtPokemons.randomElement()?.id ?? 1
                
                Image(String(randomPokemonID))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                //                    .clipShape(Circle())
                //                    .shadow(radius: 5)
                
                Text("Welcome back!")
                    .font(.title)
                    .fontWeight(.bold)
                
                VStack(spacing: 15) {
                    ForEach(User.allCases, id: \.self) { user in
                        Button(action: { self.user = user }) {
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 50, height: 50)
                                    
                                    if user == .ash {
                                        Image("ash")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    } else {
                                        Text(String(user.rawValue.prefix(1)).uppercased())
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(.trailing, 6)
                                
                                Text(user.rawValue.capitalized)
                                    .font(.headline)
                                    .foregroundColor(user == self.user ? .blue : .primary)
                                
                                Spacer()
                                
                                if user == self.user {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                            }
                        }
                    }
                }
                .padding()
                
                Button {
                    store.selectedUser = user
                    isPresented = false
                } label: {
                    Text("Log in")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .shadow(radius: 3)
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

//#Preview {
//    ContentView()
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
