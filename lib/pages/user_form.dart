import 'dart:async';

import 'package:ccm/FormControllers/user_form_controller.dart';
import 'package:ccm/controllers/sessionController.dart';
import 'package:ccm/models/countries.dart';
import 'package:ccm/models/response.dart';
import 'package:ccm/models/usermodel.dart';
import 'package:ccm/pages/countries_list.dart';
import 'package:ccm/services/firebase.dart';
import 'package:ccm/widgets/multiSelect.dart';
import 'package:ccm/widgets/quotation/quote_drop_down.dart';
import 'package:ccm/widgets/quotation/quote_text_box.dart';
import 'package:ccm/widgets/widget.dart';
import 'package:flutter/material.dart';

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Table(
                    children: [
                      TableRow(children: [
                        QuoteTextBox(controller: _controller.name, hintText: 'Name'),
                        QuoteTextBox(controller: _controller.email, hintText: 'Email'),
                        QuoteTextBox(controller: _controller.address, hintText: 'Address'),
                      ]),
                      TableRow(children: [
                        QuoteTextBox(controller: _controller.phone, hintText: 'Phone'),
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
                        (!(_controller.isAdmin ?? false))
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: ListTile(
                                  title: Text("Country"),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Card(
                                      elevation: 8,
                                      color: Colors.white,
                                      child: MultiSelect<Country>(
                                          options: session.sessionCountries.toList(),
                                          selectedValues: _controller.country,
                                          onChanged: (value) {
                                            setState(() {
                                              _controller.country = value;
                                            });
                                          },
                                          whenEmpty: 'None selected'),
                                    ),
                                  ),
                                ),
                              ),
                      ]),
                    ],
                  ),
                  Divider(),
                  (!(_controller.isAdmin ?? false))
                      ? Container()
                      : Table(
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
                              ListTile(
                                title: Text("View Clients / Contractors"),
                                trailing: Checkbox(
                                    value: _controller.viewClient && _controller.viewContractor,
                                    onChanged: (val) {
                                      setState(() {
                                        _controller.viewClient = _controller.viewContractor = val ?? _controller.viewContractor;
                                      });
                                    }),
                              ),
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
                            ]),
                          ],
                        ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      runAlignment: WrapAlignment.spaceEvenly,
                      children: _controller.country
                          .map((e) => SizedBox(width: 230, height: 83.33, child: CountryCard(text: e.name, code: e.code)))
                          .toList(),
                    ),
                  )
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
