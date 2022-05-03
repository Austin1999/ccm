import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/usermodel.dart';
import 'package:ccm/services/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  var uid = authController.auth.currentUser!.uid;

  @override
  void initState() {
    super.initState();

    userscollection.doc(uid).get().then((value) {
      setState(() {
        var userdata = UserModel.fromJson(value.data()!, value.id);
        name = TextEditingController(text: userdata.name);
        address = TextEditingController(text: userdata.address);
        fullname = TextEditingController(text: userdata.fullname);
        email = TextEditingController(text: userdata.email);
        phone = TextEditingController(text: userdata.phone);
      });
    });
  }

  GlobalKey<FormState> formkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: formkey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/logo.png'),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'User Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                              color: Colors.white,
                              elevation: 5,
                              shadowColor: Colors.grey,
                              child: TextFormField(
                                validator: (val) => val!.isEmpty ? 'Field Cannot be empty' : null,
                                controller: name,
                                decoration: InputDecoration(
                                  hintText: 'User Name',
                                  border: OutlineInputBorder(borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Address',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                              color: Colors.white,
                              elevation: 5,
                              shadowColor: Colors.grey,
                              child: TextFormField(
                                validator: (val) => val!.isEmpty ? 'Field Cannot be empty' : null,
                                controller: address,
                                decoration: InputDecoration(
                                  hintText: 'Address',
                                  border: OutlineInputBorder(borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Full Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                              color: Colors.white,
                              elevation: 5,
                              shadowColor: Colors.grey,
                              child: TextFormField(
                                validator: (val) => val!.isEmpty ? 'Field Cannot be empty' : null,
                                controller: fullname,
                                decoration: InputDecoration(
                                  hintText: 'Full Name',
                                  border: OutlineInputBorder(borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Card(
                            color: Colors.white,
                            elevation: 5,
                            shadowColor: Colors.grey,
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (val) => val!.isEmpty
                                  ? 'Email Cannot be Empty'
                                  : RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                          .hasMatch(val)
                                      ? null
                                      : 'Invalid Email',
                              controller: email,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                border: OutlineInputBorder(borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Phone Number',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Card(
                            color: Colors.white,
                            elevation: 5,
                            shadowColor: Colors.grey,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IntlPhoneField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]'),
                                  ),
                                ],
                                autofocus: true,
                                validator: (val) => val!.isEmpty ? 'Phone number should not be empty' : null,
                                controller: phone,
                                decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                  ),
                                ),
                                initialCountryCode: 'SG',
                                onChanged: (phone) {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Role',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          clipBehavior: Clip.antiAlias,
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(25)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            // Navigator.pop(context);
                          },
                          child: Text(
                            'Reset Password',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        ElevatedButton(
                          clipBehavior: Clip.antiAlias,
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(25)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            var currentstate = formkey.currentState;
                            if (currentstate!.validate()) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Row(
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(width: 10.0),
                                          Text('Updating User...'),
                                        ],
                                      ),
                                    );
                                  });

                              userscollection.doc(uid).update(
                                {"name": name.text, "address": address.text, "email": email.text, "phone": phone.text, "fullname": fullname.text},
                              ).then((value) {
                                name.clear();
                                address.clear();
                                fullname.clear();
                                email.clear();
                                phone.clear();

                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                            }
                          },
                          child: Text(
                            'Update',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ],
                    )
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
