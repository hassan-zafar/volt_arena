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
              ChangeNotifierProvider<BottomNavigationBarProvider>.value(
                value: BottomNavigationBarProvider(),
              ),
              ChangeNotifierProvider<CartProvider>.value(value: CartProvider()),
              ChangeNotifierProvider<FavsProvider>.value(value: FavsProvider()),
              ChangeNotifierProvider<OrdersProvider>.value(
                  value: OrdersProvider()),
              ChangeNotifierProvider<Products>.value(value: Products()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Volt Arena',
              theme: ThemeData(
                scaffoldBackgroundColor: Colors.black,
                primaryColor: Colors.orange,
                accentColor: Colors.black,
                brightness: Brightness.dark,
                dividerTheme: const DividerThemeData(
                    color: Colors.orange, thickness: 0.5),
                textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white))
                    .apply(bodyColor: Colors.white, displayColor: Colors.white),
                colorScheme: const ColorScheme.dark(
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
