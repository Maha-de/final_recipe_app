import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/models/recipe.models.dart';
import 'package:recipe_app/provider/recipe.provider.dart';
import 'package:recipe_app/utilities/edges.dart';

import '../models/ingredient.models.dart';


class RecipeDetailsPage extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetailsPage({required this.recipe, super.key});

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  @override
  void initState() {
    Provider.of<RecipeProvider>(context, listen: false)
        .addRecipeToUserRecentlyViewed(widget.recipe.docId!);
    super.initState();
  }

  bool get isInList => (widget.recipe.favourite_users_ids
      ?.contains(FirebaseAuth.instance.currentUser?.uid) ??
      false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details page'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Edges.appHorizontalPadding),
        child: ListView(
          children: [
            Text(widget.recipe?.type ?? 'No Type Found',
              style: const TextStyle(
                color: Color(0xff2097b3),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),),
            ListTile(
                subtitle: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('ingredients')
                        .where('users_ids',
                        arrayContains: FirebaseAuth.instance.currentUser!.uid)
                        .get(),
                    builder: (context, snapShot) {
                      if (snapShot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else {
                        var userIngredients = List<Ingredient>.from(snapShot
                            .data!.docs
                            .map((e) => Ingredient.fromJson(e.data(), e.id))
                            .toList());

                        var userIngredientsTitles =
                        userIngredients.map((e) => e.name).toList();
                        Widget checkIngredientWidget(String recipeIngredient) {
                          bool isExsist = false;
                          for (var userIngredientsTitle in userIngredientsTitles) {
                            if (recipeIngredient.contains(userIngredientsTitle!)) {
                              isExsist = true;
                              break;
                            } else {
                              isExsist = false;
                            }
                          }

                          if (isExsist) {
                            return Icon(Icons.check);
                          } else {
                            return Icon(Icons.close);
                          }
                        }

                        return SingleChildScrollView( scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.recipe.ingredients
                                  ?.map((e) => Row(
                                                          children: [
                                  Text(e),
                                  checkIngredientWidget(e)
                                                          ],
                                                        ))
                                  .toList() ??
                                  [],
                            ),
                          ),
                        );
                      }
                    },
                    ),

                title: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(widget.recipe.title ?? 'No Title'),
                    SizedBox(width: 10,),
                    InkWell(
                        onTap: () {
                          Provider.of<RecipeProvider>(context, listen: false)
                              .addRecipeToUserFavourite(widget.recipe.docId!, !isInList);

                          if (isInList) {
                            widget.recipe.favourite_users_ids
                                ?.remove(FirebaseAuth.instance.currentUser?.uid);
                          } else {
                            widget.recipe.favourite_users_ids
                                ?.add(FirebaseAuth.instance.currentUser!.uid);
                          }

                          setState(() {});
                        },
                        child: isInList
                            ? const Icon(
                          Icons.favorite_border_rounded,
                          size: 30,
                          color: Colors.red,
                        )
                            : const Icon(
                          Icons.favorite_rounded,
                          size: 30,
                          color: Colors.grey,
                        )),
                      ],
                    ),
                    Text(widget.recipe.description ?? '',
                      maxLines: 10,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),),
                    SizedBox(height: 7,),
                    Text(widget.recipe.calories.toString() ?? '',
                      style: const TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),),
                    RatingBar.builder(
                      initialRating: 4,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      updateOnDrag: false,
                      unratedColor: Colors.grey,
                      itemCount: 5,
                      itemSize: 25,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.deepOrange,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 20,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.recipe?.total_time.toString() ?? "",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.room_service_outlined,
                          size: 20,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${widget.recipe?.servings ?? 0}",
                          // overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(40, 0),
                          child: Image.network(
                            widget.recipe?.image_url ?? "",
                            fit: BoxFit.cover,
                            width: 120,
                            height: 70,
                          ),
                        ),
                      ],
                    ),
                    Text("Ingredients")
                  ],
                ),
            ),
            Text("Directions", style: TextStyle(fontSize: 14),),
            // Text(widget.recipe.directions.toString() ?? '',),


            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('recipes')
                  .where('directions',
                  arrayContains: FirebaseAuth.instance.currentUser!.uid)
                  .get(),
              builder: (context, snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {

                  return SingleChildScrollView( scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.recipe.directions
                            ?.map((index, directions) => MapEntry(index, Column(
                          children: [
                            Text(directions),
                          ],
                        )))
                            .values
                            .toList() ?? []
                      ),
                    ),
                  );
                }
              },
            ),
          ],

        ),
      ),
    );
  }
}