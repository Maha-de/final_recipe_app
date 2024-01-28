import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:recipe_app/models/favorite.models.dart';
import 'package:recipe_app/utilities/toast_message_status.dart';
import 'package:recipe_app/widgets/toast_message.widgets.dart';

class FavoriteProvider extends ChangeNotifier {
  List<Favorite>? _favoriteList;

  List<Favorite>? get favoriteList => _favoriteList;

  Future<void> getFavorites() async {
    try {
      var result =
      await FirebaseFirestore.instance.collection('favorites').get();

      if (result.docs.isNotEmpty) {
        _favoriteList = List<Favorite>.from(
            result.docs.map((doc) => Favorite.fromJson(doc.data(), doc.id)));
      } else {
        _favoriteList = [];
      }
      notifyListeners();
    } catch (e) {
      _favoriteList = [];
      notifyListeners();
    }
  }

// Future<void> addToFavorites(String item) async {
//   await FirebaseFirestore.instance.collection('favorites').add({'item': item});
// }

  Future<void> addFavoriteToUser(String favoriteId, bool isAdd) async {
    try {
      // OverlayLoadingProgress.start();
      if (isAdd) {
        await FirebaseFirestore.instance
            .collection('favorites')
            .doc(favoriteId)
            .update({
          "users_ids":
          FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('favorites')
            .doc(favoriteId)
            .update({
          "users_ids":
          FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid])
        });
      }
      OverlayLoadingProgress.stop();
      getFavorites();
    } catch (e) {
      OverlayLoadingProgress.stop();
      OverlayToastMessage.show(
        widget: ToastMessageWidget(
          message: 'Error : ${e.toString()}',
          toastMessageStatus: ToastMessageStatus.failed,
        ),
      );
      notifyListeners();
    }
  }
}
