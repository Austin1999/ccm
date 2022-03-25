import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/client.dart';
import 'package:ccm/models/countries.dart';
import 'package:ccm/services/firebase.dart';
import 'package:ccm/widgets/widget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'countries_list.dart';

class ClientList extends StatefulWidget {
  const ClientList({Key? key}) : super(key: key);

  @override
  State<ClientList> createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  @override
  void initState() {
    super.initState();
    _selectedCountry = session.country ?? session.countries.first;
  }

  late Country _selectedCountry;
  addContractor(
      {required isEdit,
      nameval,
      addressval,
      required cwrval,
      emailval,
      phoneval,
      contact,
      doc_id}) {
    TextEditingController name = TextEditingController(text: nameval);
    TextEditingController address = TextEditingController(text: addressval);
    TextEditingController cwr = TextEditingController(text: cwrval);
    TextEditingController email = TextEditingController(text: emailval);
    TextEditingController phone = TextEditingController(text: phoneval);
    TextEditingController contactPerson = TextEditingController(text: contact);
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              backgroundColor: Color(0xFFE8F3FA),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    controller: name,
                                    decoration: InputDecoration(
                                      hintText: 'Full Name',
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
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
                                    controller: address,
                                    decoration: InputDecoration(
                                      hintText: 'Address',
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: DropdownButton(
                                            value: cwr.text,
                                            items: session.countries
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
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
                                  controller: email,
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
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
                                child: TextFormField(
                                  controller: phone,
                                  decoration: InputDecoration(
                                    hintText: 'Phone Number',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
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
                                  controller: contactPerson,
                                  decoration: InputDecoration(
                                    hintText: 'Contact Person',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
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
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(15)),
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
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(15)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Row(
                                          children: [
                                            CircularProgressIndicator(),
                                            SizedBox(width: 10.0),
                                            Text(isEdit
                                                ? 'Updating User...'
                                                : 'Adding User...')
                                          ],
                                        ),
                                      );
                                    });

                                isEdit
                                    ? countries
                                        .doc(session.country!.code)
                                        .collection('clients')
                                        .doc(doc_id)
                                        .update(
                                        {
                                          'name': name.text,
                                          'address': address.text,
                                          'contactPerson': contactPerson.text,
                                          'country': session.country!.code,
                                          'email': email.text,
                                          'phone': phone.text,
                                          'cwr': cwr.text,
                                        },
                                      ).then((value) {
                                        name.clear();
                                        address.clear();
                                        cwr.clear();
                                        email.clear();
                                        phone.clear();
                                        contactPerson.clear();
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      })
                                    : await countries
                                        .doc(session.country!.code)
                                        .collection('clients')
                                        .add(
                                        {
                                          'name': name.text,
                                          'cwr': cwr.text,
                                          'address': address.text,
                                          'contactPerson': contactPerson.text,
                                          'country': session.country!.code,
                                          'email': email.text,
                                          'phone': phone.text,
                                        },
                                      ).then((value) {
                                        name.clear();
                                        address.clear();
                                        cwr.clear();
                                        email.clear();
                                        phone.clear();
                                        contactPerson.clear();
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      });
                              },
                              child: Text(
                                'Add / Update',
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
            );
          });
        });
  }

  String searchclient = '';
  String searchcountry = session.countries.first.code;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: ElevatedButton(
          onPressed: () {
            addContractor(isEdit: false, cwrval: searchcountry);
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
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
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none)),
                                      )),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 5,
                                    child: DropdownButtonHideUnderline(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: DropdownButton(
                                            value: searchcountry,
                                            items: session.countries
                                                .map((e) => DropdownMenuItem(
                                                      child: Text(e.name),
                                                      value: e.code,
                                                    ))
                                                .toList(),
                                            onChanged: (String? value) {
                                              setState(() {
                                                searchcountry = value!;
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
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                stream: countries
                                    .doc(searchcountry)
                                    .collection('clients')
                                    .where('email',
                                        isGreaterThanOrEqualTo:
                                            searchclient.toLowerCase(),
                                        isLessThan:
                                            searchclient.toLowerCase() + 'z')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.active &&
                                      snapshot.hasData) {
                                    List<Client> _clients = [];

                                    _clients = snapshot.data!.docs.map((e) {
                                      // docid = e.id;
                                      return Client.fromJson(e.data(), e.id);
                                    }).toList();
                                    // session = _tempCountries;
                                    // session.country = session.countries.first;
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        columns: [
                                          DataColumn(
                                            label: Text(
                                              'Contractor Name',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Address',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Email ID',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Phone No',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Country',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'CWR Country',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Contact Person',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Delete',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Edit',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                        rows: _clients
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
                                                          type: CoolAlertType
                                                              .confirm,
                                                          width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width >
                                                                  500
                                                              ? MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2
                                                              : MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.85,
                                                          showCancelBtn: true,
                                                          onCancelBtnTap: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          onConfirmBtnTap: () {
                                                            countries
                                                                .doc(session
                                                                    .country!
                                                                    .code)
                                                                .collection(
                                                                    'clients')
                                                                .doc(e.docid)
                                                                .delete();
                                                          });
                                                    },
                                                  ),
                                                  DataCell(
                                                      Icon(
                                                        Icons.edit,
                                                        // color: Colors.,
                                                      ), onTap: () {
                                                    print(e.docid);
                                                    addContractor(
                                                        isEdit: true,
                                                        nameval: e.name,
                                                        addressval: e.address,
                                                        emailval: e.email,
                                                        phoneval: e.phone,
                                                        cwrval: e.country,
                                                        contact:
                                                            e.contactPerson,
                                                        doc_id: e.docid);
                                                  }),
                                                ],
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    );
                                  } else {
                                    //   return Center(
                                    //     child: CircularProgressIndicator(),
                                    //   );
                                    // }
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      // enabled: _enabled,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.55,
                                              child: Card(
                                                  color: Colors.white,
                                                  elevation: 5,
                                                  child: TextFormField(
                                                    decoration: InputDecoration(
                                                        suffixIcon:
                                                            Icon(Icons.search),
                                                        border:
                                                            OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none)),
                                                  )),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 5,
                                              childAspectRatio: 4,
                                            ),
                                            itemCount: 35,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return CountryCard(
                                                  text: "", code: "");
                                            }, // crossAxisCount: 5,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }),
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
