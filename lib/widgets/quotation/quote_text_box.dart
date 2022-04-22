import 'dart:async';

import 'package:flutter/material.dart';

class QuoteTextBox extends StatelessWidget {
  const QuoteTextBox({Key? key, this.onTap, this.readOnly = false, this.controller, this.hintText, this.validator, this.onChanged, this.trailing})
      : super(key: key);

  final Function()? onTap;
  final bool readOnly;
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(hintText ?? ''),
      ),
      trailing: trailing,
      subtitle: Card(
        color: Colors.white,
        elevation: 5,
        shadowColor: Colors.grey,
        child: SizedBox(
          child: TextFormField(
            onChanged: onChanged,
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

class QuoteTypeAhead extends StatelessWidget {
  const QuoteTypeAhead(
      {Key? key, this.onSelected, required this.optionsBuilder, required this.title, this.text, this.optionsViewBuilder, this.validator})
      : super(key: key);

  final void Function(String)? onSelected;
  final FutureOr<Iterable<String>> Function(TextEditingValue) optionsBuilder;
  final String title;
  final String? text;
  final Widget Function(BuildContext, void Function(String), Iterable<String>)? optionsViewBuilder;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(title),
      ),
      subtitle: Card(
        color: Colors.white,
        elevation: 5,
        shadowColor: Colors.grey,
        child: SizedBox(
            height: 52,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Autocomplete<String>(
                initialValue: TextEditingValue(text: text ?? ''),
                optionsBuilder: optionsBuilder,
                onSelected: onSelected,
                optionsViewBuilder: optionsViewBuilder,
                fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                  return TextFormField(
                    controller: textEditingController,
                    validator: validator,
                    focusNode: focusNode,
                    decoration: InputDecoration(border: InputBorder.none),
                  );
                },
              ),
            )),
      ),
    );
  }
}
