import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:product_list/models/product_models.dart';
import 'package:product_list/utils/api_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ApiService apiService = ApiService(baseUrl: 'https://dummyjson.com');

  List<Product> products = [];
  int currentPage = 1;
  int limit = 15;
  bool isLoading = false;
  int totalRecord = 0;

  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_scrollListener);
    _fetchProduct();
    super.initState();
  }

  void _scrollListener() {
    if (totalRecord == products.length) return;
    // ignore: avoid_print
    print(_scrollController.position.extentAfter);
    if (_scrollController.position.extentAfter <= 0 && isLoading == false) {
      _fetchProduct();
    }
  }

  Future<void> _fetchProduct() async {
    try {
      // ignore: avoid_print
      int skip = (currentPage - 1) * limit;
      final productList = await apiService.fetchProduct(skip: skip, limit: 20);

      print(productList.products[0].title);
      setState(() {
        products.addAll(productList.products);
        currentPage++;
        isLoading = false;
        totalRecord = productList.total;
      });
      // ignore: avoid_print
      print(products.length);
    } catch (error) {
      // ignore: avoid_print
      print(error);
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onProductTap(Product product) {
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => ProductDetailsScreen(product: product)));
    Navigator.pushNamed(context, '/details', arguments: product);
    // ignore: avoid_print
    print(product.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Catalogue"),
      ),
      body: ListView.builder(
          itemCount: products.length,
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            if (index < products.length) {
              final product = products[index];
              return ListTile(
                leading: SizedBox(
                  width: 100,
                  child: CachedNetworkImage(
                    imageUrl: product.thumbnail,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                title: Text(product.title),
                subtitle: Text(product.description),
                onTap: () => _onProductTap(product),
              );
            } else if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const SizedBox();
            }
          }),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }
}
