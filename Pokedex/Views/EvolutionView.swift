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
        Text("Evolutions") // FIXME: alignment
            .font(.title)
        
        ScrollView {
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(pokemon.evolutions) { pokemon in
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
        //    }
    }
}

#Preview {
    EvolutionView(pokemon: pokemonRawData[0])
}
