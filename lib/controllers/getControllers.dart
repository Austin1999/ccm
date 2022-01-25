import 'package:ccm/models/user.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();
  User? user;
}

UserController userController = UserController.instance;

class SessionController extends GetxController {
  static SessionController instance = Get.find();
  Session? session;

  Rx<bool?> get isLogin => session!.isLogin.obs;
}

SessionController sessionController = SessionController.instance;
