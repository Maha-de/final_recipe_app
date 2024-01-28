import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/pages/homepage.pages.dart';
import 'package:recipe_app/provider/app_auth.provider.dart';
import 'package:recipe_app/utilities/edges.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  late ZoomDrawerController controller;
  bool isFavorite = false;

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
                  controller.close?.call();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => HomePage()));
                },
                leading: Icon(
                  Icons.home,
                  color: Colors.deepOrange,
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
            padding:
            EdgeInsets.symmetric(horizontal: Edges.appHorizontalPadding),
            child: InkWell(
                onTap: () {
                  controller.toggle!();
                },
                child: Icon(Icons.menu)),
          ),
          actions: [
            Padding(padding: EdgeInsets.only(right: 30)),
            Icon(
              Icons.notifications_none_outlined,
              size: 30,
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: Edges.appHorizontalPadding),
          child: ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "Favorites",
                style: TextStyle(fontSize: 20),
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
                      autofocus: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        labelText: "Search for recipes",
                        border: OutlineInputBorder(borderSide: BorderSide.none),
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
            ],
          ),
        ),
      ),
    );
  }
}
