class Drink {
  final int id;
  final String name;
  final double price;
  int quantity;

  Drink({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 0,
  });

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      quantity: 0,
    );
  }

  static Map<String, dynamic> toJson(Drink drink) {
    return {
      'drinkId': drink.id,
      'name': drink.name,
      'price': drink.price,
      'quantity': drink.quantity,
    };
  }
}
