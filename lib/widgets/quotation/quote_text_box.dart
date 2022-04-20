import 'package:flutter/material.dart';

class QuoteTextBox extends StatelessWidget {
  const QuoteTextBox({Key? key, this.onTap, this.readOnly = false, this.controller, this.hintText, this.validator}) : super(key: key);

  final Function()? onTap;
  final bool readOnly;
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(hintText ?? ''),
      ),
      subtitle: Card(
        color: Colors.white,
        elevation: 5,
        shadowColor: Colors.grey,
        child: SizedBox(
          child: TextFormField(
            validator: validator,
            onTap: onTap,
            readOnly: readOnly,
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
      ),
    );
  }
}
