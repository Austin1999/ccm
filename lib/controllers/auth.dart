import 'package:ccm/controllers/getControllers.dart';
import 'package:ccm/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

signin({required String username, required String password}) async {
  String serverUsername = 'ccm_auth';
  String serverPassword = 'ccm_digi123#';
  String basicAuth = 'Basic ' + convert.base64Encode(convert.utf8.encode('$serverUsername:$serverPassword'));
  print(basicAuth);

  final queryParameters = {
    'name': username,
    'password': password,
  };
  var uri = Uri.parse('https://ccmanagement.group/quote_api/public/login/login?name=$username&password=$password');
  var response = await http.get(uri, headers: {
    'authorization': basicAuth,
    'content-type': 'application/json',
    'accept': 'application/json',
  });

  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    sessionController.session = Session.fromJson(jsonResponse);
    userController.user = User.fromJson(jsonResponse["session"]);
  }
}
