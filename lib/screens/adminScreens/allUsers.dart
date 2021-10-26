import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:volt_arena/consts/collections.dart';
import 'package:volt_arena/consts/colors.dart';
import 'package:volt_arena/consts/universal_variables.dart';
import 'package:volt_arena/screens/landing_page.dart';
import 'package:volt_arena/models/users.dart';
import 'package:volt_arena/services/authentication_service.dart';

class UserNSearch extends StatefulWidget {
  // final UserModel currentUser;
  // UserNSearch({this.currentUser});
  @override
  _UserNSearchState createState() => _UserNSearchState();
}

class _UserNSearchState extends State<UserNSearch>
    with AutomaticKeepAliveClientMixin<UserNSearch> {
  Future<QuerySnapshot>? searchResultsFuture;
  TextEditingController searchController = TextEditingController();

  String typeSelected = 'users';
  handleSearch(String query) {
    if (currentUser!.isAdmin!) {
      Future<QuerySnapshot> users =
          userRef.where("userName", isGreaterThanOrEqualTo: query).get();
      setState(() {
        searchResultsFuture = users;
      });
    } else {
      Future<QuerySnapshot> users = userRef
          .where("userName", isGreaterThanOrEqualTo: query)
          .where("isAdmin", isNotEqualTo: true)
          .where("isTeacher", isEqualTo: false)
          .get();
      setState(() {
        searchResultsFuture = users;
      });
    }
  }

  clearSearch() {
    searchController.clear();
  }

  AppBar buildSearchField(context) {
    return AppBar(
      backgroundColor: Theme.of(context).accentColor,
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
            hintText: "Search",
            hintStyle: TextStyle(color: Colors.black),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onPressed: clearSearch,
            )),
        onFieldSubmitted: handleSearch,
      ),
    );
  }

  buildSearchResult() {
    return FutureBuilder<QuerySnapshot>(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingIndicator();
        }
        List<UserResult> searchResults = [];
        snapshot.data!.docs.forEach((doc) {
          String completeName = doc["userName"].toString().toLowerCase().trim();
          if (completeName.contains(searchController.text)) {
            AppUserModel user = AppUserModel.fromDocument(doc);
            setState(() {
              UserResult searchResult = UserResult(user);
              searchResults.add(searchResult);
            });
          }
        });
        return ListView(
          children: searchResults,
        );
      },
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Container(
        decoration: backgroundColorBoxDecoration(),
        child: Scaffold(
          appBar: buildSearchField(context),
          body: searchResultsFuture == null
              ? buildAllUsers()
              : buildSearchResult(),
        ),
      ),
    );
  }

  buildAllUsers() {
    return Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
            stream: userRef.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return LoadingIndicator();
              }
              List<UserResult> userResults = [];
              List<UserResult> allAdmins = [];

              snapshot.data!.docs.forEach((doc) {
                AppUserModel user = AppUserModel.fromDocument(doc);

                //remove auth user from recommended list
                if (user.isAdmin!) {
                  UserResult adminResult = UserResult(user);
                  allAdmins.add(adminResult);
                }
              });
              return GlassContainer(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    currentUser!.isAdmin!
                        ? Container(
                            height: 100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              typeSelected = "users";
                                            });
                                          },
                                          child: GlassContainer(
                                              opacity: 0.7,
                                              shadowStrength: 8,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "All Users ${userResults.length}",
                                                  style:
                                                      TextStyle(fontSize: 20.0),
                                                ),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              typeSelected = "admin";
                                            });
                                          },
                                          child: GlassContainer(
                                              opacity: 0.7,
                                              shadowStrength: 8,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "All Admins ${allAdmins.length}",
                                                  style:
                                                      TextStyle(fontSize: 20.0),
                                                ),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    typeSelected == 'admin'
                        ? Column(
                            children: allAdmins,
                          )
                        : Text(""),
                    typeSelected == 'users'
                        ? Column(
                            children: userResults,
                          )
                        : Text(''),
                  ],
                ),
              );
            }),
        Positioned(
            left: 20,
            bottom: 20,
            child: GestureDetector(
              onTap: () {
                AuthenticationService().signOut();
                Get.off(LandingScreen());
              },
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.red,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("LogOut"),
                  )),
            ))
      ],
    );
  }
}

class UserResult extends StatelessWidget {
  final AppUserModel user;
  UserResult(this.user);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => makeAdmin(context),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GlassContainer(
                opacity: 0.6,
                shadowStrength: 8,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person),
                  ),
                  title: Text(
                    user.name.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    user.name.toString(),
                  ),
                  trailing: Text(user.isAdmin != null && user.isAdmin == true
                      ? "Admin"
                      : "User"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  makeAdmin(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              user.isAdmin! && user.id != currentUser!.id
                  ? SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        makeAdminFunc("Rank changed to User");
                      },
                      child: Text(
                        'Make User',
                      ),
                    )
                  : SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        makeAdminFunc("Upgraded to Admin");
                      },
                      child: Text(
                        'Make Admin',
                      ),
                    ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  deleteUser();
                },
                child: Text(
                  'Delete User',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              )
            ],
          );
        });
  }

  void makeAdminFunc(String msg) {
    userRef.doc(user.id).update({"isAdmin": !user.isAdmin!});
    addToFeed(msg);

    BotToast.showText(text: msg);
  }

  addToFeed(String msg) {
    // activityFeedRef.doc(user.id).collection('feedItems').add({
    //   "type": "mercReq",
    //   "commentData": msg,
    //   "userName": user.displayName,
    //   "userId": user.id,
    //   "userProfileImg": user.photoUrl,
    //   "ownerId": currentUser.id,
    //   "mediaUrl": currentUser.photoUrl,
    //   "timestamp": timestamp,
    //   "productId": "",
    // });
  }

  void deleteUser() async {
    deleteUser();
    BotToast.showText(text: 'User Deleted Refresh');
  }
}
