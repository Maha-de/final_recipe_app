import 'package:flutter/material.dart';


class FavoriteIcon extends StatefulWidget {

  const FavoriteIcon({super.key});

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
    return Center(
      child: GestureDetector(

        onTap: () {

          setState(() {
            isFavorite = !isFavorite;
          });
        },
        child:
        Icon(
          color: isFavorite ? Colors.red : null,
          isFavorite ? Icons.favorite : Icons.favorite_border,
        ),
      ),
    );
  }
}




