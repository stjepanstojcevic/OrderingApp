import 'dart:convert';
import 'dart:core';
import 'package:logger/logger.dart';
import 'package:ordering_app/models/order.dart';
import 'dart:async';
import '/models/drink.dart';
import 'drink_repository_interface.dart';
import 'package:http/http.dart' as http;
import 'package:ordering_app/constants/constants.dart' as constants;

class FileDrinksRepository implements DrinksRepository {
  final _logger = Logger();

  @override
  Future<List<Drink>> fetchDrinks() async {
    var client = http.Client();
    final response = await client.get(Uri.parse('http://10.15.207.161:8080/drink/getAll/${constants.qrCode}'));
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      try {
        final menuMap = jsonDecode(response.body) as Map<String, dynamic>;
        _logger.d("Menu map: $menuMap");
        _logger.d("Menu: ${menuMap["drinks"]}");
        List<Drink> menu = [];
        for (var drink in menuMap["drinks"]) {
          menu.add(Drink.fromJson(drink));
        }

        _logger.d("drinks: ${menu.toString()}");

        return menu;

      } catch (e) {
        _logger.d("Failed decoding: ${response.body}");
        throw Future.error('Failed decoding JSON');
      }
    } else {
      throw Future.error('Failed to fetch data: ${response.statusCode}');
    }
  }

  Future<int> postOrder(Order order) async {
    var client = http.Client();

    final json = jsonEncode(Order.toJson(order));

    String fixedJson = json.replaceAll(r'\', r'');
    fixedJson = fixedJson.replaceAll(r'"[', r'[');
    fixedJson = fixedJson.replaceAll(r']"', r']');
    _logger.d("Json: $fixedJson");
    final response = await client.post(
      Uri.parse('http://10.15.207.161:8080/myorder'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: fixedJson,
    );
    _logger.d('Response Status Code: ${response.statusCode}');
    _logger.d('Response Body Latest: ${response.body}');
    _logger.d("${response.headers}");
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    constants.myOrderId = responseBody['myOrderId'];
    print("brojnarudbe");
    print(constants.myOrderId);
    return constants.myOrderId;
  }

  Future<String> getStatus(int myOrderId) async {
    var client = http.Client();
    final response = await client.get(Uri.parse('http://10.15.207.161:8080/myorder/$myOrderId'));
    _logger.d('Response Status Code for getting order status: ${response.statusCode}');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      String status = responseBody["status"];
      return status;
    } else {
      throw Exception('Failed to get status');
    }
  }

}
