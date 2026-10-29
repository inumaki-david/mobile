// lib/services/meal_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';

class MealApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Busca receitas pelo termo digitado (se vazio, busca por "chicken" como padrão)
  Future<List<Recipe>> searchRecipes(String query) async {
    final searchTerm = query.trim().isEmpty ? 'chicken' : query.trim();
    final url = Uri.parse('$_baseUrl/search.php?s=$searchTerm');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List? meals = data['meals'];

        if (meals == null) return [];

        return meals.map((mealJson) => Recipe.fromApiJson(mealJson)).toList();
      } else {
        throw Exception('Falha ao carregar receitas da API');
      }
    } catch (e) {
      throw Exception('Erro de conexão com a API: $e');
    }
  }
}
