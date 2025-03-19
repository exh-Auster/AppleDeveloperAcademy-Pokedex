//
//  PokedexView.swift
//  Pokedex
//
//  Created by Felipe Ribeiro on 19/03/25.
//

import SwiftUI

struct PokedexView : View {
    
    var body: some View {
        //        Text("Pokedex")
        ForEach(pokemons) { pokemon in
            PokemonCardView(pokemon: pokemon)
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
