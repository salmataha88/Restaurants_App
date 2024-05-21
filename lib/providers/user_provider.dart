import 'package:flutter/material.dart';
import '../blocs/user_bloc.dart';


class UserProvider extends InheritedWidget {
  final UserBloc userBloc;

  UserProvider({Key? key, required Widget child})
      : userBloc = UserBloc(),
        super(key: key, child: child);

  static UserBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserProvider>()!.userBloc;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
