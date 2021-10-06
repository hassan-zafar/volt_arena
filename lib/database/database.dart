import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:volt_arena/consts/collections.dart';
import 'package:volt_arena/models/users.dart';

import 'local_database.dart';

class DatabaseMethods {

  // Future<Stream<QuerySnapshot>> getproductData() async {
  //   return FirebaseFirestore.instance.collection(productCollection).snapshots();
  // }

  Future fetchCalenderDataFromFirebase() async {
    final QuerySnapshot calenderMeetings = await calenderRef.get();

    return calenderMeetings;
  }
  Future fetchUserInfoFromFirebase({
    required String uid,
  }) async {
    final DocumentSnapshot _user = await userRef.doc(uid).get();
    currentUser = AppUserModel.fromDocument(_user);
    createToken(uid);
    UserLocalData().setIsAdmin(currentUser!.isAdmin);
    Map userData = json.decode(currentUser!.toJson());
    UserLocalData().setUserModel(json.encode(userData));
    var user = UserLocalData().getUserData();
    print(user);
    isAdmin = currentUser!.isAdmin;
    print(currentUser!.email);
  }
  createToken(String uid) {
    FirebaseMessaging.instance.getToken().then((token) {
      userRef.doc(uid).update({"androidNotificationToken": token});
      // UserLocalData().setToken(token!);
    });
  }

  addUserInfoToFirebase({AppUserModel? userModel, String? userId, String? email, bool ?isStuTeacher}) {}
}
