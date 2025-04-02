import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  File? _selectedImage;
  Color _selectedFilter = Colors.transparent;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _applyFilter(Color color) {
    setState(() {
      _selectedFilter = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("New Post"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: _selectedImage != null
                    ? Stack(
                        children: [
                          Image.file(_selectedImage!, fit: BoxFit.cover),
                          Positioned.fill(
                            child: Container(
                              color: _selectedFilter.withOpacity(0.4),
                            ),
                          ),
                        ],
                      )
                    : Center(child: Text("No Image selected")),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _filterButton("Browse", Colors.transparent, true),
                _filterButton("Filter 1", Colors.purple),
                _filterButton("Filter 2", Colors.blue),
                _filterButton("Filter 3", Colors.indigo),
                _filterButton("Filter 4", Colors.green),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _selectedImage != null
                  ? () {
                      Navigator.pop(context, _selectedImage);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text("Post", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterButton(String label, Color color, [bool isBrowse = false]) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => isBrowse ? _pickImage() : _applyFilter(color),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: color,
            child: isBrowse ? Icon(Icons.image, color: Colors.white) : null,
          ),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
