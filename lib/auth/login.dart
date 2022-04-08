import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/services/firebase.dart';
import 'package:ccm/widgets/widget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isObscure = true;

  bool pswdtapped = false;

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
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            letterSpacing: 1.2),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      CustomTextFormField(
                        hintText: 'Username',
                        suffixIcon: Icon(Icons.person),
                        controller: username,
                      ),
                      SizedBox(height: 20),
                      FocusScope(
                        child: Focus(
                          onFocusChange: (focus) {
                            setState(() {
                              pswdtapped = !pswdtapped;
                            });
                          },
                          child: TextFormField(
                            // onTap: () {
                            //   setState(() {
                            //     pswdtapped = true;
                            //   });
                            // },
                            controller: password,
                            obscureText: isObscure,
                            decoration: InputDecoration(
                              suffixIcon: !pswdtapped ? Icon(Icons.lock) : null,
                              suffix: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isObscure = !isObscure;
                                  });
                                },
                                icon: isObscure
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off),
                              ),
                              // labelText: labelText,
                              labelStyle: const TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              hintText: 'Password',
                              hintStyle: const TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFF3A5F85),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              contentPadding:
                                  const EdgeInsetsDirectional.fromSTEB(
                                      16, 0, 0, 25),
                            ),
                            style: const TextStyle(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF2B343A),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      // CustomTextFormField(
                      //   sufix: IconButton(
                      //     onPressed: () {
                      //       isObscure = !isObscure;
                      //     },
                      //     icon: isObscure
                      //         ? Icon(Icons.visibility)
                      //         : Icon(Icons.visibility_off),
                      //   ),
                      //   // suffixIcon: Icon(Icons.visibility_off),
                      //   controller: password,
                      // ),
                      SizedBox(height: 20),
                      TextButton(
                          onPressed: () {}, child: Text("Forgot password")),
                      ElevatedButton(
                          onPressed: () {
                            CoolAlert.show(
                                width: MediaQuery.of(context).size.width > 500
                                    ? MediaQuery.of(context).size.width / 2
                                    : MediaQuery.of(context).size.width * 0.85,
                                context: context,
                                type: CoolAlertType.loading);
                            authController.auth
                                .signInWithEmailAndPassword(
                                    username.text, password.text)
                                .then((value) {
                              Navigator.pop(context);
                            }, onError: (e) {
                              Navigator.pop(context);
                              return showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Sign in Failed',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            e.message.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('OK'))
                                        ],
                                      ),
                                    );
                                  });
                            });
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
