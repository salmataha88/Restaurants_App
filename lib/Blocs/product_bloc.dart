import 'package:rxdart/rxdart.dart';
import '../models/product.dart';
import '../services/product_services.dart';

class ProductBloc {
  final ProductApiProvider _productApiProvider = ProductApiProvider();
  final _products = BehaviorSubject<List<Product>>();
  final _searchedproducts = BehaviorSubject<List<Product>>();

  Stream<List<Product>> get products => _products.stream;
  Stream<List<Product>> get searchedProducts => _searchedproducts.stream;

  void fetchProductsRestaurant(String restaurantId) async {
    try {
      List<Product> productList = await _productApiProvider.fetchProductsForRestaurant(restaurantId);
      _products.sink.add(productList);
    } catch (error) {
      _products.sink.addError('Failed to fetch products: $error');
    }
  }

  void searchProducts(String productName) async {
    try {
      final products = await _productApiProvider.searchProducts(productName);
      _searchedproducts.sink.add(products);
    } catch (error) {
      _searchedproducts.addError(error);
    }
  }


  void dispose() {
    _products.close();
    _searchedproducts.close();
  }
}
