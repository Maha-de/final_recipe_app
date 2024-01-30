import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/models/recipe.models.dart';
import 'package:recipe_app/pages/Recently.pages.dart';
import 'package:recipe_app/pages/Settings.pages.dart';
import 'package:recipe_app/pages/favorite.pages.dart';
import 'package:recipe_app/pages/ingredient.pages.dart';
import 'package:recipe_app/provider/app_auth.provider.dart';
import 'package:recipe_app/provider/recipe.provider.dart';
import 'package:recipe_app/utilities/edges.dart';
import 'package:recipe_app/widgets/recommended_widget.dart';
import 'package:recipe_app/widgets/section_header.dart';
import 'package:recipe_app/widgets/today_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late ZoomDrawerController controller;
  final Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('recipes').snapshots();

  @override
  void initState() {
    controller = ZoomDrawerController();
    Provider.of<RecipeProvider>(context, listen: false).getRecipes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
        slideWidth: MediaQuery
            .of(context)
            .size
            .width * 0.65,
        menuBackgroundColor: Colors.grey.shade300,
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
        disableDragGesture: true,
        mainScreenTapClose: true,
        controller: controller,
        drawerShadowsBackgroundColor: Colors.grey,
        menuScreen: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  onTap: () {
                    Colors.deepOrange;
                    controller.close?.call();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => HomePage()));
                  },
                  leading: Icon(
                    Icons.home,
                    // color: Colors.deepOrange,
                  ),
                  title: Text('Home'),
                ),
                ListTile(
                  onTap: () {
                    controller.close?.call();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => IngredientPage()));
                  },
                  leading: Icon(Icons.favorite_border_outlined),
                  title: Text('Ingredients'),
                ),
                ListTile(
                  onTap: () {
                    controller.close?.call();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => FavoritePage()));
                  },
                  leading: Icon(Icons.favorite_border_outlined),
                  title: Text('Favorites'),
                ),
                ListTile(
                  onTap: () {
                    controller.close?.call();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => RecentlyPage()));
                  },
                  leading: Icon(Icons.favorite_border_outlined),
                  title: Text('Recently Viewed'),
                ),
                ListTile(
                  onTap: () {
                    Colors.deepOrange;
                    controller.close?.call();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SettingsPage()));
                  },
                  leading: Icon(
                    Icons.home,
                    // color: Colors.deepOrange,
                  ),
                  title: Text('Settings'),
                ),
                ListTile(
                  onTap: () {
                    Provider.of<AppAuthProvider>(context, listen: false)
                        .signOut(context);
                  },
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                )
              ],
            ),
          ),
        ),
        mainScreen: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Edges.appHorizontalPadding),
              child: InkWell(
                  onTap: () {
                    controller.toggle!();
                  },
                  child: Icon(Icons.menu)),
            ),
            actions: [
              Icon(
                Icons.notifications_none_outlined,
                size: 30,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Edges.appHorizontalPadding),
            child: ListView(
              // verticalDirection: VerticalDirection.down,
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.max,
              // scrollDirection: Axis.vertical,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text("Bonjour, Maha", style: TextStyle(fontSize: 20)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "What would you like to cook today?",
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.shade300),
                        height: 50,
                        width: 280,
                        child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            labelText: "Search for recipes",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      SizedBox(
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
                          icon: Icon(Icons.menu),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SectionHeader(sectionName: "Today's Fresh Recipes"),
                  SizedBox(
                    height: 10,
                  ),
                  Consumer<AppAuthProvider>(
                      builder: (context, authProvider, _) =>
                          Container(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 200,
                                    child: ListView.builder(
                                        itemCount: 1,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: [
                                              Consumer<RecipeProvider>(
                                                  builder: (ctx,
                                                      recipeProvider, _) =>
                                                  recipeProvider.recipeList ==
                                                      null
                                                      ? const CircularProgressIndicator()
                                                      : (recipeProvider
                                                      .recipeList?.isEmpty ??
                                                      false)
                                                      ? const Text(
                                                      'No Data Found')
                                                      : ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection: Axis
                                                        .horizontal,
                                                    itemCount: recipeProvider
                                                        .recipeList!.length,
                                                    itemBuilder: (ctx,
                                                        index) =>
                                                        RecipeWidget(
                                                          recipe: recipeProvider
                                                              .recipeList![index],),
                                                  )),
                                            ],
                                          );
                                        }),
                                  ),
                                  SectionHeader(sectionName: "Recommended"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(width: 350,
                                    child: Consumer<RecipeProvider>(
                                        builder: (ctx,
                                            recipeProvider, _) =>
                                        recipeProvider.recipeList ==
                                            null
                                            ? const CircularProgressIndicator()
                                            : (recipeProvider
                                            .recipeList?.isEmpty ??
                                            false)
                                            ? const Text(
                                            'No Data Found')
                                            : ListView.separated(
                                          shrinkWrap: true,
                                          scrollDirection: Axis
                                              .vertical,
                                          itemCount: recipeProvider
                                              .recipeList!.length,
                                          itemBuilder: (ctx,
                                              index) =>
                                              RecommendedWidget(
                                                recipe: recipeProvider
                                                    .recipeList![index],),
                                          separatorBuilder: (context, index) { return SizedBox(height: 15);
                                                         },
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ))
                ]),
          ),
        ));
  }
}


