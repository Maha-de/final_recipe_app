import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/pages/splash_screen.pages.dart';
import 'package:recipe_app/provider/app_auth.provider.dart';
import 'package:recipe_app/provider/favorite.provider.dart';
import 'package:recipe_app/provider/ingredient.provider.dart';
import 'package:recipe_app/provider/recipe.provider.dart';
import 'package:sizer/sizer.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase successfully");
    // }
  } catch (e) {
    print("Error in Firebase ${e}");
  }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AppAuthProvider()),
    ChangeNotifierProvider(create: (_) => FavoriteProvider()),
    ChangeNotifierProvider(create: (_) => IngredientsProvider()),
    ChangeNotifierProvider(create: (_) => RecipeProvider()),

  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType)
    {
      return MaterialApp(
        theme: ThemeData(
          fontFamily: "Hellix",
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      );
    }
    );
  }
}

