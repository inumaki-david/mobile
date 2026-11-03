// lib/screens/my_notebook_screen.dart
import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../services/firestore_service.dart';
import 'recipe_detail_screen.dart';
import '../widgets/recipe_card.dart';

class MyNotebookScreen extends StatelessWidget {
  const MyNotebookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Caderno 📖'),
      ),
      body: StreamBuilder<List<Recipe>>(
        stream: firestoreService.getSavedRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          
          final recipes = snapshot.data ?? [];
          
          if (recipes.isEmpty) {
            return const Center(
              child: Text('Seu caderno está vazio.\nBusque receitas e salve-as aqui!', textAlign: TextAlign.center),
            );
          }

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Dismissible(
                key: Key(recipe.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  firestoreService.deleteRecipe(recipe.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Receita removida do caderno.')),
                  );
                },
                child: RecipeCard(recipe: recipe),
              );
            },
          );
        },
      ),
    );
  }
}
