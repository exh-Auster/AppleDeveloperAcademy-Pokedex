// By: Deepseek

import SwiftUICore

enum ElementType: String, CaseIterable, Identifiable {
    case grass
    case poison
    case fire
    case flying
    case water
    case bug
    case normal
    case electric
    case ground
    case fairy
    case psychic
    case rock
    case ice
    case dragon
    case dark
    case steel
    case fighting
    case ghost
    
    var id: Self { self }
    
    var associatedColor: Color { // TODO: check
        switch self {
        case .grass: return Color.green
        case .poison: return Color.purple
        case .fire: return Color.red
        case .flying: return Color.blue
        case .water: return Color.blue
        case .bug: return Color.green
        case .normal: return Color.gray
        case .electric: return Color.yellow
        case .ground: return Color.brown
        case .fairy: return Color.pink
        case .psychic: return Color.purple
        case .rock: return Color.brown
        case .ice: return Color.cyan
        case .dragon: return Color.blue
        case .dark: return Color.black
        case .steel: return Color.gray
        case .fighting: return Color.red
        case .ghost: return Color.purple
        }
    }
    
    var associatedWeaknesses: [ElementType] {
        switch self {
        case .grass: return [.fire, .ice, .poison, .flying, .bug]
        case .poison: return [.ground, .psychic]
        case .fire: return [.water, .ground, .rock]
        case .flying: return [.electric, .ice, .rock]
        case .water: return [.electric, .grass]
        case .bug: return [.fire, .flying, .rock]
        case .normal: return [.fighting]
        case .electric: return [.ground]
        case .ground: return [.water, .ice, .grass]
        case .fairy: return [.steel, .poison]
        case .psychic: return [.bug, .ghost, .dark]
        case .rock: return [.water, .grass, .fighting, .ground, .steel]
        case .ice: return [.fire, .fighting, .rock, .steel]
        case .dragon: return [.ice, .dragon, .fairy]
        case .dark: return [.fighting, .bug, .fairy]
        case .steel: return [.fire, .fighting, .ground]
        case .fighting: return [.flying, .psychic, .fairy]
        case .ghost: return [.ghost, .dark]
        }
    }
    
    var associatedStrengths: [ElementType] {
        switch self {
        case .grass: return [.water, .ground, .rock]
        case .poison: return [.grass, .fairy]
        case .fire: return [.grass, .bug, .ice, .steel]
        case .flying: return [.grass, .fighting, .bug]
        case .water: return [.fire, .ground, .rock]
        case .bug: return [.grass, .psychic, .dark]
        case .normal: return []
        case .electric: return [.water, .flying]
        case .ground: return [.fire, .electric, .poison, .rock, .steel]
        case .fairy: return [.fighting, .dragon, .dark]
        case .psychic: return [.fighting, .poison]
        case .rock: return [.fire, .ice, .flying, .bug]
        case .ice: return [.grass, .ground, .flying, .dragon]
        case .dragon: return [.dragon]
        case .dark: return [.psychic, .ghost]
        case .steel: return [.rock, .ice, .fairy]
        case .fighting: return [.normal, .rock, .steel, .ice, .dark]
        case .ghost: return [.psychic, .ghost]
        }
    }
}

enum User: String, CaseIterable, Identifiable {
    case ash
    case diego
    case juliana
    
    var id: Self { self }
    
    var presetCaughtPokemons: [Int] {
        switch self {
        case .ash:
            return [25, 1, 4, 7, 16, 131, 143]
        case.diego:
            return [3, 6, 9, 31, 34, 57, 59, 65, 94, 106, 107, 126, 149, 151] // 94 FAV
        case .juliana:
            return [1, 4, 7, 12, 25, 39, 54, 77, 143] // 1, 54 FAV
        }
    }
}

