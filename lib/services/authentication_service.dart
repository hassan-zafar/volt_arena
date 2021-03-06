import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:volt_arena/consts/collections.dart';
import 'package:volt_arena/database/database.dart';
import 'package:volt_arena/database/local_database.dart';
import 'package:volt_arena/database/user_local_data.dart';
import 'package:volt_arena/screens/landing_page.dart';

import 'package:volt_arena/widget/custom_toast.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    LocalDB().logOut();
  }

  Future logIn({
    required String email,
    required final String password,
  }) async {
    print("here");
    try {
      // final UserCredential result =
      await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        print(" auth service login: $value");
        print(" auth service login uid: ${value.user!.uid}");

        // return value.user!.uid;
        DatabaseMethods()
            .fetchUserInfoFromFirebase(uid: value.user!.uid)
            .then((value) => Get.off(() => LandingScreen()));
      });
      // return result.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        errorToast(message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future deleteUser({required String email, required String password}) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      User user = _firebaseAuth.currentUser!;
      AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      print(user);
      UserCredential result =
          await user.reauthenticateWithCredential(credentials);
      userRef.doc(user.uid).delete();

      await result.user!.delete();
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<UserCredential?> signUp({
    required final String password,
    required final String? userName,
    required final String? joinedAt,
    required final String? imageUrl,
    required final Timestamp? createdAt,
    required final String email,
    required final int phoneNo,
    final bool? isAdmin,
  }) async {
    print("1st stop");

    try {
      final UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .catchError((Object obj) {
        errorToast(message: obj.toString());
      });
      final UserCredential user = result;
      assert(user != null);
      assert(await user.user!.getIdToken() != null);
      if (user != null) {
        await DatabaseMethods().addUserInfoToFirebase(
            password: password,
            userName: userName,
            createdAt: createdAt,
            email: email,
            joinedAt: joinedAt,
            userId: user.user!.uid,
            phoneNo: phoneNo,
            imageUrl: imageUrl,
            isAdmin: false);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      errorToast(message: "$e.message");
    }
  }
}
