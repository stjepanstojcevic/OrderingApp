import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/bloc/drinks_list_bloc/drinks_list_bloc.dart';
import 'package:ordering_app/bloc/drinks_list_bloc/drinks_list_events.dart';
import 'package:ordering_app/bloc/drinks_list_bloc/drinks_list_states.dart';
import 'package:ordering_app/bloc/order_status_bloc/order_status_bloc.dart';
import 'package:ordering_app/constants/constants.dart' as constants;
import 'package:ordering_app/constants/konstante.dart' as konstante;
import 'package:ordering_app/models/drink.dart';
import 'package:ordering_app/ui/order_status_screen.dart';

class DrinksListScreen extends StatefulWidget {
  final String qrCode;

  const DrinksListScreen({Key? key, required this.qrCode}) : super(key: key);

  @override
  _DrinksListScreenState createState() => _DrinksListScreenState();
}

class _DrinksListScreenState extends State<DrinksListScreen> {
  double totalPrice = constants.startingValue;
  String? _defaultLocale;
  String? _drinksListLabel;
  String? _tabelTextLabel;
  String? _priceInButton;
  String? _emptyCartSnackBar;

  @override
  void initState() {
    _initPlatformState();
    BlocProvider.of<DrinksListBloc>(context).add(LoadDrinks());
    super.initState();
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
      _drinksListLabel = (locale == 'hr-HR') ? konstante.drinksListLabel : constants.drinksListLabel;
      _tabelTextLabel = (locale == 'hr-HR') ? konstante.tabelTextLabel : constants.tabelTextLabel;
      _priceInButton = (locale == 'hr-HR') ? konstante.priceInButton : constants.priceInButton;
      _emptyCartSnackBar = (locale == 'hr-HR') ? konstante.emptyCartSnackBar : constants.emptyCartSnackBar;
    });
  }


  void navigateToOrderStatusScreen(List<Drink> selectedDrinksList) {
    if (selectedDrinksList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${_emptyCartSnackBar ?? ""}"),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BlocProvider<OrderStatusBloc>(
            create: (context) => OrderStatusBloc(),
            child: OrderStatusScreen(selectedDrinks: selectedDrinksList),
          ),
        ),
      );
    }
  }
  List<Drink> getSelectedDrinksWithQuantityGreaterThanOne(List<Drink> drinks) {
    return drinks.where((drink) => drink.quantity > 0).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_drinksListLabel ?? ""),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(constants.columnPadding),
            child: Text("${_tabelTextLabel ?? ""} ${widget.qrCode}"),
          ),
          Expanded(
            child: BlocConsumer<DrinksListBloc, DrinksListState>(
              bloc: BlocProvider.of<DrinksListBloc>(context),
              buildWhen: (previous, current) => current is! TotalPriceUpdated,
              listener: (context, state) {
                if (state is TotalPriceUpdated) {
                  setState(() {
                    totalPrice = state.totalPrice;
                  });
                }
              },
              builder: (context, state) {
                if (state is DrinksListLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is DrinksListLoaded) {
                  final drinks = state.drinks;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: drinks.length,
                    itemBuilder: (context, index) {
                      final drink = drinks[index];
                      return ListTile(
                        title: Text(drink.name),
                        subtitle: Row(
                          children: [
                            Text(
                              "${constants.priceText} ${drink.price.toStringAsFixed(constants.numberOfDecimals)} ${constants.euroSign}",
                            ),
                            SizedBox(width: constants.sizedBoxWidth),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                if (drink.quantity>0) {
                                BlocProvider.of<DrinksListBloc>(context)
                                    .add(RemoveDrink(drinkName: drink.name));}
                              },
                            ),
                            Text(drink.quantity.toString()),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                BlocProvider.of<DrinksListBloc>(context)
                                    .add(AddDrink(drinkName: drink.name));
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is DrinksListError) {
                  return Text(state.errorMessage);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          SizedBox(height: constants.sizedBoxHeight),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: constants.horizontalContainerPadding,
            ),
            child: ElevatedButton(
              onPressed: () async {
                final drinksListBloc =
                BlocProvider.of<DrinksListBloc>(context);
                final state = drinksListBloc.state;
                if (state is DrinksListLoaded) {
                  final selectedDrinksList = getSelectedDrinksWithQuantityGreaterThanOne(state.drinks);
                  navigateToOrderStatusScreen(selectedDrinksList);
                }
              },
              child: Text(
                "${_priceInButton ?? ""} ${totalPrice.toStringAsFixed(constants.numberOfDecimals)} ${constants.euroSign}",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
