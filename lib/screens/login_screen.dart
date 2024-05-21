import 'package:flutter/material.dart';
import 'package:restaurant_app/screens/home_screen.dart';
import '../services/user_services.dart';
import '../Blocs/login_bloc.dart';
import '../providers/user_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginBloc = LoginBloc();
    final userBloc = UserProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            StreamBuilder<String>(
              stream: loginBloc.email,
              builder: (context, snapshot) {
                return TextField(
                  onChanged: loginBloc.changeEmail,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: snapshot.error?.toString(),
                  ),
                );
              },
            ),
            StreamBuilder<String>(
              stream: loginBloc.password,
              builder: (context, snapshot) {
                return TextField(
                  onChanged: loginBloc.changePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: snapshot.error?.toString(),
                  ),
                  obscureText: true,
                );
              },
            ),
            const SizedBox(height: 20),
            StreamBuilder<bool>(
              stream: loginBloc.submitValid,
              builder: (context, snapshot) {
                return ElevatedButton(
                  onPressed: snapshot.hasData
                      ? () async {
                          final email = await loginBloc.email.first;
                          final password = await loginBloc.password.first;

                          if (email.isNotEmpty && password.isNotEmpty) {
                            try {
                              UserApiProvider userapiProvider = UserApiProvider();
                              final responseUser = await userapiProvider.login(email, password);
                              print('Login successful: $responseUser');
                              userBloc.setUser(responseUser);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Login successful!')),
                              );
                              // Navigate to another screen or perform another action
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const HomeScreen()),
                              );

                            } catch (error) {
                              print('Login error: $error');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to login: $error')),
                              );
                            }
                          }
                        }
                      : null,
                  child: const Text('Login'),
                );
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text('Don\'t have an account? Signup here'),
            ),
          ],
        ),
      ),
    );
  }
}
