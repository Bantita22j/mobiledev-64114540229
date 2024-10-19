import 'package:flutter/material.dart';

class MemberPage extends StatelessWidget {
  final String username;

  MemberPage({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Center(
        child: Text('Welcome Admin $username!'),
      ),
    );
  }
}
