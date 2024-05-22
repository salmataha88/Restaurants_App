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
  late Future<double> _distance;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _distance = calculateDistance(widget.restaurant.latitude, widget.restaurant.longitude);
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
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
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.name),
      ),
      body: userLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: userLocation!,
                      zoom: 14.0,
                    ),
                    markers: _markers,
                  ),
                ),
                FutureBuilder<double>(
                  future: _distance,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Distance: ${snapshot.data?.toStringAsFixed(2)} meters'),
                      );
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    launchDirections(widget.restaurant.latitude, widget.restaurant.longitude);
                  },
                  child: const Text('Get Directions'),
                ),
              ],
            ),
    );
  }

  Future<double> calculateDistance(double latitude, double longitude) async {
    try {
      Position userLocation = await Geolocator.getCurrentPosition();
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
    Position userLocation = await Geolocator.getCurrentPosition();
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
}
