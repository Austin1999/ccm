import 'package:flutter/material.dart';

class QuoteDropdown<T> extends StatelessWidget {
  const QuoteDropdown({Key? key, this.items, this.onChanged, this.value, required this.title}) : super(key: key);

  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final T? value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(title),
      ),
      subtitle: SizedBox(
        width: double.infinity,
        height: 60,
        child: Card(
          color: Colors.white,
          elevation: 5,
          shadowColor: Colors.grey,
          child: DropdownButtonHideUnderline(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton(
              items: items,
              onChanged: onChanged,
              value: value,
            ),
          )),
        ),
      ),
    );
  }
}
