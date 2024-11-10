import 'package:flutter/material.dart';
import 'package:restaurant_app/providers/product_provider.dart';
import 'package:restaurant_app/screens/restaurantsProduct_screen.dart';
import 'package:restaurant_app/screens/products_screen.dart';
import 'package:restaurant_app/screens/restaurants_screen.dart';
import 'package:restaurant_app/screens/search_screen.dart';
import 'providers/bloc_provider.dart';
import 'providers/restaurant_provider.dart';
import 'providers/user_provider.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';


void main() {
  runApp(
    UserProvider(
      child: BlocProvider(
        child: RestaurantProvider(
          child: ProductProvider(
            child: const MyApp(),
          ),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      routes: {
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
        '/restaurants': (context) => const RestaurantScreen(),
        '/products': (context) => const ProductsScreen(),
        '/search': (context) => const SearchScreen(),
        '/restaurantsproducts': (context) => const RestaurantsProductScreen(),
        '/logout': (context) => const LoginScreen(),

      },
    );
  }
}
