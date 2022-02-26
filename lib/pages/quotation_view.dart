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
        appBar: AppBar(
          backgroundColor: Color(0xFF3A5F85),
          title: Text(
              'In a world of gray, CCM provides clarity to all construction & facility projects'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: SizedBox(
                          height: 45.0,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Back'),
                          ),
                        )),
                  ),
                  Spacer(),
                  Expanded(
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      shadowColor: Colors.grey,
                      child: TextFormField(
                        // controller: quotationno,
                        decoration: InputDecoration(
                          hintText: 'INR',
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      shadowColor: Colors.grey,
                      child: TextFormField(
                        // controller: quotationno,
                        decoration: InputDecoration(
                          hintText: 'Parent Quote',
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      shadowColor: Colors.grey,
                      child: TextFormField(
                        // controller: quotationno,
                        decoration: InputDecoration(
                          hintText: 'Category',
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  color: Color(0xFFE8F3FA),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Client Quotation',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Divider(),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Quotation Number',
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
                                        // controller: quotationno,
                                        decoration: InputDecoration(
                                          hintText: 'Quotation No',
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Client Name',
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
                                        // controller: clientname,
                                        decoration: InputDecoration(
                                          hintText: 'Client Name',
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Quote Amount',
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
                                        // controller: quoteamount,
                                        decoration: InputDecoration(
                                          hintText: 'Quote Amount',
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Client Approval',
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
                                        // controller: contactPerson,
                                        decoration: InputDecoration(
                                          hintText: 'Client PO',
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date Issued',
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
                                        // controller: quotationno,
                                        decoration: InputDecoration(
                                          hintText: 'dd-mm-yyyy',
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Description',
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
                                        // controller: clientname,
                                        decoration: InputDecoration(
                                          hintText: 'Description',
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Approval Status',
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: DropdownButton(
                                                value: category,
                                                items: [
                                                  DropdownMenuItem(
                                                    child: Text("Approved"),
                                                    value: 'Approved',
                                                  ),
                                                  DropdownMenuItem(
                                                    child: Text("Pending"),
                                                    value: 'Pending',
                                                  ),
                                                  DropdownMenuItem(
                                                    child: Text("Rejected"),
                                                    value: 'Rejected',
                                                  ),
                                                  DropdownMenuItem(
                                                    child: Text("Canceled"),
                                                    value: 'Canceled',
                                                  ),
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
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Margin',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          child: Card(
                                            color: Colors.grey,
                                            elevation: 5,
                                            shadowColor: Colors.grey,
                                            child: TextFormField(
                                              readOnly: true,
                                              // controller: contactPerson,
                                              decoration: InputDecoration(
                                                hintText: '%',
                                                border: OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            color: Colors.grey,
                                            elevation: 5,
                                            shadowColor: Colors.grey,
                                            child: TextFormField(
                                              readOnly: true,
                                              // controller: contactPerson,
                                              decoration: InputDecoration(
                                                hintText: 'Amount',
                                                border: OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'CCM Ticket Number',
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
                                        // controller: quotationno,
                                        decoration: InputDecoration(
                                          hintText: 'Ticket Number',
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Job Completion Date',
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
                                        // controller: clientname,
                                        decoration: InputDecoration(
                                          hintText: 'dd-mm-yyyy',
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  color: Color(0xFFE8F3FA),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Client Invoice',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Divider(),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Client Invoice No',
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
                                          // controller: quotationno,
                                          decoration: InputDecoration(
                                            hintText: 'Invoice No',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Client Invoice Amount',
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
                                          // controller: clientname,
                                          decoration: InputDecoration(
                                            hintText: 'Client Invoice Amount',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Invoice Issue Date',
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
                                          // controller: quoteamount,
                                          decoration: InputDecoration(
                                            hintText: 'dd-mm-yyyy',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Last Recived Date',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Card(
                                        color: Colors.grey[200],
                                        elevation: 5,
                                        shadowColor: Colors.grey,
                                        child: TextFormField(
                                          readOnly: true,
                                          // controller: contactPerson,
                                          decoration: InputDecoration(
                                            hintText: 'dd-mm-yyyy',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date Issued',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Card(
                                        color: Colors.grey[200],
                                        elevation: 5,
                                        shadowColor: Colors.grey,
                                        child: TextFormField(
                                          readOnly: true,
                                          // controller: quotationno,
                                          decoration: InputDecoration(
                                            hintText: 'dd-mm-yyyy',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ])),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text('Add'),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text('Edit'),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text('List Invoice'),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text('Payments/Credits'),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  color: Color(0xFFE8F3FA),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contractor Quotation',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Divider(),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'PO Number',
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
                                          // controller: quotationno,
                                          decoration: InputDecoration(
                                            hintText: 'PO Number',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Contractor Name',
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
                                          // controller: clientname,
                                          decoration: InputDecoration(
                                            hintText: 'Contractor Name',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'PO Amount',
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
                                          // controller: quoteamount,
                                          decoration: InputDecoration(
                                            hintText: 'PO Amount',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'PO Issued Date',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Card(
                                        color: Colors.grey[200],
                                        elevation: 5,
                                        shadowColor: Colors.grey,
                                        child: TextFormField(
                                          readOnly: true,
                                          // controller: contactPerson,
                                          decoration: InputDecoration(
                                            hintText: 'dd-mm-yyyy',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Quotation No',
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
                                          // controller: quotationno,
                                          decoration: InputDecoration(
                                            hintText: 'Quotation No',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Quote Amount',
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
                                          // controller: clientname,
                                          decoration: InputDecoration(
                                            hintText: 'Quote Amount',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Work Commence',
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
                                        shadowColor: Colors.white,
                                        child: TextFormField(
                                          // controller: quoteamount,
                                          decoration: InputDecoration(
                                            hintText: 'dd-mm-yyyy',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Work Complete',
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
                                          readOnly: true,
                                          // controller: contactPerson,
                                          decoration: InputDecoration(
                                            hintText: 'dd-mm-yyyy',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text('Add'),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text('Edit'),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text('List Contractors'),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  color: Color(0xFFE8F3FA),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contractor Invoice',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Divider(),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Contractor Invoice No',
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
                                          // controller: quotationno,
                                          decoration: InputDecoration(
                                            hintText: 'Contractor Invoice No',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Contractor Invoice Amount',
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
                                          // controller: clientname,
                                          decoration: InputDecoration(
                                            hintText: 'Amount',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Invoice Received Date',
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
                                          // controller: quoteamount,
                                          decoration: InputDecoration(
                                            hintText: 'dd-mm-yyyy',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tax Invoice No',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Card(
                                        color: Colors.grey[200],
                                        elevation: 5,
                                        shadowColor: Colors.grey,
                                        child: TextFormField(
                                          readOnly: true,
                                          // controller: contactPerson,
                                          decoration: InputDecoration(
                                            hintText: 'Tax Invoice No',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Paid Amount',
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
                                          readOnly: true,
                                          // controller: quotationno,
                                          decoration: InputDecoration(
                                            hintText: 'Paid Amount',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Last Paid Date',
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
                                          readOnly: true,
                                          // controller: contactPerson,
                                          decoration: InputDecoration(
                                            hintText: 'dd-mm-yyyy',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text('Add'),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text('Edit'),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text('List Invoice'),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text('Payments/Credits'),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  color: Color(0xFFE8F3FA),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Comments',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Card(
                                        color: Colors.grey[200],
                                        elevation: 5,
                                        shadowColor: Colors.grey,
                                        child: TextFormField(
                                          readOnly: true,
                                          maxLines: 10,
                                          // controller: quotationno,
                                          decoration: InputDecoration(
                                            // hintText: 'Contractor Invoice No',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Add Comment',
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
                                          // controller: clientname,
                                          decoration: InputDecoration(
                                            hintText: 'Comment Something ....',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text('Send'),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Send'),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

// CardInput(
//   hinttext: 'Search',
//   text: 'Search',
// ),
//   Padding(
//     padding:
//         const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Overall Status',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 17,
//           ),
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         SizedBox(
//           width: double.infinity,
//           child: Card(
//             color: Colors.white,
//             elevation: 5,
//             shadowColor: Colors.grey,
//             child: DropdownButtonHideUnderline(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: DropdownButton(
//                     value: category,
//                     items: [
//                       DropdownMenuItem(
//                         child: Text("Pending"),
//                         value: 'Pending',
//                       ),
//                       DropdownMenuItem(
//                         child: Text("Completed"),
//                         value: 'Completed',
//                       ),
//                       DropdownMenuItem(
//                         child: Text("Canceled"),
//                         value: 'Canceled',
//                       ),
//                       DropdownMenuItem(
//                         child: Text("All Quotations"),
//                         value: 'All Quotations',
//                       )
//                     ],
//                     onChanged: (String? value) {
//                       setState(() {
//                         category = value;
//                       });
//                     },
//                     hint: Text("Select item")),
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   ),
// ],
// ),
// ),
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
