import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/restaurant.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailsScreen({Key? key, required this.restaurant}) : super(key: key);

  @override
  _RestaurantDetailsScreenState createState() => _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  late GoogleMapController mapController;
  LatLng? userLocation;
  late Future<void> _initFuture;
  double? distance;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initFuture = _initScreen();
  }

  Future<void> _initScreen() async {
    await _getCurrentLocation();
    distance = await calculateDistance(widget.restaurant.latitude, widget.restaurant.longitude);
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      userLocation = LatLng(position.latitude, position.longitude);
      _markers.add(Marker(
        markerId: const MarkerId('userLocation'),
        position: userLocation!,
        infoWindow: const InfoWindow(title: 'Your Location'),
      ));
      _markers.add(Marker(
        markerId: const MarkerId('restaurantLocation'),
        position: LatLng(widget.restaurant.latitude, widget.restaurant.longitude),
        infoWindow: InfoWindow(title: widget.restaurant.name),
      ));
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  Future<double> calculateDistance(double latitude, double longitude) async {
    try {
      Position userLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      double distanceInMeters = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        latitude,
        longitude,
      );
      return distanceInMeters;
    } catch (e) {
      print('Error calculating distance: $e');
      return 0.0;
    }
  }

  void launchDirections(double latitude, double longitude) async {
    try {
      Position userLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      Uri url = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=${userLocation.latitude},${userLocation.longitude}&destination=$latitude,$longitude');
      print('URL to launch: $url');

      bool canLaunchUrlFlag = await canLaunchUrl(url);
      print('Can launch URL: $canLaunchUrlFlag');

      if (canLaunchUrlFlag) {
        print('URL can be launched, launching now...');
        await launchUrl(url, mode: LaunchMode.externalApplication);
        print('URL launched successfully.');
      } else {
        print('Cannot launch URL: $url');
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching directions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.name),
      ),
      body: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      mapController = controller;
                      if (userLocation != null) {
                        mapController.animateCamera(
                          CameraUpdate.newLatLngBounds(
                            LatLngBounds(
                              northeast: LatLng(
                                widget.restaurant.latitude > userLocation!.latitude
                                    ? widget.restaurant.latitude
                                    : userLocation!.latitude,
                                widget.restaurant.longitude > userLocation!.longitude
                                    ? widget.restaurant.longitude
                                    : userLocation!.longitude,
                              ),
                              southwest: LatLng(
                                widget.restaurant.latitude < userLocation!.latitude
                                    ? widget.restaurant.latitude
                                    : userLocation!.latitude,
                                widget.restaurant.longitude < userLocation!.longitude
                                    ? widget.restaurant.longitude
                                    : userLocation!.longitude,
                              ),
                            ),
                            50.0,
                          ),
                        );
                      }
                    },
                    initialCameraPosition: userLocation != null
                        ? CameraPosition(
                            target: userLocation!,
                            zoom: 14.0,
                          )
                        : const CameraPosition(
                            target: LatLng(30.033333, 31.233334), // Default to Cairo coordinates
                            zoom: 14.0,
                          ),
                    markers: _markers,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Distance: ${distance?.toStringAsFixed(2)} meters'),
                ),
                ElevatedButton(
                  onPressed: () {
                    launchDirections(widget.restaurant.latitude, widget.restaurant.longitude);
                  },
                  child: const Text('Get Directions'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
