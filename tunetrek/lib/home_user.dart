import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart'; 
import 'package:tunetrek/login.dart';
import 'package:tunetrek/blog_detail_page.dart';  // นำเข้าหน้ารายละเอียดบล็อก
import 'package:tunetrek/write_concert_diary.dart';  // นำเข้าหน้าเขียนไดอารี่

class HomeUser extends StatelessWidget {
  final String username;
  final String userId; 
  final PocketBase pb = PocketBase('http://127.0.0.1:8090'); 

  HomeUser({required this.username, required this.userId}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $username'), 
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
           
            pb.authStore.clear();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ),
      body: ConcertDiaryPage(pb: pb), // ส่ง PocketBase instance ไปยัง ConcertDiaryPage
      
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WriteConcertDiaryPage(pb: pb, userId: userId),
            ),
          );
        },
        child: Icon(Icons.add), 
      ),
    );
  }
}

class ConcertDiaryPage extends StatefulWidget {
  final PocketBase pb; 

  ConcertDiaryPage({required this.pb});

  @override
  _ConcertDiaryPageState createState() => _ConcertDiaryPageState();
}

class _ConcertDiaryPageState extends State<ConcertDiaryPage> {
  List<RecordModel> concertEntries = []; // เก็บข้อมูลบล็อกที่ดึงจาก PocketBase
  bool isLoading = true;
  bool hasError = false;

  Future<void> fetchConcertData() async {
    try {
      // ดึงข้อมูลจาก PocketBase
      final records = await widget.pb.collection('Concert_Details').getFullList();
      setState(() {
        concertEntries = records; // เก็บข้อมูลบล็อกใน state
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchConcertData(); // เรียกฟังก์ชัน fetchConcertData เมื่อเริ่มต้นหน้าจอ
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator()); // แสดง loading เมื่อข้อมูลยังไม่โหลดเสร็จ
    }

    if (hasError) {
      return Center(child: Text('Failed to load concert data')); // แสดง error message เมื่อโหลดข้อมูลล้มเหลว
    }

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
          return GestureDetector(
            onTap: () {
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlogDetailPage(concert: concert),  
                ),
              );
            },
            child: Card(
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
                      // แสดงภาพบล็อกจากฟิลด์ profile
                      'http://127.0.0.1:8090/api/files/${concert.collectionId}/${concert.id}/${concert.data['profile']}',
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
                    child: GestureDetector(
                      onTap: () {
                        // เมื่อผู้ใช้คลิกที่ชื่อบล็อก นำไปยังหน้ารายละเอียดบล็อก
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlogDetailPage(concert: concert),
                          ),
                        );
                      },
                      child: Text(
                        concert.data['name'] ?? '', // แสดงชื่อบล็อกจาก PocketBase
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width > 600 ? 16 : 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[300],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
