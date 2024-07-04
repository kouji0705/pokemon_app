import 'package:flutter/material.dart';

import 'api_service.dart';

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
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _error != null
                ? Text('Error: $_error')
                : _pokemonData != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _pokemonData!['name'].toString().toUpperCase(),
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          if (_pokemonData!['sprites'] != null &&
                              _pokemonData!['sprites']['front_default'] != null)
                            Image.network(
                              _pokemonData!['sprites']['front_default'],
                              height: 200,
                              width: 200,
                            ),
                          SizedBox(height: 20),
                          Text(
                            'Height: ${_pokemonData!['height']}',
                            style: TextStyle(fontSize: 24),
                          ),
                          Text(
                            'Weight: ${_pokemonData!['weight']}',
                            style: TextStyle(fontSize: 24),
                          ),
                        ],
                      )
                    : Container(),
      ),
    );
  }
}
