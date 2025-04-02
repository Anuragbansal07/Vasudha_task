import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'new_post_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _posts = [];

  void _addNewPost(File image) {
    setState(() {
      _posts.insert(0, {"image": image, "timestamp": DateTime.now()});
    });
  }

  String _timeAgo(DateTime postTime) {
    Duration difference = DateTime.now().difference(postTime);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} sec ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
    } else {
      return DateFormat('MMM d, yyyy').format(postTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: _posts.isEmpty
          ? Center(child: Text("No posts yet!"))
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                return _buildPostCard(_posts[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newImage = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPostScreen()),
          );

          if (newImage != null) {
            _addNewPost(newImage);
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    File image = post["image"];
    DateTime timestamp = post["timestamp"];

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage("assets/profile.jpg"),
            ),
            title: Text("John Karter",
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(_timeAgo(timestamp)), // Show dynamic time
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              image,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.favorite_border, color: Colors.grey),
                SizedBox(width: 10),
                Icon(Icons.comment, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
