import 'package:equatable/equatable.dart';

import '../../models/drink.dart';

abstract class DrinksListState extends Equatable {
  const DrinksListState();

  @override
  List<Object?> get props => [];
}

class DrinksListInitial extends DrinksListState {
  @override
  List<Object?> get props => [];
}

class DrinksListLoading extends DrinksListState {
  @override
  List<Object?> get props => [];
}

class DrinksListLoaded extends DrinksListState {
  final List<Drink> drinks;

  const DrinksListLoaded({required this.drinks});

  @override
  List<Object?> get props => [drinks];
}

class DrinksListError extends DrinksListState {
  final String errorMessage;

  DrinksListError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class UpdatingDrinks extends DrinksListState {
  @override
  List<Object?> get props => [];
}

class TotalPriceUpdated extends DrinksListState {
  final double totalPrice;

  const TotalPriceUpdated({required this.totalPrice});

  @override
  List<Object?> get props => [totalPrice];
}
