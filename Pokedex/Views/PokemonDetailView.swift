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
                PokemonImageView(pokemon: pokemon, outerWidth: 250)
                    .padding()
                
                HStack {
                    ForEach(pokemon.types, id: \.self) { type in
                        PokemonTypeCard(type: type)
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
            .padding()
        }
    }
}

struct PokemonTypeCard: View {
    let type: ElementType

    var body: some View {
        Text(type.rawValue.uppercased())
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(type.associatedColor.gradient)
            )
            .overlay(
                Capsule()
                    .stroke(type.associatedColor)
            )
            .padding(2)
    }
}

//#Preview {
//    PokemonDetailView()
//}

struct PokemonDetailView_Previews: PreviewProvider {
    static let store = PokemonStore()
    
    static var previews: some View {
        PokemonDetailView(pokemon: store.pokemons.first!)
            .environmentObject(store)
    }
}
