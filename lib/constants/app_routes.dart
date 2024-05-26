

import '../screens/home_screen/printig_screen/printing_screen.dart';
import '../screens/home_screen/settings/bluetooth_printer_setup_screen.dart';
import '../screens/home_screen/settings/printer_settings_screen.dart';
import '../screens/home_screen/settings/settings_screen.dart';



const String invoicePrintingScreen = "/invoicePrintingScreen";
const String settingsScreen = "/settingsScreen";
const String printerSettingsScreen = "/printerSettingsScreen";
const String bluetoothPrinterScreen = "/bluetoothPrinterScreen";



final routes = {

  settingsScreen: (context) => const SettingsScreen(),
  invoicePrintingScreen: (context) => const InvoicePrintingScreen(),
  printerSettingsScreen: (context) => const PrinterSettingsScreen(),
  bluetoothPrinterScreen: (context) =>  const BluetoothPrinterScreen(),

};
