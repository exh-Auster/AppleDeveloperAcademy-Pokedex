//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Felipe Ribeiro on 19/03/25.
//

import SwiftUI

struct PokemonDetailView: View {
    @EnvironmentObject var store: PokemonStore
    @State var pokemon: Pokemon
    
    var body: some View {
        ScrollView {
            VStack {
                Image(systemName: "lizard")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200)
                
                Text(pokemon.name.capitalized)
                    .font(.title)
                
                HStack {
                    ForEach(pokemon.types, id: \.self) { type in
                        Text(type.rawValue.capitalized) // TODO: full caps; capsule
                    }
                }
                
                Text("""
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
""")
                .multilineTextAlignment(.center)
            }
            .navigationTitle(pokemon.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                let isCaught = pokemon.isCaught
                
                Button(isCaught ? "Remove" : "Add", systemImage: isCaught ? "checkmark.circle.fill" : "plus.circle") {
                    pokemon.isCaught.toggle() // FIXME: remove
                    store.toggleCaughtStatus(for: pokemon)
                }
            }
        }
    }
}

//#Preview {
//    PokemonDetailView(pokemon: store.pokemons.randomElement()!)
//}
