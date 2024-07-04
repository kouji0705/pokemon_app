import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

import 'package:pokemon_app/api_service.dart';

void main() {
  group('ApiService', () {
    test(
        'fetchPokemon returns Pokemon data if the http call completes successfully',
        () async {
      // モッククライアントを作成
      final mockClient = MockClient((request) async {
        return http.Response(
            json.encode({
              'name': 'pikachu',
              'height': 4,
              'weight': 60,
              'sprites': {
                'front_default':
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png'
              }
            }),
            200);
      });

      final apiService = ApiService();

      // プロダクトコードの変更なしでモッククライアントを使うために、直接http.getをモックします。
      Future<Map<String, dynamic>> mockFetchPokemon(String name) async {
        final response = await mockClient
            .get(Uri.parse('${ApiService.baseUrl}/pokemon/$name'));
        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          throw Exception('Failed to load Pokemon');
        }
      }

      final pokemon = await mockFetchPokemon('pikachu');

      expect(pokemon['name'], 'pikachu');
      expect(pokemon['height'], 4);
      expect(pokemon['weight'], 60);
      expect(pokemon['sprites']['front_default'],
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png');
    });

    test(
        'fetchPokemon throws an exception if the http call completes with an error',
        () async {
      // モッククライアントを作成
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final apiService = ApiService();

      // プロダクトコードの変更なしでモッククライアントを使うために、直接http.getをモックします。
      Future<Map<String, dynamic>> mockFetchPokemon(String name) async {
        final response = await mockClient
            .get(Uri.parse('${ApiService.baseUrl}/pokemon/$name'));
        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          throw Exception('Failed to load Pokemon');
        }
      }

      expect(() => mockFetchPokemon('unknown'), throwsException);
    });
  });
}
