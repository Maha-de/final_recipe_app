import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/pages/recipe_details.pages.dart';
import 'package:recipe_app/utilities/edges.dart';

import '../models/recipe.models.dart';
import '../provider/recipe.provider.dart';
import '../widgets/recommended_widget.dart';

class FilteredPage extends StatefulWidget {
  final Recipe? recipe;
  final List<QueryDocumentSnapshot> recipes;


  const FilteredPage({super.key, this.recipe, required this.recipes,});

  @override
  State<FilteredPage> createState() => _FilteredPageState();
}

class _FilteredPageState extends State<FilteredPage> {

  var value = {"type": "breakfast", "serving": 5, "total_time": 20};

  Future<void> getFilteredResult() async {
    try {
      Query<Map<String, dynamic>> ref = FirebaseFirestore.instance.collection('recipes');

      // Chain where clauses for each key-value pair in the value map
      value.forEach((key, value) {
        ref = ref.where(key, isEqualTo: value);
      });

      var result = await ref.get();

      // Handle the result, you may want to iterate through result.docs
      result.docs.forEach((doc) {
        print(doc.data()); // Print document data
      });
    } catch (e) {
      print("Error $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtered Recipes'),
      ),
      body:

      ListView.builder(
        itemCount: widget.recipes.length,
        itemBuilder: (context, index) {
          QueryDocumentSnapshot recipe = widget.recipes[index];
          return Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: Edges.appHorizontalPadding),
              child: Stack(children: [
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => RecipeDetailsPage(
                                recipe: widget.recipe!,
                              )));
                    },
                    child: Container(
                      height: 150,
                      width: 345,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade300),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.network(
                            recipe['image_url']?? "",
                            fit: BoxFit.cover,
                            width: 100,
                            height: 70,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 5),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(recipe["type"] ?? 'No Type Found',
                                    style: const TextStyle(
                                      color: Color(0xff2097b3),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    )),
                                Container(
                                    width: 150,
                                    child: Text(
                                      recipe['title'] ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )),
                                Row(
                                  children: [
                                    RatingBar.builder(
                                      initialRating: 4,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      updateOnDrag: false,
                                      unratedColor: Colors.grey,
                                      itemCount: 5,
                                      itemSize: 15,
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.deepOrange,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      recipe['calories'] ?? '',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_alarm,
                                      size: 20,
                                    ),
                                    Text(recipe['total_time'] ?? "",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey,
                                        )),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    const Icon(
                                      Icons.room_service_outlined,
                                      size: 20,
                                    ),
                                    Text("${recipe['servings'] ?? 0}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))
              ]));
        },
      ),
    );
  }
}
