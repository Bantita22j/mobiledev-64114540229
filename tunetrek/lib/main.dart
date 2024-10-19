import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(MyApp());
}

class ConcertDiaryApp extends StatelessWidget {
  final String username; 
  final String userId; 

  
  ConcertDiaryApp({required this.username, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome $username'), 
      ),
      body: Center(
        child: Text('This is your concert diary page.'),
      ),
    );
  }
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Concert Diary',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.pink[50],
        fontFamily: 'Raleway',
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(), // Start at HomePage
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Concert Diary'),
        backgroundColor: Colors.pink[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Attending a concert of our favorite band is an experience filled with special memories. '
                'From the booming sound of the music to the dazzling lights and the thrill of being in the moment, '
                'surrounded by fellow fans, every part of it holds deep meaning.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center, 
              ),
              SizedBox(height: 20),
              Text(
                'This is what makes writing a concert diary such an exciting activity to try. '
                'It’s not just about recording memories, but also sharing those unforgettable impressions and preserving the emotions in the pages of our journal.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Text(
                'If you\'ve just been to a concert, don\'t wait! '
                'Grab a pen or your keyboard and start documenting that incredible experience today!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink[300],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[300], 
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}