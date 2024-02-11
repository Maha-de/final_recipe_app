import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/models/recipe.models.dart';
import 'package:recipe_app/pages/filter.pages.dart';
import 'package:recipe_app/pages/recipe_details.pages.dart';
import 'package:recipe_app/provider/recipe.provider.dart';
import 'package:recipe_app/utilities/edges.dart';
import 'package:recipe_app/widgets/recommended_widget.dart';

class RecentlyPage extends StatefulWidget {
  final Recipe? recipe;

  const RecentlyPage({super.key, this.recipe});

  @override
  State<RecentlyPage> createState() => _RecentlyPageState();
}

class _RecentlyPageState extends State<RecentlyPage> {
  final TextEditingController _controller = TextEditingController();
  List<DocumentSnapshot> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: Edges.appHorizontalPadding),
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
                      onChanged: _filterData,
                      // onChanged: (String? value){
                      //   setState(() {
                      //     search = value.toString();
                      //   });
                      // },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        labelText: "Search for recipes",
                        border: OutlineInputBorder(borderSide: BorderSide.none),
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
                                builder: (_) => const FilterPage()));
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 380,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('recipes')
                        .where("recently_viewd_users_ids",
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
                            List<Recipe> recentlyRecipesList = snapshots
                                    .data?.docs
                                    .map((e) => Recipe.fromJson(e.data(), e.id))
                                    .toList() ??
                                [];
                            return ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: _data.length,
                              itemBuilder: (ctx, index) {
                                final DocumentSnapshot doc = _data[index];

                                // ListTile(
                                //   title: Text(_resultList[index]['title']),
                                // ),
                                return
                                    // ListTile(
                                    //       title: Text(doc['title']),
                                    //       subtitle: Text(doc['description']))
                                //     RecommendedWidget(
                                //   recipe: recentlyRecipesList[index],
                                // );

                                  Padding(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: Edges.appHorizontalPadding),
                                      child: Stack(children: [
                                        InkWell(
                                            // onTap: () {
                                            //   Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //           builder: (_) => RecipeDetailsPage(
                                            //             recipe: widget.recipe!,
                                            //           )));
                                            // },
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
                                                    doc['image_url']?? "",
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
                                                        Text(doc["type"] ?? 'No Type Found',
                                                            style: const TextStyle(
                                                              color: Color(0xff2097b3),
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w500,
                                                            )),
                                                        Container(
                                                            width: 150,
                                                            child: Text(
                                                              doc['title'] ?? "",
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
                                                              doc['calories'] ?? '',
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
                                                            Text(doc['total_time'] ?? "",
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
                                                            Text("${doc['servings'] ?? 0}",
                                                                style: const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.normal,
                                                                  color: Colors.grey,
                                                                )),
                                                            // Consumer<RecipeProvider>(
                                                            //   builder: (ctx,
                                                            //       recipeProvider,
                                                            //       _) =>
                                                              IconButton(onPressed: (){
                                                                // recipeProvider.removeRecipeToUserRecentlyViewed('');
                                                                final String? recipeId = widget.recipe?.docId;
                                                                if (recipeId != null) {
                                                                  Provider.of<RecipeProvider>(context, listen: false)
                                                                      .removeRecipeToUserRecentlyViewed(recipeId);
                                                                }
                                                            }, icon: const Icon(Icons.clear)),
                                                            // )
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
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(height: 15);
                              },
                            );
                          } else {
                            return const Text('No Data Found');
                          }
                        }
                      }
                    }),
              ),
              // IconButton(onPressed: (){
              //   Provider.of<RecipeProvider>(context, listen: false).removeRecipeToUserRecentlyViewed('');
              // }, icon: const Icon(Icons.clear)),
            ],
          ),
        ),
      ),
    );
  }
}
