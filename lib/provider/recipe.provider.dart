import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe.models.dart';

class RecipeProvider extends ChangeNotifier {
  List<Recipe>? _recipeList;
  List<Recipe>? get recipeList => _recipeList;

  Future<void> getRecipes() async {
    try {
      var result = await FirebaseFirestore.instance
          .collection("recipes")
      // .where("isActive", isEqualTo: true)
          .get();
      if (result.docs.isNotEmpty) {
        _recipeList = List<Recipe>.from(
            result.docs.map((doc) => Recipe.fromJson(doc.data(), doc.id)));
        print("Succsess to recive list");
        print(result);
      } else {
        _recipeList = [];
      }
      notifyListeners();
    } catch (e) {
      _recipeList = [];
      notifyListeners();
    }
  }

  getDataStream() {}
}
