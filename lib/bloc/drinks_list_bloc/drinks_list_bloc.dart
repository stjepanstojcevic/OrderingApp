import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/bloc/drinks_list_bloc/drinks_list_events.dart';
import 'package:ordering_app/bloc/drinks_list_bloc/drinks_list_states.dart';
import 'package:ordering_app/constants/constants.dart' as constants;
import 'package:ordering_app/repository/drink_repository_implementation.dart';

import '../../models/drink.dart';

class DrinksListBloc extends Bloc<DrinksListEvent, DrinksListState> {
  List<Drink> drinks = [];

  DrinksListBloc() : super(DrinksListInitial()) {
    on<LoadDrinks>(_loadDrinks);
    on<AddDrink>(_addDrink);
    on<RemoveDrink>(_removeDrink);
  }

  FutureOr<void> _loadDrinks(LoadDrinks event, Emitter<DrinksListState> emit) async {
    try {
      final drinksRepository = FileDrinksRepository();
      drinks = await drinksRepository.fetchDrinks();
      emit(DrinksListLoaded(drinks: drinks));
    } catch (_) {
      emit(DrinksListError(constants.fetchingError));
    }
  }

  void _addDrink(AddDrink event, Emitter<DrinksListState> emit) {
    emit(UpdatingDrinks());
    try {
      final drinkIndex = drinks.indexWhere((drink) => drink.name == event.drinkName);
      if (drinkIndex != -1) {
        drinks[drinkIndex].quantity++;
        _calculateAndEmitTotalPrice(emit);
        emit(DrinksListLoaded(drinks: drinks));
      }
    } catch (e) {
      emit(DrinksListError(constants.loadingError));
    }
  }

  void _removeDrink(RemoveDrink event, Emitter<DrinksListState> emit) {
    emit(UpdatingDrinks());
    final drinkIndex = drinks.indexWhere((drink) => drink.name == event.drinkName);
    if (drinkIndex != -1 && drinks[drinkIndex].quantity > 0) {
      drinks[drinkIndex].quantity--;
      _calculateAndEmitTotalPrice(emit);
      emit(DrinksListLoaded(drinks: drinks));
    }
  }

  void _calculateAndEmitTotalPrice(Emitter<DrinksListState> emit) {
    final totalPrice = calculateTotalPrice();
    emit(TotalPriceUpdated(totalPrice: totalPrice));
  }

  double calculateTotalPrice() {
    return drinks.fold(0.0, (total, drink) => total + drink.price * drink.quantity);
  }
}
