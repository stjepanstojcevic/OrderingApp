import 'dart:core';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/bloc/order_status_bloc/order_status_bloc.dart';
import 'package:ordering_app/bloc/order_status_bloc/order_status_events.dart';
import 'package:ordering_app/constants/constants.dart' as constants;
import 'package:ordering_app/constants/konstante.dart' as konstante;
import 'package:ordering_app/models/drink.dart';
import 'package:ordering_app/ui/theme/theme.dart';
import 'package:ordering_app/models/order.dart';

import '../constants/constants.dart';

Order myOrder = Order(tableId: int.parse(constants.qrCode), orderedDrinks: [], comment: "", status: "NEW");

class OrderStatusScreen extends StatefulWidget {
  final List<Drink> selectedDrinks;

  const OrderStatusScreen({Key? key, required this.selectedDrinks})
      : super(key: key);

  @override
  _OrderStatusScreenState createState() => _OrderStatusScreenState();
}

List<DataColumn> buildDataColumns(List<String> columnLabels) {
  return columnLabels
      .map((label) => DataColumn(
          label: Text(label, style: AppTheme.dataTableHeaderTextStyle)))
      .toList();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  late List<Drink> selectedDrinks;
  String? _defaultLocale;
  String? _appTitle;
  String? _tabelTextLabel;
  String? _priceInButton;
  String? _emptyCartSnackBar;
  String? _drinkNameLabel;
  String? _quantityLabel;
  String? _totalPriceLabel;

  @override
  void initState() {
    super.initState();
    _initPlatformState();
    BlocProvider.of<OrderStatusBloc>(context)
        .add(LoadOrderStatus(widget.selectedDrinks));
  }

  Future<void> _initPlatformState() async {
    await _getDefaultLocale();
    await _loadConstants();
  }

  Future<void> _getDefaultLocale() async {
    try {
      final defaultLocale = await Devicelocale.defaultLocale;
      setState(() => _defaultLocale = defaultLocale);
    } on PlatformException catch (e) {
      print("$e");
    }
  }

  Future<void> _loadConstants() async {
    final locale = _defaultLocale ?? 'en-US';
    setState(() {
      _tabelTextLabel = (locale == 'hr-HR') ? konstante.tabelTextLabel : constants.tabelTextLabel;
      _priceInButton = (locale == 'hr-HR') ? konstante.priceInButton : constants.priceInButton;
      _emptyCartSnackBar = (locale == 'hr-HR') ? konstante.emptyCartSnackBar : constants.emptyCartSnackBar;
      _drinkNameLabel = (locale == 'hr-HR') ? konstante.drinkNameLabel : constants.drinkNameLabel;
      _quantityLabel = (locale == 'hr-HR') ? konstante.quantityLabel : constants.quantityLabel;
      _totalPriceLabel = (locale == 'hr-HR') ? konstante.totalPriceLabel : constants.totalPriceLabel;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: BlocBuilder<OrderStatusBloc, OrderStatusState>(
        builder: (context, state) {
          if (state is OrderStatusLoaded) {
            selectedDrinks = state.selectedDrinks.keys.toList();
            return _buildOrderStatusContent(context, state);
          } else if (state is OrderStatusUpdate) {
            return _buildOrderConfirmed(state.status);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  double calculateTotalPrice(List<Drink> drinks) {
    double total = constants.startingValue;
    for (var drink in drinks) {
      total += drink.price * drink.quantity;
    }
    return double.parse(total.toStringAsFixed(constants.numberOfDecimals));
  }

  Widget _buildOrderStatusContent(BuildContext context,
      OrderStatusLoaded state) {
    double totalPrice = calculateTotalPrice(widget.selectedDrinks);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: FittedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    constants.drinksListLabel,
                    style: AppTheme.headingTextStyle,
                  ),
                  const SizedBox(height: 10),
                  DataTable(
                    columns: buildDataColumns([
                      drinkNameLabel,
                      quantityLabel,
                      unitPriceLabel,
                      totalPriceLabel
                    ]),
                    rows: List<DataRow>.generate(
                      state.selectedDrinks.keys.length,
                          (index) {
                        final drink =
                        state.selectedDrinks.keys.elementAt(index);
                        final isEvenRow = index.isEven;

                        return DataRow(
                          color: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return Theme
                                    .of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.08);
                              }
                              if (isEvenRow) {
                                return Colors.grey.withOpacity(0.3);
                              }
                              return null;
                            },
                          ),
                          cells: [
                            DataCell(Text(drink.name)),
                            DataCell(Text(drink.quantity.toString())),
                            DataCell(Text(drink.price.toStringAsFixed(2))),
                            DataCell(Text(state.selectedDrinks[drink]!
                                .toStringAsFixed(2))),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    constants.customerNote = value;
                    myOrder.comment = constants.customerNote ?? "";
                  });
                },
                decoration: const InputDecoration(
                  labelText: constants.userComment,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              OrderButton(
                totalPrice: totalPrice,
                onPressed: () {},
                customerNote: constants.customerNote,
                selectedDrinks: selectedDrinks,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderConfirmed(String status) {
    return Center(
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 70,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }
}

  class OrderButton extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onPressed;
  final String customerNote;
  final List<Drink> selectedDrinks;

  const OrderButton({
    Key? key,
    required this.totalPrice,
    required this.onPressed,
    required this.customerNote,
    required this.selectedDrinks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        onPressed: () async {
          BlocProvider.of<OrderStatusBloc>(context).add(
            ConfirmOrder(Order(tableId: int.parse(constants.qrCode), orderedDrinks: selectedDrinks, comment: customerNote)),
          );
        },
        child: Text(
          "$priceInButton${totalPrice.toStringAsFixed(2)} €",
        ),
      ),
    );
  }
}
