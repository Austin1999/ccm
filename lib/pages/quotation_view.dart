import 'package:flutter/material.dart';

class QuotationView extends StatefulWidget {
  const QuotationView({Key? key}) : super(key: key);

  @override
  _QuotationViewState createState() => _QuotationViewState();
}

class _QuotationViewState extends State<QuotationView> {
  String? category;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              CardInput(
                hinttext: 'Search',
                text: 'Search',
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overall Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        color: Colors.white,
                        elevation: 5,
                        shadowColor: Colors.grey,
                        child: DropdownButtonHideUnderline(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: DropdownButton(
                                value: category,
                                items: [
                                  DropdownMenuItem(
                                    child: Text("Pending"),
                                    value: 'Pending',
                                  ),
                                  DropdownMenuItem(
                                    child: Text("Completed"),
                                    value: 'Completed',
                                  ),
                                  DropdownMenuItem(
                                    child: Text("Canceled"),
                                    value: 'Canceled',
                                  ),
                                  DropdownMenuItem(
                                    child: Text("All Quotations"),
                                    value: 'All Quotations',
                                  )
                                ],
                                onChanged: (String? value) {
                                  setState(() {
                                    category = value;
                                  });
                                },
                                hint: Text("Select item")),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardInput extends StatelessWidget {
  CardInput({required this.text, required this.hinttext});
  String text, hinttext;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              decoration: InputDecoration(
                hintText: hinttext,
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
