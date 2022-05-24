import 'package:ccm/controllers/sessionController.dart';
import 'package:ccm/models/client.dart';
import 'package:ccm/services/firebase.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  addClient({required isEdit, nameval, addressval, required cwrval, emailval, phoneval, contact, docId}) {
    TextEditingController name = TextEditingController(text: nameval);
    TextEditingController address = TextEditingController(text: addressval);
    TextEditingController cwr = TextEditingController(text: cwrval);
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
                                  SizedBox(
                                    width: double.infinity,
                                    child: Card(
                                      color: Colors.white,
                                      elevation: 5,
                                      shadowColor: Colors.grey,
                                      child: DropdownButtonHideUnderline(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: DropdownButton(
                                              value: cwr.text,
                                              items: session.sessionCountries
                                                  .map((e) => DropdownMenuItem(
                                                        child: Text(e.name),
                                                        value: e.code,
                                                      ))
                                                  .toList(),
                                              onChanged: (String? value) {
                                                setState(() {
                                                  cwr.text = value!;
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
                                                Text(isEdit ? 'Updating User...' : 'Adding User...')
                                              ],
                                            ),
                                          );
                                        });

                                    var client = Client(
                                      name: name.text,
                                      address: address.text,
                                      contactPerson: contactPerson.text,
                                      country: searchcountry,
                                      email: email.text,
                                      phone: phone.text,
                                      cwr: cwr.text,
                                      docid: docId,
                                    );

                                    isEdit
                                        ? client.update().then((value) {
                                            name.clear();
                                            address.clear();
                                            cwr.clear();
                                            email.clear();
                                            phone.clear();
                                            contactPerson.clear();
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          })
                                        : client.add().then((value) {
                                            name.clear();
                                            address.clear();
                                            cwr.clear();
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
            addClient(isEdit: false, cwrval: searchcountry);
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
                Padding(
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
                                    //  TextFormField(
                                    //   decoration: InputDecoration(
                                    //       hintText: 'Enter Country',
                                    //       suffixIcon: Icon(Icons.search),
                                    //       border: OutlineInputBorder(
                                    //           borderSide: BorderSide.none)),
                                    // )
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
                                                'Country',
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
                                                      Text(e.address!),
                                                    ),
                                                    DataCell(
                                                      Text(e.email!),
                                                    ),
                                                    DataCell(
                                                      Text(e.phone!),
                                                    ),
                                                    DataCell(
                                                      Text(e.country!),
                                                    ),
                                                    DataCell(
                                                      Text(e.cwr!),
                                                    ),
                                                    DataCell(
                                                      Text(e.contactPerson!),
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
                                                              await countries.doc(session.country!.code).collection('clients').doc(e.docid).delete();
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
                                                          cwrval: e.country,
                                                          contact: e.contactPerson,
                                                          docId: e.docid);
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
                ),
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

// class ClientView extends StatefulWidget {
//   ClientView({Key? key, this.client}) : super(key: key);

//   final Client? client;

//   @override
//   _ClientViewState createState() => _ClientViewState();
// }

// class _ClientViewState extends State<ClientView> {
//   @override
//   @override
//   void initState() {
//     super.initState();
//     if (widget.client != null) {
//       name.text = widget.client!.name;
//       address.text = widget.client!.address ?? '';

//       email.text = widget.client!.email ?? '';
//       phone.text = widget.client!.phone ?? '';
//       countryCode = widget.client!.country!;
//     }
//     countryCode = session.country != null
//         ? session.country!.code
//         : session.countries.first.code;
//   }

//   late String countryCode;

//   final name = TextEditingController();
//   final address = TextEditingController();

//   final email = TextEditingController();
//   final phone = TextEditingController();

//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFFAFAFA),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Card(
//           elevation: 5,
//           color: Color(0xFFE8F3FA),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Table(children: [
//                   TableRow(
//                     children: [
//                       Expanded(
//                           child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16.0, vertical: 8.0),
//                         child: Card(
//                           color: Colors.white,
//                           elevation: 5,
//                           shadowColor: Colors.grey,
//                           child: TextFormField(
//                             decoration: InputDecoration(
//                               suffixIcon: Icon(Icons.search),
//                               hintText: 'Enter Email',
//                               border: OutlineInputBorder(
//                                   borderSide: BorderSide.none),
//                             ),
//                           ),
//                         ),
//                       )),
//                       Expanded(
//                           child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16.0, vertical: 8.0),
//                         child: Card(
//                           color: Colors.white,
//                           elevation: 5,
//                           shadowColor: Colors.grey,
//                           child: TextFormField(
//                             decoration: InputDecoration(
//                               hintText: 'Enter Country',
//                               suffixIcon: Icon(Icons.search),
//                               border: OutlineInputBorder(
//                                   borderSide: BorderSide.none),
//                             ),
//                           ),
//                         ),
//                       )),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 16, horizontal: 64),
//                           child: SizedBox(
//                             height: 40,
//                             child: ElevatedButton(
//                                 onPressed: () {
//                                   var client = Client(
//                                       name: name.text,
//                                       address: address.text,
//                                       email: email.text,
//                                       country: countryCode,
//                                       phone: phone.text);
//                                   // client.add().then((value){
//                                   showFutureDialog(
//                                       context: context, future: client.add());
//                                   // });
//                                 },
//                                 child: Text("Add Client")),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ]),
//               ),

//               // Form(
//               //     child: Card(
//               //   color: Color(0xFFE8F3FA),
//               //   child: SizedBox(
//               //     height: double.maxFinite,
//               //     child: Column(
//               //       crossAxisAlignment: CrossAxisAlignment.start,
//               //       children: [
//               //         Padding(
//               //           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 64),
//               //           child: Text("Add Client", style: Theme.of(context).textTheme.headline6),
//               //         ),
//               //         Table(
//               //           children: [
//               //             TableRow(children: [
//               //               Container(),
//               //               Padding(
//               //                 padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 64),
//               //                 child: DropdownButtonFormField(
//               //                   value: countryCode,
//               //                   items: session.countries.map((e) => DropdownMenuItem(value: e.code, child: Text(e.name))).toList(),
//               //                   onChanged: (String? code) {
//               //                     setState(() {
//               //                       countryCode = code ?? countryCode;
//               //                     });
//               //                   },
//               //                 ),
//               //               )
//               //             ]),
//               //             TableRow(children: [
//               //               Padding(
//               //                 padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 64),
//               //                 child: CustomTextFormField(controller: name, labelText: "Name", suffixIcon: Icon(Icons.person)),
//               //               ),
//               //               Padding(
//               //                 padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 64),
//               //                 child: CustomTextFormField(controller: email, labelText: "Email", suffixIcon: Icon(Icons.email)),
//               //               ),
//               //             ]),
//               //             TableRow(children: [
//               //               Padding(
//               //                 padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 64),
//               //                 child: CustomTextFormField(controller: address, labelText: "Address", suffixIcon: Icon(Icons.location_on)),
//               //               ),
//               //               Padding(
//               //                 padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 64),
//               //                 child: CustomTextFormField(
//               //                   suffixIcon: Icon(Icons.phone),
//               //                   controller: phone,
//               //                   labelText: "Phone",
//               //                 ),
//               //               ),
//               //             ]),
//               //           ],
//               //         ),
//               SizedBox(
//                 height: 20.0,
//               ),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: DataTable(
//                     headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
//                     columns: [
//                       "Client Name",
//                       "Address",
//                       "Email ID",
//                       "Phone No",
//                       "Country",
//                       "Contact Person",
//                       "Delete",
//                       "Edit",
//                     ].map((e) => DataColumn(label: Text(e))).toList(),
//                     rows: []),
//               ),
//             ],
//           ),
//           // ),
//           // )),
//         ),
//       ),
//     );
//   }
// }
