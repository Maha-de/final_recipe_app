import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/models/recipe.models.dart';
import 'package:recipe_app/provider/recipe.provider.dart';


class FavoriteIcon extends StatefulWidget {

  final Recipe? recipe;


  const FavoriteIcon({super.key, this.recipe});

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {

  bool isFavorite = false;


  // void _toggleButton() {
  //   setState(() {
  //     isFavorite = !isFavorite;
  //   });
  // }



  @override
  Widget build(BuildContext context) {
    return
      InkWell(
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
      );
    //   Center(
    //   child: GestureDetector(
    //
    //     onTap: () {
    //       Provider.of<RecipeProvider>(context, listen: false)
    //           .addRecipeToUser(
    //           widget.recipe!.docId!,
    //           !(widget.recipe?.favourite_users_ids?.contains(
    //               FirebaseAuth.instance.currentUser?.uid) ??
    //               false));
    //       // setState(() {
    //       //   isFavorite = !isFavorite;
    //       // });
    //     },
    //     child:
    //     (widget.recipe?.favourite_users_ids?.contains(
    // FirebaseAuth.instance.currentUser?.uid) ??
    // false
    // ? const
    // Icon(
    // Icons.favorite,
    // size: 30,
    // color: Colors.red,
    // )
    //     : const Icon(
    // Icons.favorite,
    // size: 30,
    // color: Colors.grey,
    // )
    //     // Icon(
    //     //   color: isFavorite ? Colors.red : null,
    //     //   isFavorite ? Icons.favorite : Icons.favorite_border,
    //     // ),
    //   ),
    // )
    // );
  }
}




