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

import 'package:ccm/auth/login.dart';
import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/pages/client_list.dart';
import 'package:ccm/pages/contractor_list.dart';
import 'package:ccm/pages/countries_list.dart';
import 'package:ccm/pages/dashboardpage.dart';
import 'package:ccm/pages/userList.dart';
import 'package:ccm/pages/user_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

PageController page = PageController();

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
          init: authController,
          builder: (context) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                authController.auth.currentUser == null
                    ? Container()
                    : AnimatedContainer(
                        duration: Duration(seconds: 1),
                        child: CustomDrawer(),
                      ),
                Expanded(
                  flex: 17,
                  child: child,
                ),
              ],
            );
          }),
    );
  }
}

class CustomDrawer extends StatefulWidget {
  CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int selectedIndex = 0;
  bool isCollapsed = false;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * (isCollapsed ? 1 : 2) / 17,
      ),
      child: Card(
        elevation: 8,
        child: Drawer(
            backgroundColor: Colors.lightBlue[30],
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        "assets/logo.png",
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SideTile(
                        isCollapsed: isCollapsed,
                        selected: selectedIndex == 0,
                        title: Text('Home'),
                        leading: Icon(Icons.home),
                        onTap: () {
                          Get.offAll(() => CountriesList());
                          setState(() {
                            selectedIndex = 0;
                          });
                        },
                      ),
                      SideTile(
                        isCollapsed: isCollapsed,
                        selected: selectedIndex == 1,
                        title: Text('Dashboard'),
                        onTap: () {
                          // page.jumpToPage(1);
                          Get.offAll(() => Dashboard());
                          setState(() {
                            selectedIndex = 1;
                          });
                        },
                        leading: Icon(Icons.dashboard_rounded),
                      ),
                      SideTile(
                        isCollapsed: isCollapsed,
                        selected: selectedIndex == 2,
                        title: Text('My Profile'),
                        onTap: () {
                          // page.jumpToPage(2);
                          Get.offAll(() => UserForm(user: session.user));
                          setState(() {
                            selectedIndex = 2;
                          });
                        },
                        leading: Icon(Icons.account_circle),
                      ),
                      GetBuilder(
                          init: session,
                          builder: (context) {
                            return (session.user?.role ?? "User") != "Admin"
                                ? Container()
                                : SideTile(
                                    isCollapsed: isCollapsed,
                                    selected: selectedIndex == 3,
                                    title: Text('User'),
                                    onTap: () {
                                      // page.jumpToPage(3);
                                      Get.offAll(() => UsersList());
                                      setState(() {
                                        selectedIndex = 3;
                                      });
                                    },
                                    leading: Icon(Icons.people),
                                  );
                          }),
                      SideTile(
                        isCollapsed: isCollapsed,
                        selected: selectedIndex == 4,
                        title: Text('Client'),
                        onTap: () {
                          // page.jumpToPage(4);
                          Get.offAll(() => ClientList());
                          setState(() {
                            selectedIndex = 4;
                          });
                        },
                        leading: Icon(Icons.person),
                      ),
                      SideTile(
                        isCollapsed: isCollapsed,
                        selected: selectedIndex == 5,
                        title: Text('Contractor'),
                        onTap: () {
                          // page.jumpToPage(5);
                          Get.offAll(() => ContractorList());
                          setState(() {
                            selectedIndex = 5;
                          });
                        },
                        leading: Icon(Icons.workspaces_rounded),
                      ),
                      SideTile(
                        isCollapsed: isCollapsed,
                        title: Text('Log out'),
                        onTap: () {
                          authController.auth.signOut().then((value) {
                            Get.offAll(SignIn());
                          });
                        },
                        leading: Icon(Icons.logout),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SideTile(
                      isCollapsed: isCollapsed,
                      title: Text('Collapse'),
                      onTap: () {
                        setState(() {
                          isCollapsed = !isCollapsed;
                        });
                      },
                      leading: Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class SideTile extends StatelessWidget {
  const SideTile({
    Key? key,
    required this.title,
    this.onTap,
    required this.leading,
    required this.isCollapsed,
    this.selected = false,
  }) : super(key: key);

  final Widget? title;
  final void Function()? onTap;
  final Widget leading;
  final bool isCollapsed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    if (isCollapsed) {
      return ListTile(
        selected: selected,
        title: leading,
        onTap: onTap,
      );
    } else {
      return ListTile(
        selected: selected,
        title: title,
        onTap: onTap,
        leading: leading,
      );
    }
  }
}



//  body: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [

//           Expanded(
//             child: PageView(
//               controller: page,
//               children: [
//                 CountriesList(),
//                 Dashboard(),
//                 ProfilePage(),
//                 UsersList(),
//                 ClientList(),
//                 ContractorList(),

//                 // ContractorView()
//               ],
//             ),
//           ),
//         ],
//       ),
