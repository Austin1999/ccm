// import 'package:ccm/pages/contractor_list.dart';
// import 'package:ccm/pages/countries_list.dart';
// import 'package:ccm/pages/dashboard.dart';
// import 'package:ccm/pages/userList.dart';
// import 'package:flutter/material.dart';

// import 'client_list.dart';
// import 'cwr_summary.dart';

// class LandingPage extends StatefulWidget {
//   LandingPage({Key? key}) : super(key: key);

//   @override
//   _LandingPageState createState() => _LandingPageState();
// }

// class _LandingPageState extends State<LandingPage> {
//   final pageController = PageController();

//   setindex(int index) {
//     setState(() {
//       pageController.jumpToPage(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(),
//       backgroundColor: Color(0xFFFAFAFA),
//       body: Row(
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width * 0.125,
//             color: Colors.white,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 AspectRatio(
//                     aspectRatio: 1,
//                     child: Image.asset(
//                       "assets/logo.png",
//                       fit: BoxFit.scaleDown,
//                       height: 25,
//                     )),
//                 DrawerTile(
//                     icon: Icons.home, label: "Home", onTap: () => setindex(0)),
//                 DrawerTile(
//                     icon: Icons.dashboard,
//                     label: "Dashboard",
//                     onTap: () => setindex(1)),
//                 DrawerTile(
//                     icon: Icons.account_circle,
//                     label: "My Profile",
//                     onTap: () => setindex(2)),
//                 DrawerTile(
//                     icon: Icons.settings,
//                     label: "Administration",
//                     onTap: () => null),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 25.0),
//                   child: DrawerTile(
//                       icon: Icons.people,
//                       label: "Users",
//                       onTap: () => setindex(4)),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 25.0),
//                   child: DrawerTile(
//                       icon: Icons.person,
//                       label: "Client",
//                       onTap: () => setindex(2)),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 25.0),
//                   child: DrawerTile(
//                       icon: Icons.workspaces_filled,
//                       label: "Contractor",
//                       onTap: () => setindex(3)),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//               child: Column(
//             children: [
//               Container(
//                 color: Color(0xFF3A5F85),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Text(
//                         "In a world of gray, CCM provides clarity to all construction & facility projects.",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Text(
//                         "Logout",
//                         style: TextStyle(color: Colors.white, fontSize: 15),
//                       ),
//                     ),
//                   ],
//                 ),
//                 height: 60,
//                 width: double.maxFinite,
//               ),
//               Expanded(
//                   child: PageView(
//                 controller: pageController,
// children: [
//   CountriesList(),
//   DashBoardPage(),
//   ClientList(),
//   ContractorList(),
//   UsersList()
//   // ContractorView()
// ],
//               )),
//             ],
//           )),
//         ],
//       ),
//     );
//   }

//   Widget getWidget(int index) {
//     return CountriesList();
//   }
// }

// class DrawerTile extends StatelessWidget {
//   final void Function()? onTap;

//   const DrawerTile({
//     Key? key,
//     required this.icon,
//     required this.label,
//     this.onTap,
//   }) : super(key: key);

//   final IconData icon;
//   final String label;

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       child: InkWell(
//         onTap: onTap,
//         child: SizedBox(
//           height: 50,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Icon(icon, color: Colors.grey[700]),
//               ),
//               Text(
//                 "$label",
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold, color: Colors.grey[700]),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/pages/profile.dart';
import 'package:ccm/pages/userList.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';

import 'client_list.dart';
import 'contractor_list.dart';
import 'countries_list.dart';
import 'dashboard.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  PageController page = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3A5F85),
        title: Text(
            'In a world of gray, CCM provides clarity to all construction & facility projects'),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () async {
              await authController.auth.signOut();
            },
            icon: Icon(
              Icons.exit_to_app_rounded,
              color: Colors.white,
            ),
            label: Text(
              'Logout',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: page,
            style: SideMenuStyle(
              displayMode: SideMenuDisplayMode.auto,
              hoverColor: Colors.blue[100],
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
              // backgroundColor: Colors.amber
              // openSideMenuWidth: 200
            ),
            title: Column(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 150,
                    maxWidth: 150,
                  ),
                  child: Image.asset(
                    "assets/logo.png",
                  ),
                ),
                Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            footer: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Devloped by Digisailor',
                style: TextStyle(fontSize: 15),
              ),
            ),
            items: [
              SideMenuItem(
                priority: 0,
                title: 'Home',
                onTap: () {
                  page.jumpToPage(0);
                },
                icon: Icon(Icons.home),
                // badgeContent: Text(
                //   '3',
                //   style: TextStyle(color: Colors.white),
                // ),
              ),
              SideMenuItem(
                priority: 1,
                title: 'Dashboard',
                onTap: () {
                  page.jumpToPage(1);
                },
                icon: Icon(Icons.dashboard_rounded),
              ),
              SideMenuItem(
                priority: 2,
                title: 'My Profile',
                onTap: () {
                  page.jumpToPage(2);
                },
                icon: Icon(Icons.account_circle),
              ),
              // SideMenuItem(
              //   priority: 3,
              //   title: 'Administration',
              //   onTap: () => null,
              //   icon: Icon(Icons.settings),
              // ),
              SideMenuItem(
                priority: 3,
                title: 'User',
                onTap: () {
                  page.jumpToPage(3);
                },
                icon: Icon(Icons.people),
              ),
              SideMenuItem(
                priority: 4,
                title: 'Client',
                onTap: () {
                  page.jumpToPage(4);
                },
                icon: Icon(Icons.person),
              ),
              SideMenuItem(
                priority: 5,
                title: 'Contractor',
                onTap: () {
                  page.jumpToPage(5);
                },
                icon: Icon(Icons.workspaces_rounded),
              ),
              // SideMenuItem(
              //   priority: 6,
              //   title: 'Logout',
              //   onTap: () async {},
              //   icon: Icon(Icons.exit_to_app),
              // ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: [
                CountriesList(),
                DashBoardPage(),
                ProfilePage(),
                UsersList(),
                ClientList(),
                ContractorList(),

                // ContractorView()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
