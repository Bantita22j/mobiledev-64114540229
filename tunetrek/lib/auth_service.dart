import 'package:pocketbase/pocketbase.dart';


final pb = PocketBase('http://127.0.0.1:8090');

// คลาส User เพื่อเก็บข้อมูลผู้ใช้
class User {
  final String id; 
  final String username;
  final String email;
  final bool isAdmin;

  User({
    required this.id, 
    required this.username,
    required this.email,
    this.isAdmin = false,
  });
}


Future<User> login(String email, String password) async {
  try {
    
    try {
      final authData = await pb.collection('users').authWithPassword(email, password);
      
      final user = User(
        id: authData.record!.id, 
        username: authData.record?.data['username'] ?? 'Unknown',
        email: email,
        isAdmin: false, 
      );

      print('Login successful');
      print('Token: ${authData.token}');
      return user;
    } catch (e) {
      print('User login failed, trying admin login...');
      
      
      final authData = await pb.admins.authWithPassword(email, password);
      final user = User(
        id: "admin", 
        username: "Admin",
        email: email,
        isAdmin: true, // กำหนดว่าเป็น admin
      );

      print('Admin login successful');
      print('Token: ${authData.token}');
      return user;
    }
  } catch (e) {
    print('Login failed: $e');
    throw Exception('Login failed');
  }
}


Future<void> register(String username, String email, String password) async {
  try {
   
    final newUser = {
      'username': username,
      'email': email,
      'password': password,
      'passwordConfirm': password,
    };

    // ส่งคำขอไปยัง PocketBase เพื่อสร้างผู้ใช้ใหม่
    final response = await pb.collection('users').create(body: newUser);

    print('User registered successfully: ${response.data}');
  } catch (e) {
    print('Failed to Register: $e');
    throw Exception('Registration failed');
  }
}