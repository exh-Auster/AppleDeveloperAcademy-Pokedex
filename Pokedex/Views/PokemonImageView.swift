//
//  PokemonImageView.swift
//  Pokedex
//
//  Created by Felipe Ribeiro on 19/03/25.
//

import SwiftUI

struct PokemonImageView: View {
    let pokemon: Pokemon
    let outerWidth: Double
    
    var color: LinearGradient {
        let colors = pokemon.types.map { $0.associatedColor }
        
        return LinearGradient(colors: colors, startPoint: .bottom, endPoint: .top)
    }
    
    var body: some View {
        (UIImage(named: pokemon.id.description) != nil ? Image(pokemon.id.description) : Image(systemName: "photo")) // TODO: check
            .resizable()
            .scaledToFit()
            .frame(width: outerWidth / 2.5, height: outerWidth / 2.5)
            .clipShape(.rect)
            .frame(width: outerWidth, height: outerWidth)
            .overlay(
                Circle()
                //                        .stroke(.black, lineWidth: 1)
                //                        .stroke(pokemon.types.first!.associatedColor, lineWidth: 1)
                    .stroke(color, lineWidth: outerWidth / 50)
            )
    }
}

//#Preview {
//    let pokemon = Pokemon(id: 0, name: "Test", types: [.bug, .dark, .dragon, .fighting])
//    
//    PokemonImageView(pokemon: pokemon, outerWidth: 300)
//}

struct PokemonImageView_Previews: PreviewProvider {
    static let pokemon = Pokemon(id: 0, name: "Test", types: [.bug, .dark, .dragon, .fighting])
    
    static var previews: some View {
        PokemonImageView(pokemon: pokemon, outerWidth: 300)
    }
}
