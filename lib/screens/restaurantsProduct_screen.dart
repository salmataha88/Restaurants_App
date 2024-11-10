import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurant_app/providers/restaurant_provider.dart';
import '../models/restaurant.dart';
import 'restaurantDetails_screen.dart';

class RestaurantsProductScreen extends StatefulWidget {
  const RestaurantsProductScreen({Key? key}) : super(key: key);

  @override
  _RestaurantsProductScreenState createState() => _RestaurantsProductScreenState();
}

class _RestaurantsProductScreenState extends State<RestaurantsProductScreen> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  bool _isMapView = false;

  @override
  Widget build(BuildContext context) {
    final restaurantBloc = RestaurantProvider.of(context);
    final productName = ModalRoute.of(context)!.settings.arguments as String;

    restaurantBloc.fetchRestaurantsByProduct(productName);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Restaurants',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 15, 119, 203),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 15, 119, 203),
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          DropdownButton<bool>(
            value: _isMapView,
            items: [
              DropdownMenuItem(
                value: false,
                child: Text('List View'),
              ),
              DropdownMenuItem(
                value: true,
                child: Text('Map View'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _isMapView = value!;
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<List<Restaurant>>(
          stream: restaurantBloc.restaurantsProduct,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No restaurants found'));
            }

            final restaurants = snapshot.data!;
            _markers = restaurants.map((restaurant) {
              return Marker(
                markerId: MarkerId(restaurant.name),
                position: LatLng(restaurant.latitude, restaurant.longitude),
                infoWindow: InfoWindow(
                  title: restaurant.name,
                  snippet: restaurant.address,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantDetailsScreen(restaurant: restaurant),
                      ),
                    );
                  },
                ),
              );
            }).toSet();

            if (_isMapView) {
              return GoogleMap(
                onMapCreated: (controller) {
                  _mapController = controller;
                  if (restaurants.isNotEmpty) {
                    // Move camera to the first restaurant
                    _mapController.animateCamera(
                      CameraUpdate.newLatLngBounds(
                        _calculateBounds(restaurants),
                        50.0, // Padding around the bounds
                      ),
                    );
                  }
                },
                initialCameraPosition: const CameraPosition(
                  target: LatLng(30.033333, 31.233334), // Default to Cairo coordinates
                  zoom: 12.0,
                ),
                markers: _markers,
              );
            } else {
              return ListView.builder(
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurants[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantDetailsScreen(restaurant: restaurant),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurant.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            restaurant.address,
                            style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 74, 74, 74)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  LatLngBounds _calculateBounds(List<Restaurant> restaurants) {
    double x0 = restaurants.first.latitude;
    double x1 = restaurants.first.latitude;
    double y0 = restaurants.first.longitude;
    double y1 = restaurants.first.longitude;

    for (var restaurant in restaurants) {
      if (restaurant.latitude > x1) x1 = restaurant.latitude;
      if (restaurant.latitude < x0) x0 = restaurant.latitude;
      if (restaurant.longitude > y1) y1 = restaurant.longitude;
      if (restaurant.longitude < y0) y0 = restaurant.longitude;
    }

    return LatLngBounds(
      northeast: LatLng(x1, y1),
      southwest: LatLng(x0, y0),
    );
  }
}
