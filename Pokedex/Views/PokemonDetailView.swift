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
                
                Divider()
                    .padding()
                
                Text(pokemon.description ?? """
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
                    """)
//                .multilineTextAlignment(.center)

                if !pokemon.types.flatMap({ $0.associatedStrengths + $0.associatedWeaknesses }).isEmpty {
                    Divider()
                        .padding()
                    
                    HStack {
                        if !pokemon.types.flatMap({ $0.associatedStrengths }).isEmpty {
                            VStack {
                                Text("Strong against")
                                    .font(.title2)
                                ForEach(pokemon.types, id: \.self) { type in
                                    ForEach(type.associatedStrengths, id: \.self) { strength in
                                        PokemonTypeCard(type: strength, withFixedWidth: true)
                                    }
                                }
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, alignment: .top)
                        }
                        
                        if !pokemon.types.flatMap({ $0.associatedWeaknesses }).isEmpty {
                            VStack {
                                Text("Weak against")
                                    .font(.title2)
                                ForEach(pokemon.types, id: \.self) { type in
                                    ForEach(type.associatedWeaknesses, id: \.self) { weakness in
                                        PokemonTypeCard(type: weakness, withFixedWidth: true)
                                    }
                                }
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, alignment: .top)
                        }
                    }
                    .font(.headline)
                }
                
                if !pokemon.evolutions.isEmpty {
                    Divider()
                        .padding()
                    
                    EvolutionView(pokemon: pokemon)
                }
            }
            .navigationTitle(pokemon.name.capitalized)
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
    var withFixedWidth: Bool = false

    var body: some View {
        Text(type.rawValue.uppercased())
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .frame(width: withFixedWidth ? 100 : nil)
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

