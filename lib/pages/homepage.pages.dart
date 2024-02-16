import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/models/recipe.models.dart';
import 'package:recipe_app/pages/Recently.pages.dart';
import 'package:recipe_app/pages/Settings.pages.dart';
import 'package:recipe_app/pages/favorite.pages.dart';
import 'package:recipe_app/pages/filter.pages.dart';
import 'package:recipe_app/pages/ingredient.pages.dart';
import 'package:recipe_app/pages/search_test.dart';
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
  final controllerSearch = TextEditingController();
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('recipes').snapshots();
  List<DocumentSnapshot> _data = [];
  late final String userId;


  // Future<String> _getProfileImageUrl() async {
  //   final String userId = FirebaseAuth.instance.currentUser!.uid;
  //   final Reference storageRef =
  //       FirebaseStorage.instance.ref().child('profileImageUrl/$userId');
  //   final String imageUrl = await storageRef.getDownloadURL();
  //   return imageUrl;
  // }

  @override
  void initState() {
    controller = ZoomDrawerController();
    Provider.of<RecipeProvider>(context, listen: false).getRecipes();
    Provider.of<RecipeProvider>(context, listen: false).getFreshRecipes();
    Provider.of<RecipeProvider>(context, listen: false).getRecommendedRecipes();
    // _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      ZoomDrawer(
        slideWidth: MediaQuery.of(context).size.width * 0.65,
        menuBackgroundColor: Colors.grey.shade300,
        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)],
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

                // ProfileImageWidget(),

                const CircleAvatar(
                  radius: 50,
                  backgroundImage: CachedNetworkImageProvider(
                      'https://firebasestorage.googleapis.com/v0/b/final-recipe-app.appspot.com/o/profile%2Fistockphoto-1381637603-1024x1024.jpg?alt=media&token=cc0b28ab-a2db-4723-be86-1bf3a3556cb3'),
                ),
                ListTile(
                  onTap: () {
                    Colors.deepOrange;
                    controller.close?.call();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const HomePage()));
                  },
                  leading: const Icon(
                    Icons.home,
                    // color: Colors.deepOrange,
                  ),
                  title: const Text('Home'),
                ),
                ListTile(
                  onTap: () {
                    controller.close?.call();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const IngredientPage()));
                  },
                  leading: const Icon(Icons.fastfood),
                  title: const Text('Ingredients'),
                ),
                ListTile(
                  onTap: () {
                    controller.close?.call();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const FavoritePage()));
                  },
                  leading: const Icon(Icons.favorite_border_outlined),
                  title: const Text('Favorites'),
                ),
                ListTile(
                  onTap: () {
                    controller.close?.call();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RecentlyPage()));
                  },
                  leading: const Icon(Icons.arrow_forward),
                  title: const Text('Recently Viewed'),
                ),
                ListTile(
                  onTap: () {
                    Colors.deepOrange;
                    controller.close?.call();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SettingsPage()));
                  },
                  leading: const Icon(
                    Icons.settings,
                    // color: Colors.deepOrange,
                  ),
                  title: const Text('Settings'),
                ),
                ListTile(
                  onTap: () {
                    Provider.of<AppAuthProvider>(context, listen: false)
                        .signOut(context);
                  },
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
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
                  child: const Icon(Icons.menu)),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => SearchDemo()));
                },
                child: const Icon(
                  Icons.notifications_none_outlined,
                  size: 30,
                ),
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
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Bonjour, ${FirebaseAuth.instance.currentUser?.email}",
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "What would you like to cook today?",
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 280,
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.shade300),
                          height: 50,
                          width: 280,
                          child: TextFormField(
                            decoration:  InputDecoration(
                              prefixIcon: GestureDetector(
                                onTap: (){Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const FilterPage()));},
                                  child: const Icon(Icons.search)),
                              labelText: "Search for recipes",
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.07,
                          width: MediaQuery.of(context).size.width * 0.10,
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
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SectionHeader(sectionName: "Today's Fresh Recipes"),
                  const SizedBox(
                    height: 10,
                  ),
                  Consumer<AppAuthProvider>(
                      builder: (context, authProvider, _) => Container(
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
                                                  builder: (ctx, recipeProvider,
                                                          _) =>
                                                      recipeProvider.freshRecipesList ==
                                                              null
                                                          ? const CircularProgressIndicator()
                                                          : (recipeProvider
                                                                      .freshRecipesList
                                                                      ?.isEmpty ??
                                                                  false)
                                                              ? const Text(
                                                                  'No Data Found')
                                                              : ListView
                                                                  .builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  itemCount:
                                                                      recipeProvider
                                                                          .freshRecipesList!
                                                                          .length,
                                                                  itemBuilder: (ctx,
                                                                          index) =>
                                                                      RecipeWidget(
                                                                    recipe: recipeProvider
                                                                            .freshRecipesList![
                                                                        index],
                                                                  ),
                                                                )),
                                            ],
                                          );
                                        }),
                                  ),
                                  const SectionHeader(
                                      sectionName: "Recommended"),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.850,
                                    child: Consumer<RecipeProvider>(
                                        builder: (ctx, recipeProvider, _) =>
                                            recipeProvider
                                                        .recommendedRecipesList ==
                                                    null
                                                ? const CircularProgressIndicator()
                                                : (recipeProvider
                                                            .recommendedRecipesList
                                                            ?.isEmpty ??
                                                        false)
                                                    ? const Text(
                                                        'No Data Found')
                                                    : ListView.separated(
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount: recipeProvider
                                                            .recommendedRecipesList!
                                                            .length,
                                                        itemBuilder: (ctx,
                                                                index) =>
                                                            RecommendedWidget(
                                                          recipe: recipeProvider
                                                                  .recommendedRecipesList![
                                                              index],
                                                        ),
                                                        separatorBuilder:
                                                            (context, index) {
                                                          return const SizedBox(
                                                              height: 15);
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


