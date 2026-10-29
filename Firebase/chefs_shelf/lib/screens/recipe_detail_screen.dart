// lib/screens/recipe_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../services/firestore_service.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            tooltip: 'Salvar Receita',
            onPressed: () async {
              try {
                await firestoreService.saveRecipe(recipe);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Receita salva no seu caderno!'), backgroundColor: Colors.green),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(recipe.imageUrl, width: double.infinity, height: 250, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ingredientes', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  ...recipe.ingredients.map((ingredient) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            const Icon(Icons.circle, size: 8, color: Colors.deepOrange),
                            const SizedBox(width: 8),
                            Expanded(child: Text(ingredient)),
                          ],
                        ),
                      )),
                  const Divider(height: 32),
                  Text('Modo de Preparo', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  ...recipe.instructions.map((step) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Text(step, style: const TextStyle(height: 1.5)),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
