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
        color: Colors.white,
        shadowColor: Colors.grey,
        child: SizedBox(
          width: double.infinity,
          height: 51,
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
