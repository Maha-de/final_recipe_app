import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/pages/favorite.pages.dart';
import 'package:recipe_app/provider/app_auth.provider.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
        slideWidth: MediaQuery.of(context).size.width * 0.65,
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
                        MaterialPageRoute(builder: (_) => FavoritePage()));
                  },
                  leading: Icon(Icons.favorite_border_outlined),
                  title: Text('Favorites'),
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
              // PopupMenuButton<int>(
              //     onSelected: (item) => onSelected(context, item),
              //     itemBuilder: (context) =>
              //         [PopupMenuItem<int>(value: 0, child: Text("Logout"))])
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
                                          Container(
                                            height: 320,
                                            width: 200,
                                            margin: EdgeInsets.fromLTRB(
                                                0, 10, 40, 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    20),
                                                color:
                                                Colors.grey.shade300),
                                            child: TodayWidget(
                                                imageName: Image.asset(
                                                  "images/french_toast_large.png",
                                                  height: 80,
                                                  width: 150,
                                                ),
                                                headerText: "Breakfast",
                                                titleText:
                                                "French Toast with Berries",
                                                caloriesText:
                                                "120 Calories",
                                                timeText: "10 mins",
                                                servingText: "1 Serving"),
                                          ),
                                          Container(
                                            height: 320,
                                            width: 220,
                                            margin: EdgeInsets.fromLTRB(
                                                0, 10, 40, 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    20),
                                                color:
                                                Colors.grey.shade300),
                                            child: TodayWidget(
                                                imageName: Image.asset(
                                                  "images/cinnamon_large.png",
                                                  height: 80,
                                                  width: 150,
                                                ),
                                                headerText: "Breakfast",
                                                titleText:
                                                "Brown Sugar Cinnamon Toast",
                                                caloriesText:
                                                "135 Calories",
                                                timeText: "15 mins",
                                                servingText: "1 Serving"),
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                              SectionHeader(sectionName: "Recommended"),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 600,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: _usersStream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot>
                                      snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Something went wrong');
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Text("Loading");
                                    }

                                    return ListView(
                                      children: snapshot.data!.docs.map(
                                            (DocumentSnapshot document) {
                                          // Map<String, dynamic> data =
                                          //     document.data()! as Map<String, dynamic>;
                                          var data = document.data()!
                                          as Map<String, dynamic>;
                                          return ListView.separated(
                                            itemCount: 1,
                                            physics:
                                            NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  RecommendedWidget(
                                                    imageName: Image.asset(
                                                      "images/muffins_large2.png",
                                                      height: 180,
                                                      width: 100,
                                                    ),
                                                    headerText: "Breakfast",
                                                    titleText:
                                                    data['title'],
                                                    caloriesText: data[
                                                    'calories']
                                                        .toString(),
                                                    timeText:
                                                    data['total_time'],
                                                    servingText:
                                                    data['servings'],
                                                    description:
                                                    data['description'],
                                                    ingredients:
                                                    data['ingredients']
                                                        .toString(),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  // InkWell(
                                                  //   onTap: () {
                                                  //     authProvider
                                                  //         .bottomSheetBuilder(
                                                  //             HomeBottomSheet(),
                                                  //             context);
                                                  //   },
                                                  //   child:
                                                  //       RecommendedWidget(
                                                  //           imageName:
                                                  //               Image.asset(
                                                  //             "images/glazed_large.png",
                                                  //             height: 180,
                                                  //             width: 100,
                                                  //           ),
                                                  //           headerText:
                                                  //               "Main Dish",
                                                  //           titleText:
                                                  //               "Glazed Salmon",
                                                  //           caloriesText:
                                                  //               "280 Calories",
                                                  //           timeText:
                                                  //               "45 mins",
                                                  //           servingText:
                                                  //               "1 Serving"),
                                                  // ),
                                                ],
                                              );
                                            },
                                            separatorBuilder:
                                                (context, index) {
                                              return SizedBox(
                                                height: 15,
                                              );
                                            },
                                          );
                                        },
                                      ).toList(),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ))
                ]),
          ),
        )
    );
  }
}
