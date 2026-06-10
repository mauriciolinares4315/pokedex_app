import 'dart:convert';
import 'package:http/http.dart' as http;

class PokeService {
  
  static const String _baseUrl = 'https://pokeapi.co/api/v2';

  
  Future<Map<String, dynamic>> obtenerPokemon(String idONombre) async {
    // PASO 1: construir la URL
    final url = Uri.parse('$_baseUrl/pokemon/$idONombre');

    // PASO 2: hacer el GET
    final response = await http.get(url);

    // PASO 3: verificar el status code y retornar o lanzar
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 404) {
      throw Exception('Pokémon "$idONombre" no encontrado');
    } else {
      throw Exception('Error del servidor: ${response.statusCode}');
    }
  }
}