struct Pokemon: Identifiable {
    var id: Int
    var name: String
    var types: [ElementType]
    var isCaught: Bool = Bool.random() // TODO: remove random default value
    var evolutionIds: [Int] = []
    var evolutions: [Pokemon] {
        evolutionIds.map { i in
            pokemonRawData[i - 1]
        }
    }
}

class PokemonStore: ObservableObject {
    @Published var tokens: [ElementType] = []
    
    @Published var selectedUser: User = .ash {
        didSet { loadPokemons(for: selectedUser) }
    }
    
    @Published var pokemons: [Pokemon] = []
    
    init() {
        loadPokemons(for: selectedUser)
    }
    
    func loadPokemons(for user: User) {
        pokemons = pokemonRawData.map { pokemon in
            var newPokemon = pokemon
            newPokemon.isCaught = user.presetCaughtPokemons.contains(pokemon.id)
            return newPokemon
        }
    }
    
    func toggleCaughtStatus(for pokemon: Pokemon) {
        if let index = pokemons.firstIndex(where: { $0.id == pokemon.id }) {
            pokemons[index].isCaught.toggle()
        }
    }
    
    func filteredPokemon(
        pokemons: [Pokemon],
        searchText: String,
        tokens: [ElementType],
        caughtOnly: Bool = false
    ) -> [Pokemon] {
        print(tokens)
        guard !searchText.isEmpty || !tokens.isEmpty else {
            return caughtOnly ? pokemons.filter { $0.isCaught } : pokemons
        }
        
        return pokemons.filter { pokemon in
            if !searchText.isEmpty { // TODO: improve logic
                pokemon.name.lowercased().contains(searchText.lowercased()) &&
                tokens.allSatisfy(pokemon.types.contains)
            } else {
                tokens.allSatisfy(pokemon.types.contains)
            }
        }
    }
}

