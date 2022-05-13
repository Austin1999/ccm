import 'dart:async';

import 'package:ccm/FormControllers/user_form_controller.dart';
import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/countries.dart';
import 'package:ccm/models/response.dart';
import 'package:ccm/models/usermodel.dart';
import 'package:ccm/services/firebase.dart';
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
                          onChanged: (value) {
                            _controller.isAdmin = value;
                          },
                        ),
                      ]),
                    ],
                  ),
                  Divider(),
                  session.user?.role != "Admin"
                      ? Container()
                      : StatefulBuilder(builder: (context, setstate) {
                          List<Country> list = countryController.countrylist.toList();
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
                                          print(_controller.country);
                                        },
                                      ),
                                    ),
                                  )
                                  .toList());
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
                          authController.auth.resetPassword(email: _controller.object.email!);
                        });
                      } catch (e) {}
                    } else {
                      future = userscollection
                          .doc(_controller.docid)
                          .update(_controller.object.toJson())
                          .then((value) => Result.success("Profile updated successfully"));
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
