import 'package:ccm/controllers/sessionController.dart';
import 'package:ccm/models/client.dart';
import 'package:ccm/services/firebase.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ClientList extends StatefulWidget {
  const ClientList({Key? key}) : super(key: key);

  @override
  State<ClientList> createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  @override
  void initState() {
    super.initState();
  }

  List<Client> get clientList {
    if (searchcountry == null) {
      return clientController.overAllClientList;
    } else {
      return clientController.overAllClientList.where((element) => element.country == searchcountry).toList();
    }
  }

  String searchclient = '';
  String? searchcountry;
  addClient({required isEdit, nameval, addressval, required String cwrval, emailval, phoneval, contact, docId}) {
    TextEditingController name = TextEditingController(text: nameval);
    TextEditingController address = TextEditingController(text: addressval);
    String? cwr = cwrval;
    TextEditingController email = TextEditingController(text: emailval);
    TextEditingController phone = TextEditingController(text: phoneval);
    TextEditingController contactPerson = TextEditingController(text: contact);
    GlobalKey<FormState> clientkey = GlobalKey();
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              backgroundColor: Color(0xFFE8F3FA),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: clientkey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/logo.png'),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                                      validator: (val) => val!.isEmpty ? 'Field Cannot be empty' : null,
                                      controller: name,
                                      decoration: InputDecoration(
                                        hintText: 'Full Name',
                                        border: OutlineInputBorder(borderSide: BorderSide.none),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Address',
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
                                      validator: (val) => val!.isEmpty ? 'Field Cannot be empty' : null,
                                      controller: address,
                                      decoration: InputDecoration(
                                        hintText: 'Address',
                                        border: OutlineInputBorder(borderSide: BorderSide.none),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CWR Country',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Builder(builder: (context) {
                                    session.sessionCountries.forEach((element) => print(element.toJson()));

                                    return SizedBox(
                                      width: double.infinity,
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 5,
                                        shadowColor: Colors.grey,
                                        child: DropdownButtonHideUnderline(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: DropdownButton<String?>(
                                                value: cwr,
                                                items: session.myCountries
                                                    .map((e) => DropdownMenuItem(
                                                          child: Text(e.name),
                                                          value: e.code,
                                                        ))
                                                    .toList(),
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    cwr = value!;
                                                  });
                                                },
                                                hint: Text("Select item")),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email',
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
                                    validator: (val) => val!.isEmpty ? 'Field Cannot be empty' : null,
                                    controller: email,
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      border: OutlineInputBorder(borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Phone Number',
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IntlPhoneField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]'),
                                        ),
                                      ],
                                      autofocus: true,
                                      validator: (val) => val!.isEmpty ? 'Phone number should not be empty' : null,
                                      controller: phone,
                                      decoration: InputDecoration(
                                        labelText: 'Phone Number',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(),
                                        ),
                                      ),
                                      initialCountryCode: searchcountry,
                                      onChanged: (phone) {},
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Contact Person',
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
                                    validator: (val) => val!.isEmpty ? 'Field Cannot be empty' : null,
                                    controller: contactPerson,
                                    decoration: InputDecoration(
                                      hintText: 'Contact Person',
                                      border: OutlineInputBorder(borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                clipBehavior: Clip.antiAlias,
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              ElevatedButton(
                                clipBehavior: Clip.antiAlias,
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (clientkey.currentState!.validate()) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Row(
                                              children: [
                                                CircularProgressIndicator(),
                                                SizedBox(width: 10.0),
                                                Text(isEdit ? 'Updating Client...' : 'Adding Client...')
                                              ],
                                            ),
                                          );
                                        });

                                    var client = Client(
                                      name: name.text,
                                      address: address.text,
                                      contactPerson: contactPerson.text,
                                      country: cwr,
                                      email: email.text,
                                      phone: phone.text,
                                      cwr: cwr,
                                      docid: docId,
                                    );

                                    isEdit
                                        ? client.update().then((value) {
                                            name.clear();
                                            address.clear();
                                            cwr = null;
                                            email.clear();
                                            phone.clear();
                                            contactPerson.clear();
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          })
                                        : client.add().then((value) {
                                            name.clear();
                                            address.clear();
                                            cwr = null;
                                            email.clear();
                                            phone.clear();
                                            contactPerson.clear();
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          });
                                  }
                                },
                                child: Text(
                                  isEdit ? 'Update' : 'Add',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: ElevatedButton(
          onPressed: () {
            addClient(isEdit: false, cwrval: searchcountry ?? session.myCountries.first.code);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Add Client",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        backgroundColor: Color(0xFFFAFAFA),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Client List',
                  style: Theme.of(context).textTheme.headline6,
                ),
                GetBuilder(
                    init: clientController,
                    builder: (_) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
                          shadowColor: Colors.grey[600],
                          elevation: 5,
                          color: Colors.lightBlue[50],
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.30,
                                        child: Card(
                                            color: Colors.white,
                                            elevation: 5,
                                            child: TextFormField(
                                              onChanged: (value) {
                                                setState(() {
                                                  searchclient = value;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                  hintText: 'Enter Email',
                                                  suffixIcon: Icon(Icons.search),
                                                  border: OutlineInputBorder(borderSide: BorderSide.none)),
                                            )),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.30,
                                        child: Card(
                                          color: Colors.white,
                                          elevation: 5,
                                          child: DropdownButtonHideUnderline(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: DropdownButton(
                                                  value: searchcountry,
                                                  items: getCountryDropdown(),
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      searchcountry = value;
                                                    });
                                                  },
                                                  hint: Text("Select item")),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Table(
                                        children: [
                                          TableRow(
                                            children: [
                                              DataTable(
                                                columns: [
                                                  DataColumn(
                                                    label: Text(
                                                      'Client Name',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      'Address',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      'Email ID',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      'Phone No',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      'CWR Country',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      'Contact Person',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      'Delete',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      'Edit',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                                rows: clientList
                                                    .map<DataRow>(
                                                      (e) => DataRow(
                                                        cells: [
                                                          DataCell(
                                                            Text(e.name),
                                                          ),
                                                          DataCell(
                                                            Text(e.address ?? ''),
                                                          ),
                                                          DataCell(
                                                            Text(e.email ?? ''),
                                                          ),
                                                          DataCell(
                                                            Text(e.phone ?? ''),
                                                          ),
                                                          DataCell(
                                                            Text(e.cwr ?? ''),
                                                          ),
                                                          DataCell(
                                                            Text(e.contactPerson ?? ''),
                                                          ),
                                                          DataCell(
                                                            Icon(
                                                              Icons.delete,
                                                              color: Colors.red,
                                                            ),
                                                            onTap: () {
                                                              CoolAlert.show(
                                                                  context: context,
                                                                  type: CoolAlertType.confirm,
                                                                  width: MediaQuery.of(context).size.width > 500
                                                                      ? MediaQuery.of(context).size.width / 2
                                                                      : MediaQuery.of(context).size.width * 0.85,
                                                                  showCancelBtn: true,
                                                                  onCancelBtnTap: () => Navigator.pop(context),
                                                                  onConfirmBtnTap: () async {
                                                                    await countries
                                                                        .doc(session.country!.code)
                                                                        .collection('clients')
                                                                        .doc(e.docid)
                                                                        .delete();
                                                                    // .whenComplete(() =>
                                                                    Navigator.pop(context);
                                                                    // );
                                                                  });
                                                            },
                                                          ),
                                                          DataCell(
                                                              Icon(
                                                                Icons.edit,
                                                                // color: Colors.,
                                                              ), onTap: () {
                                                            addClient(
                                                              isEdit: true,
                                                              nameval: e.name,
                                                              addressval: e.address,
                                                              emailval: e.email,
                                                              phoneval: e.phone,
                                                              cwrval: e.cwr ?? session.myCountries.first.code,
                                                              contact: e.contactPerson,
                                                              docId: e.docid,
                                                            );
                                                          }),
                                                        ],
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ));
  }

  List<DropdownMenuItem<String>> getCountryDropdown() {
    var list = session.sessionCountries
        .map((e) => DropdownMenuItem(
              child: Text(e.name),
              value: e.code,
            ))
        .toList();
    list.add(DropdownMenuItem(child: Text('All Countries')));
    return list;
  }
}
