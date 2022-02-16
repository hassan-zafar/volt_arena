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
              'Paintball Reservation & Booking App',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const Spacer(),
          _loginButton(context), SizedBox,
          _googleSignup(context),
          const SizedBox(height: 12),
          // Column(
          //   children: [
          //     _googleSignup(context),
          //     const SizedBox(height: 12),
          //     _guestUserButton(context),
          //     const SizedBox(height: 30),
          //     _signupLine(),
          //     const SizedBox(height: 16),
          //   ],
          // ),
        ],
      ),
    );
  }

  InkWell _googleSignup(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Utilities.borderRadius),
      onTap: () async {
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
