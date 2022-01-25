import 'package:ccm/pages/contractor_list.dart';
import 'package:ccm/pages/countries_list.dart';
import 'package:flutter/material.dart';

import 'client_list.dart';
import 'cwr_summary.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final pageController = PageController();

  setindex(int index) {
    setState(() {
      pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      backgroundColor: Color(0xFFFAFAFA),
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.125,
            color: Colors.white,
            child: Column(
              children: [
                AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(
                      "assets/logo.png",
                      fit: BoxFit.scaleDown,
                      height: 25,
                    )),
                DrawerTile(icon: Icons.home, label: "Home", onTap: () => setindex(0)),
                DrawerTile(icon: Icons.dashboard, label: "Dashboard", onTap: () => setindex(1)),
                DrawerTile(icon: Icons.business, label: "Clients", onTap: () => setindex(2)),
                DrawerTile(icon: Icons.business, label: "Contractors", onTap: () => setindex(3)),
              ],
            ),
          ),
          Expanded(
              child: Column(
            children: [
              Container(
                color: Color(0xFF3A5F85),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "In a world of gray, CCM provides clarity to all construction & facility projects.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Logout",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
                height: 60,
                width: double.maxFinite,
              ),
              Expanded(
                  child: PageView(
                controller: pageController,
                children: [CountriesList(), CwrSummary(), ClientView(), ContractorView()],
              )),
            ],
          )),
        ],
      ),
    );
  }

  Widget getWidget(int index) {
    return CountriesList();
  }
}

class DrawerTile extends StatelessWidget {
  final void Function()? onTap;

  const DrawerTile({
    Key? key,
    required this.icon,
    required this.label,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(icon),
              ),
              Text("$label"),
            ],
          ),
        ),
      ),
    );
  }
}
