import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  File? _imageFile;
  final TextEditingController _captionController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isUploading = false;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadPost() async {
    if (_imageFile == null || _captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an image and add a caption.')));
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // Upload image to Firebase Storage
        String fileName = 'posts/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = storageRef.putFile(_imageFile!);
        TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => null);
        String imageUrl = await storageSnapshot.ref.getDownloadURL();

        // Create a new post in Firestore
        await FirebaseFirestore.instance.collection('posts').add({
          'userId': user.uid,
          'imageUrl': imageUrl,
          'caption': _captionController.text,
          'createdAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Post uploaded successfully!')));
        Navigator.pop(context);  // Redirect back to the home screen or posts page.
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload post: $error')));
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _isUploading ? null : _uploadPost,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Display selected image
              _imageFile == null
                  ? Text('No image selected.')
                  : Image.file(_imageFile!, height: 300, fit: BoxFit.cover),

              SizedBox(height: 20),

              // Caption input field
              TextField(
                controller: _captionController,
                decoration: InputDecoration(
                  labelText: 'Enter caption',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),

              // Upload image buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.photo),
                    label: Text('Gallery'),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: Text('Camera'),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                ],
              ),

              if (_isUploading) CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
