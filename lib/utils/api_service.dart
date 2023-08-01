import 'dart:convert';

import 'package:product_list/models/product_models.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  ApiService({required this.baseUrl});

  Future<ProductList> fetchProduct({int skip = 0, int limit = 10}) async {
    print('$baseUrl/products?skip=$skip&limit=$limit');
    final response =
        await http.get(Uri.parse('$baseUrl/products?skip=$skip&limit=$limit'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final productsData = jsonData['products'] as List<dynamic>;
      final products =
          productsData.map((json) => Product.fromJson(json)).toList();
      return ProductList(products: products, total: jsonData['total']);
    } else {
      throw Exception('Failed to load products');
    }
  }
}
