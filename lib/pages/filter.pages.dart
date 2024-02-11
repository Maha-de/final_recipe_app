import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/pages/filtered.pages.dart';
import 'package:recipe_app/utilities/edges.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../provider/recipe.provider.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  var selectedUserValue = {};
  SfRangeValues _values = const SfRangeValues(1, 2);
  SfRangeValues _values1 = const SfRangeValues(1, 6);
  SfRangeValues _values2 = const SfRangeValues(1, 6);

  List<String> selectedFilters = [];

  getFilteredResult() async {
    print('getFilteredResult() method called');

    CollectionReference reference =
    FirebaseFirestore.instance.collection("recipes");

    Query filteredQuery = reference;

    if (selectedUserValue.containsKey('type')) {
      filteredQuery = filteredQuery.where("type", isEqualTo: selectedUserValue['type']);
      print('Filter applied: ${selectedUserValue['type']}');
    }
    if (_values != null && _values.start != null && _values.end != null) {
      Query servingQuery = filteredQuery.where("servings", isGreaterThanOrEqualTo: _values.start)
          .where("servings", isLessThanOrEqualTo: _values.end);
      QuerySnapshot servingSnapshot = await servingQuery.get();
      List<QueryDocumentSnapshot> servingRecipes = servingSnapshot.docs;

      for (var recipeSnapshot in servingRecipes) {
        // Access fields within each document
        var recipeData = recipeSnapshot.data();

        if (recipeData is Map<String, dynamic>) {
          var title = recipeData['title'];
          var servings = recipeData['servings'];
          // Process or display the recipe data as needed
          print('Recipe: $title - Servings: $servings');
        } else {
          // Handle the case where recipeData is not a Map<String, dynamic>
          print('Recipe data is not of type Map<String, dynamic>');
        }
      }

    }
    if (_values1 != null && _values1.start != null && _values1.end != null) {
      Query totalTimeQuery = filteredQuery.where("total_time", isGreaterThanOrEqualTo: _values1.start)
          .where("total_time", isLessThanOrEqualTo: _values1.end);
      QuerySnapshot totalTimeSnapshot = await totalTimeQuery.get();

    }

    if (_values2 != null && _values2.start != null && _values2.end != null) {
      Query caloriesQuery = filteredQuery.where("calories", isGreaterThanOrEqualTo: _values2.start)
          .where("calories", isLessThanOrEqualTo: _values2.end);
      QuerySnapshot caloriesSnapshot = await caloriesQuery.get();
    }
    // Execute the query and handle the results
    print('Executing Firestore query...');
    QuerySnapshot querySnapshot = await filteredQuery.get();

    print('Firestore query executed');

    // Handle querySnapshot to get filtered recipes
    List<QueryDocumentSnapshot> recipes = querySnapshot.docs;

    // Do something with the filtered recipes
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilteredPage(recipes: recipes,),
      ),
    );
  }


  // @override
  // void initState() {
  //   Provider.of<RecipeProvider>(context, listen: false).getFilteredResult();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter Page"),
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Edges.appHorizontalPadding),
        child: ListView(
          children: [
            const Text(
              "Meal",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Wrap(
                // space between chips
                spacing: 30,
                // list of chips
                children: [
                  InkWell(
                    onTap: () {
                      selectedUserValue['type'] = "breakfast";
                      setState(() {});
                    },
                    child: Chip(
                      label: const Text('Breakfast'),
                      backgroundColor: selectedUserValue['type'] == "breakfast"
                          ? Colors.deepOrange
                          : Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      selectedUserValue['type'] = "brunch";
                      setState(() {});
                    },
                    child: Chip(
                      label: const Text('Brunch'),
                      backgroundColor: selectedUserValue['type'] == "brunch"
                          ? Colors.deepOrange
                          : Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      selectedUserValue['type'] = "lunch";
                      setState(() {});
                    },
                    child: Chip(
                      label: const Text('Lunch'),
                      backgroundColor: selectedUserValue['type'] == "lunch"
                          ? Colors.deepOrange
                          : Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      selectedUserValue['type'] = "dinner";
                      setState(() {});
                    },
                    child: Chip(
                      label: const Text('Dinner'),
                      backgroundColor: selectedUserValue['type'] == "dinner"
                          ? Colors.deepOrange
                          : Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                    ),
                  ),
                ]),
            const Text(
              "Serving",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SfRangeSlider(
              min: 1.0,
              max: 15.0,
              interval: 1,
              activeColor: Colors.deepOrange,
              showDividers: true,
              stepSize: 1,
              showLabels: true,
              enableTooltip: true,
              minorTicksPerInterval: 1,
              values: _values,
              onChanged: (SfRangeValues values) {
                setState(() {
                  _values = values;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Total Time",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SfRangeSlider(
              min: 1.0,
              max: 600.0,
              interval: 100,
              activeColor: Colors.deepOrange,
              showDividers: true,
              showLabels: true,
              stepSize: 1,
              enableTooltip: true,
              minorTicksPerInterval: 1,
              values: _values1,
              onChanged: (SfRangeValues values) {
                setState(() {
                  _values1 = values;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Calories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SfRangeSlider(
              min: 1.0,
              max: 600.0,
              interval: 100,
              activeColor: Colors.deepOrange,
              showDividers: true,
              stepSize: 1,
              showLabels: true,
              enableTooltip: true,
              minorTicksPerInterval: 1,
              values: _values2,
              onChanged: (SfRangeValues values) {
                setState(() {
                  _values2 = values;
                });
              },
            ),
            const SizedBox(
              height: 50,
            ),
            Consumer<RecipeProvider>(
              builder: (ctx, recipeProvider, _) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange),
                  onPressed: () {
                    getFilteredResult();
                    // print(getFilteredResult);
                    // recipeProvider.getFilteredResult();
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) => const FilteredPage()));
                  },
                  child: const Text(
                    "Apply",
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
