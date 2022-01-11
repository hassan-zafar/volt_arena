import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share/share.dart';
import 'package:volt_arena/cart/cart.dart';
import 'package:volt_arena/consts/collections.dart';
import 'package:volt_arena/database/auth_methods.dart';
import 'package:volt_arena/database/database.dart';
import 'package:volt_arena/database/user_api.dart';
import 'package:volt_arena/database/user_local_data.dart';
import 'package:volt_arena/inner_screens/productComments.dart';
import 'package:volt_arena/screens/adminScreens/commentsNChat.dart';
import 'package:volt_arena/screens/calender.dart';
import 'package:volt_arena/screens/landing_page.dart';
import 'package:volt_arena/screens/orders/order.dart';
import 'package:volt_arena/utilities/utilities.dart';
import 'package:volt_arena/widget/tools/show_loading.dart';
import 'package:volt_arena/wishlist/wishlist.dart';
import 'circular_profile_image.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  File? _pickedImage;
  @override
  Widget build(BuildContext context) {
    const Icon forwardArrow = Icon(
      Icons.arrow_forward_ios_rounded,
      size: 16,
    );
    return Drawer(
      child: ListView(
        children: <Widget>[
          _peronalInfo(context),
          currentUser!.isAdmin!
              ? Column(
                  children: [
                    _divider('Bookings & Reservations', context),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CalenderScreen(),
                        ));
                      },
                      leading: const Icon(Icons.shopping_bag),
                      title: const Text('All Bookings'),
                      trailing: forwardArrow,
                    ),
                  ],
                )
              : Column(
                  children: [
                    _divider('User Bag', context),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .pushNamed(WishlistScreen.routeName);
                      },
                      leading: const Icon(Icons.favorite_border),
                      title: const Text('Wish List'),
                      trailing: forwardArrow,
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .pushNamed(MyBookingsScreen.routeName);
                      },
                      leading: const Icon(Icons.shopping_cart),
                      title: const Text('My Booking'),
                      trailing: forwardArrow,
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CalenderScreen(
                            mySessions: true,
                          ),
                        ));
                      },
                      leading: const Icon(Icons.shopping_bag),
                      title: const Text('Completed Sessions'),
                      trailing: forwardArrow,
                    ),
                  ],
                ),
          _divider('User Information', context),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: Text(currentUser!.email!),
          ),
          ListTile(
            leading: const Icon(Icons.call),
            title: const Text('Phone Number'),
            subtitle: Text("${currentUser!.phoneNo!}"),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today_rounded),
            title: const Text('Joining Date'),
            subtitle: Text(currentUser!.joinedAt!),
          ),
          _divider('User Settings', context),
          ListTile(
            onTap: () => Share.share(
              'check out this app https://play.google.com/store/apps/details?id=com.whatsapp',
              subject: 'Look at this app!',
            ),
            leading: Icon(
              Icons.person_add,
              color: Theme.of(context).primaryColor,
            ),
            title: const Text('Invite Friends'),
            trailing: forwardArrow,
          ),
          !currentUser!.isAdmin!
              ? ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentsNChat(
                          chatId: currentUser!.id,
                          chatNotificationToken:
                              currentUser!.androidNotificationToken),
                    ));
                  },
                  leading: Icon(
                    Icons.chat,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: const Text('Contact Admin'),
                  trailing: forwardArrow,
                )
              : Container(),
          ListTile(
            onTap: () async {
              showLicensePage(context: context);
              await AuthMethod().signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                LandingScreen.routeName,
                (Route<dynamic> route) => false,
              );
            },
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Column _divider(String title, BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const Divider(),
      ],
    );
  }

  Padding _peronalInfo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Utilities.padding,
        horizontal: Utilities.padding,
      ),
      child: Row(
        children: <Widget>[
          Stack(
            children: [
              CircularProfileImage(
                radious: 50,
                imageURL: currentUser!.imageUrl!,
              ),
              Positioned(
                bottom: 6,
                right: -6,
                child: GestureDetector(
                  onTap: () async {
                    await _pickImageGallery();
                    if (_pickedImage != null) {
                      showLoadingDislog(context);
                      String _imageURL = '';
                      _imageURL = await UserAPI().uploadImage(
                          File(_pickedImage!.path), UserLocalData.getUserUID);
                      await UserAPI().updateImage(imageURL: _imageURL);
                      await DatabaseMethods().fetchUserInfoFromFirebase(
                          uid: UserLocalData.getUserUID);
                      setState(() {});
                      Navigator.of(context).pop();
                      _pickedImage = null;
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('Edit'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  currentUser!.name!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 26,
                  ),
                ),
                Text(
                  currentUser!.email!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    final File pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }
}