let pokemonRawData: [Pokemon] = [
    Pokemon(id: 1, name: "bulbasaur", types: [.grass, .poison], evolutionIds: [2, 3]),
    Pokemon(id: 2, name: "ivysaur", types: [.grass, .poison], evolutionIds: [3]),
    Pokemon(id: 3, name: "venusaur", types: [.grass, .poison]),
    Pokemon(id: 4, name: "charmander", types: [.fire], evolutionIds: [5, 6]),
    Pokemon(id: 5, name: "charmeleon", types: [.fire], evolutionIds: [6]),
    Pokemon(id: 6, name: "charizard", types: [.fire, .flying]),
    Pokemon(id: 7, name: "squirtle", types: [.water], evolutionIds: [8, 9]),
    Pokemon(id: 8, name: "wartortle", types: [.water], evolutionIds: [9]),
    Pokemon(id: 9, name: "blastoise", types: [.water]),
    Pokemon(id: 10, name: "caterpie", types: [.bug], evolutionIds: [11, 12]),
    Pokemon(id: 11, name: "metapod", types: [.bug], evolutionIds: [12]),
    Pokemon(id: 12, name: "butterfree", types: [.bug, .flying]),
    Pokemon(id: 13, name: "weedle", types: [.bug, .poison], evolutionIds: [14, 15]),
    Pokemon(id: 14, name: "kakuna", types: [.bug, .poison], evolutionIds: [15]),
    Pokemon(id: 15, name: "beedrill", types: [.bug, .poison]),
    Pokemon(id: 16, name: "pidgey", types: [.normal, .flying], evolutionIds: [17, 18]),
    Pokemon(id: 17, name: "pidgeotto", types: [.normal, .flying], evolutionIds: [18]),
    Pokemon(id: 18, name: "pidgeot", types: [.normal, .flying]),
    Pokemon(id: 19, name: "rattata", types: [.normal], evolutionIds: [20]),
    Pokemon(id: 20, name: "raticate", types: [.normal]),
    Pokemon(id: 21, name: "spearow", types: [.normal, .flying], evolutionIds: [22]),
    Pokemon(id: 22, name: "fearow", types: [.normal, .flying]),
    Pokemon(id: 23, name: "ekans", types: [.poison], evolutionIds: [24]),
    Pokemon(id: 24, name: "arbok", types: [.poison]),
    Pokemon(id: 25, name: "pikachu", types: [.electric], evolutionIds: [26]),
    Pokemon(id: 26, name: "raichu", types: [.electric]),
    Pokemon(id: 27, name: "sandshrew", types: [.ground], evolutionIds: [28]),
    Pokemon(id: 28, name: "sandslash", types: [.ground]),
    Pokemon(id: 29, name: "nidoran-f", types: [.poison], evolutionIds: [30, 31]),
    Pokemon(id: 30, name: "nidorina", types: [.poison], evolutionIds: [31]),
    Pokemon(id: 31, name: "nidoqueen", types: [.poison, .ground]),
    Pokemon(id: 32, name: "nidoran-m", types: [.poison], evolutionIds: [33, 34]),
    Pokemon(id: 33, name: "nidorino", types: [.poison], evolutionIds: [34]),
    Pokemon(id: 34, name: "nidoking", types: [.poison, .ground]),
    Pokemon(id: 35, name: "clefairy", types: [.fairy], evolutionIds: [36]),
    Pokemon(id: 36, name: "clefable", types: [.fairy]),
    Pokemon(id: 37, name: "vulpix", types: [.fire], evolutionIds: [38]),
    Pokemon(id: 38, name: "ninetales", types: [.fire]),
    Pokemon(id: 39, name: "jigglypuff", types: [.normal, .fairy], evolutionIds: [40]),
    Pokemon(id: 40, name: "wigglytuff", types: [.normal, .fairy]),
    Pokemon(id: 41, name: "zubat", types: [.poison, .flying], evolutionIds: [42]),
    Pokemon(id: 42, name: "golbat", types: [.poison, .flying]),
    Pokemon(id: 43, name: "oddish", types: [.grass, .poison], evolutionIds: [44, 45]),
    Pokemon(id: 44, name: "gloom", types: [.grass, .poison], evolutionIds: [45]),
    Pokemon(id: 45, name: "vileplume", types: [.grass, .poison]),
    Pokemon(id: 46, name: "paras", types: [.bug, .grass], evolutionIds: [47]),
    Pokemon(id: 47, name: "parasect", types: [.bug, .grass]),
    Pokemon(id: 48, name: "venonat", types: [.bug, .poison], evolutionIds: [49]),
    Pokemon(id: 49, name: "venomoth", types: [.bug, .poison]),
    Pokemon(id: 50, name: "diglett", types: [.ground], evolutionIds: [51]),
    Pokemon(id: 51, name: "dugtrio", types: [.ground]),
    Pokemon(id: 52, name: "meowth", types: [.normal], evolutionIds: [53]),
    Pokemon(id: 53, name: "persian", types: [.normal]),
    Pokemon(id: 54, name: "psyduck", types: [.water], evolutionIds: [55]),
    Pokemon(id: 55, name: "golduck", types: [.water]),
    Pokemon(id: 56, name: "mankey", types: [.fighting], evolutionIds: [57]),
    Pokemon(id: 57, name: "primeape", types: [.fighting]),
    Pokemon(id: 58, name: "growlithe", types: [.fire], evolutionIds: [59]),
    Pokemon(id: 59, name: "arcanine", types: [.fire]),
    Pokemon(id: 60, name: "poliwag", types: [.water], evolutionIds: [61, 62]),
    Pokemon(id: 61, name: "poliwhirl", types: [.water], evolutionIds: [62]),
    Pokemon(id: 62, name: "poliwrath", types: [.water, .fighting]),
    Pokemon(id: 63, name: "abra", types: [.psychic], evolutionIds: [64, 65]),
    Pokemon(id: 64, name: "kadabra", types: [.psychic], evolutionIds: [65]),
    Pokemon(id: 65, name: "alakazam", types: [.psychic]),
    Pokemon(id: 66, name: "machop", types: [.fighting], evolutionIds: [67, 68]),
    Pokemon(id: 67, name: "machoke", types: [.fighting], evolutionIds: [68]),
    Pokemon(id: 68, name: "machamp", types: [.fighting]),
    Pokemon(id: 69, name: "bellsprout", types: [.grass, .poison], evolutionIds: [70, 71]),
    Pokemon(id: 70, name: "weepinbell", types: [.grass, .poison], evolutionIds: [71]),
    Pokemon(id: 71, name: "victreebel", types: [.grass, .poison]),
    Pokemon(id: 72, name: "tentacool", types: [.water, .poison], evolutionIds: [73]),
    Pokemon(id: 73, name: "tentacruel", types: [.water, .poison]),
    Pokemon(id: 74, name: "geodude", types: [.rock, .ground], evolutionIds: [75, 76]),
    Pokemon(id: 75, name: "graveler", types: [.rock, .ground], evolutionIds: [76]),
    Pokemon(id: 76, name: "golem", types: [.rock, .ground]),
    Pokemon(id: 77, name: "ponyta", types: [.fire], evolutionIds: [78]),
    Pokemon(id: 78, name: "rapidash", types: [.fire]),
    Pokemon(id: 79, name: "slowpoke", types: [.water, .psychic], evolutionIds: [80]),
    Pokemon(id: 80, name: "slowbro", types: [.water, .psychic]),
    Pokemon(id: 81, name: "magnemite", types: [.electric, .steel], evolutionIds: [82]),
    Pokemon(id: 82, name: "magneton", types: [.electric, .steel]),
    Pokemon(id: 83, name: "farfetchd", types: [.normal, .flying]),
    Pokemon(id: 84, name: "doduo", types: [.normal, .flying], evolutionIds: [85]),
    Pokemon(id: 85, name: "dodrio", types: [.normal, .flying]),
    Pokemon(id: 86, name: "seel", types: [.water], evolutionIds: [87]),
    Pokemon(id: 87, name: "dewgong", types: [.water, .ice]),
    Pokemon(id: 88, name: "grimer", types: [.poison], evolutionIds: [89]),
    Pokemon(id: 89, name: "muk", types: [.poison]),
    Pokemon(id: 90, name: "shellder", types: [.water], evolutionIds: [91]),
    Pokemon(id: 91, name: "cloyster", types: [.water, .ice]),
    Pokemon(id: 92, name: "gastly", types: [.ghost, .poison], evolutionIds: [93, 94]),
    Pokemon(id: 93, name: "haunter", types: [.ghost, .poison], evolutionIds: [94]),
    Pokemon(id: 94, name: "gengar", types: [.ghost, .poison]),
    Pokemon(id: 95, name: "onix", types: [.rock, .ground]),
    Pokemon(id: 96, name: "drowzee", types: [.psychic], evolutionIds: [97]),
    Pokemon(id: 97, name: "hypno", types: [.psychic]),
    Pokemon(id: 98, name: "krabby", types: [.water], evolutionIds: [99]),
    Pokemon(id: 99, name: "kingler", types: [.water]),
    Pokemon(id: 100, name: "voltorb", types: [.electric], evolutionIds: [101]),
    Pokemon(id: 101, name: "electrode", types: [.electric]),
    Pokemon(id: 102, name: "exeggcute", types: [.grass, .psychic], evolutionIds: [103]),
    Pokemon(id: 103, name: "exeggutor", types: [.grass, .psychic]),
    Pokemon(id: 104, name: "cubone", types: [.ground], evolutionIds: [105]),
    Pokemon(id: 105, name: "marowak", types: [.ground]),
    Pokemon(id: 106, name: "hitmonlee", types: [.fighting]),
    Pokemon(id: 107, name: "hitmonchan", types: [.fighting]),
    Pokemon(id: 108, name: "lickitung", types: [.normal]),
    Pokemon(id: 109, name: "koffing", types: [.poison], evolutionIds: [110]),
    Pokemon(id: 110, name: "weezing", types: [.poison]),
    Pokemon(id: 111, name: "rhyhorn", types: [.ground, .rock], evolutionIds: [112]),
    Pokemon(id: 112, name: "rhydon", types: [.ground, .rock]),
    Pokemon(id: 113, name: "chansey", types: [.normal]),
    Pokemon(id: 114, name: "tangela", types: [.grass]),
    Pokemon(id: 115, name: "kangaskhan", types: [.normal]),
    Pokemon(id: 116, name: "horsea", types: [.water], evolutionIds: [117]),
    Pokemon(id: 117, name: "seadra", types: [.water]),
    Pokemon(id: 118, name: "goldeen", types: [.water], evolutionIds: [119]),
    Pokemon(id: 119, name: "seaking", types: [.water]),
    Pokemon(id: 120, name: "staryu", types: [.water], evolutionIds: [121]),
    Pokemon(id: 121, name: "starmie", types: [.water, .psychic]),
    Pokemon(id: 122, name: "mr-mime", types: [.psychic, .fairy]),
    Pokemon(id: 123, name: "scyther", types: [.bug, .flying]),
    Pokemon(id: 124, name: "jynx", types: [.ice, .psychic]),
    Pokemon(id: 125, name: "electabuzz", types: [.electric]),
    Pokemon(id: 126, name: "magmar", types: [.fire]),
    Pokemon(id: 127, name: "pinsir", types: [.bug]),
    Pokemon(id: 128, name: "tauros", types: [.normal]),
    Pokemon(id: 129, name: "magikarp", types: [.water], evolutionIds: [130]),
    Pokemon(id: 130, name: "gyarados", types: [.water, .flying]),
    Pokemon(id: 131, name: "lapras", types: [.water, .ice]),
    Pokemon(id: 132, name: "ditto", types: [.normal]),
    Pokemon(id: 133, name: "eevee", types: [.normal], evolutionIds: [134, 135, 136]),
    Pokemon(id: 134, name: "vaporeon", types: [.water]),
    Pokemon(id: 135, name: "jolteon", types: [.electric]),
    Pokemon(id: 136, name: "flareon", types: [.fire]),
    Pokemon(id: 137, name: "porygon", types: [.normal]),
    Pokemon(id: 138, name: "omanyte", types: [.rock, .water], evolutionIds: [139]),
    Pokemon(id: 139, name: "omastar", types: [.rock, .water]),
    Pokemon(id: 140, name: "kabuto", types: [.rock, .water], evolutionIds: [141]),
    Pokemon(id: 141, name: "kabutops", types: [.rock, .water]),
    Pokemon(id: 142, name: "aerodactyl", types: [.rock, .flying]),
    Pokemon(id: 143, name: "snorlax", types: [.normal]),
    Pokemon(id: 144, name: "articuno", types: [.ice, .flying]),
    Pokemon(id: 145, name: "zapdos", types: [.electric, .flying]),
    Pokemon(id: 146, name: "moltres", types: [.fire, .flying]),
    Pokemon(id: 147, name: "dratini", types: [.dragon], evolutionIds: [148, 149]),
    Pokemon(id: 148, name: "dragonair", types: [.dragon], evolutionIds: [149]),
    Pokemon(id: 149, name: "dragonite", types: [.dragon, .flying]),
    Pokemon(id: 150, name: "mewtwo", types: [.psychic]),
    Pokemon(id: 151, name: "mew", types: [.psychic])
]

/*
 https://www.hackingwithswift.com/quick-start/swiftui/whats-the-difference-between-observedobject-state-and-environmentobject
 https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-environmentobject-to-share-data-between-views
 */
