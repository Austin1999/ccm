import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  SignIn({Key? key}) : super(key: key);

  final username = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Expanded(child: Container(), flex: 1),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20),
                      Image.asset("assets/logo.png"),
                      SizedBox(height: 20),
                      Text(
                        "Crystal Clear Management-Leading Facilities Management Service In Asia",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      CustomTextFormField(
                        suffixIcon: Icon(Icons.person),
                        controller: username,
                      ),
                      SizedBox(height: 20),
                      CustomTextFormField(
                        suffixIcon: Icon(Icons.visibility_off),
                        controller: password,
                      ),
                      SizedBox(height: 20),
                      TextButton(onPressed: () {}, child: Text("Forgot password")),
                      ElevatedButton(
                          onPressed: () {
                            authController.auth.signInWithEmailAndPassword(username.text, password.text);
                            print("username : ${username.text} , password : ${password.text}");
                          },
                          child: Text("Login")),
                    ],
                  ),
                )),
            Expanded(child: Container(), flex: 1),
            Expanded(flex: 4, child: Container()),
          ],
        ),
        decoration: BoxDecoration(
          color: Color(0xFFCAE5F5),
          image: DecorationImage(
            image: AssetImage("assets/side.png"),
            alignment: Alignment.centerRight,
          ),
        ),
      ),
    );
  }
}
