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
//    @State private var searchTokens: [ElementType] = []
    
    var body: some View {
        NavigationView {
            //        Text("Pokedex")
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(store.filteredPokemon(pokemons: store.pokemons, searchText: searchText, tokens: store.tokens)) { pokemon in
                        NavigationLink {
                            PokemonDetailView(pokemon: pokemon)
                        } label: {
                            PokemonCardView(pokemon: pokemon)
                        }
                    }
                }
                //            .edgesIgnoringSafeArea(.horizontal)
            }
            .navigationTitle("Pokedex")
            .searchable(text: $searchText, tokens: $store.tokens, suggestedTokens: .constant(ElementType.allCases), token: { token in
                Text(token.rawValue)
            })
        }
    }
}

struct PokemonCardView: View {
    let pokemon: Pokemon
    
    var body: some View {
        Text(pokemon.name)
    }
}

//#Preview {
//    PokedexView()
//}

struct PokedexView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexView()
    }
}
