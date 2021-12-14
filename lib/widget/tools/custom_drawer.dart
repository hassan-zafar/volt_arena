import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:volt_arena/cart/cart.dart';
import 'package:volt_arena/consts/collections.dart';
import 'package:volt_arena/database/auth_methods.dart';
import 'package:volt_arena/database/user_local_data.dart';
import 'package:volt_arena/inner_screens/commentsNChat.dart';
import 'package:volt_arena/screens/landing_page.dart';
import 'package:volt_arena/screens/orders/order.dart';
import 'package:volt_arena/utilities/utilities.dart';
import 'package:volt_arena/wishlist/wishlist.dart';
import 'circular_profile_image.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Icon forwardArrow = Icon(
      Icons.arrow_forward_ios_rounded,
      size: 16,
    );
    return Drawer(
      child: ListView(
        children: <Widget>[
          _peronalInfo(),
          _divider('User Bag', context),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(WishlistScreen.routeName);
            },
            leading: const Icon(Icons.favorite_border),
            title: const Text('Wish List'),
            trailing: forwardArrow,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(MyBookingsScreen.routeName);
            },
            leading: const Icon(Icons.shopping_cart),
            title: const Text('My Booking'),
            trailing: forwardArrow,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(OrderScreen.routeName);
            },
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Completed Sessions'),
            trailing: forwardArrow,
          ),
          _divider('User Information', context),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: Text(UserLocalData.getUserEmail),
          ),
          ListTile(
            leading: const Icon(Icons.call),
            title: const Text('Phone Number'),
            subtitle: Text(UserLocalData.getPhoneNumber),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today_rounded),
            title: const Text('Joing Date'),
            subtitle: Text(UserLocalData.getUUserCreatedAt),
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
                          isPostComment: false, isProductComment: false),
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

  Padding _peronalInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Utilities.padding,
        horizontal: Utilities.padding,
      ),
      child: Row(
        children: <Widget>[
          CircularProfileImage(
            radious: 50,
            imageURL: UserLocalData.getUserImageUrl,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  UserLocalData.getUserDisplayName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 26,
                  ),
                ),
                Text(
                  UserLocalData.getUserEmail,
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
}
