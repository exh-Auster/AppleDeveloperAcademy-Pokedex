//
//  ContentView.swift
//  Pokedex
//
//  Created by Felipe Ribeiro on 19/03/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Pokedex", systemImage : "magazine") {
                PokedexView()
            }
            Tab("Estatisticas", systemImage : "chart.xyaxis.line") {
                StatisticsView()
            }
        }
    }
}

#Preview {
    ContentView()
}
