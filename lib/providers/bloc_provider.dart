import 'package:flutter/material.dart';

import '../blocs/signup_bloc.dart';

class BlocProvider extends InheritedWidget {
  final SignupBloc signupBloc;

  BlocProvider({Key? key, required Widget child})
      : signupBloc = SignupBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static SignupBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BlocProvider>()!.signupBloc;
  }
}