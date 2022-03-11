import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/client.dart';
import 'package:ccm/models/contractor.dart';
import 'package:ccm/models/countries.dart';
import 'package:ccm/services/firebase.dart';
import 'package:ccm/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'countries_list.dart';

class ContractorList extends StatefulWidget {
  const ContractorList({Key? key}) : super(key: key);

  @override
  State<ContractorList> createState() => _ContractorListState();
}

class _ContractorListState extends State<ContractorList> {
  @override
  void initState() {
    super.initState();
    _selectedCountry = session.country ?? session.countries.first;
  }

  late Country _selectedCountry;

  String searchcountry = session.countries.first.code;
  String searchcontractor = '';

  addContractor(
      {required isEdit,
      nameval,
      addressval,
      cwrval,
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
          return StatefulBuilder(builder: (context, setState) {
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
                                                      value: e.name,
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
                          SizedBox(
                            height: 15.0,
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
                                Contractor contractordata =
                                    Contractor(name: name.text);
                                isEdit
                                    ? contractors.doc(doc_id).update(
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
                                    : await contractors.add(
                                        {
                                          'name': name.text,
                                          'cwr': cwr.text,
                                          'address': address.text,
                                          'contactPerson': contactPerson.text,
                                          'country': session.country!.code,
                                          'email': email.text,
                                          'phone': phone.text,
                                          'countryName': session.country!.name
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: ElevatedButton(
          onPressed: () {
            addContractor(isEdit: false, cwrval: session.country!.name);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Add Contractor",
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
                  'Contractor List',
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
                                            searchcontractor = value;
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
                                    // TextFormField(
                                    //   onChanged: (value) {
                                    //     setState(() {
                                    //       searchcountry = value;
                                    //     });
                                    //   },
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
                                stream: contractors
                                    .where('email',
                                        isGreaterThanOrEqualTo:
                                            searchcontractor.toLowerCase(),
                                        isLessThan:
                                            searchcontractor.toLowerCase() +
                                                'z')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.active &&
                                      snapshot.hasData) {
                                    List<Contractor> _contractors = [];

                                    _contractors = snapshot.data!.docs.map((e) {
                                      // docid = e.id;
                                      return Contractor.fromJson(
                                          e.data(), e.id);
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
                                        rows: _contractors
                                            .where((element) =>
                                                element.country ==
                                                searchcountry)
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
                                                      ), onTap: () {
                                                    contractors
                                                        .doc(e.docid)
                                                        .delete();
                                                  }),
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
                                                        cwrval: e.cwr,
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

class ContractorView extends StatefulWidget {
  ContractorView({Key? key, this.contractor}) : super(key: key);

  final Client? contractor;

  @override
  _ContractorViewState createState() => _ContractorViewState();
}

class _ContractorViewState extends State<ContractorView> {
  @override
  @override
  void initState() {
    super.initState();
    if (widget.contractor != null) {
      name.text = widget.contractor!.name;
      address.text = widget.contractor!.address ?? '';

      email.text = widget.contractor!.email ?? '';
      phone.text = widget.contractor!.phone ?? '';
      countryCode = widget.contractor!.country!;
    }
    countryCode = session.country != null
        ? session.country!.code
        : session.countries.first.code;
  }

  late String countryCode;

  final name = TextEditingController();
  final address = TextEditingController();

  final email = TextEditingController();
  final phone = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          child: Card(
        color: Color(0xFFE8F3FA),
        child: SizedBox(
          height: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 64),
                child: Text("Add Contractor",
                    style: Theme.of(context).textTheme.headline6),
              ),
              Table(
                children: [
                  TableRow(children: [
                    Container(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 64),
                      child: DropdownButtonFormField(
                        value: countryCode,
                        items: session.countries
                            .map((e) => DropdownMenuItem(
                                value: e.code, child: Text(e.name)))
                            .toList(),
                        onChanged: (String? code) {
                          setState(() {
                            countryCode = code ?? countryCode;
                          });
                        },
                      ),
                    )
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 64),
                      child: CustomTextFormField(
                          controller: name,
                          labelText: "Name",
                          suffixIcon: Icon(Icons.person)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 64),
                      child: CustomTextFormField(
                          controller: email,
                          labelText: "Email",
                          suffixIcon: Icon(Icons.email)),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 64),
                      child: CustomTextFormField(
                          controller: address,
                          labelText: "Address",
                          suffixIcon: Icon(Icons.location_on)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 64),
                      child: CustomTextFormField(
                        suffixIcon: Icon(Icons.phone),
                        controller: phone,
                        labelText: "Phone",
                      ),
                    ),
                  ]),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 64),
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                        onPressed: () {
                          var client = Client(
                              name: name.text,
                              address: address.text,
                              email: email.text,
                              country: countryCode,
                              phone: phone.text);
                          // client.add().then((value){
                          showFutureDialog(
                              context: context, future: client.add());
                          // });
                        },
                        child: Text("Add Contractor")),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
