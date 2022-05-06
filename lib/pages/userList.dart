import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/client.dart';
import 'package:ccm/models/countries.dart';
import 'package:ccm/models/usermodel.dart';
import 'package:ccm/pages/user_form.dart';
import 'package:ccm/services/firebase.dart';
import 'package:ccm/widgets/widget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
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

  String searchclient = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return UserForm();
                });
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
                                        border: OutlineInputBorder(borderSide: BorderSide.none)),
                                  )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                stream: userscollection
                                    .where('email', isGreaterThanOrEqualTo: searchclient.toLowerCase(), isLessThan: searchclient.toLowerCase() + 'z')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
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
                                              'Role',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'FullName',
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
                                                        onConfirmBtnTap: () {
                                                          userscollection.doc(e.docid).delete().then(
                                                                (value) => Navigator.pop(context),
                                                              );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  DataCell(
                                                      Icon(
                                                        Icons.edit,
                                                        // color: Colors.,
                                                      ), onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return UserForm(
                                                            user: e,
                                                          );
                                                        });
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.55,
                                              child: Card(
                                                  color: Colors.white,
                                                  elevation: 5,
                                                  child: TextFormField(
                                                    decoration: InputDecoration(
                                                        suffixIcon: Icon(Icons.search), border: OutlineInputBorder(borderSide: BorderSide.none)),
                                                  )),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          GridView.builder(
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 5,
                                              childAspectRatio: 4,
                                            ),
                                            itemCount: 35,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return CountryCard(text: "", code: "");
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
