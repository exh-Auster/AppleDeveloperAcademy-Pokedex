//
//  PokedexView.swift
//  Pokedex
//
//  Created by Felipe Ribeiro on 19/03/25.
//

import SwiftUI

struct PokedexView : View {
    @EnvironmentObject var store: PokemonStore
    
    @State private var searchText: String = ""
    @State private var filter: Bool = true
    
    var body: some View {
        NavigationView {
            //        Text("Pokedex")
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(store.filteredPokemon(pokemons: store.pokemons, searchText: searchText, tokens: store.tokens, caughtOnly: filter)) { pokemon in
                        NavigationLink {
                            PokemonDetailView(pokemon: pokemon)
                        } label: {
                            PokemonCardView(pokemon: pokemon)
                        }
                    }
                }
                .padding()
                //            .edgesIgnoringSafeArea(.horizontal)
            }
            .navigationTitle("Pokedex")
            .searchable(text: $searchText, tokens: $store.tokens, suggestedTokens: .constant(ElementType.allCases), token: { token in
                Text(token.rawValue)
            })
            .toolbar {
                Button("Filter caught only", systemImage: filter ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle") {
                    filter.toggle()
                }
            }
        }
    }
}

struct PokemonCardView: View {
    let pokemon: Pokemon
    
    var color: LinearGradient {
        let colors = pokemon.types.map { $0.associatedColor }
        
        return LinearGradient(colors: colors, startPoint: .bottom, endPoint: .top)
    }
    
    var body: some View {
        VStack {
            PokemonImageView(pokemon: pokemon, outerWidth: 100)
            
            Text("#\(pokemon.id)")
                .font(.caption2)
                .padding(.top, 1)
            Text(pokemon.name.capitalized)
                .padding(.bottom)
        }
    }
}

//#Preview {
//    PokedexView()
//}

struct PokedexView_Previews: PreviewProvider {
    static let store = PokemonStore(user: .ash)
    
    static var previews: some View {
        PokedexView()
            .environmentObject(store)
    }
}

/*
 https://developer.apple.com/documentation/swiftui/adding-a-search-interface-to-your-app
 https://developer.apple.com/documentation/swiftui/performing-a-search-operation
 https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-search-tokens-to-a-search-field
 https://www.hackingwithswift.com/quick-start/swiftui/how-to-draw-a-border-around-a-view
 */
