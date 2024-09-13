// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ProfileTab extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<void> _logout(BuildContext context) async {
//     try {
//       await _auth.signOut();
//       Navigator.of(context).pushReplacementNamed('/login');
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Failed to log out: $e'),
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     User? user = _auth.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Use an icon as a placeholder if the image is not available
//             CircleAvatar(
//               radius: 50,
//               backgroundImage: user?.photoURL != null
//                   ? NetworkImage(user!.photoURL!)
//                   : null,
//               child: user?.photoURL == null
//                   ? Icon(Icons.person, size: 50)
//                   : null,
//             ),
//             SizedBox(height: 20),

//             // Display username and email
//             Text(
//               user?.displayName ?? 'Username',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 10),
//             Text(
//               user?.email ?? 'Email',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 30),

//             // Logout button
//             ElevatedButton(
//               onPressed: () => _logout(context),
//               child: Text('Logout'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ProfileTab extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<void> _logout(BuildContext context) async {
//     try {
//       await _auth.signOut();
//       Navigator.of(context).pushReplacementNamed('/login'); // Redirect to login after logout
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Failed to log out: $e'),
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     User? user = _auth.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Profile Picture
//             CircleAvatar(
//               radius: 50,
//               backgroundImage: user?.photoURL != null
//                   ? NetworkImage(user!.photoURL!)
//                   : AssetImage('assets/placeholder_image.png') as ImageProvider,
//             ),
//             SizedBox(height: 20),

//             // Username and Email
//             Text(
//               user?.displayName ?? 'No Username',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text(
//               user?.email ?? 'No Email',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 30),

//             // Logout Button
//             ElevatedButton(
//               onPressed: () => _logout(context),
//               child: Text('Logout'),
//             ),
//             SizedBox(height: 30),

//             // List of User's Posts
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('posts')
//                     .where('userId', isEqualTo: user?.uid) // Filter posts by userId
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   }

//                   if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   }

//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return Center(child: Text('No posts available'));
//                   }

//                   return ListView.builder(
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (context, index) {
//                       var post = snapshot.data!.docs[index];

//                       return ListTile(
//                         title: Text(post['caption'] ?? 'No Caption'),
//                         subtitle: Text(post['timestamp'].toDate().toString()),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileTab extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _logout(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.of(context).pushReplacementNamed('/login'); // Redirect to login after logout
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to log out: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 50,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : AssetImage('assets/plh.jpg') as ImageProvider,
            ),
            SizedBox(height: 20),

            // Username and Email
            Text(
              user?.displayName ?? 'No Username',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              user?.email ?? 'No Email',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),

            // Logout Button
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text('Logout'),
            ),
            SizedBox(height: 30),

            // List of User's Posts
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('userId', isEqualTo: user?.uid) // Filter posts by userId
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No posts available'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var post = snapshot.data!.docs[index];
                      var caption = post.get('caption') ?? 'No Caption'; // Provide a default value

                      return ListTile(
                        title: Text(caption),
                        subtitle: Text(post.get('timestamp')?.toDate().toString() ?? 'No Date'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}




