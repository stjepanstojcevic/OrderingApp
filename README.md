# ordering_app

The Flutter project that I made during a 5-week internship at ATOS d.o.o. The idea of the project is that the user in the coffee bar scans the QR code on the table, orders the drinks he wants, optionally adds a comment, and when he confirms the order, he can track the status of the current order.

Logo :

![coffee](https://github.com/stjepanstojcevic/OrderingApp/assets/48209720/5482b627-61dd-4941-a35d-09a85e3bc133)

The Java code checks whether the user's mobile phone is connected to the Internet. This information is passed to the Flutter part of the code via the Method Channel. If the mobile phone is not connected to the Internet, the application remains on the first screen and cannot be used. If the user scans a QR code that does not provide a natural number, a SnackBar appears that says "QR code from not valid! Try again.". It checks which language is set on the phone. If Croatian is set, all text will be in Croatian, and if it is any other language, all text will be in English.

<img width="695" alt="Screenshot 2024-03-04 at 16 04 42" src="https://github.com/stjepanstojcevic/OrderingApp/assets/48209720/175cdf46-dccc-4f41-bd01-8f7ddfe94dfd">

On this screen, an http get request is sent to retrieve the list of drinks and their prices. A scanned number representing the table number is displayed at the top. The user can select the quantity of a particular drink and by clicking the button at the bottom, move to the next screen.

<img width="349" alt="Screenshot 2024-03-04 at 16 03 23" src="https://github.com/stjepanstojcevic/OrderingApp/assets/48209720/9da3fd29-cca4-4a72-a617-dcc83e57e7d2">

This screen shows a list of selected drinks with the option to add comments for the current order. By clicking on the button at the bottom, an http post request is sent, which sends the table number, selected drinks (with quantity) and a comment to the API. As a result, we get the orderID that we need on the next screen.

<img width="349" alt="Screenshot 2024-03-04 at 16 04 04" src="https://github.com/stjepanstojcevic/OrderingApp/assets/48209720/1cb0f993-188c-44c0-812b-32edc99ae22e">

Every 5 seconds a http get request is sent to the API which gives the status of the current order.

<img width="878" alt="Screenshot 2024-03-04 at 16 04 17" src="https://github.com/stjepanstojcevic/OrderingApp/assets/48209720/8a9a4d78-20d9-42de-af09-999f359441c9">

