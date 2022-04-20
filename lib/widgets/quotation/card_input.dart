import 'package:flutter/material.dart';

class CardInputField extends StatelessWidget {
  const CardInputField({Key? key, this.onTap, this.readonly, required this.controller, required this.hinttext, required this.text}) : super(key: key);
  final String text, hinttext;
  final onTap;
  final bool? readonly;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              color: Colors.white,
              elevation: 5,
              shadowColor: Colors.grey,
              child: TextFormField(
                onTap: onTap,
                readOnly: readonly ?? false,
                controller: controller,
                decoration: InputDecoration(
                  hintText: hinttext,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
