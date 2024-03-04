import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:ordering_app/bloc/order_status_bloc/order_status_events.dart';
import 'package:ordering_app/constants/constants.dart';
import 'package:ordering_app/models/drink.dart';
import 'package:ordering_app/repository/drink_repository_implementation.dart';
import 'package:ordering_app/constants/constants.dart' as constants;

part 'order_status_states.dart';

class OrderStatusBloc extends Bloc<OrderStatusEvent, OrderStatusState> {
  OrderStatusBloc() : super(const OrderStatusInitial()) {
    on<LoadOrderStatus>(_displayReceipt);
    on<ConfirmOrder>(_confirmOrder);
    on<UpdateStatus>(_updateStatus);
  }



  final Logger _logger = Logger();
  final FileDrinksRepository _repository = FileDrinksRepository();

  FutureOr<void> _displayReceipt(
      LoadOrderStatus event, Emitter<OrderStatusState> emit) {
    try {
      Map<Drink, double> selectedDrinks = {};
      double totalPrice = 0;
      event.drinks.forEach((element) {
        selectedDrinks[element] = element.price * element.quantity;
      });

      selectedDrinks.values.forEach((unitPrice) {
        totalPrice = totalPrice + unitPrice;
      });

      emit(OrderStatusLoaded(
          selectedDrinks: selectedDrinks, totalPrice: totalPrice));
    } catch (e) {
      emit(const OrderStatusFailed(failedOrderLabel));
    }
  }

  FutureOr<void> _confirmOrder(
      ConfirmOrder event, Emitter<OrderStatusState> emit) async {
    try {
      emit(OrderStatusConfirmed());
      if(event.order.orderedDrinks.isNotEmpty) {
        _repository.postOrder(event.order);
        startTimer();
      }
    } catch (e) {
      emit(const OrderStatusFailed(failedOrderLabel));
    }
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 5), (timer) async{
      try {
        final status = await _repository.getStatus(constants.myOrderId);
        add(UpdateStatus(status));
      } catch(e) {
        _logger.d("Failed updating status");
      }
    });
  }


  FutureOr<void> _updateStatus(UpdateStatus event, Emitter<OrderStatusState> emit) {
    emit(OrderStatusUpdate(event.status));
  }

}


