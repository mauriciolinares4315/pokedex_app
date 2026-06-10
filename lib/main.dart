import 'package:detalle_pokemon_app/presentation/screen/pokemon_detail_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const PokedexApp());

   class PokedexApp extends StatelessWidget {
     const PokedexApp({super.key});
     @override
     Widget build(BuildContext context) {
       return MaterialApp(
         title: 'Pokédex',
         debugShowCheckedModeBanner: false,
         theme: ThemeData.dark().copyWith(
           scaffoldBackgroundColor: kBgDark,
           appBarTheme: const AppBarTheme(
             backgroundColor: kPokeRed,
             foregroundColor: Colors.white,
             elevation: 0,
           ),
         ),
         home : const HomeScreen(),
        // home: const PokemonDetailScreen(idONombre:"mew" ),
       );
     }
   }

   class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nombre o ID',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                final texto =
                    _controller.text.trim().toLowerCase();

                if (texto.isEmpty) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PokemonDetailScreen(
                      idONombre: texto,
                    ),
                  ),
                );
              },
              child: const Text('Buscar'),
            ),
          ],
        ),
      ),
    );
  }
}