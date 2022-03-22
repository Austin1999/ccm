import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/countries.dart';
import 'package:ccm/pages/cwr_summary.dart';
import 'package:ccm/pages/splashscreen.dart';
import 'package:ccm/services/firebase.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class CountriesList extends StatefulWidget {
  CountriesList({Key? key}) : super(key: key);

  @override
  State<CountriesList> createState() => _CountriesListState();
}

class _CountriesListState extends State<CountriesList> {
  TextEditingController searchcon = TextEditingController();
  String search = '';
  late String _selectedCountry;
  @override
  void initState() {
    super.initState();
    _selectedCountry = Country.countries.first.code;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      title: Text('Select Country'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButton<String>(
                            items: Country.countries
                                .map(
                                  (e) => DropdownMenuItem(
                                    child: Text(e.name),
                                    value: e.code,
                                  ),
                                )
                                .toList(),
                            onChanged: (code) {
                              setState(() {
                                _selectedCountry = code ?? _selectedCountry;
                              });
                            },
                            value: _selectedCountry,
                          ),
                          Positioned(
                            child: ElevatedButton(
                              child: Text(
                                'Add Country',
                              ),
                              onPressed: () {
                                Country.countries
                                    .firstWhere((element) =>
                                        element.code == _selectedCountry)
                                    .add();
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  });
                });
          },
          child: Text("Add Country"),
        ),
        backgroundColor: Color(0xFFFAFAFA),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Country List',
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
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: Card(
                                  color: Colors.white,
                                  elevation: 5,
                                  child: TextFormField(
                                    controller: searchcon,
                                    onChanged: (v) {
                                      setState(() {
                                        search = v;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(Icons.search),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none)),
                                  )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                stream: countries
                                    .where('name',
                                        isGreaterThanOrEqualTo:
                                            search.toTitleCase())
                                    .where('name',
                                        isLessThan: search.toTitleCase() + 'z')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.active &&
                                      snapshot.hasData) {
                                    List<Country> _tempCountries = [];
                                    _tempCountries = snapshot.data!.docs
                                        .map(
                                          (e) => Country.fromJson(
                                            e.data(),
                                          ),
                                        )
                                        .toList();
                                    session.countries = _tempCountries;
                                    session.country = session.countries.first;
                                    print(session.country);
                                    return GridView.count(
                                      shrinkWrap: true,
                                      crossAxisCount: 5,
                                      childAspectRatio: 4,
                                      children: _tempCountries
                                          .map((e) => InkWell(
                                              onTap: () {
                                                // showDialog(
                                                //     context: context,
                                                //     builder: (context) {
                                                //       return AlertDialog(
                                                //         content: Row(
                                                //           children: [
                                                //             CircularProgressIndicator(),
                                                //             SizedBox(
                                                //               width: 10,
                                                //             ),
                                                //             Text(
                                                //                 'Please Wait, Loading...')
                                                //           ],
                                                //         ),
                                                //       );
                                                //     });
                                                session.country = e;
                                                // Navigator.pop(context);
                                                Get.to(() => CwrSummary());
                                              },
                                              child: CountryCard(
                                                  text: e.name,
                                                  code: e.code.toLowerCase())))
                                          .toList(),
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

class CountryCard extends StatelessWidget {
  CountryCard({Key? key, required this.text, required this.code})
      : super(key: key);
  final String text;
  final String code;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3,
      child: Card(
        shadowColor: Colors.grey[600],
        elevation: 5,
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset('icons/flags/png/$code.png',
                    package: 'country_icons',
                    height: double.maxFinite / 2,
                    fit: BoxFit.contain),
              ),
            ),
            Expanded(flex: 3, child: Text(text)),
          ],
        ),
      ),
    );
  }
}

// class AddCountry extends StatefulWidget {
//   AddCountry({Key? key}) : super(key: key);

//   @override
//   _AddCountryState createState() => _AddCountryState();
// }

// class _AddCountryState extends State<AddCountry> {
//   late String _selectedCountry;
//   @override
//   void initState() {
//     super.initState();
//     _selectedCountry = Country.countries.first.code;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         DropdownButtonFormField<String>(
//           onChanged: (code) {
//             _selectedCountry = code ?? _selectedCountry;
//           },
//           value: _selectedCountry,
//           items: Country.countries
//               .map((e) => DropdownMenuItem(
//                   // child: SizedBox(
//                   //     // height: 100,
//                   //     // width: 250,
//                   //     child: Column(
//                   //   children: [
//                   //     ListTile(
//                   //       // leading: Image.asset(
//                   //       //   'icons/flags/png/${e.code}.png',
//                   //       //   width: 50,
//                   //       //   height: 50,
//                   //       //   fit: BoxFit.contain,
//                   //       //   package: 'country_icons',
//                   //       // ),
//                   // title:
//                   child: Text(
//                     e.name.toLowerCase(),
//                     //     ),
//                     //   ),
//                     //   Divider()
//                     // ],
//                     // )
//                     // CountryCard(
//                     //     text: e.name.toUpperCase(),
//                     //     code: e.code.toLowerCase()
//                     //     )
//                   ),
//                   value: e.code))
//               .toList(),
//         ),
//         Expanded(
//           child: Center(
//             child: ElevatedButton(
//                 onPressed: () {
//                   Country.countries
//                       .firstWhere((element) => element.code == _selectedCountry)
//                       .add();
//                   Navigator.of(context).pop();
//                 },
//                 child: Text("Add County")),
//           ),
//         ),
//       ],
//     );
//   }
// }

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
