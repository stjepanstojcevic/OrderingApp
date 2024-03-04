part of 'order_status_bloc.dart';

abstract class OrderStatusState extends Equatable {
  const OrderStatusState();

  @override
  List<Object?> get props => [];
}

class OrderStatusInitial extends OrderStatusState {
  const OrderStatusInitial() : super();
}

class OrderStatusLoaded extends OrderStatusState {
  final Map<Drink, double> selectedDrinks;
  final double totalPrice;

  OrderStatusLoaded({
    required this.selectedDrinks,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [selectedDrinks, totalPrice];
}

class OrderStatusConfirmed extends OrderStatusState {}

class OrderStatusUpdate extends OrderStatusState {
  final String status;

  const OrderStatusUpdate(this.status);

  @override
  List<Object?> get props => [status];
}

class OrderStatusFailed extends OrderStatusState {
  final String errorMessage;

  const OrderStatusFailed(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
