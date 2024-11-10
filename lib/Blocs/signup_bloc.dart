import 'dart:async';
import 'package:rxdart/rxdart.dart';

class SignupBloc {
  final _nameController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _confirmPasswordController = BehaviorSubject<String>();
  final _genderController = BehaviorSubject<String>();
  final _levelController = BehaviorSubject<int>();

  // Add data to stream
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeConfirmPassword => _confirmPasswordController.sink.add;
  void Function(String)? get changeGender => _genderController.sink.add;
  void Function(int)? get changeLevel => _levelController.sink.add;

  // Retrieve data from stream
  Stream<String> get name => _nameController.stream.transform(validateName);
  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get password => _passwordController.stream.transform(validatePassword);
  Stream<String> get confirmPassword => _confirmPasswordController.stream.transform(validateConfirmPassword);
  Stream<String> get gender => _genderController.stream;
  Stream<int> get level => _levelController.stream;

  // Validators
  final validateName = StreamTransformer<String, String>.fromHandlers(
      handleData: (name, sink) {
    if (name.isNotEmpty) {
      sink.add(name);
    } else {
      sink.addError('Name is required');
    }
  });

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

  final validateConfirmPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (confirmPassword, sink) {
    if (confirmPassword.length > 7) {
      sink.add(confirmPassword);
    } else {
      sink.addError('Confirm Password must be at least 8 characters');
    }
  });

  dispose() {
    _nameController.close();
    _emailController.close();
    _passwordController.close();
    _confirmPasswordController.close();
    _genderController.close();
    _levelController.close();
  }
}
