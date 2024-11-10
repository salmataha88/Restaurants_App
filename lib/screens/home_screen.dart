import 'package:flutter/material.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userBloc = UserProvider.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: StreamBuilder<User?>(
        stream: userBloc.userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data != null) {
            return Center(child: Text('Welcome, ${snapshot.data!.name}'));
          } else {
            return const Center(child: Text('User not logged in'));
          }
        },
      ),
    );
  }
}
