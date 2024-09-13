import 'package:flutter/material.dart';

class NewPostTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Post')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Logic for creating a new post (e.g., open a form)
          },
          child: Text('Create New Post'),
        ),
      ),
    );
  }
}
