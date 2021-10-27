import 'package:flutter/material.dart';
import 'package:volt_arena/database/auth_methods.dart';
import 'package:volt_arena/screens/auth/login.dart';
import 'package:volt_arena/utilities/custom_images.dart';
import 'package:volt_arena/utilities/utilities.dart';
import 'package:volt_arena/widget/tools/show_loading.dart';
import '../main_screen.dart';
import 'auth/sign_up.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);
  static const String routeName = '/LandingScreen';
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 30),
          Center(
            child: SizedBox(
              height: size.width * 0.6,
              width: size.width * 0.6,
              child: Image.asset(CustomImages.logo),
            ),
          ),
          const Text(
            'Welcome',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: Utilities.padding),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Welcome to V⚡lt Arena Online Store',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const Spacer(),
          _loginButton(context),
          const SizedBox(height: 12),
          _googleSignup(context),
          const SizedBox(height: 12),
          _guestUserButton(context),
          const SizedBox(height: 30),
          _signupLine(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  InkWell _googleSignup(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Utilities.borderRadius),
      onTap: () async {
        showLoadingDislog(context);
        final bool _login = await AuthMethod().signinWithGoogle();
        if (_login) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            MainScreens.routeName,
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Utilities.padding / 2,
          horizontal: Utilities.padding * 2.5,
        ),
        decoration: BoxDecoration(
          // color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(Utilities.borderRadius),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        child: const Text(
          'Sign in with Google',
          style: TextStyle(
            letterSpacing: 1,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Row _signupLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('''Don't have a account? '''),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(SignupScreen.routeName);
          },
          child: const Text('Sign Up'),
        ),
      ],
    );
  }

  InkWell _guestUserButton(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Utilities.borderRadius),
      onTap: () async {
        showLoadingDislog(context);
        final bool _login = await AuthMethod().loginAnonymosly();
        if (_login) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              MainScreens.routeName, (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Utilities.padding / 2,
          horizontal: Utilities.padding * 3,
        ),
        decoration: BoxDecoration(
          // color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(Utilities.borderRadius),
          border: Border.all(color: Theme.of(context).colorScheme.secondary),
        ),
        child: const Text(
          'Sign in as a Guest',
          style: TextStyle(
            letterSpacing: 1,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  GestureDetector _loginButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(LoginScreen.routeName);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Utilities.padding / 2,
          horizontal: Utilities.padding * 7,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(Utilities.borderRadius),
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

// class LandingPage extends StatefulWidget {
//   @override
//   _LandingPageState createState() => _LandingPageState();
// }

// class _LandingPageState extends State<LandingPage>
//     with TickerProviderStateMixin {
//   AnimationController? _animationController;
//   Animation<double>? _animation;
//   // List<String> images = [
//   //   'https://media.istockphoto.com/photos/man-at-the-shopping-picture-id868718238?k=6&m=868718238&s=612x612&w=0&h=ZUPCx8Us3fGhnSOlecWIZ68y3H4rCiTnANtnjHk0bvo=',
//   //   'https://thumbor.forbes.com/thumbor/fit-in/1200x0/filters%3Aformat%28jpg%29/https%3A%2F%2Fspecials-images.forbesimg.com%2Fdam%2Fimageserve%2F1138257321%2F0x0.jpg%3Ffit%3Dscale',
//   //   'https://e-shopy.org/wp-content/uploads/2020/08/shop.jpeg',
//   //   'https://e-shopy.org/wp-content/uploads/2020/08/shop.jpeg',
//   // ];
//   List<String> assetImages = [
//     "assets/images/volt arena.png"
//         "assets/images/voltArtBoard2.jpg"
//   ];
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   GlobalMethods _globalMethods = GlobalMethods();
//   bool _isLoading = false;
//   @override
//   void initState() {
//     super.initState();
//     // images.shuffle();
//     _animationController =
//         AnimationController(vsync: this, duration: Duration(seconds: 20));
//     _animation =
//         CurvedAnimation(parent: _animationController!, curve: Curves.linear)
//           ..addListener(() {
//             setState(() {});
//           })
//           ..addStatusListener((animationStatus) {
//             if (animationStatus == AnimationStatus.completed) {
//               _animationController!.reset();
//               _animationController!.forward();
//             }
//           });
//     _animationController!.forward();
//   }

//   @override
//   void dispose() {
//     _animationController!.dispose();
//     super.dispose();
//   }

//   Future<void> _googleSignIn() async {
//     final googleSignIn = GoogleSignIn();
//     final googleAccount = await googleSignIn.signIn();
//     if (googleAccount != null) {
//       final googleAuth = await googleAccount.authentication;
//       if (googleAuth.accessToken != null && googleAuth.idToken != null) {
//         try {
//           var date = DateTime.now().toString();
//           var dateparse = DateTime.parse(date);
//           var formattedDate =
//               "${dateparse.day}-${dateparse.month}-${dateparse.year}";
//           final authResult = await _auth.signInWithCredential(
//               GoogleAuthProvider.credential(
//                   idToken: googleAuth.idToken,
//                   accessToken: googleAuth.accessToken));
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(authResult.user!.uid)
//               .set({
//             'id': authResult.user!.uid,
//             'name': authResult.user!.displayName,
//             'email': authResult.user!.email,
//             'phoneNumber': authResult.user!.phoneNumber,
//             'imageUrl': authResult.user!.photoURL,
//             'joinedAt': formattedDate,
//             'createdAt': Timestamp.now(),
//           });
//         } catch (error) {
//           _globalMethods.authErrorHandle(error.toString(), context);
//         }
//       }
//     }
//   }

//   void _loginAnonymosly() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       await _auth.signInAnonymously();
//     } catch (error) {
//       _globalMethods.authErrorHandle(error.toString(), context);
//       print('error occured ${error.toString()}');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Stack(children: [
//       Image.asset(
//         "assets/images/black.jpg",
//         errorBuilder: (context, url, error) => Center(child: Icon(Icons.error)),
//         fit: BoxFit.cover,
//         height: double.infinity,
//         width: double.infinity,
//         alignment: FractionalOffset(_animation!.value, 0),
//       ),
//       // CachedNetworkImage(
//       //   imageUrl: images[1],
//       //   // placeholder: (context, url) => Image.network(
//       //   //   'https://image.flaticon.com/icons/png/128/564/564619.png',
//       //   //   fit: BoxFit.contain,
//       //   // ),
//       //   errorWidget: (context, url, error) => Icon(Icons.error),
//       //   fit: BoxFit.cover,
//       //   height: double.infinity,
//       //   width: double.infinity,
//       //   alignment: FractionalOffset(_animation!.value, 0),
//       // ),

//       Container(
//         margin: EdgeInsets.only(top: 30),
//         width: double.infinity,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image.asset(
//               "assets/images/logo.png",
//               errorBuilder: (context, url, error) =>
//                   Center(child: Icon(Icons.error)),
//             ),
//             Text(
//               'Welcome',
//               style: TextStyle(
//                 fontSize: 40,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: Text(
//                 'Welcome to V⚡lt Arena Online Store',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     fontSize: 26,
//                     fontWeight: FontWeight.w400,
//                     color: Colors.white),
//               ),
//             )
//           ],
//         ),
//       ),
//       Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Row(
//             children: [
//               SizedBox(width: 10),
//               Expanded(
//                 child: ElevatedButton(
//                     style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all(
//                           Colors.orange,
//                         ),
//                         shape:
//                             MaterialStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30.0),
//                             side:
//                                 BorderSide(color: ColorsConsts.backgroundColor),
//                           ),
//                         )),
//                     onPressed: () {
//                       //TODO:login Signup wala issue krna h resolve

//                       Navigator.pushNamed(context, LoginScreen.routeName);
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Login',
//                           style: TextStyle(
//                               fontWeight: FontWeight.w500, fontSize: 17),
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         FaIcon(
//                           FontAwesomeIcons.user,
//                           size: 18,
//                         )
//                       ],
//                     )),
//               ),
//               SizedBox(width: 10),
//               Expanded(
//                 child: ElevatedButton(
//                     style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all(Colors.red),
//                         shape:
//                             MaterialStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30.0),
//                             side:
//                                 BorderSide(color: ColorsConsts.backgroundColor),
//                           ),
//                         )),
//                     onPressed: () {
//                       // Navigator.pushNamed(context, SignUpScreen.routeName);
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Sign up',
//                           style: TextStyle(
//                               fontWeight: FontWeight.w500, fontSize: 17),
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Icon(
//                           Icons.person_add,
//                           size: 18,
//                         )
//                       ],
//                     )),
//               ),
//               SizedBox(width: 10),
//             ],
//           ),
//           SizedBox(
//             height: 30,
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Divider(
//                     color: Colors.white,
//                     thickness: 2,
//                   ),
//                 ),
//               ),
//               Text(
//                 'Or continue with',
//                 style: TextStyle(color: Colors.white),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Divider(
//                     color: Colors.white,
//                     thickness: 2,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 30,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               OutlineButton(
//                 onPressed: _googleSignIn,
//                 shape: StadiumBorder(),
//                 highlightedBorderColor: Colors.red.shade200,
//                 borderSide: BorderSide(width: 2, color: Colors.red),
//                 child: Text('Google',
//                     style: TextStyle(
//                       color: Colors.white,
//                     )),
//               ),
//               _isLoading
//                   ? CircularProgressIndicator()
//                   : OutlineButton(
//                       onPressed: () {
//                         _loginAnonymosly();
//                         // Navigator.pushNamed(context, BottomBarScreen.routeName);
//                       },
//                       shape: StadiumBorder(),
//                       highlightedBorderColor: Colors.deepPurple.shade200,
//                       borderSide:
//                           BorderSide(width: 2, color: Colors.deepPurple),
//                       child: Text('Sign in as a guest',
//                           style: TextStyle(
//                             color: Colors.white,
//                           )),
//                     ),
//             ],
//           ),
//           SizedBox(
//             height: 40,
//           ),
//         ],
//       ),
//     ]));
//   }
// }
