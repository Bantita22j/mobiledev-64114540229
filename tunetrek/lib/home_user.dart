import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart'; // นำเข้า PocketBase
import 'package:tunetrek/login.dart';

class HomeUser extends StatelessWidget {
  final String username;
  final String userId; // เพิ่ม userId
  final PocketBase pb = PocketBase('http://127.0.0.1:8090'); // ประกาศตัวแปร pb

  HomeUser({required this.username, required this.userId}); // เพิ่มการรับ userId

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $username'), // แสดงชื่อผู้ใช้
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            // ล้างข้อมูลผู้ใช้และนำกลับไปที่หน้า Login
            pb.authStore.clear();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ),
      body: ConcertDiaryPage(), // เรียกใช้ ConcertDiaryPage
    );
  }
}

class ConcertDiaryPage extends StatelessWidget {
  final List<Map<String, String>> concertEntries = [
    {
      'title': 'ENHYPEN',
      'image': 'https://i.scdn.co/image/ab676161000051748665a74333bb3ca3fde5c06a',
    },
    {
      'title': 'TREASURE',
      'image': 'https://cdn.readawrite.com/articles/9171/9170879/thumbnail/large.gif?1',
    },
    {
      'title': 'RIIZE',
      'image': 'https://cdn.antaranews.com/cache/1200x800/2023/10/24/F9IgG4ybAAA3Oia.jpeg',
    },
    {
      'title': 'NCT DREAM',
      'image': 'https://i0.wp.com/www.korseries.com/wp-content/uploads/2021/07/NCT-DREAM-Hello-Future-scaled.jpg?resize=750%2C1019&ssl=1',
    },
    {
      'title': 'AESPA',
      'image': 'https://static.thairath.co.th/media/Dtbezn3nNUxytg04avc5gHUp5jfCxk6Y1IL0VraHnDTZKz.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 5 : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: concertEntries.length,
        itemBuilder: (context, index) {
          final concert = concertEntries[index];
          return Card(
            elevation: 3,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    concert['image'] ?? '',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.width > 600 ? 220 : 120,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 14,
                        color: Colors.grey,
                        child: Center(
                          child: Text(
                            'Image not available',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        concert['title'] ?? '',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width > 600 ? 16 : 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[300],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
