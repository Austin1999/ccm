import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/client.dart';
import 'package:ccm/models/countries.dart';
import 'package:ccm/services/firebase.dart';
import 'package:ccm/widgets/widget.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          child: Card(
        child: Table(
          children: [
            TableRow(children: [CustomTextFormField(), CustomTextFormField()]),
            TableRow(children: [CustomTextFormField(), CustomTextFormField()]),
            TableRow(children: [CustomTextFormField(), CustomTextFormField()]),
          ],
        ),
      )),
    );
  }
}

class ClientView extends StatefulWidget {
  ClientView({Key? key, this.client}) : super(key: key);

  final Client? client;

  @override
  _ClientViewState createState() => _ClientViewState();
}

class _ClientViewState extends State<ClientView> {
  @override
  @override
  void initState() {
    super.initState();
    if (widget.client != null) {
      name.text = widget.client!.name;
      address.text = widget.client!.address ?? '';

      email.text = widget.client!.email ?? '';
      phone.text = widget.client!.phone ?? '';
      countryCode = widget.client!.country!;
    }
    countryCode = session.country != null ? session.country!.code : session.countries.first.code;
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
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 64),
                child: Text("Add Client", style: Theme.of(context).textTheme.headline6),
              ),
              Table(
                children: [
                  TableRow(children: [
                    Container(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 64),
                      child: DropdownButtonFormField(
                        value: countryCode,
                        items: session.countries.map((e) => DropdownMenuItem(value: e.code, child: Text(e.name))).toList(),
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
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 64),
                      child: CustomTextFormField(controller: name, labelText: "Name", suffixIcon: Icon(Icons.person)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 64),
                      child: CustomTextFormField(controller: email, labelText: "Email", suffixIcon: Icon(Icons.email)),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 64),
                      child: CustomTextFormField(controller: address, labelText: "Address", suffixIcon: Icon(Icons.location_on)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 64),
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
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 64),
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                        onPressed: () {
                          var client = Client(name: name.text, address: address.text, email: email.text, country: countryCode, phone: phone.text);
                          // client.add().then((value){
                          showFutureDialog(context: context, future: client.add());
                          // });
                        },
                        child: Text("Add Client")),
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
