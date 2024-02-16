import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/provider/recipe.provider.dart';
import '../provider/app_auth.provider.dart';
import 'homepage.pages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // late String _profileImageUrl; // Change to late initialization
  String _profileImageUrl = '';
  final currentUser = FirebaseAuth.instance.currentUser;
  final AppAuthProvider authService = AppAuthProvider();
  final usersCollection = FirebaseFirestore.instance.collection("users");


  Future<void> imageUpload() async {
    OverlayLoadingProgress.start();
    var imageResult = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: true);
    var reference = FirebaseStorage.instance
        .ref("profile/${imageResult?.files.first.name}");
    if (imageResult?.files.first.bytes != null) {
      var uploadResult = await reference.putData(
          imageResult!.files.first.bytes!,
          SettableMetadata(contentType: "image/png"));
      if (uploadResult.state == TaskState.success) {
        final imageUrl = await reference.getDownloadURL();
        await usersCollection
            .doc(currentUser!.email)
            .update({'profileImageUrl': imageUrl});
        setState(() {
          _profileImageUrl = imageUrl;
        });
      }
    }
    OverlayLoadingProgress.stop();
  }


  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(context: context, builder: (context) =>
    AlertDialog(title: const Text("Edit UserName"),
    content: TextField(
      decoration: const InputDecoration(hintText: "Enter new Username"),
      onChanged: (value){
        newValue = value;
      },
    ),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
      TextButton(onPressed: () => Navigator.of(context).pop(newValue), child: const Text("Save")),
    ],
    )
    );
    if(newValue.length > 0){
      await usersCollection.doc(currentUser!.email).update({field: newValue});
    }
  }

  Future<void> _fetchProfileImageUrl() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userData = await usersCollection.doc(currentUser!.email).get();

    setState(() {
      _profileImageUrl = userData['profileImageUrl'] ?? '';
    });
  }

  @override
  void initState() {
    _fetchProfileImageUrl();
    // Provider.of<AppAuthProvider>(context, listen: false).providerInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // User? currentUser = authService.getCurrentUser();
    // final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    // final profileProvider = Provider.of<RecipeProvider>(context);
    // profileProvider.setProfileImageUrl(userId);
   
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
      ),

      body: StreamBuilder<DocumentSnapshot>(stream:
      FirebaseFirestore.instance.collection("users").doc(currentUser!.email).snapshots(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          return Stack(
            children: [
              Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/background.png"),
                          fit: BoxFit.cover))),
              ListView(
                children: [
                  Center(
                    child:
                    // ProfileImageWidget()
                    _profileImageUrl.isEmpty
                        ? Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                "assets/images/logo3.png",
                              )),
                          border:
                          Border.all(color: Colors.black, width: 5)),
                    )
                    :
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(_profileImageUrl)),
                          border:
                          Border.all(color: Colors.black, width: 5)),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      const Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 320,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0, left: 20),
                          child:
                          Text(userData["username"], style: const TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      const Icon(Icons.email, size: 30, color: Colors.white),
                      SizedBox(
                        width: 320,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0, left: 20),
                          child:
                          Text(currentUser!.email!, style: const TextStyle(color: Colors.white, fontSize: 18),),

                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                      onPressed: () {
                        // authService.updateDisplayName("");
                        editField('username');
                      },
                      child: const Text(
                        "Edit Username",
                        style: TextStyle(color: Colors.white),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                      onPressed: imageUpload,

                      child: const Text(
                        "Upload Photo",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ],
          );

        }else {
          if(snapshot.hasError){
            return Center(child: Text("error ${snapshot.error}"),);
          }
          return const Center(child: CircularProgressIndicator(),);
        }
      },
      ),
    );
  }
}


