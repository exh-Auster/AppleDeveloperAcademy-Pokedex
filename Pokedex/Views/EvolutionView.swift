//
//  EvolutionView.swift
//  Pokedex
//
//  Created by Felipe Ribeiro on 20/03/25.
//

import SwiftUI

struct EvolutionView: View {
    var pokemon: Pokemon
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Evolutions") // FIXME: alignment
                .font(.title2)
                .padding(.horizontal)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(pokemon.evolutions) { pokemon in
                        NavigationLink {
                            PokemonDetailView(pokemon: pokemon)
                        } label: {
                            PokemonCardView(pokemon: pokemon)
                        }
                    }
                    .padding(.horizontal, 10)
                }
                .padding()
            }
        }
    }
}

#Preview {
    EvolutionView(pokemon: pokemonRawData[132])
}
