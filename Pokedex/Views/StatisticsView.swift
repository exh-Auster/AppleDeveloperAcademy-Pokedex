//
//  StatisticsView.swift
//  Pokedex
//
//  Created by Felipe Ribeiro on 19/03/25.
//

import SwiftUI

struct TypeData { // TODO: dict?
    var store: PokemonStore // TODO: Environment?
    
    let type: ElementType
    
    var total: Double {
        Double(store.pokemons.count { pokemon in
            pokemon.types.contains(type)
        })
    }
    
    var caught: Double {
        Double(store.pokemons.count { pokemon in
            pokemon.types.contains(type) && pokemon.isCaught
        })
    }
}

struct StatisticsView : View {
    @EnvironmentObject var store: PokemonStore
    
    private var numberOfPokemon: Double { Double(store.pokemons.count)
    }
    
    private var caughtCount: Double {
        Double(store.pokemons.count(where: { $0.isCaught } ))
    }
    
    var body: some View {
        List {
            //            TODO: Gauge labels - string interpolation vs. format:?
            Gauge(value: caughtCount, in: 0...numberOfPokemon) {
                Text("Total")
            } currentValueLabel: {
                //            Text("\(Int(caughtCount))")
                Text(caughtCount, format: .number)
            } minimumValueLabel: {
                //            Text("\(Int(0))")
                Text(0, format: .number)
            } maximumValueLabel: {
                //            Text("\(Int(numberOfPokemon))")
                Text(numberOfPokemon, format: .number)
            }
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) { // TODO: check
                ForEach(ElementType.allCases, id: \.self) { type in
                    let data = TypeData(store: store, type: type)
                    
                    Gauge(value: data.caught, in: 0...data.total) {
                        Text(type.rawValue.capitalized)
                    } currentValueLabel: {
                        Text(data.caught, format: .number)
//                    } minimumValueLabel: {
////                        Text(0, format: .number)
//                        Text("") // TODO: check
//                    } maximumValueLabel: {
//                        Text(data.total, format: .number)
                    }
                    .tint(type.associatedColor)
                    .gaugeStyle(.accessoryLinearCapacity)
                }
                .padding(.vertical, 5)
            }
        }
    }
}

//#Preview {
//    StatisticsView()
//}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}

/*
 https://developer.apple.com/design/human-interface-guidelines/gauges
 https://developer.apple.com/documentation/swiftui/gauge
 
 https://www.hackingwithswift.com/read/0/5/string-interpolation
 https://developer.apple.com/documentation/swiftui/text/init(_:format:)
 
 https://stackoverflow.com/questions/27706832/can-swift-enums-have-multiple-raw-values
 */
