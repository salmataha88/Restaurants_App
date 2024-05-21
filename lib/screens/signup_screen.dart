import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/user.dart';
import '../providers/bloc_provider.dart';
import '../services/user_services.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);


  Future<String> _location() async {
    // Check if location permissions are granted
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Request location permissions
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied.');
    } else if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    // Get user's current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    String location = '${position.latitude}, ${position.longitude}';
    return location;
  }


  @override
  Widget build(BuildContext context) {
    final signupBloc = BlocProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            StreamBuilder<String>(
              stream: signupBloc.name,
              builder: (context, snapshot) {
                return TextField(
                  onChanged: signupBloc.changeName,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    errorText: snapshot.error?.toString(),
                  ),
                );
              },
            ),
            StreamBuilder<String>(
              stream: signupBloc.email,
              builder: (context, snapshot) {
                return TextField(
                  onChanged: signupBloc.changeEmail,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: snapshot.error?.toString(),
                  ),
                );
              },
            ),
            StreamBuilder<String>(
              stream: signupBloc.password,
              builder: (context, snapshot) {
                return TextField(
                  onChanged: signupBloc.changePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: snapshot.error?.toString(),
                  ),
                  obscureText: true,
                );
              },
            ),
            StreamBuilder<String>(
              stream: signupBloc.confirmPassword,
              builder: (context, snapshot) {
                return TextField(
                  onChanged: signupBloc.changeConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    errorText: snapshot.error?.toString(),
                  ),
                  obscureText: true,
                );
              },
            ),
            StreamBuilder<String>(
              stream: signupBloc.gender,
              builder: (context, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text('Gender', style: Theme.of(context).textTheme.titleMedium),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Male',
                          groupValue: snapshot.data,
                          onChanged: (value) => signupBloc.changeGender!(value!),
                        ),
                        const Text('Male'),
                        Radio<String>(
                          value: 'Female',
                          groupValue: snapshot.data,
                          onChanged: (value) => signupBloc.changeGender!(value!),
                        ),
                        const Text('Female'),
                      ],
                    ),
                  ],
                );
              },
            ),
            StreamBuilder<int>(
              stream: signupBloc.level,
              builder: (context, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text('Level', style: Theme.of(context).textTheme.titleMedium),
                    DropdownButton<int>(
                      value: snapshot.data,
                      onChanged: (value) => signupBloc.changeLevel!(value!),
                      items: const [
                        DropdownMenuItem<int>(
                          value: 1,
                          child: Text('1'),
                        ),
                        DropdownMenuItem<int>(
                          value: 2,
                          child: Text('2'),
                        ),
                        DropdownMenuItem<int>(
                          value: 3,
                          child: Text('3'),
                        ),
                        DropdownMenuItem<int>(
                          value: 4,
                          child: Text('4'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final name = await signupBloc.name.first;
                final email = await signupBloc.email.first;
                final password = await signupBloc.password.first;
                final confirmPassword = await signupBloc.confirmPassword.first;
                final gender = await signupBloc.gender.first;
                final level = await signupBloc.level.first;
                final location = await _location();

                if (name.isNotEmpty &&
                    email.isNotEmpty &&
                    password.isNotEmpty &&
                    confirmPassword.isNotEmpty &&
                    location.isNotEmpty) {
                  if (password == confirmPassword) {
                    final user = User(
                      name: name,
                      email: email,
                      password: password,
                      confirmPassword: confirmPassword,
                      gender: gender,
                      level: level,
                      latitude: double.parse(location.split(',')[0]), // Extract latitude from location string
                      longitude: double.parse(location.split(',')[1]), 
                      
                    );
                    try {
                      final userapiProvider = UserApiProvider();
                      final responseUser = await userapiProvider.signup(user);
                      print('Signup successful: $responseUser');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Signup successful!')),
                      );
                    } catch (error) {
                      print('Signup error===: $error');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Signup failed====: $error')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match')),
                    );
                  }
                }else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields and enable location services')),
                  );
                }               
              },
              child: const Text('Signup'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Already have an account? Login here'),
            ),
          ],
        ),
      ),
    );
  }
}
