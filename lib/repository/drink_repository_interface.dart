import '/models/drink.dart';

abstract class DrinksRepository {
  Future<List<Drink>> fetchDrinks();
}
