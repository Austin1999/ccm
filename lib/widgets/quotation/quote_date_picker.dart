import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final format = DateFormat.yMMMMd('en_US');

class QuoteDate extends StatelessWidget {
  const QuoteDate({Key? key, required this.title, this.date, this.onPressed}) : super(key: key);
  final String title;
  final DateTime? date;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(title),
      ),
      subtitle: Card(
        elevation: 5,
        color: onPressed == null ? Colors.grey.shade100 : Colors.white,
        shadowColor: Colors.grey,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: Row(
            children: [
              Expanded(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(date != null ? format.format(date!) : ''),
                  )),
              Expanded(
                flex: 2,
                child: IconButton(
                  onPressed: onPressed,
                  icon: Icon(Icons.calendar_month_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
      // trailing: IconButton(onPressed: () {}, icon: Icon(Icons.calendar_month_outlined)),
    );
  }
}

class QuoteDateBox extends StatelessWidget {
  QuoteDateBox(
      {Key? key,
      this.onTap,
      this.readOnly = true,
      this.hintText,
      this.validator,
      this.onChanged,
      this.trailing,
      this.onPressed,
      this.controler,
      this.title})
      : super(key: key);

  final Function()? onTap;
  final bool readOnly;

  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? trailing;
  final void Function()? onPressed;
  final TextEditingController? controler;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(title ?? ''),
      ),
      trailing: trailing,
      subtitle: Card(
        color: onPressed == null ? Colors.grey.shade100 : Colors.white,
        elevation: 5,
        shadowColor: Colors.grey,
        child: SizedBox(
          child: TextFormField(
            controller: controler,
            onChanged: onChanged,
            validator: validator,
            onTap: onTap,
            readOnly: readOnly,
            decoration: InputDecoration(
                hintText: hintText,
                contentPadding: EdgeInsets.only(left: 8, top: 16),
                border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(4.0))),
                errorBorder:
                    OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(4.0)), borderSide: BorderSide(color: Colors.red)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_month_outlined),
                  onPressed: onPressed,
                )),
          ),
        ),
      ),
    );
  }
}
