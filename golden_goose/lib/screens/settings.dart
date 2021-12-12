import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/auth_controller.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/screens/set_country.dart';
import 'package:golden_goose/screens/set_nick_name.dart';
import 'package:golden_goose/screens/set_withdrawal.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final AuthController ac = Get.find<AuthController>();
  final UserController uc = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            Card(
              elevation: 8.0,
              margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              color: Colors.purple,
              child: ListTile(
                onTap: () {
                  Get.to(() => SetNickName());
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            uc.user.nickname,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        uc.user.email,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(
                      Icons.location_on_outlined,
                    ),
                    title: Text("Change Country".tr),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Get.to(() => SetCountry(
                            country: uc.user.nation,
                          ));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(
                      Icons.delete_forever,
                    ),
                    title: Text("Membership Withdrawal".tr),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Get.to(() => SetWithdrawal());
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50.0),
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text("Privacy Policy".tr),
                  ),
                  ListTile(
                      title: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: const Text(
                              "URL: https://sites.google.com/view/short-scalpers")))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
