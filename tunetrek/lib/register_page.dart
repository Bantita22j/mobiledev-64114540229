import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final pb = PocketBase('http://127.0.0.1:8090/');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

Future<void> register(String email, String password) async {
  try {
    final body = {
      'email': email,
      'password': password,
      'passwordConfirm': password,
      'username': email.split('@')[0], // กำหนด username จากส่วนหน้าอีเมล
    };
    await pb.collection('users').create(body: body); // ส่งข้อมูลผ่าน named argument 'body'
    print('Registration successful');
    // ทำงานเมื่อสมัครเสร็จเรียบร้อย
    Navigator.pop(context); // กลับไปยังหน้า login หลังสมัครเสร็จ
  } catch (e) {
    print('Registration failed: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_passwordController.text == _confirmPasswordController.text) {
                  register(_emailController.text, _passwordController.text);
                } else {
                  print('Passwords do not match');
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}