import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:recipe_app/models/recipe.models.dart';
import 'package:recipe_app/utilities/edges.dart';
import 'package:recipe_app/widgets/today_widget.dart';

class FavoritePage extends StatefulWidget {

  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  late ZoomDrawerController controller;

  @override
  void initState() {
    controller = ZoomDrawerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SizedBox(
          width: 380,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('recipes')
                  .where("favourite_users_ids",
                  arrayContains: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  if (snapshots.hasError) {
                    return const Text('ERROR WHEN GET DATA');
                  } else {
                    if (snapshots.hasData) {
                      List<Recipe> recipesList = snapshots.data?.docs
                          .map((e) => Recipe.fromJson(e.data(), e.id))
                          .toList() ??
                          [];
                      return FlexibleGridView(
                        children: recipesList
                            .map((e) => RecipeWidget(recipe: e))
                            .toList(),
                        axisCount: GridLayoutEnum.twoElementsInRow,
                        shrinkWrap: true,
                        // crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      );
                    } else {
                      return const Text('No Data Found');
                    }
                  }
                }
              }),
        ),

      );
  }
}
