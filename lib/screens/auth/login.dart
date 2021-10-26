import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:volt_arena/database/auth_methods.dart';
import 'package:volt_arena/main_screen.dart';
import 'package:volt_arena/utilities/custom_validator.dart';
import 'package:volt_arena/utilities/utilities.dart';
import 'package:volt_arena/widget/tools/custom_button.dart';
import 'package:volt_arena/widget/tools/custom_textformfield.dart';
import 'package:volt_arena/widget/tools/custom_toast.dart';
import 'package:volt_arena/widget/tools/password_textformfield.dart';
import 'package:volt_arena/widget/tools/show_loading.dart';

import 'forget_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = '/LoginScreen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Utilities.padding),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _loginWord(context),
              const SizedBox(height: 30),
              CustomTextFormField(
                title: 'Email',
                controller: _email,
                hint: 'test@test.com',
                validator: (String? value) => CustomValidator.email(value),
                autoFocus: true,
              ),
              PasswordTextFormField(controller: _password),
              _forgetPassword(),
              CustomTextButton(
                onTap: () async {
                  if (_key.currentState!.validate()) {
                    showLoadingDislog(context);
                    final User? _user =
                        await AuthMethod().loginWithEmailAndPassword(
                      _email.text.trim(),
                      _password.text.trim(),
                    );
                    if (_user != null) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        MainScreens.routeName,
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      Navigator.of(context).pop();
                      CustomToast.errorToast(
                          message: 'email OR password in incorrect');
                    }
                  }
                },
                text: 'Login',
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _forgetPassword() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ForgetPassword.routeName);
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        alignment: Alignment.centerRight,
        child: const Text('Forget password?'),
      ),
    );
  }

  Row _loginWord(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          'Login',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Icon(
            Icons.fiber_manual_record,
            size: 18,
          ),
        )
      ],
    );
  }
}
