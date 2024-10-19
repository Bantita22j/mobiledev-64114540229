import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data'; // สำหรับจัดการกับข้อมูลไฟล์
import 'package:http/http.dart' as http;

class CreatePage extends StatefulWidget {
  final PocketBase pb; 

  CreatePage({required this.pb});

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String detailsconcert = '';
  String url = ''; 
  Uint8List? profileImage;  // เก็บไฟล์ภาพ
  String? profileImageName; // ชื่อไฟล์ภาพ
  bool isSubmitting = false; // ตรวจสอบว่ากำลังส่งข้อมูลอยู่หรือไม่

  Future<void> createConcert() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://127.0.0.1:8090/api/collections/Concert_Details/records'), // URL ของ PocketBase API
      );

      request.fields['name'] = name;
      request.fields['detailsconcert'] = detailsconcert;
      request.fields['url'] = url; // ส่งฟิลด์ URL ไปด้วย

      // ตรวจสอบว่ามีไฟล์ภาพถูกเลือกหรือไม่
      if (profileImage != null && profileImageName != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'profile', 
            profileImage!,
            filename: profileImageName,
          ),
        );
      }

      // ส่ง request ไปที่ PocketBase
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Concert added successfully!')),
        );
        Navigator.pop(context); // กลับไปยังหน้าหลัก
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add concert: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        profileImage = result.files.first.bytes;
        profileImageName = result.files.first.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Concert'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                TextFormField(
                  decoration: InputDecoration(labelText: 'Concert Name'),
                  onChanged: (value) => setState(() {
                    name = value;
                  }),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a concert name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

               
                TextFormField(
                  decoration: InputDecoration(labelText: 'Concert Details'),
                  onChanged: (value) => setState(() {
                    detailsconcert = value;
                  }),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter concert details';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Field สำหรับใส่ URL
                TextFormField(
                  decoration: InputDecoration(labelText: 'Concert URL'),
                  onChanged: (value) => setState(() {
                    url = value;
                  }),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the concert URL';
                    } else if (!Uri.parse(value).isAbsolute) {
                      return 'Please enter a valid URL';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                
                ElevatedButton(
                  onPressed: pickImage,
                  child: Text('Select Concert Image'),
                ),
                
                SizedBox(height: 16),

                
                profileImage != null
                    ? Column(
                        children: [
                          Text('Image Preview:'),
                          SizedBox(height: 10),
                          Image.memory(
                            profileImage!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ],
                      )
                    : Text('No image selected'),

                SizedBox(height: 32),

                
                isSubmitting
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: createConcert,
                        child: Text('Add Concert'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
