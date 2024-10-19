// lib/blog_detail_page.dart
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class BlogDetailPage extends StatelessWidget {
  final RecordModel concert; 

  BlogDetailPage({required this.concert});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(concert.data['name'] ?? 'Blog Details'), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            Text(
              concert.data['name'] ?? 'No title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
         
            Text(
              concert.data['detailsconcert'] ?? 'No details available',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
