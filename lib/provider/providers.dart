import 'package:untitled/provider/general_notifier.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'invoice_printing_screen.dart';

List<SingleChildWidget> providers = [...providersList];

//independent providers
List<SingleChildWidget> providersList = [
  ChangeNotifierProvider(create: (_) => InvoicePrintingNotifier()),
  ChangeNotifierProvider(create: (_) => GeneralNotifier()),
];