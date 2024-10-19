import 'package:flutter/material.dart';
// ignore: unused_import
import 'auth_service.dart'; // นำเข้าไฟล์ที่มีฟังก์ชัน register

class RegisterPage extends StatefulWidget {
  
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool isValidUsername(String username) {
    // กำหนดเงื่อนไขที่เหมาะสมสำหรับ username ที่คุณต้องการ
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,}$');
    return usernameRegex.hasMatch(username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // ตรวจสอบข้อมูลก่อนการสมัคร
                if (!isValidEmail(_emailController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid email address.')),
                  );
                  return;
                }

                if (!isValidUsername(_usernameController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid username.')),
                  );
                  return;
                }

                // เรียกใช้ฟังก์ชัน register จาก auth_service.dart
                try {
                  await register(
                    _usernameController.text,
                    _emailController.text,
                    _passwordController.text,
                  );

                  // แสดงข้อความเมื่อสมัครสำเร็จ
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Register successful')),
                  );

                  // นำผู้ใช้กลับไปยังหน้า LoginPage หลังจากสมัครสำเร็จ
                  Navigator.pop(context);
                } catch (e) {
                  // แสดงข้อความเมื่อสมัครไม่สำเร็จ
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to Register: $e')),
                  );
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}