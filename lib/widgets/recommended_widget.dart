import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/pages/recipe_details.pages.dart';
import 'package:recipe_app/provider/recipe.provider.dart';

import '../models/recipe.models.dart';
import '../utilities/edges.dart';

class RecommendedWidget extends StatefulWidget {
  final Recipe? recipe;

  const RecommendedWidget({ this.recipe, super.key});

  @override
  State<RecommendedWidget> createState() => _RecipeWidgetState();
}

class _RecipeWidgetState extends State<RecommendedWidget> {
  @override
  Widget build(BuildContext context) {
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
                      widget.recipe?.image_url ?? "",
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
                          Text(widget.recipe?.type ?? 'No Type Found',
                              style: TextStyle(
                                color: Color(0xff2097b3),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              )),
                          Container(
                              width: 150,
                              child: Text(
                                widget.recipe?.title ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          // Container(
                          // width: 200,
                          // child: Text(
                          // description,
                          // textAlign: TextAlign.start,
                          // maxLines: 2,
                          // ),
                          // ),
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
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                widget.recipe?.calories.toString() ?? '',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.access_alarm,
                                size: 20,
                              ),
                              Text(widget.recipe?.total_time.toString() ?? "",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                  )),
                              SizedBox(
                                width: 7,
                              ),
                              Icon(
                                Icons.room_service_outlined,
                                size: 20,
                              ),
                              Text("${widget.recipe?.servings ?? 0}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                  )),
                            ],
                          ),
                          // Container(
                          // width: 200,
                          // child: SingleChildScrollView(
                          // physics: const AlwaysScrollableScrollPhysics(),
                          // scrollDirection: Axis.horizontal,
                          // child: Text(
                          // ingredients,
                          // textAlign: TextAlign.start,
                          // maxLines: 2,
                          // ),
                          // ),
                          // )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, right: 10),
                          child: InkWell(
                              onTap: () {
                                Provider.of<RecipeProvider>(context,
                                        listen: false)
                                    .addRecipeToUserFavourite(
                                        widget.recipe!.docId!,
                                        !(widget.recipe?.favourite_users_ids
                                                ?.contains(FirebaseAuth.instance
                                                    .currentUser?.uid) ??
                                            false));
                              },
                              child: (widget.recipe?.favourite_users_ids
                                          ?.contains(FirebaseAuth
                                              .instance.currentUser?.uid) ??
                                      false
                                  ? const Icon(
                                      Icons.favorite_rounded,
                                      size: 30,
                                      color: Colors.red,
                                    )
                                  : const Icon(
                                      Icons.favorite_rounded,
                                      size: 30,
                                      color: Colors.grey,
                                    ))),
                        ),
                      ],
                    ),
                  ],
                ),
              ))
        ]));
  }
}
