//QR View
const String appTitle = "Ordering App";
const String qrNotValidLabel = "QR code is not valid! Try again.";
const String drinksListLabel = "Drinks List";
const String tableIDLabel = "Table ID : ";
const String methodChannelName = "orderingappMC";
const String checkInternetConnectionLabel= "checkInternetConnection";
const String noInternetConnectionLabel = "No Internet Connection";
const String failure = "Not Connected";
const String success = "Connected";

String qrCode = "";

const double qrDimension = 20;
const double loadingStroke = 150;

//Drinks List
const double startingValue = 0.0;
const int initialDrinkQuantity = 0;
const int numberOfDecimals = 2;
const double columnPadding = 8.0;
const double horizontalContainerPadding = 16.0;
const double sizedBoxHeight = 20;
const double sizedBoxWidth = 20;

const String tabelTextLabel = 'Table number: ';
const String priceText = 'Price: ';
const String euroSign = '€';
const String priceInButton = 'Proceed to Order - Total: ';
const String emptyCartSnackBar = 'Your cart is empty!';

const String fetchingError = 'Failed fetching menu';
const String loadingError = 'Error loading list';

//Order Status
const String userComment = 'Add a comment (optional)';
const String drinkNameLabel = "Drink Name";
const String quantityLabel = "Quantity";
const String unitPriceLabel = "Unit Price";
const String totalPriceLabel = "Total Price";


const String orderConfirmedMessage = 'Your order is confirmed!';
const String orderAgainLabel = 'Order Again';
const String confirmOrderLabel = 'Confirm Order';
const String failedOrderLabel = "Failed in ordering, try again";

const int NumberOfStepsInStepper = 3;

String customerNote = '';
int myOrderId = 0;
String status = "";