// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/recipe_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Retorna a referência para a coleção de receitas do usuário logado
  CollectionReference _userRecipesCollection() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');
    return _db.collection('users').doc(user.uid).collection('recipes');
  }

  // CREATE: Salva uma receita no caderno do usuário
  Future<void> saveRecipe(Recipe recipe) async {
    try {
      final docRef = _userRecipesCollection().doc(recipe.id);
      await docRef.set(recipe.toFirestore());
    } catch (e) {
      throw Exception('Erro ao salvar receita: $e');
    }
  }

  // READ: Obtém as receitas salvas em tempo real
  Stream<List<Recipe>> getSavedRecipes() {
    return _userRecipesCollection().snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Recipe.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // DELETE: Remove uma receita do caderno
  Future<void> deleteRecipe(String recipeId) async {
    try {
      await _userRecipesCollection().doc(recipeId).delete();
    } catch (e) {
      throw Exception('Erro ao deletar receita: $e');
    }
  }
}
