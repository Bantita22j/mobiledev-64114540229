import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class WriteConcertDiaryPage extends StatefulWidget {
  final PocketBase pb;

  WriteConcertDiaryPage({required this.pb, required String userId});

  @override
  _WriteConcertDiaryPageState createState() => _WriteConcertDiaryPageState();
}

class _WriteConcertDiaryPageState extends State<WriteConcertDiaryPage> {
  final _formKey = GlobalKey<FormState>();
  String concertName = '';
  String concertDetails = '';
  String imageUrl = '';

  // ฟังก์ชันบันทึกไดอารี่
  Future<void> saveDiary() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // แสดงข้อมูลที่ส่งไปยัง PocketBase ใน console
        print('Saving diary with:');
        print('Name: $concertName');
        print('Details: $concertDetails');
        print('Image URL: $imageUrl');

        // เรียกใช้ API บันทึกข้อมูล
        final response = await widget.pb.collection('Concert_Details').create(
          body: {
            'name': concertName,
            'detailsconcert': concertDetails,
            'officialaccount': imageUrl,
          },
        );

        // แสดงข้อมูล response จาก PocketBase
        print('Response from PocketBase: $response');

        // แสดง SnackBar เมื่อบันทึกสำเร็จ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('บันทึกไดอารี่สำเร็จ')),
        );

        // กลับไปหน้าแรกหรือทำงานอื่นต่อ
        Navigator.pop(context);
      } catch (e) {
        // แสดงข้อผิดพลาดที่เกิดขึ้น
        print('Error saving diary: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึกไดอารี่: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เขียนไดอารี่คอนเสิร์ต'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'ชื่อคอนเสิร์ต'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อคอนเสิร์ต';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    concertName = value!;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'รายละเอียดเกี่ยวกับคอนเสิร์ต'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรายละเอียด';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    concertDetails = value!;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'ลิงก์รูปภาพ (URL)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาใส่ URL ของรูปภาพ';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    imageUrl = value!;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: saveDiary,
                  child: Text('บันทึกไดอารี่'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
