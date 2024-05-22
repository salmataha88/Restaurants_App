import 'package:rxdart/rxdart.dart';
import '../models/restaurant.dart';
import '../services/restaurant_services.dart';

class RestaurantBloc {
  final RestaurantApiProvider _restaurantapiProvider = RestaurantApiProvider();
  final _restaurants = BehaviorSubject<List<Restaurant>>();
  final _restaurantsProduct = BehaviorSubject<List<Restaurant>>();

  Stream<List<Restaurant>> get restaurants => _restaurants.stream;
  Stream<List<Restaurant>> get restaurantsProduct => _restaurantsProduct.stream;

  void fetchRestaurants() async {
    try {
      List<Restaurant> restaurantList = await _restaurantapiProvider.fetchRestaurants();
      _restaurants.sink.add(restaurantList);
    } catch (error) {
      _restaurants.sink.addError('Failed to fetch restaurants: $error');
    }
  }

  void fetchRestaurantsByProduct(String productName) async {
    try {
      final restaurants = await _restaurantapiProvider.getRestaurantsByProduct(productName);
      _restaurantsProduct.sink.add(restaurants);
    } catch (error) {
      _restaurantsProduct.addError(error);
    }
  }

  void dispose() {
    _restaurants.close();
    _restaurantsProduct.close();
  }
}
