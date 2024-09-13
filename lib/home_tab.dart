import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<DocumentSnapshot> posts = [];

  @override
  void initState() {
    super.initState();
    fetchAllPosts();
  }

  Future<void> fetchAllPosts() async {
    try {
      QuerySnapshot postSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt', descending: true) // Order posts by creation time
          .get();

      setState(() {
        posts = postSnapshot.docs;
      });
    } catch (error) {
      print('Error fetching posts: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: posts.isEmpty
          ? Center(child: Text('No posts available'))
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                var post = posts[index].data() as Map<String, dynamic>;
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(post['title'] ?? 'Untitled'),
                    subtitle: Text(post['description'] ?? ''),
                  ),
                );
              },
            ),
    );
  }
}
