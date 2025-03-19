//
//  StatisticsView.swift
//  Pokedex
//
//  Created by Felipe Ribeiro on 19/03/25.
//

import SwiftUI

struct StatisticsView : View {
    private var numberOfPokemon = Double(pokemons.count)
    private var caughtCount = Double(pokemons.count(where: { $0.isCaught } ))


    var body: some View {
        Gauge(value: caughtCount, in: 0...numberOfPokemon) {
            Text("Capturados")
        } currentValueLabel: {
//            TODO: String interpolation vs. format:?
//            Text("\(Int(caughtCount))")
            Text(caughtCount, format: .number)
        } minimumValueLabel: {
//            Text("\(Int(0))")
            Text(0, format: .number)
        } maximumValueLabel: {
//            Text("\(Int(numberOfPokemon))")
            Text(numberOfPokemon, format: .number)
        }
    }
}

#Preview {
    StatisticsView()
}

/*
 https://developer.apple.com/design/human-interface-guidelines/gauges
 https://developer.apple.com/documentation/swiftui/gauge
 
 https://www.hackingwithswift.com/read/0/5/string-interpolation
 https://developer.apple.com/documentation/swiftui/text/init(_:format:)
 */
