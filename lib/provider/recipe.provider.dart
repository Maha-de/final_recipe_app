import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:recipe_app/models/recipe.models.dart';

import '../utilities/toast_message_status.dart';
import '../widgets/toast_message.widgets.dart';

class RecipeProvider extends ChangeNotifier {
  var value = {"type": "breakfast", "serving": 5, "total_time": 20};
  late String _profileImageUrl = '';
  String get profileImageUrl => _profileImageUrl;
  static final storage = FirebaseStorage.instance;

  Future<String?> getProfileImageUrl(String userId) async {
    try {
      final ref = storage.ref().child('profile_images/$userId');
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      // Handle error
      print('Error getting profile image URL: $e');
      return null;
    }
  }

  // Future<void> setProfileImageUrl(String userId) async {
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userId)
  //       .get();
  //
  //   _profileImageUrl = snapshot.data()?['profileImageUrl'];
  //   notifyListeners();
  // }




  Future<void> getFilteredResult() async {
    try {
      var ref = FirebaseFirestore.instance.collection('recipes');

      for (var entry in value.entries) {
        ref.where(entry.key, isEqualTo: entry.value);
      }

      var result = await ref.get();
      result;
      print(result);
    } catch (e) {
      print("Error $e");
    }
  }

  List<Recipe>? _recipeList;

  List<Recipe>? get recipeList => _recipeList;

  List<Recipe>? _freshRecipesList;

  List<Recipe>? get freshRecipesList => _freshRecipesList;

  List<Recipe>? _recommendedRecipesList;

  List<Recipe>? get recommendedRecipesList => _recommendedRecipesList;

  List<Recipe>? _recentlyRecipesList;

  List<Recipe>? get recentlyRecipesList => _recentlyRecipesList;

  List<Recipe>? _filteredRecipesList;

  List<Recipe>? get filteredRecipesList => _filteredRecipesList;

  Recipe? openedRecipe;

  Future<void> getSelectedRecipe(String recipeId) async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .get();
      if (result.data() != null) {
        openedRecipe = Recipe.fromJson(result.data()!, result.id);
      } else {
        return;
      }
      notifyListeners();
    } catch (e) {
      print('>>>>>error in update recipe');
    }
  }

  Future<void> getRecipes() async {
    try {
      var result = await FirebaseFirestore.instance.collection('recipes').get();

      if (result.docs.isNotEmpty) {
        _recipeList = List<Recipe>.from(
            result.docs.map((doc) => Recipe.fromJson(doc.data(), doc.id)));
      } else {
        _recipeList = [];
        print(_recipeList?.length);
      }
      notifyListeners();
    } catch (e) {
      _recipeList = [];
      notifyListeners();
      print(_recipeList?.length);
      print('>>>>>error in update recipe$e');
    }
  }

  Future<void> getFreshRecipes() async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('recipes')
          .where('isFresh', isEqualTo: true)
          .limit(4)
          .get();

      if (result.docs.isNotEmpty) {
        _freshRecipesList = List<Recipe>.from(
            result.docs.map((doc) => Recipe.fromJson(doc.data(), doc.id)));
      } else {
        _freshRecipesList = [];
      }
      notifyListeners();
    } catch (e) {
      _freshRecipesList = [];
      notifyListeners();
      print('>>>>>error in update recipe$e');
    }
  }

  Future<void> getRecommendedRecipes() async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('recipes')
          .where('isFresh', isEqualTo: false)
          .limit(4)
          .get();
      if (result.docs.isNotEmpty) {
        _recommendedRecipesList = List<Recipe>.from(
            result.docs.map((doc) => Recipe.fromJson(doc.data(), doc.id)));
      } else {
        _recommendedRecipesList = [];
      }
      notifyListeners();
    } catch (e) {
      _recommendedRecipesList = [];
      notifyListeners();
      print('>>>>>error in update recipe$e');
    }
  }
  // added new to test the function
  // Future<void> addRecentlyToUserFavourite(String recipeId, bool isAdd) async {
  //   try {
  //     OverlayLoadingProgress.start();
  //     if (isAdd) {
  //       await FirebaseFirestore.instance
  //           .collection('recipes')
  //           .doc(recipeId)
  //           .update({
  //         "recently_viewd_users_ids":
  //         FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])
  //       });
  //     } else {
  //       await FirebaseFirestore.instance
  //           .collection('recipes')
  //           .doc(recipeId)
  //           .update({
  //         "recently_viewd_users_ids":
  //         FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid])
  //       });
  //       print(FieldValue);
  //     }
  //     await _updateRecipe(recipeId);
  //     OverlayLoadingProgress.stop();
  //   } catch (e) {
  //     OverlayLoadingProgress.stop();
  //     OverlayToastMessage.show(
  //       widget: ToastMessageWidget(
  //         message: 'Error : ${e.toString()}',
  //         toastMessageStatus: ToastMessageStatus.failed,
  //       ),
  //     );
  //   }
  // }

  void addRecipeToUserRecentlyViewed(String recipeId) async {
    try {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .update({
        "recently_viewd_users_ids":
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])
      });
    } catch (e) {}
  }

  void removeRecipeToUserRecentlyViewed(String recipeId) async {
    try {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .update({
        "recently_viewd_users_ids":
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid])
      });
    } catch (e) {}
  }

  Future<void> addRecipeToUserFavourite(String recipeId, bool isAdd) async {
    try {
      OverlayLoadingProgress.start();
      if (isAdd) {
        await FirebaseFirestore.instance
            .collection('recipes')
            .doc(recipeId)
            .update({
          "favourite_users_ids":
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('recipes')
            .doc(recipeId)
            .update({
          "favourite_users_ids":
              FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid])
        });
      }
      await _updateRecipe(recipeId);
      OverlayLoadingProgress.stop();
    } catch (e) {
      OverlayLoadingProgress.stop();
      OverlayToastMessage.show(
        widget: ToastMessageWidget(
          message: 'Error : ${e.toString()}',
          toastMessageStatus: ToastMessageStatus.failed,
        ),
      );
    }
  }


  Future<void> _updateRecipe(String recipeId) async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .get();
      Recipe? updatedRecipe;
      if (result.data() != null) {
        updatedRecipe = Recipe.fromJson(result.data()!, result.id);
      } else {
        return;
      }

      var recipesListIndex =
          recipeList?.indexWhere((recipe) => recipe.docId == recipeId);

      if (recipesListIndex != -1) {
        recipeList?.removeAt(recipesListIndex!);
        recipeList?.insert(recipesListIndex!, updatedRecipe);
      }

      var freshRecipesListIndex =
          freshRecipesList?.indexWhere((recipe) => recipe.docId == recipeId);

      if (freshRecipesListIndex != -1) {
        freshRecipesList?.removeAt(freshRecipesListIndex!);
        freshRecipesList?.insert(freshRecipesListIndex!, updatedRecipe);
      }

      var recommendedRecipesListIndex = recommendedRecipesList
          ?.indexWhere((recipe) => recipe.docId == recipeId);

      if (recommendedRecipesListIndex != -1) {
        recommendedRecipesList?.removeAt(recommendedRecipesListIndex!);
        recommendedRecipesList?.insert(
            recommendedRecipesListIndex!, updatedRecipe);
      }

      notifyListeners();
    } catch (e) {
      print('>>>>>error in update recipe');
    }
  }
}

