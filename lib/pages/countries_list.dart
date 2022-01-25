import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/countries.dart';
import 'package:ccm/pages/cwr_summary.dart';
import 'package:ccm/services/firebase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountriesList extends StatelessWidget {
  CountriesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: SizedBox(
                          height: MediaQuery.of(context).size.height / 4, width: MediaQuery.of(context).size.width / 4, child: AddCountry()));
                });
          },
          child: Text("Add Country"),
        ),
        backgroundColor: Color(0xFFFAFAFA),
        body: Card(
          color: Colors.lightBlue[50],
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: countries.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                    List<Country> _tempCountries = [];
                    _tempCountries = snapshot.data!.docs.map((e) => Country.fromJson(e.data())).toList();
                    session.countries = _tempCountries;
                    session.country = session.countries.first;
                    return GridView.count(
                      crossAxisCount: 5,
                      childAspectRatio: 4,
                      children: _tempCountries
                          .map((e) => GestureDetector(
                              onTap: () {
                                session.country = e;
                                Get.to(() => CwrSummary());
                              },
                              child: CountryCard(text: e.name, code: e.code.toLowerCase())))
                          .toList(),
                    );
                  }
                  return GridView.count(
                    crossAxisCount: 5,
                    childAspectRatio: 4,
                    children: [
                      CountryCard(text: "India", code: "in"),
                      CountryCard(text: "Denmark", code: "de"),
                      CountryCard(text: "Denmark", code: "de"),
                      CountryCard(text: "Singapore", code: "sg"),
                    ],
                  );
                }),
          ),
        ));
  }
}

class CountryCard extends StatelessWidget {
  CountryCard({Key? key, required this.text, required this.code}) : super(key: key);
  final String text;
  final String code;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3,
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset('icons/flags/png/$code.png', package: 'country_icons', height: double.maxFinite / 2, fit: BoxFit.contain),
              ),
            ),
            Expanded(flex: 3, child: Text(text)),
          ],
        ),
      ),
    );
  }
}

class AddCountry extends StatefulWidget {
  AddCountry({Key? key}) : super(key: key);

  @override
  _AddCountryState createState() => _AddCountryState();
}

class _AddCountryState extends State<AddCountry> {
  late String _selectedCountry;
  @override
  void initState() {
    super.initState();
    _selectedCountry = Country.countries.first.code;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<String>(
          onChanged: (code) {
            _selectedCountry = code ?? _selectedCountry;
          },
          value: _selectedCountry,
          items: Country.countries
              .map((e) => DropdownMenuItem(
                  child: SizedBox(height: 60, width: 180, child: CountryCard(text: e.name.toUpperCase(), code: e.code.toLowerCase())), value: e.code))
              .toList(),
        ),
        Expanded(
          child: Center(
            child: ElevatedButton(
                onPressed: () {
                  Country.countries.firstWhere((element) => element.code == _selectedCountry).add();
                  Navigator.of(context).pop();
                },
                child: Text("Add County")),
          ),
        ),
      ],
    );
  }
}
