//
//  PokedexView.swift
//  Pokedex
//
//  Created by Felipe Ribeiro on 19/03/25.
//

import SwiftUI

struct PokedexView : View {

    var body : some View {
//        Text("Pokedex")
        ForEach(pokemons) { pokemon in
            VStack {
                Text(pokemon.name)
                Text(pokemon.types.count, format: .number)
                
            }
        }
    }
}

#Preview {
    PokedexView()
}
