import 'package:flutter/material.dart';
import 'Blocs/signup_bloc.dart';
import 'screens/signup_screen.dart';

class BlocProvider extends InheritedWidget {
  final SignupBloc signupBloc;

  BlocProvider({Key? key, required Widget child})
      : signupBloc = SignupBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static SignupBloc of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<BlocProvider>();
    assert(provider != null, 'No BlocProvider found in context');
    return provider!.signupBloc;
  }
}

void main() {
  runApp(
    BlocProvider(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SignupScreen(),
    );
  }
}
