import 'package:ccm/auth/login.dart';
import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/pages/landing_page.dart';
import 'package:flutter/material.dart';
import '../services/firebase.dart';

class AuthRouter extends StatelessWidget {
  const AuthRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authController.auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            var user = snapshot.data;
            // print(user!.uid);
            if (user!.emailVerified) {
              return LandingPage();
            } else {
              return LandingPage();
            }
          } else {
            return SignIn();
          }
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
