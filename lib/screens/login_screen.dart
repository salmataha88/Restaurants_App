import 'package:flutter/material.dart';
import '../helper/show_snackBar.dart';
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(bottom: 80),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 21, 132, 224),
                    ),
                  ),
                ),
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
                const SizedBox(height: 10),
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
                const SizedBox(height: 30),
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
                                  showSnackBar(context, 'Login successful!');

                                  // Navigate to another screen or perform another action
                                  Navigator.pushNamed(context, '/restaurants');

                                } catch (error) {
                                  print('Login error: $error');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed to login: $error')),
                                  );
                                }
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Set the background color to blue
                        ),
                        child: const Text(
                        'Login',
                        style: TextStyle(fontWeight: FontWeight.bold,color:Color.fromARGB(255, 15, 119, 203)), // Set the text color to white
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text(
                    'Don\'t have an account? Signup here',
                    style: TextStyle(color:Color.fromARGB(255, 7, 83, 145)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
