import 'package:audioplayers/audioplayers.dart';
import 'package:detalle_pokemon_app/presentation/screen/poke_service.dart';
import 'package:flutter/material.dart';


// ── Colores del tema Pokédex ──────────────────────────────────────────────────
const kPokeRed    = Color(0xFFCC0000);
const kPokeYellow = Color(0xFFFFCC00);
const kBgDark     = Color(0xFF1A1A2E);
const kCardBg     = Color(0xFF16213E);
const kTextLight  = Color(0xFFE0E0E0);
const kTextMuted  = Color(0xFF9E9E9E);

class PokemonData {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final double height;  // en metros
  final double weight;  // en kg
  final int baseXp;
  final List<Map<String, dynamic>> stats;

  const PokemonData({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
    required this.baseXp,
    required this.stats,
  });
}

// Datos de prueba — reemplaza con tu integración de la API en la Fase final
const kPikachuData = PokemonData(
  id: 25,
  name: 'pikachu',
  imageUrl:
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png',
  types: ['electric'],
  height: 0.4,
  weight: 6.0,
  baseXp: 112,
  stats: [
    {'name': 'hp',      'value': 35},
    {'name': 'attack',  'value': 55},
    {'name': 'defense', 'value': 40},
    {'name': 'speed',   'value': 50},
  ],
);

class PokemonDetailScreen extends StatefulWidget {
  final String idONombre;

  const PokemonDetailScreen({
    super.key,
    required this.idONombre,
  });

  @override
  State<PokemonDetailScreen> createState() =>
      _PokemonDetailScreenState();
}

class _PokemonDetailScreenState
    extends State<PokemonDetailScreen> {

      final PokeService _service = PokeService();
      final AudioPlayer _audioPlayer = AudioPlayer();

PokemonData? pokemon;
bool cargando = true;
String? error;

@override
void initState() {
  super.initState();
  _cargarPokemon();
  
}

Future<void> _cargarPokemon() async {
  setState(() {
    cargando = true;
    error = null;
  });

  try {
    final json =
        await _service.obtenerPokemon(widget.idONombre);

    final data = PokemonData(
      id: json['id'],
      name: json['name'],
      imageUrl:
          json['sprites']['other']['official-artwork']['front_default'],
      types: (json['types'] as List)
          .map((t) => t['type']['name'].toString())
          .toList(),
      height: (json['height'] / 10),
      weight: (json['weight'] / 10),
      baseXp: json['base_experience'] ?? 0,
      stats: (json['stats'] as List)
          .map((s) => {
                'name': s['stat']['name'],
                'value': s['base_stat'],
              })
          .toList(),
    );

    setState(() {
      pokemon = data;
      cargando = false;
    });
  } catch (e) {
    setState(() {
      error = e.toString();
      cargando = false;
    });
  }
}
String _getCryUrl(int pokemonId) {
  return 'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/$pokemonId.ogg';
}

Future<void> _playPokemonCry(int pokemonId) async {
  try {
    await _audioPlayer.play(
      UrlSource(_getCryUrl(pokemonId)),
    );
  } catch (e) {
    debugPrint('Error al reproducir audio: $e');
  }
}

@override
void dispose() {
  _audioPlayer.dispose();
  super.dispose();
}



Color _backgroundColor(String type) {
    switch (type) {
      case 'fire':
        return Colors.deepOrange.shade900;

      case 'water':
        return Colors.blue.shade900;

      case 'electric':
        return Colors.amber.shade900;

      default:
        return kBgDark;
    }
  }

  @override
Widget build(BuildContext context) {
  // 🔄 Loading
  if (cargando) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFFFFCC00),
        ),
      ),
    );
  }

  // ❌ Error
  if (error != null) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Error al cargar el Pokémon',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cargarPokemon,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  // ✅
  final p = pokemon!;

  return Scaffold(
      backgroundColor:
      _backgroundColor(p.types.first),
    appBar: AppBar(
      title: const Text(
        'Pokédex',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.white),
          onPressed: () {},
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Image.network(
              p.imageUrl,
              height: 220,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const SizedBox(
                  height: 220,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFFCC00),
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stack) => const Icon(
                Icons.catching_pokemon,
                size: 80,
                color: Color(0xFFFFCC00),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${p.id.toString().padLeft(3, '0')}',
                  style: const TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(
                          p.name.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFFE0E0E0),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.volume_up,
                          color: kPokeYellow,
                          size: 32,
                        ),
                        onPressed: () => _playPokemonCry(p.id),
                      ),
                    Row(
                      children: p.types
                          .map((t) => Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: _TypeChip(type: t),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF16213E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _InfoItem(label: 'Altura', value: '${p.height}m'),
                    _InfoItem(label: 'Peso', value: '${p.weight}kg'),
                    _InfoItem(label: 'XP base', value: '${p.baseXp}'),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: Colors.white12),
                ),
                const Text(
                  'Stats',
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 13,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                ...p.stats.map(
                  (s) => _StatBar(
                    name: s['name'] as String,
                    value: s['value'] as int,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
class _TypeChip extends StatelessWidget {
  final String type;
  const _TypeChip({required this.type});

  // TODO: implementa _colorForType(String type) → Color
  Color _colorForType(String type) {
    switch (type) {
       case 'fire':     return Colors.deepOrange;
       case 'water':    return Colors.blue;
       case 'electric': return Colors.amber;
       case 'grass':    return Colors.green;
       case 'psychic':  return Colors.pink;
       case 'normal':   return Colors.grey;
       default:         return Colors.purple;
     }
  }

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 4,
    ),
    decoration: BoxDecoration(
      color: _colorForType(type),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      type,
      style: const TextStyle(
        color: Color(0xFF333333),
        fontWeight: FontWeight.bold,
      ),
        )
     ); // reemplaza esto
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: kTextMuted,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: kTextLight,
        ),
      ),
    ],
  );
}
}
class _StatBar extends StatelessWidget {
  final String name;
  final int value;
  const _StatBar({required this.name, required this.value});

  // Color de la barra según el rango del valor
  Color _barColor() {
    if (value >= 80) return Colors.green;
    if (value >= 50) return Colors.amber;
    return Colors.redAccent;
  }

  @override
 Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            name,
            style: const TextStyle(
              color: kTextMuted,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 150,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation(_barColor()),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 32,
          child: Text(
            value.toString(),
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: kTextLight,
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  );
}
}

// ─────────────────────────────────────────────────────────────────────────────
// FASE 8 (RETO) — Conectar con la PokéAPI
// ─────────────────────────────────────────────────────────────────────────────
// Convierte PokemonDetailScreen en StatefulWidget y:
//
// 1. Recibe un String idONombre en lugar de PokemonData
// 2. En initState() llama a tu PokeService.obtenerPokemon()
//    (del taller anterior en Dart)
// 3. Mientras carga → muestra CircularProgressIndicator centrado
// 4. Si hay error → muestra un mensaje con botón de reintentar
// 5. Si cargó → muestra la pantalla completa con los datos reales
//
// La pantalla de inicio (home en main.dart) podría tener un
// TextField para escribir el nombre y un botón que navega a
// PokemonDetailScreen con Navigator.push()
