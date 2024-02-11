import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/pages/recipe_details.pages.dart';
import 'package:recipe_app/provider/recipe.provider.dart';

import '../models/recipe.models.dart';
import '../utilities/edges.dart';

class RecipeWidget extends StatefulWidget {
  final Recipe? recipe;

  const RecipeWidget({required this.recipe, super.key});

  @override
  State<RecipeWidget> createState() => _RecipeWidgetState();
}

class _RecipeWidgetState extends State<RecipeWidget> {

  double _initialRating = 0.0; // Initial rating value

  @override
  void initState() {
    _fetchRatingFromFirestore();
    super.initState();
  }

  void _fetchRatingFromFirestore() async {
    try{
      DocumentSnapshot ratingSnapshot =
      await FirebaseFirestore.instance.collection('recipes').doc('docId').get();

      if (ratingSnapshot.exists) {
        Map<String, dynamic>? data = ratingSnapshot.data() as Map<String,
            dynamic>?;

        if (data != null && data.containsKey('rate')) {
          setState(() {
            // Access the 'rating' field in the data map
            _initialRating = data['rate'] ?? 0.0;
            print("rateeeeeeeeeee$_initialRating");
          });
        }
      }
    }catch(e){
      print("aaaaaaaaaaaaaaaaaaaaaa$e");}

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: Edges.appHorizontalPadding),
      child: Stack(
        children: [
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
              width: 200,
              height: 380,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(
                    0xffeeeeee,
                  )),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.network(
                      widget.recipe?.image_url ?? "",
                      fit: BoxFit.cover,
                      width: 120,
                      height: 70,
                    ),
                    Text(
                      widget.recipe?.type ?? 'No Type Found',
                      style: TextStyle(
                        color: Color(0xff2097b3),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // const SizedBox(
                    //   height: 3,
                    // ),
                    Text(
                      widget.recipe?.title ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // const SizedBox(
                    //   height: 6,
                    // ),
                    RatingBar.builder(
                      initialRating: _initialRating,
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
                    // const SizedBox(
                    //   height: 7,
                    // ),
                    Text(
                      widget.recipe?.calories.toString() ?? '',
                      style: const TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(
                    //   height: 7,
                    // ),
                    ClipRect(
                      child: Row(
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
                            "${widget.recipe?.servings?? 0}",
                            // overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
                onTap: () {
                  Provider.of<RecipeProvider>(context, listen: false)
                      .addRecipeToUserFavourite(
                      widget.recipe!.docId!,
                      !(widget.recipe?.favourite_users_ids?.contains(
                          FirebaseAuth.instance.currentUser?.uid) ??
                          false));
                },
                child: (widget.recipe?.favourite_users_ids?.contains(
                    FirebaseAuth.instance.currentUser?.uid) ??
                    false
                    ? const
                Icon(
                  Icons.favorite_rounded,
                  size: 30,
                  color: Colors.red,
                )
                    : const Icon(
                  Icons.favorite_rounded,
                  size: 30,
                  color: Colors.grey,
                )
                )
            ),
          ),
        ],
      ),
    );
  }
}
