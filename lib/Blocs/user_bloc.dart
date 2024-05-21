import 'package:rxdart/rxdart.dart';
import '../models/user.dart';

class UserBloc {
  // Subject to handle the current user
  final _userSubject = BehaviorSubject<User?>();

  // Stream to expose the user
  Stream<User?> get userStream => _userSubject.stream;

  // Function to set the user
  void setUser(User user) {
    _userSubject.add(user);
  }

  // Function to clear the user
  void clearUser() {
    _userSubject.add(null);
  }

  // Dispose the subject
  void dispose() {
    _userSubject.close();
  }
}
