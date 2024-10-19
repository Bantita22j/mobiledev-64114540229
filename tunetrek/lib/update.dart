import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data'; 
import 'package:http/http.dart' as http;

class UpdatePage extends StatefulWidget {
  final PocketBase pb;
  final String recordId;
  final Map<String, dynamic> currentData; // ข้อมูลปัจจุบัน

  UpdatePage({required this.pb, required this.recordId, required this.currentData});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String detailsconcert;
  late String url;
  Uint8List? profileImage;  
  String? profileImageName; 
  bool isSubmitting = false; 

  @override
  void initState() {
    super.initState();
    // ตั้งค่าเริ่มต้นสำหรับข้อมูลปัจจุบัน
    name = widget.currentData['name'] ?? '';
    detailsconcert = widget.currentData['detailsconcert'] ?? '';
    url = widget.currentData['url'] ?? '';
  }

  Future<void> updateConcert() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      var request = http.MultipartRequest(
        'PATCH', // ใช้ PATCH สำหรับการอัปเดต
        Uri.parse('http://127.0.0.1:8090/api/collections/Concert_Details/records/${widget.recordId}'), 
      );

      request.fields['name'] = name;
      request.fields['detailsconcert'] = detailsconcert;
      request.fields['url'] = url;

      if (profileImage != null && profileImageName != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'profile', 
            profileImage!,
            filename: profileImageName,
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Concert updated successfully!')),
        );
        Navigator.pop(context); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update concert: ${response.body}')),
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
        title: Text('Update Concert'),
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
                  initialValue: name,
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
                  initialValue: detailsconcert,
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

                TextFormField(
                  initialValue: url,
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
                        onPressed: updateConcert,
                        child: Text('Update Concert'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
