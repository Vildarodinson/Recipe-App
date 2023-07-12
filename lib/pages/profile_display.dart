import 'package:flutter/material.dart';
import 'package:recipe_app/widgets/profile_module.dart';

class ProfileDisplayPage extends StatelessWidget {
  final Profile profile;
  final String userId;

  const ProfileDisplayPage({required this.userId, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
        backgroundColor: Colors.yellow,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.yellow,
                  child: Icon(
                    Icons.account_circle,
                    size: 120,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Name: ${profile.name}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Email: ${profile.email}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Bio:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                profile.bio ?? 'No bio available',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Navigate back to the previous page
                },
                child: const Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow,
                  textStyle: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
