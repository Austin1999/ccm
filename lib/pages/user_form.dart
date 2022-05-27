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

  String? _requiredValidator(String? number) {
    if ((number ?? '').isEmpty) {
      return 'Field should not be empty';
    }
    return null;
  }

  String? _requiredEmailValidator(String? email) {
    if ((email ?? '').isEmpty) {
      return 'Field should not be empty';
    }
    if (!GetUtils.isEmail(email ?? '')) {
      return 'Number should be a alid email';
    }
    return null;
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
              child: Form(
                key: _controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Table(
                      children: [
                        TableRow(children: [
                          QuoteTextBox(controller: _controller.name, hintText: 'Name', validator: _requiredValidator),
                          QuoteTextBox(
                            controller: _controller.email,
                            hintText: 'Email',
                            validator: _requiredEmailValidator,
                          ),
                          QuoteTextBox(controller: _controller.address, hintText: 'Address', validator: _requiredValidator),
                        ]),
                        TableRow(children: [
                          QuoteTextBox(controller: _controller.phone, hintText: 'Phone'),
                          QuoteDropdown(
                            title: 'Role',
                            items: <DropdownMenuItem<bool>>[
                              DropdownMenuItem(child: Text("Admin"), value: true),
                              DropdownMenuItem(child: Text("User"), value: false),
                            ],
                            value: _controller.isAdmin,
                            onChanged: (session.user!.isAdmin)
                                ? (bool? value) {
                                    setState(() {
                                      _controller.isAdmin = value ?? _controller.isAdmin;
                                    });
                                  }
                                : null,
                          ),
                          _controller.isAdmin
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
                                            enabled: (session.user?.isAdmin ?? false),
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
                    (_controller.isAdmin)
                        ? Container()
                        : Table(
                            children: [
                              TableRow(children: [
                                ListTile(
                                  title: Text("Client Quotation"),
                                  trailing: Checkbox(
                                    value: _controller.quoteClient,
                                    onChanged: (session.user?.isAdmin ?? false)
                                        ? (val) {
                                            setState(() {
                                              _controller.quoteClient = !_controller.quoteClient;
                                            });
                                          }
                                        : null,
                                  ),
                                ),
                                ListTile(
                                  title: Text("Contractor Quotation"),
                                  trailing: Checkbox(
                                      value: _controller.quoteContractor,
                                      onChanged: (session.user?.isAdmin ?? false)
                                          ? (val) {
                                              setState(() {
                                                _controller.quoteContractor = !_controller.quoteContractor;
                                              });
                                            }
                                          : null),
                                ),
                                ListTile(
                                  title: Text("View Clients / Contractors"),
                                  trailing: Checkbox(
                                      value: _controller.viewClient && _controller.viewContractor,
                                      onChanged: (session.user?.isAdmin ?? false)
                                          ? (val) {
                                              setState(() {
                                                _controller.viewClient = _controller.viewContractor = val ?? _controller.viewContractor;
                                              });
                                            }
                                          : null),
                                ),
                              ]),
                              TableRow(children: [
                                ListTile(
                                  title: Text("Client Invoices"),
                                  trailing: Checkbox(
                                      value: _controller.invoiceClient,
                                      onChanged: (session.user?.isAdmin ?? false)
                                          ? (val) {
                                              setState(() {
                                                _controller.invoiceClient = !_controller.invoiceClient;
                                              });
                                            }
                                          : null),
                                ),
                                ListTile(
                                  title: Text("Contractor Invoices"),
                                  trailing: Checkbox(
                                      value: _controller.invoiceContractor,
                                      onChanged: (session.user?.isAdmin ?? false)
                                          ? (val) {
                                              setState(() {
                                                _controller.invoiceContractor = !_controller.invoiceContractor;
                                              });
                                            }
                                          : null),
                                ),
                                ListTile(
                                  title: Text("View Dashboard"),
                                  trailing: Checkbox(
                                      value: _controller.viewDashboard,
                                      onChanged: (session.user?.isAdmin ?? false)
                                          ? (val) {
                                              setState(() {
                                                _controller.viewDashboard = !_controller.viewDashboard;
                                              });
                                            }
                                          : null),
                                ),
                              ]),
                            ],
                          ),
                    Divider(),
                    _controller.isAdmin
                        ? Container()
                        : Padding(
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
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonBar(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")),
                ElevatedButton(
                  onPressed: () {
                    var future;
                    if (_controller.formKey.currentState!.validate()) {
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
                    }
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
