import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pocketbase/pocketbase.dart';
import 'create.dart'; 
import 'update.dart'; // นำเข้าหน้า UpdatePage

final pb = PocketBase('http://127.0.0.1:8090'); // เปลี่ยน URL ตามที่ต้องการ

class HomeAdmin extends StatefulWidget {
  final String username;

  HomeAdmin({required this.username});

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  List<RecordModel> concertDetails = []; // เก็บหลายเรคคอร์ด
  bool isLoading = true; 
  bool hasError = false; 

  Future<void> fetchData() async {
    try {
      final records = await pb.collection('Concert_Details').getFullList();
      setState(() {
        concertDetails = records;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      print('Error fetching data: $e'); 
    }
  }

  // ฟังก์ชันสำหรับลบคอนเสิร์ต
  Future<void> deleteConcert(String recordId) async {
    try {
      await pb.collection('Concert_Details').delete(recordId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Concert deleted successfully')),
      );

      // ลบข้อมูลจากรายการที่แสดงในแอป
      setState(() {
        concertDetails.removeWhere((record) => record.id == recordId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete concert')),
      );
    }
  }

  // แสดง Dialog เพื่อยืนยันการลบข้อมูล
  void confirmDelete(BuildContext context, String recordId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this concert?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // ปิด dialog
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ปิด dialog
                deleteConcert(recordId); // เรียกฟังก์ชันลบ
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : hasError
                ? Center(child: Text('Failed to load data'))
                : ListView.builder(
                    itemCount: concertDetails.length, 
                    itemBuilder: (context, index) {
                      final concert = concertDetails[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          child: ListTile(
                            title: Text(concert.data['name'] ?? 'No name'), 
                            subtitle: Text(concert.data['detailsconcert'] ?? 'No details'),
                            leading: concert.data['profile'] != null
                                ? Image.network(
                                    'http://127.0.0.1:8090/api/files/${concert.collectionId}/${concert.id}/${concert.data['profile']}',
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.error);
                                    },
                                  )
                                : Icon(Icons.image_not_supported),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdatePage(
                                          pb: pb,
                                          recordId: concert.id,
                                          currentData: concert.data,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => confirmDelete(context, concert.id),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePage(pb: pb),
            ),
          );
        },
        child: Icon(Icons.add), 
      ),
    );
  }
}
