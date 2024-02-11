import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:recipe_app/models/recipe.models.dart';
import 'package:recipe_app/models/recipe.models.dart';
import 'package:recipe_app/pages/filter.pages.dart';
import 'package:recipe_app/utilities/edges.dart';
import 'package:recipe_app/widgets/today_widget.dart';

import '../models/recipe.models.dart';
import '../models/recipe.models.dart';

class FavoritePage extends StatefulWidget {


  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  final TextEditingController _controller = TextEditingController();
  List<DocumentSnapshot> _data = [];
  late ZoomDrawerController controller;

  String name = "";

  @override
  void initState() {
    controller = ZoomDrawerController();
    _fetchData();
    super.initState();

  }

  Future<void> _fetchData() async {
    final QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('recipes').get();
    setState(() {
      _data = snapshot.docs;
    });
  }

  void _filterData(String query) {
    final List<DocumentSnapshot> filteredData = _data.where((doc) {
      final String name = doc['title'].toString().toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _data = filteredData;
    });
  }
  //Trying search method
  // void updateList(String value){
  //   setState(() {
  //     recipesList = _data.where((doc) => doc.title!.toString().
  //     toLowerCase().contains(value.toLowerCase())).cast<Recipe>().toList();
  //   });
  // }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Edges.appHorizontalPadding),
        child: ListView(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade300),
                  height: 50,
                  width: 280,
                  child: TextFormField(
                    controller: _controller,
                    onChanged: (query) => _filterData(query),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      labelText: "Search for recipes",
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  height: 50,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade300,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const FilterPage(
                              )));
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 20,),
            SizedBox(
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

                          return

                            ClipRect(
                              child: FlexibleGridView(
                                shrinkWrap: true,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 8,
                                children: recipesList
                                    .map((e) => RecipeWidget(recipe: e))
                                    .toList(),
                              ),
                            );
                        } else {
                          return const Text('No Data Found');
                        }
                      }
                    }
                  }),
            ),
          ],
        ),
      ),

    );
  }
}
