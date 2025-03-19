//
//  PokedexView.swift
//  Pokedex
//
//  Created by Felipe Ribeiro on 19/03/25.
//

import SwiftUI

struct PokedexView : View {
    var body: some View {
        NavigationView {
            //        Text("Pokedex")
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(pokemons) { pokemon in
                        NavigationLink {
                            Text("Placeholder: \(pokemon.id)")
                        } label: {
                            PokemonCardView(pokemon: pokemon)
                        }
                    }
                }
                //            .edgesIgnoringSafeArea(.horizontal)
            }
            .navigationTitle("Pokedex")
        }
    }
}

struct PokemonCardView: View {
    let pokemon: Pokemon
    
    var body: some View {
        Text(pokemon.name)
    }
}

#Preview {
    PokedexView()
}
