import 'package:flutter/material.dart';
import '../blocs/restaurant_bloc.dart';

class RestaurantProvider extends InheritedWidget {
  final RestaurantBloc restaurantBloc;

  RestaurantProvider({Key? key, required Widget child})
      : restaurantBloc = RestaurantBloc(),
        super(key: key, child: child);

  static RestaurantBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RestaurantProvider>()!.restaurantBloc;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
