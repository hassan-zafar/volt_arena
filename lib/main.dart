import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:volt_arena/bottom_bar.dart';
import 'package:volt_arena/cart/cart.dart';
import 'package:volt_arena/database/user_local_data.dart';
import 'package:volt_arena/provider/bottom_navigation_bar_provider.dart';
import 'package:volt_arena/provider/dark_theme_provider.dart';
import 'package:volt_arena/screens/landing_page.dart';
import 'package:volt_arena/screens/orders/order.dart';
import 'package:volt_arena/screens/servicesScreen.dart';
import 'package:volt_arena/inner_screens/service_details.dart';
import 'package:volt_arena/main_screen.dart';
import 'package:volt_arena/provider/cart_provider.dart';
import 'package:volt_arena/provider/favs_provider.dart';
import 'package:volt_arena/provider/orders_provider.dart';
import 'package:volt_arena/provider/products.dart';
import 'package:volt_arena/screens/auth/login.dart';
import 'package:volt_arena/screens/auth/sign_up.dart';
import 'package:volt_arena/screens/calender.dart';
import 'package:volt_arena/screens/adminScreens/upload_product_form.dart';
import 'package:volt_arena/user_state.dart';
import 'package:volt_arena/wishlist/wishlist.dart';
import 'consts/theme_data.dart';
import 'screens/auth/forget_password.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  "high_importance_channel",
  "High Importance Notifications",
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserLocalData.init();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  void getCurrentAppTheme() async {
    print('called ,mmmmm');
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = true;
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Text('Error occured'),
                ),
              ),
            );
          }
          return MultiProvider(
            // ignore: always_specify_types
            providers: [
              // ChangeNotifierProvider<DarkThemeProvider>(create: (_) {
              //   return themeChangeProvider;
              // }),
              ChangeNotifierProvider<BottomNavigationBarProvider>.value(
                value: BottomNavigationBarProvider(),
              ),
              ChangeNotifierProvider<CartProvider>.value(value: CartProvider()),
              ChangeNotifierProvider<FavsProvider>.value(value: FavsProvider()),
              ChangeNotifierProvider<OrdersProvider>.value(
                  value: OrdersProvider()),
              ChangeNotifierProvider<Products>.value(value: Products()),
            ],
            child:
                // Consumer<DarkThemeProvider>(
                //   builder: (context, themeChangeProvider, ch) {
                // return
                MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Volt Arena',
              theme:
                  // ThemeData(
                  //   scaffoldBackgroundColor:
                  //       isDarkTheme ? Colors.black : Colors.grey.shade300,
                  //   primaryColor: isDarkTheme ? Colors.black : Colors.grey.shade300,
                  //   backgroundColor:
                  //       isDarkTheme ? Colors.grey.shade700 : Colors.white,
                  //   indicatorColor:
                  //       isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
                  //   buttonColor:
                  //       isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
                  //   hintColor:
                  //       isDarkTheme ? Colors.grey.shade300 : Colors.grey.shade800,
                  //   // highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
                  //   hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
                  //   focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
                  //   disabledColor: Colors.grey,
                  //   dividerColor: isDarkTheme ? Colors.white : Colors.black,
                  //   cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
                  //   canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
                  //   brightness: Brightness.dark,
                  //   buttonTheme: Theme.of(context).buttonTheme.copyWith(
                  //       colorScheme:
                  //           isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
                  //   appBarTheme: AppBarTheme(
                  //     elevation: 0.0,
                  //   ),
                  //   colorScheme:
                  //       ColorScheme.fromSwatch(primarySwatch: Colors.yellow)
                  //           .copyWith(secondary: Colors.yellow),
                  //   textSelectionTheme: TextSelectionThemeData(
                  //       selectionColor: isDarkTheme ? Colors.white : Colors.black),
                  // ),
                  // Styles.themeData(themeChangeProvider.darkTheme, context),

                  ThemeData(
                scaffoldBackgroundColor: Colors.black,
                primaryColor: Colors.orange,
                accentColor: Colors.black,
                brightness: Brightness.dark,
                dividerTheme: const DividerThemeData(
                    color: Colors.orange, thickness: 0.5),
                textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white))
                    .apply(bodyColor: Colors.white, displayColor: Colors.white),
                colorScheme:
                    // ColorScheme.fromSwatch(primarySwatch: Colors.orange)
                    //     .copyWith(secondary: Colors.red),
                    // textSelectionTheme:
                    //     TextSelectionThemeData(selectionColor: Colors.white),
                    // primaryTextTheme: TextTheme(
                    //     bodyText1: TextStyle(
                    //       color: Colors.white,
                    //     ),
                    //     headline1: TextStyle(
                    //       color: Colors.white,
                    //     ),
                    //     bodyText2: TextStyle(
                    //       color: Colors.white,
                    //     )).apply(bodyColor: Colors.white)

                    const ColorScheme.dark(
                  primary: Colors.orange,
                  secondary: Colors.red,
                ),
              ),
              home: UserState(),
              routes: {
                // '/': (ctx) => LandingPage(),
                // WebhookPaymentScreen.routeName: (ctx) =>
                //     WebhookPaymentScreen(),
                MyBookingsScreen.routeName: (ctx) => MyBookingsScreen(),
                CalenderScreen.routeName: (ctx) => CalenderScreen(),
                ServicesScreen.routeName: (ctx) => ServicesScreen(),
                WishlistScreen.routeName: (ctx) => WishlistScreen(),
                MainScreens.routeName: (ctx) => MainScreens(),
                ServiceDetailsScreen.routeName: (ctx) => ServiceDetailsScreen(),
                LoginScreen.routeName: (ctx) => LoginScreen(),
                SignupScreen.routeName: (ctx) => SignupScreen(),
                BottomBarScreen.routeName: (ctx) => BottomBarScreen(),
                UploadProductForm.routeName: (ctx) => UploadProductForm(),
                ForgetPassword.routeName: (ctx) => ForgetPassword(),
                LandingScreen.routeName: (ctx) => LandingScreen(),
                OrderScreen.routeName: (ctx) => OrderScreen(),
              },
            ),
            //   },
            // ),
          );
        });
  }
}

// import 'package:volt_arena/screens/home_screen.dart';
// import 'package:volt_arena/screens/introduction_auth_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: NavigationPage(),
//     );
//   }
// }

// class NavigationPage extends StatefulWidget {
//   @override
//   _NavigationPageState createState() => _NavigationPageState();
// }

// class _NavigationPageState extends State<NavigationPage> {
//   bool isLoggedIn = false;

//   @override
//   void initState() {
//     super.initState();
//     FirebaseAuth.instance.authStateChanges().listen((event) {
//       if (event != null) {
//         setState(() {
//           isLoggedIn = true;
//         });
//       } else {
//         setState(() {
//           isLoggedIn = false;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: isLoggedIn == false ? IntroductionAuthScreen() : HomeScreen(),
//     );
//   }
// }
