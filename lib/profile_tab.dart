import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  String profilePicUrl = '';
  List<DocumentSnapshot> posts = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchUserData();
    fetchUserPosts();
  }

  void getCurrentUser() {
    user = _auth.currentUser;
  }

  Future<void> fetchUserData() async {
    if (user != null) {
      DocumentSnapshot userData =
          await _firestore.collection('users').doc(user!.uid).get();
      String profilePicPath = userData['profilePic'] ?? '';

      // Fetch profile picture URL from Firebase Storage
      if (profilePicPath.isNotEmpty) {
        String downloadURL =
            await FirebaseStorage.instance.ref(profilePicPath).getDownloadURL();
        setState(() {
          profilePicUrl = downloadURL;
        });
      }
    }
  }

  Future<void> fetchUserPosts() async {
    if (user != null) {
      QuerySnapshot userPosts = await _firestore
          .collection('posts')
          .where('userId', isEqualTo: user!.uid)
          .get();
      setState(() {
        posts = userPosts.docs;
      });
    }
  }

  void logout() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Picture
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: profilePicUrl.isNotEmpty
                          ? CachedNetworkImageProvider(profilePicUrl)
                          : null,
                      child: profilePicUrl.isEmpty
                          ? Icon(Icons.person, size: 60)
                          : null,
                    ),
                    SizedBox(height: 20),

                    // Username and Email
                    Text(
                      user!.displayName ?? 'Username',
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      user!.email ?? 'Email',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 20),

                    // Logout Button
                    ElevatedButton(
                      onPressed: logout,
                      child: Text('Logout'),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10)),
                    ),
                    SizedBox(height: 30),

                    // User's Posts
                    Text(
                      'Your Posts',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    posts.isEmpty
                        ? Text('No posts found.')
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              var post = posts[index].data() as Map;
                              return ListTile(
                                title: Text(post['title'] ?? 'Untitled'),
                                subtitle: Text(post['description'] ?? ''),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
