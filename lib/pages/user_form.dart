import 'dart:async';

import 'package:ccm/FormControllers/user_form_controller.dart';
import 'package:ccm/controllers/sessionController.dart';
import 'package:ccm/models/countries.dart';
import 'package:ccm/models/response.dart';
import 'package:ccm/models/usermodel.dart';
import 'package:ccm/services/firebase.dart';
import 'package:ccm/widgets/quotation/quote_drop_down.dart';
import 'package:ccm/widgets/quotation/quote_text_box.dart';
import 'package:ccm/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserForm extends StatefulWidget {
  UserForm({Key? key, this.user}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();

  final UserModel? user;
}

class _UserFormState extends State<UserForm> {
  UserModel? get user => widget.user;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _controller = UserFormController.fromUser(user!);
    } else {
      _controller = UserFormController();
      _controller.isAdmin = false;
    }
  }

  late UserFormController _controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: Text("User Data", textAlign: TextAlign.center),
        actionsPadding: EdgeInsets.symmetric(horizontal: 24),
        content: Row(
          children: [
            Expanded(
                flex: 1,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/logo.png'),
                  ),
                )),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Table(
                    children: [
                      TableRow(children: [
                        QuoteTextBox(controller: _controller.name, hintText: 'Name'),
                        QuoteTextBox(controller: _controller.email, hintText: 'Email'),
                      ]),
                      TableRow(children: [
                        QuoteTextBox(controller: _controller.address, hintText: 'Address'),
                        QuoteTextBox(controller: _controller.phone, hintText: 'Phone'),
                      ]),
                      TableRow(children: [
                        Container(),
                        QuoteDropdown(
                          title: 'Role',
                          items: ["User", "Admin"].map((e) => DropdownMenuItem(value: e == "Admin", child: Text(e))).toList(),
                          value: _controller.isAdmin,
                          onChanged: (session.user?.role ?? false || widget.user == null)
                              ? (value) {
                                  setState(() {
                                    _controller.isAdmin = value;
                                  });
                                }
                              : null,
                        ),
                      ]),
                    ],
                  ),
                  Divider(),
                  (_controller.isAdmin ?? false)
                      ? Container()
                      : Table(
                          children: [
                            TableRow(
                              children: [
                                Table(
                                  children: [
                                    TableRow(children: [
                                      ListTile(
                                        title: Text("Client Quotation"),
                                        trailing: Checkbox(
                                            value: _controller.quoteClient,
                                            onChanged: (val) {
                                              setState(() {
                                                _controller.quoteClient = !_controller.quoteClient;
                                              });
                                            }),
                                      ),
                                      Container(),
                                    ]),
                                    TableRow(children: [
                                      ListTile(
                                        title: Text("Client Invoices"),
                                        trailing: Checkbox(
                                            value: _controller.invoiceClient,
                                            onChanged: (val) {
                                              setState(() {
                                                _controller.invoiceClient = !_controller.invoiceClient;
                                              });
                                            }),
                                      ),
                                      Container(),
                                    ]),
                                    TableRow(children: [
                                      ListTile(
                                        title: Text("Contractor Quotation"),
                                        trailing: Checkbox(
                                            value: _controller.quoteContractor,
                                            onChanged: (val) {
                                              setState(() {
                                                _controller.quoteContractor = !_controller.quoteContractor;
                                              });
                                            }),
                                      ),
                                      Container(),
                                    ]),
                                    TableRow(children: [
                                      ListTile(
                                        title: Text("Contractor Invoices"),
                                        trailing: Checkbox(
                                            value: _controller.invoiceContractor,
                                            onChanged: (val) {
                                              setState(() {
                                                _controller.invoiceContractor = !_controller.invoiceContractor;
                                              });
                                            }),
                                      ),
                                      Container(),
                                    ]),
                                  ],
                                ),
                                Table(
                                  children: [
                                    TableRow(children: [
                                      ListTile(
                                        title: Text("View Clients"),
                                        trailing: Checkbox(
                                            value: _controller.viewClient,
                                            onChanged: (val) {
                                              setState(() {
                                                _controller.viewClient = !_controller.viewClient;
                                              });
                                            }),
                                      ),
                                      Container(),
                                    ]),
                                    TableRow(children: [
                                      ListTile(
                                        title: Text("View Contractors"),
                                        trailing: Checkbox(
                                            value: _controller.viewContractor,
                                            onChanged: (val) {
                                              setState(() {
                                                _controller.viewContractor = !_controller.viewContractor;
                                              });
                                            }),
                                      ),
                                      Container(),
                                    ]),
                                    TableRow(children: [
                                      ListTile(
                                        title: Text("View Dashboard"),
                                        trailing: Checkbox(
                                            value: _controller.viewDashboard,
                                            onChanged: (val) {
                                              setState(() {
                                                _controller.viewDashboard = !_controller.viewDashboard;
                                              });
                                            }),
                                      ),
                                      Container(),
                                    ]),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                  Divider(),
                  GetBuilder(
                      init: session,
                      builder: (_) {
                        return StatefulBuilder(builder: (context, setstate) {
                          List<Country> list = session.sessionCountries.toList();
                          print(list);
                          return Wrap(
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: list
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: ChoiceChip(
                                        label:
                                            Text(e.name, style: TextStyle(color: _controller.country.contains(e.code) ? Colors.white : Colors.black)),
                                        selected: _controller.country.contains(e.code),
                                        tooltip: e.code,
                                        selectedColor: Colors.blue,
                                        onSelected: (val) {
                                          if (val == true) {
                                            setstate(() {
                                              _controller.country.add(e.code);
                                            });
                                          } else {
                                            setstate(() {
                                              _controller.country.removeWhere((element) => element == e.code);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  )
                                  .toList());
                        });
                      })
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonBar(
              children: [
                Align(alignment: Alignment.centerLeft, child: ElevatedButton(onPressed: () {}, child: Text("Select Countries"))),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")),
                ElevatedButton(
                  onPressed: () {
                    var future;
                    if (user == null) {
                      future = userscollection.add(_controller.object.toJson()).then((value) => Result.success("Profile created successfully"));
                      try {
                        Timer(Duration(seconds: 5), () {
                          session.auth.resetPassword(email: _controller.object.email!);
                        });
                      } catch (e) {}
                    } else {
                      print(_controller.object.toJson());
                      future = userscollection.doc(_controller.docid).update(_controller.object.toJson()).then((value) {
                        session.user = _controller.object;
                        session.update();
                        return Result.success("Profile updated successfully");
                      });
                    }
                    showFutureDialog(context: context, future: future);
                  },
                  child: Text("Submit"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
