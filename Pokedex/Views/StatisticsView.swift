//
//  StatisticsView.swift
//  Pokedex
//
//  Created by Felipe Ribeiro on 19/03/25.
//

import SwiftUI

struct StatisticsView : View {
    var body : some View {
//        Text("Estatisticas")
        Text("Caught: \(pokemons.count(where: { $0.isCaught }))")
    }
}

#Preview {
    StatisticsView()
}
