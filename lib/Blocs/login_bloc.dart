import 'dart:async';
import 'package:rxdart/rxdart.dart';

class LoginBloc {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Add data to stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // Retrieve data from stream
  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get password => _passwordController.stream.transform(validatePassword);

  // Combined stream for enabling login button
  Stream<bool> get submitValid => Rx.combineLatest2(email, password, (e, p) => true);

  // Validators
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
      handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError('Enter a valid email');
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 7) {
      sink.add(password);
    } else {
      sink.addError('Password must be at least 8 characters');
    }
  });

  // Dispose
  dispose() {
    _emailController.close();
    _passwordController.close();
  }
}
