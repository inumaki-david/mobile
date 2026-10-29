// lib/models/recipe_model.dart
class Recipe {
  final String id;
  final String title;
  final String category;
  final String area;
  final String imageUrl;
  final List<String> instructions; // Mapeado como Lista
  final List<String> ingredients;  // Mapeado como Lista

  Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.area,
    required this.imageUrl,
    required this.instructions,
    required this.ingredients,
  });

  // Converte a resposta JSON da API TheMealDB para o nosso objeto Recipe
  factory Recipe.fromApiJson(Map<String, dynamic> json) {
    List<String> parsedIngredients = [];
    
    // A API TheMealDB possui até 20 ingredientes enumerados
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        final text = (measure != null && measure.toString().trim().isNotEmpty)
            ? '$measure $ingredient'
            : ingredient;
        parsedIngredients.add(text);
      }
    }

    // Divide o bloco de instruções em passos individuais (separados por quebra de linha)
    final rawInstructions = json['strInstructions'] as String? ?? '';
    List<String> parsedInstructions = rawInstructions
        .split('\r\n')
        .where((step) => step.trim().isNotEmpty)
        .toList();

    return Recipe(
      id: json['idMeal'] ?? '',
      title: json['strMeal'] ?? '',
      category: json['strCategory'] ?? 'Geral',
      area: json['strArea'] ?? 'Internacional',
      imageUrl: json['strMealThumb'] ?? '',
      instructions: parsedInstructions,
      ingredients: parsedIngredients,
    );
  }

  // Converte o objeto para Map (será útil para salvar no Firestore no Passo 4)
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'area': area,
      'imageUrl': imageUrl,
      'instructions': instructions, // Salva como Array de Strings no Firestore
      'ingredients': ingredients,   // Salva como Array de Strings no Firestore
    };
  }

  // Converte do formato do Firestore de volta para o objeto Recipe
  factory Recipe.fromFirestore(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      area: json['area'],
      imageUrl: json['imageUrl'],
      instructions: List<String>.from(json['instructions'] ?? []),
      ingredients: List<String>.from(json['ingredients'] ?? []),
    );
  }
}