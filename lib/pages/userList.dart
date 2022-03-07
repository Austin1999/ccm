import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/client.dart';
import 'package:ccm/models/countries.dart';
import 'package:ccm/models/usermodel.dart';
import 'package:ccm/services/firebase.dart';
import 'package:ccm/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'countries_list.dart';

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
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
      fullnameval,
      emailval,
      phoneval,
      roleval,
      doc_id}) {
    String role = roleval;
    TextEditingController name = TextEditingController(text: nameval);
    TextEditingController address = TextEditingController(text: addressval);
    TextEditingController fullname = TextEditingController(text: fullnameval);
    TextEditingController email = TextEditingController(text: emailval);
    TextEditingController phone = TextEditingController(text: phoneval);
    showDialog(
        context: context,
        builder: (context) {
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
                                'User Name',
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
                                'Full Name',
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
                                  controller: fullname,
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
                              'Role',
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
                              child: DropdownButtonHideUnderline(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: DropdownButton(
                                      value: role,
                                      items: [
                                        DropdownMenuItem(
                                          child: Text(
                                            "Role",
                                            style: TextStyle(
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                          value: 'N/A',
                                        ),
                                        DropdownMenuItem(
                                          child: Text("Admin"),
                                          value: 'Admin',
                                        ),
                                        DropdownMenuItem(
                                          child: Text("User"),
                                          value: 'User',
                                        ),
                                      ],
                                      onChanged: (String? value) {
                                        setState(() {
                                          role = value!;
                                        });
                                      },
                                      hint: Text("Select item")),
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
                                  ? userscollection.doc(doc_id).update(
                                      {
                                        "name": name.text,
                                        "address": address.text,
                                        "email": email.text,
                                        "phone": phone.text,
                                        "role": role,
                                        "fullname": fullname.text
                                      },
                                    ).then((value) {
                                      name.clear();
                                      address.clear();
                                      fullname.clear();
                                      email.clear();
                                      phone.clear();
                                      role = '';
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    })
                                  : await userscollection.add(
                                      {
                                        "name": name.text,
                                        "address": address.text,
                                        "email": email.text,
                                        "phone": phone.text,
                                        "role": role,
                                        "fullname": fullname.text
                                      },
                                    ).then((value) {
                                      name.clear();
                                      address.clear();
                                      fullname.clear();
                                      email.clear();
                                      phone.clear();
                                      role = '';
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
  }

  String searchclient = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: ElevatedButton(
          onPressed: () {
            addContractor(isEdit: false, roleval: 'N/A');
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Add User",
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
                  'Users List',
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
                                        hintText: 'Search Email',
                                        suffixIcon: Icon(Icons.search),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none)),
                                  )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                stream: userscollection
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
                                    List<UserModel> _clients = [];

                                    _clients = snapshot.data!.docs.map((e) {
                                      // docid = e.id;
                                      return UserModel.fromJson(e.data(), e.id);
                                    }).toList();
                                    // session = _tempCountries;
                                    session.country = session.countries.first;
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
                                              'Role',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'FullName',
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
                                                    Text(e.role!),
                                                  ),
                                                  DataCell(
                                                    Text(e.fullname!),
                                                  ),
                                                  DataCell(
                                                      Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ), onTap: () {
                                                    userscollection
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
                                                        roleval: e.role,
                                                        fullnameval: e.fullname,
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
