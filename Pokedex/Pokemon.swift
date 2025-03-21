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
//    case dark
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
//        case .dark: return Color.black
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
//        case .psychic: return [.bug, .ghost, .dark]
        case .psychic: return [.bug, .ghost]
        case .rock: return [.water, .grass, .fighting, .ground, .steel]
        case .ice: return [.fire, .fighting, .rock, .steel]
        case .dragon: return [.ice, .dragon, .fairy]
//        case .dark: return [.fighting, .bug, .fairy]
        case .steel: return [.fire, .fighting, .ground]
        case .fighting: return [.flying, .psychic, .fairy]
//        case .ghost: return [.ghost, .dark]
        case .ghost: return [.ghost]
        }
    }
    
    var associatedStrengths: [ElementType] {
        switch self {
        case .grass: return [.water, .ground, .rock]
        case .poison: return [.grass, .fairy]
        case .fire: return [.grass, .bug, .ice, .steel]
        case .flying: return [.grass, .fighting, .bug]
        case .water: return [.fire, .ground, .rock]
//        case .bug: return [.grass, .psychic, .dark]
        case .bug: return [.grass, .psychic]
        case .normal: return []
        case .electric: return [.water, .flying]
        case .ground: return [.fire, .electric, .poison, .rock, .steel]
//        case .fairy: return [.fighting, .dragon, .dark]
        case .fairy: return [.fighting, .dragon]
        case .psychic: return [.fighting, .poison]
        case .rock: return [.fire, .ice, .flying, .bug]
        case .ice: return [.grass, .ground, .flying, .dragon]
        case .dragon: return [.dragon]
//        case .dark: return [.psychic, .ghost]
        case .steel: return [.rock, .ice, .fairy]
//        case .fighting: return [.normal, .rock, .steel, .ice, .dark]
        case .fighting: return [.normal, .rock, .steel, .ice]

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

enum FilterOptions {
    case all
    case caught
    case uncaught
}

struct Pokemon: Identifiable {
    var id: Int
    var name: String
    var description: String?
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
        filter: FilterOptions = .all
    ) -> [Pokemon] {
        print(tokens)
        guard !searchText.isEmpty || !tokens.isEmpty else {
            return pokemons.filter { pokemon in
                switch filter {
                case .all: return true
                case .caught: return pokemon.isCaught
                case .uncaught: return !pokemon.isCaught
                }
            }
        }
        
        return pokemons.filter { pokemon in
            let matchesSearch = searchText.isEmpty || pokemon.name.lowercased().contains(searchText.lowercased())
            let matchesTokens = tokens.isEmpty || tokens.allSatisfy(pokemon.types.contains)
            let matchesFilter: Bool = {
                switch filter {
                case .all: return true
                case .caught: return pokemon.isCaught
                case .uncaught: return !pokemon.isCaught
                }
            }()
            
            return matchesSearch && matchesTokens && matchesFilter
        }
    }
}

let pokemonRawData: [Pokemon] = [
    Pokemon(id: 1, name: "bulbasaur", description: "A small, quadruped Pokémon with a plant bulb on its back. Bulbasaur's bulb grows over time, providing it with energy through photosynthesis. It is known for being calm and easy to raise.", types: [.grass, .poison], evolutionIds: [2, 3]),
    Pokemon(id: 2, name: "ivysaur", description: "The evolved form of Bulbasaur with a larger bud on its back that occasionally blooms. Ivysaur's bud releases a sweet aroma when it is ready to bloom. It becomes more active as the bud grows larger.", types: [.grass, .poison], evolutionIds: [3]),
    Pokemon(id: 3, name: "venusaur", description: "The final evolution of Bulbasaur with a fully bloomed flower on its back. Venusaur's flower emits a soothing fragrance that calms those around it. It draws energy from the sun to power its attacks.", types: [.grass, .poison]),
    Pokemon(id: 4, name: "charmander", description: "A bipedal lizard Pokémon with a flame burning at the tip of its tail. Charmander's tail flame indicates its health and emotions. Its fiery nature makes it a spirited companion.", types: [.fire], evolutionIds: [5, 6]),
    Pokemon(id: 5, name: "charmeleon", description: "The evolved form of Charmander with sharp claws and a more aggressive demeanor. Charmeleon's flame burns more intensely as it experiences tough battles. It has a short temper and can be difficult to control.", types: [.fire], evolutionIds: [6]),
    Pokemon(id: 6, name: "charizard", description: "A draconic Pokémon with large wings and a powerful flame at the tip of its tail. Charizard can fly at great heights and spew intense flames that can melt almost anything. Its competitive spirit drives it to seek strong opponents.", types: [.fire, .flying]),
    Pokemon(id: 7, name: "squirtle", description: "A small turtle Pokémon with a round shell and curled tail. Squirtle can withdraw into its shell for protection or to reduce water resistance when swimming. It sprays water from its mouth with remarkable accuracy.", types: [.water], evolutionIds: [8, 9]),
    Pokemon(id: 8, name: "wartortle", description: "The evolved form of Squirtle with a fluffier tail and ear-like protrusions. Wartortle is known for its longevity, with some living for over 10,000 years. Its tail is considered a symbol of longevity and good luck.", types: [.water], evolutionIds: [9]),
    Pokemon(id: 9, name: "blastoise", description: "The final evolution of Squirtle with powerful water cannons protruding from its shell. Blastoise can fire water jets with enough precision and power to punch through thick steel. It uses its heavy weight to tackle opponents in battle.", types: [.water]),
    Pokemon(id: 10, name: "caterpie", description: "A small, green caterpillar Pokémon with a red antenna on its head. Caterpie has a voracious appetite and can devour leaves larger than itself in moments. Its feet have suction cups that allow it to climb any surface.", types: [.bug], evolutionIds: [11, 12]),
    Pokemon(id: 11, name: "metapod", description: "A cocoon Pokémon with a hard shell that barely moves. Metapod hardens its shell to protect its soft body as it undergoes metamorphosis. It remains motionless as it prepares for evolution.", types: [.bug], evolutionIds: [12]),
    Pokemon(id: 12, name: "butterfree", description: "A butterfly Pokémon with large, colorful wings and round red eyes. Butterfree's wings are covered in toxic scales that disperse with each flap. It can locate flower nectar using its highly developed sense of smell.", types: [.bug, .flying]),
    Pokemon(id: 13, name: "weedle", description: "A small, hairy bug Pokémon with a venomous stinger on its head. Weedle uses its acute sense of smell to find leaves for food. Its bright coloration warns predators of its poisonous nature.", types: [.bug, .poison], evolutionIds: [14, 15]),
    Pokemon(id: 14, name: "kakuna", description: "A yellow cocoon Pokémon that remains virtually immobile. Kakuna's interior is busy preparing for evolution while its hard shell provides protection. It can extend its stinger if threatened.", types: [.bug, .poison], evolutionIds: [15]),
    Pokemon(id: 15, name: "beedrill", description: "An aggressive bee Pokémon with three stingers and striped coloration. Beedrill flies at high speeds and attacks using the poisonous stingers on its forelegs and abdomen. It is fiercely territorial and lives in colonies.", types: [.bug, .poison]),
    Pokemon(id: 16, name: "pidgey", description: "A small, brown bird Pokémon with a cream-colored belly. Pidgey is docile and prefers to avoid conflict by using sand to blind opponents. It has an excellent sense of direction and can always find its way home.", types: [.normal, .flying], evolutionIds: [17, 18]),
    Pokemon(id: 17, name: "pidgeotto", description: "A medium-sized bird Pokémon with colorful plumage and sharp talons. Pidgeotto claims a large territory and fiercely defends it from intruders. It searches for prey by flying over its wide territory.", types: [.normal, .flying], evolutionIds: [18]),
    Pokemon(id: 18, name: "pidgeot", description: "A large, majestic bird Pokémon with beautiful, glossy feathers. Pidgeot can fly at Mach 2 speed and its powerful wings create gusts of wind. It has spectacular eyesight that allows it to spot prey from incredible heights.", types: [.normal, .flying]),
    Pokemon(id: 19, name: "rattata", description: "A small, purple rat Pokémon with large teeth and a curled tail. Rattata is incredibly prolific and can live anywhere it can find food. Its incisors grow continuously, requiring it to gnaw on hard objects.", types: [.normal], evolutionIds: [20]),
    Pokemon(id: 20, name: "raticate", description: "A larger rat Pokémon with prominent fangs and tough whiskers. Raticate's strong teeth can gnaw through concrete walls and steel containers. It uses its whiskers to maintain balance and is an excellent swimmer.", types: [.normal]),
    Pokemon(id: 21, name: "spearow", description: "A small, brown bird Pokémon with rough plumage and a fierce temperament. Spearow has a loud cry that can be heard from half a mile away. Despite its small size, it's very territorial and aggressive.", types: [.normal, .flying], evolutionIds: [22]),
    Pokemon(id: 22, name: "fearow", description: "A large bird Pokémon with a long, thin beak and impressive wingspan. Fearow can fly continuously for a whole day and uses its long beak to catch prey. It is known for its persistence when pursuing targets.", types: [.normal, .flying]),
    Pokemon(id: 23, name: "ekans", description: "A purple snake Pokémon with a yellow band around its neck. Ekans silently slithers through grass to surprise prey with its venomous bite. It can dislocate its jaw to swallow large prey whole.", types: [.poison], evolutionIds: [24]),
    Pokemon(id: 24, name: "arbok", description: "A large cobra Pokémon with intimidating markings on its hood. Arbok's pattern can immobilize prey through fear or fascination. Its powerful constricting abilities can crush steel oil drums.", types: [.poison]),
    Pokemon(id: 25, name: "pikachu", description: "A yellow, mouse-like Pokémon with red cheeks that store electricity. Pikachu generates electricity through the electric sacs in its cheeks. It occasionally discharges electricity when nervous or excited.", types: [.electric], evolutionIds: [26]),
    Pokemon(id: 26, name: "raichu", description: "The evolved form of Pikachu with a long tail that serves as a ground wire. Raichu can release up to 100,000 volts of electricity through its body. It glows in the dark when fully charged with electricity.", types: [.electric]),
    Pokemon(id: 27, name: "sandshrew", description: "A small, ground-dwelling Pokémon with tough, yellow skin resembling sandstone. Sandshrew curls into a ball when threatened to protect its soft belly. It lives in arid regions where it digs burrows to escape the heat.", types: [.ground], evolutionIds: [28]),
    Pokemon(id: 28, name: "sandslash", description: "The evolved form of Sandshrew with large, sharp spines covering its back. Sandslash's claws are perfect for digging and can double as effective weapons. It curls into a spiky ball when endangered.", types: [.ground]),
    Pokemon(id: 29, name: "nidoran-f", description: "A small, bluish female Pokémon with small spines and large ears. Female Nidoran has smaller horns than its male counterpart but possesses more potent poison. It has a gentle disposition despite its toxic abilities.", types: [.poison], evolutionIds: [30, 31]),
    Pokemon(id: 30, name: "nidorina", description: "The evolved form of female Nidoran with larger spines and a more aggressive nature. Nidorina lives in groups with others of its kind for protection. It becomes aggressive when caring for its young.", types: [.poison], evolutionIds: [31]),
    Pokemon(id: 31, name: "nidoqueen", description: "The final evolution of female Nidoran with a thick hide and powerful limbs. Nidoqueen has armored skin that can withstand powerful attacks. It uses its bulk to protect its young from danger.", types: [.poison, .ground]),
    Pokemon(id: 32, name: "nidoran-m", description: "A small, purple male Pokémon with a prominent horn and large ears. Male Nidoran develops toxic spines that seep poison when it feels threatened. Its horn contains a powerful venom.", types: [.poison], evolutionIds: [33, 34]),
    Pokemon(id: 33, name: "nidorino", description: "The evolved form of male Nidoran with a more aggressive disposition. Nidorino has a volatile temperament and uses its horn to inject venom. It becomes wildly aggressive when it senses danger.", types: [.poison], evolutionIds: [34]),
    Pokemon(id: 34, name: "nidoking", description: "The final evolution of male Nidoran with powerful muscles and a large horn. Nidoking's thick tail can topple a metal transmission tower with one swing. Its horn acts as a drill when it charges at enemies.", types: [.poison, .ground]),
    Pokemon(id: 35, name: "clefairy", description: "A pink, fairy-like Pokémon with a curled lock of hair and pointed ears. Clefairy is rarely seen and is believed to have arrived on Earth via meteorite. It dances under the full moon to gather moonlight energy.", types: [.fairy], evolutionIds: [36]),
    Pokemon(id: 36, name: "clefable", description: "The evolved form of Clefairy with a more robust body and wing-like appendages. Clefable moves by skipping lightly as if it were flying. It is so rare that some consider it just a myth.", types: [.fairy]),
    Pokemon(id: 37, name: "vulpix", description: "A fox-like Pokémon with six curly tails and reddish-brown fur. Vulpix is born with one white tail that splits into six as it grows older. It can control flames inside its body to exhale fire.", types: [.fire], evolutionIds: [38]),
    Pokemon(id: 38, name: "ninetales", description: "A majestic fox Pokémon with nine flowing tails and golden-white fur. Ninetales is said to live for 1,000 years and can understand human speech. It is highly intelligent and is said to cast curses on those who mistreat it.", types: [.fire]),
    Pokemon(id: 39, name: "jigglypuff", description: "A round, pink Pokémon with large blue eyes and a tuft of fur on its head. Jigglypuff can inflate its body and sing a lullaby that puts listeners to sleep. It becomes upset when others fall asleep during its performances.", types: [.normal, .fairy], evolutionIds: [40]),
    Pokemon(id: 40, name: "wigglytuff", description: "The evolved form of Jigglypuff with a larger, more oval body. Wigglytuff's body is very elastic and filled with air, allowing it to inflate itself. Its fur is so fine and luxurious that those who touch it can't stop petting it.", types: [.normal, .fairy]),
    Pokemon(id: 41, name: "zubat", description: "A small, blue bat Pokémon that lacks eyes and navigates using echolocation. Zubat lives in caves away from sunlight and can fly for long periods. It feeds on the blood of both Pokémon and humans.", types: [.poison, .flying], evolutionIds: [42]),
    Pokemon(id: 42, name: "golbat", description: "The evolved form of Zubat with a large mouth and sharp fangs. Golbat can drink over 10 ounces of blood in one go from its victims. Its ultrasonic waves can cause confusion and headaches in humans.", types: [.poison, .flying]),
    Pokemon(id: 43, name: "oddish", description: "A small, blue plant Pokémon with leaves sprouting from its head. Oddish buries itself in the soil during the day to absorb nutrients. At night, it walks around scattering its seeds.", types: [.grass, .poison], evolutionIds: [44, 45]),
    Pokemon(id: 44, name: "gloom", description: "The evolved form of Oddish with a drooling mouth and a large flower on its head. Gloom emits an incredibly foul odor from the nectar of its flower. The smell is so powerful it can cause memory loss in some cases.", types: [.grass, .poison], evolutionIds: [45]),
    Pokemon(id: 45, name: "vileplume", description: "The final evolution of Oddish with an enormous flower atop its head. Vileplume's petals are the largest in the world and release toxic pollen when shaken. It is known to walk around at night to scatter its pollen.", types: [.grass, .poison]),
    Pokemon(id: 46, name: "paras", description: "A small, insect Pokémon with parasitic mushrooms growing from its back. Paras is controlled by the mushrooms, which gradually take over its body. It prefers damp, dark places where mushrooms thrive.", types: [.bug, .grass], evolutionIds: [47]),
    Pokemon(id: 47, name: "parasect", description: "The evolved form of Paras with a single large mushroom completely covering its back. Parasect is entirely controlled by the parasitic mushroom on its back. Its insect host is merely a shell at this point.", types: [.bug, .grass]),
    Pokemon(id: 48, name: "venonat", description: "A round, insect Pokémon covered in purple fur with large red compound eyes. Venonat's eyes can identify even tiny prey in darkness. It is drawn to light and feeds on small insects.", types: [.bug, .poison], evolutionIds: [49]),
    Pokemon(id: 49, name: "venomoth", description: "A large moth Pokémon with purple wings dusted with toxic powder. Venomoth's wings scatter poisonous scales when flapped, causing paralysis. It is attracted to light and often flies around city streetlights.", types: [.bug, .poison]),
    Pokemon(id: 50, name: "diglett", description: "A small, brown Pokémon that lives underground with only its head visible. Diglett's actual body beneath the ground remains a mystery. It creates tunnel networks under the surface at impressive speeds.", types: [.ground], evolutionIds: [51]),
    Pokemon(id: 51, name: "dugtrio", description: "Three Diglett combined as a single entity, with greater power and speed. Dugtrio can dig to a depth of 60 miles and trigger earthquakes. Its three heads bob separately as it moves through the ground.", types: [.ground]),
    Pokemon(id: 52, name: "meowth", description: "A feline Pokémon with cream-colored fur and a gold coin embedded in its forehead. Meowth is attracted to shiny objects and often steals them. The coin on its head is said to bring good fortune.", types: [.normal], evolutionIds: [53]),
    Pokemon(id: 53, name: "persian", description: "The evolved form of Meowth with elegant proportions and a red gem on its forehead. Persian is known for its lithe muscles and graceful movements. It has a vicious temperament despite its refined appearance.", types: [.normal]),
    Pokemon(id: 54, name: "psyduck", description: "A yellow duck Pokémon that constantly suffers from headaches. Psyduck's psychic powers emerge when its headache becomes severe enough. It typically appears dazed and confused due to its chronic pain.", types: [.water], evolutionIds: [55]),
    Pokemon(id: 55, name: "golduck", description: "The evolved form of Psyduck with a sleek blue body and enhanced psychic abilities. Golduck is an excellent swimmer that can move faster than a champion swimmer. The gem on its forehead glows when it uses its psychic powers.", types: [.water]),
    Pokemon(id: 56, name: "mankey", description: "A pig-monkey Pokémon known for its furious temper and agility. Mankey lives in treetops and is constantly angry, flying into a rage at the slightest provocation. It is difficult to tame due to its extreme moodiness.", types: [.fighting], evolutionIds: [57]),
    Pokemon(id: 57, name: "primeape", description: "The evolved form of Mankey with an even more ferocious temperament. Primeape never stops being angry and will chase targets that upset it until they're caught. Its fury increases the more it chases its target.", types: [.fighting]),
    Pokemon(id: 58, name: "growlithe", description: "A canine Pokémon with orange fur marked with black stripes. Growlithe is extremely loyal to its trainer and will bark at or bite anyone who approaches suspiciously. It has an excellent sense of smell that never forgets a scent.", types: [.fire], evolutionIds: [59]),
    Pokemon(id: 59, name: "arcanine", description: "A large, majestic canine Pokémon with luxurious orange fur and black stripes. Arcanine can run 6,200 miles in a single day and night. It is admired for its beauty and speed around the world.", types: [.fire]),
    Pokemon(id: 60, name: "poliwag", description: "A blue, tadpole Pokémon with a translucent skin revealing a spiral pattern on its belly. Poliwag's swirl pattern is actually its internal organs visible through its thin skin. Its newly formed legs make it unsteady on land.", types: [.water], evolutionIds: [61, 62]),
    Pokemon(id: 61, name: "poliwhirl", description: "The evolved form of Poliwag with a more defined spiral pattern and developed limbs. Poliwhirl can live on land but prefers to stay in water. It sweats constantly to keep its skin moist and slippery.", types: [.water], evolutionIds: [62]),
    Pokemon(id: 62, name: "poliwrath", description: "The final evolution of Poliwag with muscular arms and a more aggressive appearance. Poliwrath is an excellent swimmer that can outperform professional human swimmers. Its muscles never fatigue no matter how much it exercises.", types: [.water, .fighting]),
    Pokemon(id: 63, name: "abra", description: "A psychic Pokémon that sleeps 18 hours a day to store mental energy. Abra can teleport away from danger even while sleeping. It has the ability to read minds and predict future events.", types: [.psychic], evolutionIds: [64, 65]),
    Pokemon(id: 64, name: "kadabra", description: "The evolved form of Abra, holding a spoon that amplifies its psychic powers. Kadabra emits alpha waves that can cause headaches and can bend spoons with its mind. It has a star on its forehead that glows when using psychic powers.", types: [.psychic], evolutionIds: [65]),
    Pokemon(id: 65, name: "alakazam", description: "The final evolution of Abra, wielding two spoons and possessing incredible intelligence. Alakazam's brain continually grows, and it has an IQ of approximately 5,000. It can remember everything that happens in its lifetime.", types: [.psychic]),
    Pokemon(id: 66, name: "machop", description: "A humanoid Pokémon with grayish-blue skin and extraordinary strength. Machop trains by lifting heavy objects like Graveler. Its muscles never get sore no matter how much it exercises.", types: [.fighting], evolutionIds: [67, 68]),
    Pokemon(id: 67, name: "machoke", description: "The evolved form of Machop with enhanced musculature and a belt to control its power. Machoke is so strong it can lift a sumo wrestler with one finger. It often helps humans with physically demanding labor.", types: [.fighting], evolutionIds: [68]),
    Pokemon(id: 68, name: "machamp", description: "The final evolution of Machop with four arms and incredible fighting ability. Machamp can throw 1,000 punches in two seconds and move mountains with one arm. It must wear a power-save belt to regulate its strength.", types: [.fighting]),
    Pokemon(id: 69, name: "bellsprout", description: "A plant Pokémon with a thin, flexible body and a bell-shaped head. Bellsprout's roots can be replanted for it to absorb nutrients from soil. It ensnares and digests small insects using its acid-filled mouth.", types: [.grass, .poison], evolutionIds: [70, 71]),
    Pokemon(id: 70, name: "weepinbell", description: "The evolved form of Bellsprout with a larger bell-shaped body and a hooked vine. Weepinbell hangs from tree branches waiting to spray acid on passing prey. It secretes a honey-like fluid that attracts insects.", types: [.grass, .poison], evolutionIds: [71]),
    Pokemon(id: 71, name: "victreebel", description: "The final evolution of Bellsprout resembling a large pitcher plant with a long vine. Victreebel lures prey with a sweet-smelling honey and swallows them whole. Its internal acids can dissolve anything that falls inside.", types: [.grass, .poison]),
    Pokemon(id: 72, name: "tentacool", description: "A water-dwelling Pokémon resembling a jellyfish with red crystal-like orbs. Tentacool's body is mostly composed of water and can melt away when dehydrated. Its tentacles deliver a painful, venomous sting.", types: [.water, .poison], evolutionIds: [73]),
    Pokemon(id: 73, name: "tentacruel", description: "The evolved form of Tentacool with more tentacles and larger red orbs. Tentacruel can extend its 80 tentacles to form a poisonous web in the ocean. The red orbs on its head glow before unleashing a strong electrical shock.", types: [.water, .poison]),
    Pokemon(id: 74, name: "geodude", description: "A rock Pokémon with muscular arms that looks like a boulder with eyes. Geodude is often mistaken for a rock when resting and can be stepped on accidentally. It uses its arms to climb mountain paths.", types: [.rock, .ground], evolutionIds: [75, 76]),
    Pokemon(id: 75, name: "graveler", description: "The evolved form of Geodude with four arms and a more rugged appearance. Graveler rolls down mountain paths, growing bigger as it collects debris. It feeds on rocks and is known to cause landslides.", types: [.rock, .ground], evolutionIds: [76]),
    Pokemon(id: 76, name: "golem", description: "The final evolution of Geodude with a turtle-like shell made of rock. Golem sheds its outer layer once a year, revealing a new, smoother shell underneath. It can withstand explosions without damage.", types: [.rock, .ground]),
    Pokemon(id: 77, name: "ponyta", description: "A horse Pokémon with a fiery mane and tail that ignite at birth. Ponyta's hooves are harder than diamond and can crush anything underfoot. Its fire will not burn those it trusts.", types: [.fire], evolutionIds: [78]),
    Pokemon(id: 78, name: "rapidash", description: "The evolved form of Ponyta with more intense flames and greater speed. Rapidash can reach speeds of up to 150 mph, leaving only blazing hoofprints in its wake. It enjoys racing against other fast Pokémon.", types: [.fire]),
    Pokemon(id: 79, name: "slowpoke", description: "A pink Pokémon with a vacant expression and incredibly slow reactions. Slowpoke uses its tail to fish but often forgets what it's doing. It takes 5 seconds for it to feel pain when something bites its tail.", types: [.water, .psychic], evolutionIds: [80]),
    Pokemon(id: 80, name: "slowbro", description: "The evolved form of Slowpoke with a Shellder attached to its tail. Slowbro evolves when a Shellder bites its tail and refuses to let go. It loses its ability to fish but gains increased psychic powers.", types: [.water, .psychic]),
    Pokemon(id: 81, name: "magnemite", description: "A mechanical Pokémon resembling a magnet with a single eye. Magnemite floats using electromagnetic waves and can emit powerful magnetic fields. It feeds on electricity and is often found near power plants.", types: [.electric, .steel], evolutionIds: [82]),
    Pokemon(id: 82, name: "magneton", description: "Three Magnemite linked together to form a single, more powerful entity. Magneton creates strong magnetic fields that can disrupt electronic equipment. It appears when sunspot activity increases.", types: [.electric, .steel]),
    Pokemon(id: 83, name: "farfetchd", description: "A wild duck Pokémon that carries a leek stalk as a weapon. Farfetch'd uses its leek for both defense and food preparation. It's a rare Pokémon that was hunted nearly to extinction for its delicious taste.", types: [.normal, .flying]),
    Pokemon(id: 84, name: "doduo", description: "A flightless bird Pokémon with two heads attached to a single body. Doduo's two heads contain separate brains but share the same body. Its two heads take turns sleeping to maintain vigilance.", types: [.normal, .flying], evolutionIds: [85]),
    Pokemon(id: 85, name: "dodrio", description: "The evolved form of Doduo with three heads instead of two. Dodrio's three heads represent joy, sorrow, and anger, each with a distinct personality. It can run at nearly 40 mph, chasing prey across the plains.", types: [.normal, .flying]),
    Pokemon(id: 86, name: "seel", description: "A pinniped Pokémon with a thick hide, sharp horn, and flipper-like limbs. Seel thrives in cold environments and hunts underwater for food. Its horn serves as a drill to break through ice sheets.", types: [.water], evolutionIds: [87]),
    Pokemon(id: 87, name: "dewgong", description: "The evolved form of Seel with a more streamlined body and longer horn. Dewgong sleeps in shallow seawater, creating a pillow with its thick fur. It can swim through frigid ocean waters at 8 knots.", types: [.water, .ice]),
    Pokemon(id: 88, name: "grimer", description: "A slimy, amorphous Pokémon composed of toxic waste and pollutants. Grimer's body contains numerous unknown germs and spreads disease. It was born when sludge in a dirty stream was exposed to X-rays from the moon.", types: [.poison], evolutionIds: [89]),
    Pokemon(id: 89, name: "muk", description: "The evolved form of Grimer with a larger, more amorphous body. Muk's touch leaves a powerful toxic residue that can make plants wilt and die. Its smell is so awful it can cause fainting.", types: [.poison]),
    Pokemon(id: 90, name: "shellder", description: "A bivalve Pokémon with a hard purple shell and a protruding tongue. Shellder clamps down on prey with its shell and doesn't let go. When threatened, it swims away by rapidly opening and closing its shell.", types: [.water], evolutionIds: [91]),
    Pokemon(id: 91, name: "cloyster", description: "The evolved form of Shellder with spikes adorning its harder, blacker shell. Cloyster's shell is so durable that even a bomb blast couldn't harm it. It launches spikes as projectiles when threatened.", types: [.water, .ice]),
    Pokemon(id: 92, name: "gastly", description: "A gaseous Pokémon consisting of a sphere of ghostly matter surrounded by purple gas. Gastly's body is 95% gas and can slip through any crack or opening. It can topple an Indian elephant by enveloping it in poisonous gas.", types: [.ghost, .poison], evolutionIds: [93, 94]),
    Pokemon(id: 93, name: "haunter", description: "The evolved form of Gastly with disembodied hands and a more defined face. Haunter can slip through solid walls and enjoys scaring people in the darkness. Its touch can drain the life energy from living beings.", types: [.ghost, .poison], evolutionIds: [94]),
    Pokemon(id: 94, name: "gengar", description: "The final evolution of Gastly with a more substantial body and mischievous personality. Gengar hides in shadows, waiting to steal the life of those who get lost in mountains. It pretends to be the victim's shadow before striking.", types: [.ghost, .poison]),
    Pokemon(id: 95, name: "onix", description: "A massive snake-like Pokémon composed of rock segments with a stone horn. Onix tunnels through the ground at 50 mph, causing tremors and loud roars. Its body becomes harder as it tunnels through the ground.", types: [.rock, .ground]),
    Pokemon(id: 96, name: "drowzee", description: "A tapir-like Pokémon that feeds on dreams and can cause drowsiness in those nearby. Drowzee can tell what kind of dreams someone is having by sniffing with its trunk. It prefers the dreams of children as they taste sweeter.", types: [.psychic], evolutionIds: [97]),
    Pokemon(id: 97, name: "hypno", description: "The evolved form of Drowzee that carries a pendulum to enhance its hypnotic powers. Hypno puts its opponents to sleep before eating their dreams. There are reports of it hypnotizing children and leading them away.", types: [.psychic]),
    Pokemon(id: 98, name: "krabby", description: "A crustacean Pokémon with powerful pincers and a hard shell. Krabby lives near the shoreline, burrowing in sand to hide itself. Its pincers can break even the hardest shells.", types: [.water], evolutionIds: [99]),
    Pokemon(id: 99, name: "kingler", description: "The evolved form of Krabby with an enormous oversized pincer. Kingler's larger pincer can exert 10,000 horsepower of pressure but is so heavy that it's difficult to aim properly. It communicates with others by making bubbles.", types: [.water]),
    Pokemon(id: 100, name: "voltorb", description: "A spherical Pokemon that resembles a Poke Ball and often self-destructs when threatened. It is believed to have been created when a Poke Ball was exposed to a powerful energy pulse. Voltorb tends to be found near power plants where it feeds on electricity.", types: [.electric], evolutionIds: [101]),
    Pokemon(id: 101, name: "electrode", description: "The evolved form of Voltorb, known for its incredible speed and explosive tendencies. Electrode stores so much electrical energy that the slightest shock can trigger a massive explosion. It has been known to explode without warning when overcharged or agitated.", types: [.electric]),
    Pokemon(id: 102, name: "exeggcute", description: "A cluster of six eggs with distinct facial expressions that function as a single Pokemon. Though they look like eggs, they are actually more similar to seeds with telepathic abilities. The eggs speak to each other using a form of telepathy that can only be understood by other Exeggcute.", types: [.grass, .psychic], evolutionIds: [103]),
    Pokemon(id: 103, name: "exeggutor", description: "A tall, palm tree-like Pokemon with multiple heads that evolved from Exeggcute. Each of its three heads thinks independently, though they rarely disagree. Exeggutor thrives in tropical climates where it can absorb abundant sunlight to strengthen its psychic powers.", types: [.grass, .psychic]),
    Pokemon(id: 104, name: "cubone", description: "A small ground Pokemon that wears the skull of its deceased mother as a helmet. Cubone is known for its mournful crying at night as it grieves for its lost parent. It uses the bone it carries as both a weapon and a tool for foraging.", types: [.ground], evolutionIds: [105]),
    Pokemon(id: 105, name: "marowak", description: "The evolved form of Cubone, recognized by its expertise in wielding its bone club as a formidable weapon. Marowak has grown tougher through its hardships and has mastered throwing its bone like a boomerang. Its skill with the bone club is unmatched among Pokemon.", types: [.ground]),
    Pokemon(id: 106, name: "hitmonlee", description: "A fighting Pokemon known for its phenomenal kicking abilities and spring-like legs. Hitmonlee can extend its legs to kick opponents from surprisingly long distances. Its fighting style is heavily inspired by kickboxing techniques.", types: [.fighting]),
    Pokemon(id: 107, name: "hitmonchan", description: "A boxing Pokemon famous for its lightning-fast punches that are invisible to the untrained eye. Hitmonchan trains rigorously, even punching through concrete to strengthen its fists. It wears a purple tunic reminiscent of boxing shorts and never gives up in a fight.", types: [.fighting]),
    Pokemon(id: 108, name: "lickitung", description: "A pink Pokemon with an incredibly long, versatile tongue that extends over twice its body length. Its tongue contains special nerves that can determine the texture and composition of anything it licks. Lickitung uses its tongue for both battling and gathering food from hard-to-reach places.", types: [.normal]),
    Pokemon(id: 109, name: "koffing", description: "A poison-type Pokemon that floats by containing lightweight toxic gases within its round body. Koffing can expel noxious fumes from the craters covering its surface when threatened or excited. It tends to gather in polluted areas where it can absorb more toxins to strengthen itself.", types: [.poison], evolutionIds: [110]),
    Pokemon(id: 110, name: "weezing", description: "The evolved form of Koffing, consisting of two connected spherical bodies that create more potent poison gases. Weezing's internal chemicals can generate over 70 different types of toxic gases. It often lives near waste facilities where it feeds on garbage and transforms it into poisonous gases.", types: [.poison]),
    Pokemon(id: 111, name: "rhyhorn", description: "A rock-plated rhinoceros Pokemon with limited intelligence but tremendous charging power. Once Rhyhorn begins to run, it has difficulty stopping due to its one-track mind. Its rocky hide is so tough that not even dynamite can scratch it.", types: [.ground, .rock], evolutionIds: [112]),
    Pokemon(id: 112, name: "rhydon", description: "The evolved form of Rhyhorn, standing on its hind legs with an even more formidable horn and protective plates. Rhydon's horn can drill through solid bedrock and can even shatter diamonds. Its brain developed after evolution, making it significantly more intelligent than its pre-evolved form.", types: [.ground, .rock]),
    Pokemon(id: 113, name: "chansey", description: "A pink, egg-shaped Pokemon known for its incredible kindness and healing abilities. Chansey carries a nutritious egg in its pouch that it shares with injured Pokemon and people. It has an incredibly rare spawn rate in the wild, making it highly sought after by trainers.", types: [.normal]),
    Pokemon(id: 114, name: "tangela", description: "A Pokemon completely covered in thick blue vines that conceal its true form. Tangela's vines constantly grow, break, and regrow throughout its lifetime. It can extend these vines to ensnare prey or defend itself from predators.", types: [.grass]),
    Pokemon(id: 115, name: "kangaskhan", description: "A maternal Pokemon that carries its young in a pouch on its belly. Kangaskhan is fiercely protective of its baby and will become aggressive if it perceives any threat. The baby itself never leaves the pouch until it's ready to become a parent itself.", types: [.normal]),
    Pokemon(id: 116, name: "horsea", description: "A small, seahorse-like Pokemon that sprays ink to escape from predators. Horsea is an excellent swimmer that uses its prehensile tail to anchor itself to coral when ocean currents become too strong. It feeds on microscopic organisms that it draws in through its tube-like mouth.", types: [.water], evolutionIds: [117]),
    Pokemon(id: 117, name: "seadra", description: "The evolved form of Horsea with a more menacing appearance and poisonous spines. Seadra can generate whirlpools by spinning its body rapidly in water. Males are responsible for hatching eggs, fiercely guarding their young from any potential threats.", types: [.water]),
    Pokemon(id: 118, name: "goldeen", description: "A white and orange fish Pokemon with a horn on its forehead. Goldeen is known for its elegant swimming patterns and beautiful flowing tail. It can be quite aggressive despite its delicate appearance, using its horn to fiercely protect its territory.", types: [.water], evolutionIds: [119]),
    Pokemon(id: 119, name: "seaking", description: "The evolved form of Goldeen, with more pronounced fins and a larger horn. Seaking migrates upstream to spawn in the autumn, fighting its way against currents with powerful tail strokes. Its horn is used for both battling rival males during mating season and for burrowing into riverbed soil to look for food.", types: [.water]),
    Pokemon(id: 120, name: "staryu", description: "A star-shaped Pokemon with a jewel-like core at its center that glows with mysterious power. Staryu can regenerate its body as long as its core remains intact. At night, groups of Staryu often gather at shorelines where their cores blink in beautiful patterns like stars.", types: [.water], evolutionIds: [121]),
    Pokemon(id: 121, name: "starmie", description: "The evolved form of Staryu, featuring a second star attached to the back of the first. Starmie's central core glows with seven different colors, and it can communicate using electrical pulses from this core. It is an incredibly fast swimmer, using psychic powers to glide through water at high speeds.", types: [.water, .psychic]),
    Pokemon(id: 122, name: "mr-mime", description: "A psychic Pokemon known for its pantomime abilities and invisible barriers it creates with its fingertips. Mr. Mime practices its mime routines constantly, confusing observers with its convincing imitations. Its fingers are so dexterous that they can solidify air into actual walls.", types: [.psychic, .fairy]),
    Pokemon(id: 123, name: "scyther", description: "An insectoid Pokemon with sharp blade-like forearms capable of slicing through steel. Scyther moves so quickly it appears to be flying when it runs. Its mastery of swordsmanship has earned it the nickname 'the mantis Pokemon'.", types: [.bug, .flying]),
    Pokemon(id: 124, name: "jynx", description: "A humanoid Pokemon with icy powers and hypnotic dancing abilities. Jynx communicates using a language that sounds similar to human speech but remains indecipherable. Its swaying motions and vocalizations can lull opponents into a deep trance.", types: [.ice, .psychic]),
    Pokemon(id: 125, name: "electabuzz", description: "A yellow and black striped electric Pokemon that generates powerful electricity. Electabuzz is often found during thunderstorms, where it competes with others of its kind to reach electrically charged ground struck by lightning. It can cause major power outages when it gathers near power plants.", types: [.electric]),
    Pokemon(id: 126, name: "magmar", description: "A fire-type Pokemon whose body constantly burns with orange flames. Magmar lives in and around active volcanoes, where the extreme heat feels pleasantly warm to its flame-resistant body. It can breathe fire reaching temperatures of nearly 2,200 degrees Fahrenheit.", types: [.fire]),
    Pokemon(id: 127, name: "pinsir", description: "A beetle-like Pokemon with large pincers on its head used to crush opponents. Pinsir's horns have enough crushing power to shatter thick logs and even crack boulders. It is highly territorial and uses its incredible strength to throw intruders great distances.", types: [.bug]),
    Pokemon(id: 128, name: "tauros", description: "A wild bull Pokemon known for its aggressive temperament and need for constant movement. Tauros becomes frustrated and uncontrollable if it doesn't have space to run, often charging recklessly at objects. It whips itself with its three tails to heighten its fighting spirit before charging.", types: [.normal]),
    Pokemon(id: 129, name: "magikarp", description: "A seemingly useless fish Pokemon notorious for being extremely weak and only capable of splashing. Magikarp is considered the weakest Pokemon in existence, barely able to swim against currents. However, it is incredibly hardy and can survive in virtually any body of water, no matter how polluted.", types: [.water], evolutionIds: [130]),
    Pokemon(id: 130, name: "gyarados", description: "The evolved form of Magikarp, transformed from a pathetic fish into a fearsome sea serpent with devastating power. Gyarados is known for its violent nature and ability to destroy entire cities in a rage. Ancient literature describes Gyarados as the embodiment of natural disasters, bringing storms and tsunamis wherever it appears.", types: [.water, .flying]),
    Pokemon(id: 131, name: "lapras", description: "A gentle, transport Pokemon that ferries people across bodies of water on its shell. Lapras is highly intelligent and can understand human speech. Unfortunately, it has been hunted nearly to extinction for its beautiful singing voice and tasty meat.", types: [.water, .ice]),
    Pokemon(id: 132, name: "ditto", description: "A shapeless purple Pokemon with the unique ability to transform into an exact copy of anything it sees. Ditto's cellular structure is unique, allowing it to completely reorganize its cells to match another Pokemon's appearance and abilities. When it tries to transform from memory, it sometimes gets details wrong.", types: [.normal]),
    Pokemon(id: 133, name: "eevee", description: "A mammalian Pokemon with an unstable genetic makeup that allows it to evolve into multiple different forms. Eevee adapts to its environment by changing its cellular structure, which triggers its evolution. Its irregular genetic code is the focus of many scientific studies.", types: [.normal], evolutionIds: [134, 135, 136]),
    Pokemon(id: 134, name: "vaporeon", description: "A water-type evolution of Eevee with fish-like features and the ability to melt into water. Vaporeon's cellular composition is similar to water molecules, allowing it to become invisible while submerged. It can manipulate water at will and helps purify polluted lakes and rivers.", types: [.water]),
    Pokemon(id: 135, name: "jolteon", description: "An electric evolution of Eevee with a spiky appearance and incredible speed. Jolteon can generate negative ions that spark into lightning bolts, and its cells generate electricity when agitated. It shoots pin-like fur that works as electrical needles when it feels threatened.", types: [.electric]),
    Pokemon(id: 136, name: "flareon", description: "A fire-type evolution of Eevee with an internal flame sac that can produce temperatures up to 1,650 degrees Fahrenheit. Flareon stores thermal energy in its fluffy fur, which can reach temperatures of over 200 degrees. It inhales air to fuel the fire burning inside its body.", types: [.fire]),
    Pokemon(id: 137, name: "porygon", description: "The first artificial Pokemon created entirely from programming code. Porygon can travel through cyberspace and electronic devices by converting its body into digital data. Though designed to work in space, its movement capabilities are somewhat limited by its blocky design.", types: [.normal]),
    Pokemon(id: 138, name: "omanyte", description: "An ancient Pokemon revived from a fossil, with a spiral shell and tentacles. Omanyte became extinct millions of years ago but has been brought back through cloning technology. It uses its tentacles to swim and capture prey, retracting into its hard shell when threatened.", types: [.rock, .water], evolutionIds: [139]),
    Pokemon(id: 139, name: "omastar", description: "The evolved form of Omanyte with a larger shell and more powerful tentacles. Omastar is believed to have gone extinct because its shell grew too heavy to move effectively. Its powerful tentacles could break through prey's shells, but it was too slow to catch the faster, more agile prey that evolved later.", types: [.rock, .water]),
    Pokemon(id: 140, name: "kabuto", description: "An ancient horseshoe crab-like Pokemon revived from a fossil found on the ocean floor. Kabuto has remained unchanged for 300 million years and uses its sharp claws to capture prey. Its shell is remarkably durable, protecting its soft organs from even the strongest attacks.", types: [.rock, .water], evolutionIds: [141]),
    Pokemon(id: 141, name: "kabutops", description: "The evolved form of Kabuto, which adapted to living on land with scythe-like arms. Kabutops was a swift hunter that sliced prey with its razor-sharp forearms, then sucked out their bodily fluids. It became extinct when its prey sources disappeared during ancient climate changes.", types: [.rock, .water]),
    Pokemon(id: 142, name: "aerodactyl", description: "A ferocious prehistoric Pokemon revived from old amber containing its DNA. Aerodactyl was the apex predator of its time, soaring through ancient skies with its large, powerful wings. Its serrated teeth and sharp claws made it a formidable hunter that struck fear into other prehistoric Pokemon.", types: [.rock, .flying]),
    Pokemon(id: 143, name: "snorlax", description: "An enormous Pokemon known for its insatiable appetite and tendency to sleep for long periods. Snorlax eats about 900 pounds of food daily before falling into a deep slumber, becoming impossible to move or wake. Despite its laziness, it has tremendous strength and power when actively battling.", types: [.normal]),
    Pokemon(id: 144, name: "articuno", description: "A legendary ice bird Pokemon that controls frigid winds and brings winter with its passage. Articuno's feathers glisten with an icy sheen and release cold air when it flies. It appears to help people and Pokemon lost in icy mountains, guiding them to safety with its majestic presence.", types: [.ice, .flying]),
    Pokemon(id: 145, name: "zapdos", description: "A legendary electric bird Pokemon that generates massive amounts of electricity and lives in thunderclouds. Zapdos creates thunderstorms wherever it flies, with lightning constantly crackling around its sharp feathers. It's said to appear only during major electrical storms, feeding directly on lightning bolts.", types: [.electric, .flying]),
    Pokemon(id: 146, name: "moltres", description: "A legendary fire bird Pokemon whose body burns with the intensity of magma and whose wings scatter embers as it flies. Moltres is known to help those with a pure heart and appears to worthy trainers. Its appearance signals the end of winter as it brings the warmth of spring wherever it goes.", types: [.fire, .flying]),
    Pokemon(id: 147, name: "dratini", description: "An extremely rare dragon Pokemon that starts its life small but has enormous potential for growth. Dratini was long thought to be mythical until a colony was discovered living underwater. It sheds its skin regularly as it grows, hiding away during this vulnerable process.", types: [.dragon], evolutionIds: [148, 149]),
    Pokemon(id: 148, name: "dragonair", description: "The evolved form of Dratini, with a more serpentine body and crystal orbs that can control the weather. Dragonair emits a gentle aura that gives people a sense of wonder and happiness. It can fly despite lacking wings, gliding gracefully through the air as if swimming.", types: [.dragon], evolutionIds: [149]),
    Pokemon(id: 149, name: "dragonite", description: "The final evolution of Dratini, transforming from a serpent into a bipedal dragon with tremendous power. Despite its intimidating appearance, Dragonite is known for its intelligence and kind heart, even helping to guide lost ships safely to land. It can fly around the globe in just 16 hours, breaking the sound barrier with ease.", types: [.dragon, .flying]),
    Pokemon(id: 150, name: "mewtwo", description: "A genetically engineered Pokemon created by scientists who manipulated Mew's DNA. Mewtwo possesses immense psychic power and a savage heart filled with anger at its creators. Its combat abilities exceed those of any natural Pokemon, making it one of the most dangerous beings in existence.", types: [.psychic]),
    Pokemon(id: 151, name: "mew", description: "A mythical Pokemon believed to contain the genetic code of all other Pokemon species. Mew is playful and elusive, capable of turning invisible at will to avoid detection. Scientists believe it is the ancestor of all modern Pokemon, possessing the ability to learn any move or technique.", types: [.psychic])
]

/*
 https://www.hackingwithswift.com/quick-start/swiftui/whats-the-difference-between-observedobject-state-and-environmentobject
 https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-environmentobject-to-share-data-between-views
 */
