import 'package:flutter/material.dart';
import 'package:pokemon_app/api_service.dart';

void main() {
  runApp(PokemonApp());
}

class PokemonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PokemonHomePage(),
    );
  }
}

class PokemonHomePage extends StatefulWidget {
  @override
  _PokemonHomePageState createState() => _PokemonHomePageState();
}

class _PokemonHomePageState extends State<PokemonHomePage> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _pokemonData;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDefaultPokemon();
  }

  void _fetchDefaultPokemon() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await _apiService.fetchPokemon('pikachu');
      setState(() {
        _pokemonData = data;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokemon App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_isLoading) CircularProgressIndicator(),
            if (_error != null) Text('Error: $_error'),
            if (_pokemonData != null) ...[
              Text(
                _pokemonData!['name'].toString().toUpperCase(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              if (_pokemonData!['sprites'] != null &&
                  _pokemonData!['sprites']['front_default'] != null)
                Image.network(_pokemonData!['sprites']['front_default']),
              Text('Height: ${_pokemonData!['height']}'),
              Text('Weight: ${_pokemonData!['weight']}'),
            ],
          ],
        ),
      ),
    );
  }
}
