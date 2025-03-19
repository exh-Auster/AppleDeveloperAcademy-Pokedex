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
            VStack {
                ForEach(pokemons) { pokemon in
                    NavigationLink {
                        Text("Placeholder: \(pokemon.id)")
                    } label: {
                        PokemonCardView(pokemon: pokemon)
                    }
                }
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
