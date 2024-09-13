import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kush/loginscreen.dart';
  // Make sure you have the login screen implemented

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _username;
  String? _email;
  String? _profileImageUrl;

  // Function to fetch the user's profile data from Firestore
  Future<void> _loadUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        _username = userDoc['username'];
        _email = userDoc['email'];
        _profileImageUrl = userDoc['profileImageUrl'];
      });
    }
  }

  // Function to handle logout
  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),  // Redirect to login screen after logout
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();  // Load user profile when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: _username == null
          ? Center(child: CircularProgressIndicator())  // Show loading indicator while fetching data
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImageUrl != null
                      ? NetworkImage(_profileImageUrl!)
                      : null,
                  child: _profileImageUrl == null ? Icon(Icons.person, size: 50) : null,
                ),
                SizedBox(height: 20),
                Text('Username: $_username', style: TextStyle(fontSize: 18)),
                Text('Email: $_email', style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _logout,  // Call the logout function when pressed
                  child: Text('Logout'),
                ),
              ],
            ),
    );
  }
}
