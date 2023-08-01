import 'package:flutter/material.dart';
import 'package:product_list/models/product_models.dart';
import 'package:product_list/screens/product_details_screen.dart';
import 'package:product_list/screens/product_list_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: ProductListScreen(),
      initialRoute: '/',
      routes: {
        '/': (context) => const ProductListScreen(),
        '/details': (context) => ProductDetailsScreen(
            product: ModalRoute.of(context)!.settings.arguments as Product),
      },
    );
  }
}
