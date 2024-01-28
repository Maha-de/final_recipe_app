import 'package:flutter/material.dart';
import 'package:recipe_app/widgets/favorite_icon.dart';

class RecommendedWidget extends StatelessWidget {
  final Image imageName;
  final String headerText;
  final String titleText;
  final String caloriesText;
  final String timeText;
  final String servingText;
  final String description;
  final String ingredients;
  const RecommendedWidget(
      {required this.imageName,
        required this.headerText,
        required this.titleText,
        required this.caloriesText,
        required this.timeText,
        required this.servingText,
        required this.description,
        required this.ingredients,
        super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
          height: 200,
          width: 350,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade300),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              imageName,
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headerText,
                      style: TextStyle(color: Colors.blue),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        titleText,
                        textAlign: TextAlign.start,
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        description,
                        textAlign: TextAlign.start,
                        maxLines: 2,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_border_outlined,
                          size: 20,
                        ),
                        Icon(
                          Icons.star_border_outlined,
                          size: 20,
                        ),
                        Icon(
                          Icons.star_border_outlined,
                          size: 20,
                        ),
                        Icon(
                          Icons.star_border_outlined,
                          size: 20,
                        ),
                        Icon(
                          Icons.star_border_outlined,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          caloriesText,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_alarm,
                          size: 20,
                        ),
                        Text(timeText, style: TextStyle(fontSize: 12)),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.table_bar,
                          size: 20,
                        ),
                        Text(servingText, style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Container(
                      width: 200,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          ingredients,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, right: 10),
                    child: FavoriteIcon(),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
