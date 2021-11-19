import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CurrenciesController extends GetxController {
  RxMap _list = {}.obs;

  RxMap get list => _list;

  @override
  void onInit() {
    super.onInit();
    getCurrencies().then((list) {
      setList(list);
    });
  }

  void setList(Map list) {
    _list(list);
  }

  Future<Map> getCurrencies() async {
    String apiUrl = 'https://api.bithumb.com/public/ticker/ALL/KRW';
    http.Response response = await http.get(Uri.parse(apiUrl));
    return json.decode(response.body)["data"];
  }
}
