import 'package:flutter/material.dart';
import '../blocs/product_bloc.dart';

class ProductProvider extends InheritedWidget {
  final ProductBloc productBloc;

  ProductProvider({Key? key, required Widget child})
      : productBloc = ProductBloc(),
        super(key: key, child: child);

  static ProductBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ProductProvider>()!.productBloc;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
