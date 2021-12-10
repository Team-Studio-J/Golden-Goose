// ignore_for_file: must_be_immutable

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golden_goose/controllers/auth_controller.dart';
import 'package:golden_goose/controllers/user_controller.dart';
import 'package:golden_goose/databases/database.dart';
import 'package:golden_goose/models/user_model.dart';
import 'package:golden_goose/widgets/grid.dart';
import 'package:golden_goose/widgets/nation_avatar.dart';

class SetCountry extends StatefulWidget {
  SetCountry({Key? key, required this.country}) : super(key: key);
  String? country;

  @override
  State<SetCountry> createState() => _SetCountryState();
}

class _SetCountryState extends State<SetCountry> {
  final ac = Get.find<AuthController>();

  final uc = Get.find<UserController>();

  final nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("국가 변경"),
              Card(
                elevation: 8.0,
                margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: Colors.white.withOpacity(0.4),
                child: ListTile(
                  onTap: () {
                    showCountryPicker(
                        context: context,
                        showPhoneCode: true,
                        // optional. Shows phone code before the country name.
                        onSelect: (Country country) {
                          setState(() {
                            widget.country = country.countryCode;
                          });
                        });
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      NationAvatar(nation: widget.country),
                      const SizedBox(width: 6),
                      SizedBox(
                        width: 140,
                        child: FittedBox(
                            fit: BoxFit.scaleDown, child: buildCountry()),
                      ),
                    ],
                  ),
                  trailing: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonGrid(
                      color: Colors.grey,
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      onTap: () {
                        Get.back();
                      },
                      child: const Text("취소")),
                  const SizedBox(width: 10),
                  ButtonGrid(
                      color: Colors.indigo.withOpacity(0.8),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      onTap: () => updateCountry(widget.country),
                      child: const Text("변경")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateCountry(String? country) {
    if (country == null) {
      Get.snackbar("국가 설정 에러", "국가를 설정해 주세요",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    UserModel userModel = uc.user;
    userModel.nation = country;
    Database.updateUser(ac.user!, userModel.toJson());
    Get.back();
  }

  Text buildCountry() {
    if (widget.country == null) {
      return const Text("-");
    }
    return Text(
      Country.parse(widget.country!).displayName,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
