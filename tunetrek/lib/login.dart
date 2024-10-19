import 'package:flutter/material.dart';
//import 'package:pocketbase/pocketbase.dart';
import 'home_user.dart'; // Import หน้า main_page สำหรับผู้ใช้ทั่วไป
import 'home_dmin.dart'; // Import หน้า MemberPage สำหรับแอดมิน
import 'auth_service.dart'; //ฟังก์ชั่น login
import 'package:tunetrek/register_page.dart';
import 'package:tunetrek/register.dart' as register;


class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                // เรียกใช้ฟังก์ชัน login จาก auth_service.dart
                try {
                  final user = await login(
                    _emailController.text,
                    _passwordController.text,
                  );

                  // แสดงข้อความเมื่อเข้าสู่ระบบสำเร็จ
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login successful')),
                  );

                  // ตรวจสอบประเภทของผู้ใช้
                  if (user.isAdmin) {
                    // ถ้าเป็น admin นำไปยังหน้า HomeAdmin
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MemberPage(username: user.username),
                      ),
                    );
                  } else {
                    // ถ้าเป็น user ธรรมดา นำไปยังหน้า HomeUser
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeUser(
                          username: user.username,
                          userId: user.id, // ส่งค่า userId ไปด้วย
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  // แสดงข้อความเมื่อเข้าสู่ระบบไม่สำเร็จ
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed: $e')),
                  );
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // นำไปยังหน้า RegisterPage เมื่อผู้ใช้กดปุ่มสมัครสมาชิก
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => register.RegisterPage()),
                );
              },
              child: const Text('Don\'t have an account? Register here'),
            ),
          ],
        ),
      ),
    );
  }
}
