class ConcertEntry {
  final String id;
  final String title;
  final String date;
  final String location;
  final String description;

  ConcertEntry({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.description,
  });

  // ฟังก์ชันสำหรับแปลง JSON จาก PocketBase เป็น ConcertEntry
  factory ConcertEntry.fromJson(Map<String, dynamic> json) {
    return ConcertEntry(
      id: json['id'],
      title: json['title'],
      date: json['date'],
      location: json['location'],
      description: json['description'],
    );
  }

  // ฟังก์ชันสำหรับแปลง ConcertEntry เป็น JSON สำหรับส่งไปที่ PocketBase
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'location': location,
      'description': description,
    };
  }
}
