import 'dart:convert';

import 'package:ordering_app/models/drink.dart';

class Order {
  int tableId;
  String comment;
  String status;
  List<Drink> orderedDrinks;

  Order({
    required this.tableId,
    this.comment = "",
    this.status = "NEW",
    required this.orderedDrinks,
  });


  static Map<String, dynamic> toJson(Order order) {
    return {
      "tableId" : order.tableId,
      "comment" : order.comment,
      "status" : order.status,
      "orderedDrinks" :  jsonEncode(order.orderedDrinks.map((e) => Drink.toJson(e)).toList())
    };
  }
}
