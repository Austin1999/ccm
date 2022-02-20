import 'package:ccm/models/response.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    this.labelText,
    this.obscureText = false,
    this.hintText,
    this.sufix,
    this.controller,
    this.suffixIcon,
  }) : super(key: key);

  final String? labelText;
  final bool obscureText;
  final Widget? sufix;
  final String? hintText;
  final TextEditingController? controller;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            suffix: sufix,
            suffixIcon: suffixIcon,
            labelText: labelText,
            labelStyle: const TextStyle(
              fontFamily: 'Lexend Deca',
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            hintText: hintText,
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
            contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 24, 0, 24),
          ),
          style: const TextStyle(
            fontFamily: 'Lexend Deca',
            color: Color(0xFF2B343A),
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

getHeight(context) => MediaQuery.of(context).size.height;
getWidth(context) => MediaQuery.of(context).size.width;

showFutureDialog(
    {required BuildContext context, required Future<dynamic> future}) {
  print("I am in future dialog");
  showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                var response = snapshot.data as Response;
                return AlertDialog(
                  title: Text(response.code),
                  content: Text(response.message),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Okay"))
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            });
      });
}
