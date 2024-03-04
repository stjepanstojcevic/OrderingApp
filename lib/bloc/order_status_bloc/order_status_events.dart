import 'package:equatable/equatable.dart';
import 'package:ordering_app/models/drink.dart';
import 'package:ordering_app/models/order.dart';

abstract class OrderStatusEvent extends Equatable {}

class LoadOrderStatus extends OrderStatusEvent {
  final List<Drink> drinks;

  LoadOrderStatus(this.drinks);

  @override
  List<Object?> get props => [drinks];
}

class ConfirmOrder extends OrderStatusEvent {
  final Order order;

  ConfirmOrder(this.order);

  @override
  List<Object?> get props => [order];
}

class UpdateStatus extends OrderStatusEvent {
  final String status;

  UpdateStatus(this.status);

  @override
  List<Object?> get props => [status];

}
