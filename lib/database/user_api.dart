import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:volt_arena/models/users.dart';
import 'package:volt_arena/widget/tools/custom_toast.dart';

class UserAPI {
  static const String _collection = 'users';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  // functions
  Future<DocumentSnapshot<Map<String, dynamic>>> getInfo(
      {required String uid}) async {
    var docs = await _instance.collection(_collection).doc(uid).get();
    final AppUserModel appUser = AppUserModel.fromDocument(docs);

    if (appUser.phoneNo == null || appUser.phoneNo == '') {
      await _instance.collection(_collection).doc(uid).update({
        'phoneNo': 'Not Added',
      });
    }
    return _instance.collection(_collection).doc(uid).get();
  }

  Future<bool> addUser(AppUserModel appUser) async {
    await _instance
        .collection(_collection)
        .doc(appUser.id)
        .set(appUser.toMap())
        .catchError((Object e) {
      CustomToast.successToast(message: e.toString());
      // ignore: invalid_return_type_for_catch_error
      return false;
    });
    return true;
  }

  Future<String> uploadImage(File? file, String uid) async {
    final Reference ref =
        FirebaseStorage.instance.ref().child('users').child(uid);
    await ref.putFile(file!);
    String url = await ref.getDownloadURL();
    return url;
  }
}
