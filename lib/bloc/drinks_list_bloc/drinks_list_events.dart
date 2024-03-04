import 'package:equatable/equatable.dart';

abstract class DrinksListEvent extends Equatable {
  const DrinksListEvent();

  @override
  List<Object?> get props => [];
}

class LoadDrinks extends DrinksListEvent {}

class AddDrink extends DrinksListEvent {
  final String drinkName;

  const AddDrink({required this.drinkName});

  @override
  List<Object?> get props => [drinkName];
}

class RemoveDrink extends DrinksListEvent {
  final String drinkName;

  const RemoveDrink({required this.drinkName});

  @override
  List<Object?> get props => [drinkName];
}
