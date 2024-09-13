// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class NewPostScreen extends StatefulWidget {
//   @override
//   _NewPostScreenState createState() => _NewPostScreenState();
// }

// class _NewPostScreenState extends State<NewPostScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   File? _image;
//   bool _isUploading = false;
//   final ImagePicker _picker = ImagePicker();

//   // Pick image from gallery
//   Future<void> _pickImageFromGallery() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   // Capture image from camera
//   Future<void> _captureImageFromCamera() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   // Upload image to Firebase Storage and post metadata to Firestore
//   Future<void> _uploadPost() async {
//     if (_image == null) return;

//     setState(() {
//       _isUploading = true;
//     });

//     try {
//       // Get the current user
//       User? user = _auth.currentUser;
//       if (user == null) return;

//       // Upload the image to Firebase Storage
//       final storageRef = _storage.ref().child('posts/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');
//       await storageRef.putFile(_image!);
//       final imageUrl = await storageRef.getDownloadURL();

//       // Save post metadata to Firestore
//       await _firestore.collection('posts').add({
//         'imageUrl': imageUrl,
//         'userId': user.uid,
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post uploaded successfully')));
//       setState(() {
//         _image = null;  // Clear the image after upload
//       });

//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload post: $e')));
//     } finally {
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Create New Post')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _image == null
//                 ? Text('No image selected')
//                 : Image.file(_image!, height: 200, width: 200, fit: BoxFit.cover),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton.icon(
//                   icon: Icon(Icons.photo),
//                   label: Text('Gallery'),
//                   onPressed: _pickImageFromGallery,
//                 ),
//                 ElevatedButton.icon(
//                   icon: Icon(Icons.camera),
//                   label: Text('Camera'),
//                   onPressed: _captureImageFromCamera,
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             _isUploading
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: _uploadPost,
//                     child: Text('Upload Post'),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';  // For image picking
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  XFile? _image;
  String _caption = '';
  bool _isUploading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Future<void> _uploadPost() async {
    if (_image == null || _caption.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please provide an image and caption.'),
      ));
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Upload image to Firebase Storage
      final user = _auth.currentUser;
      final imagePath = 'posts/${user!.uid}/${DateTime.now().millisecondsSinceEpoch}.png';
      final imageRef = _storage.ref().child(imagePath);
      await imageRef.putFile(File(_image!.path));
      final imageUrl = await imageRef.getDownloadURL();

      // Add post data to Firestore
      await _firestore.collection('posts').add({
        'userId': user.uid,
        'caption': _caption,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Post created successfully!'),
      ));
      Navigator.of(context).pop();  // Return to previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to create post: $e'),
      ));
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Picker
            _image != null
                ? Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(File(_image!.path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: Icon(Icons.image, size: 100, color: Colors.grey[600]),
                  ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: Text('Pick from Gallery'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: Text('Take a Photo'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Caption Input
            TextField(
              onChanged: (value) {
                setState(() {
                  _caption = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Caption',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            // Submit Button
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadPost,
              child: _isUploading
                  ? CircularProgressIndicator() // Show loading indicator while uploading
                  : Text('Submit Post'),
            ),
          ],
        ),
      ),
    );
  }
}


