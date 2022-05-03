import 'package:flutter/material.dart';

class QuoteDropdown<T> extends StatelessWidget {
  const QuoteDropdown(
      {Key? key, this.items, this.onChanged, this.value, required this.title, this.validator, this.selectedItemBuilder, this.hintText})
      : super(key: key);

  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final T? value;
  final String title;
  final String? Function(T?)? validator;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;
  final String? hintText;

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
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              hintText: '',
              border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(4.0))),
            ),
            validator: validator,
            items: items,
            onChanged: onChanged,
            value: value,
            isExpanded: true,
          ),
        ),
      ),
    );
  }
}
