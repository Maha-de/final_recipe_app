import 'package:flutter/material.dart';
import 'package:recipe_app/pages/profile.pages.dart';
import 'package:recipe_app/utilities/edges.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Edges.appHorizontalPadding),
        child: ListView(
          children: [
            Container(height: 50,width: 350,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey.shade300,
              ),
              child: const ListTile(
                leading: Icon(Icons.language),

              title: Text("Language", style: TextStyle(fontSize: 14),),
              trailing: Text("English", style: TextStyle(fontSize: 14)),),
            ),
            const SizedBox(height: 20,),
            Container(height: 50,width: 350,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey.shade300,
              ),
              child: ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text(
                  "Profile Page", style: TextStyle(fontSize: 14, color: Colors.black)),
              trailing: TextButton(onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ProfilePage())); },
                  child: const Text("Edit", style: TextStyle(fontSize: 14, color: Colors.deepOrange))),),

            )
          ],
        ),
      ),
    );
  }
}
