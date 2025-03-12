import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:convert';
import '../../../../widget/burger-navbar.dart';

class CommunityForumScreen extends StatefulWidget {
  const CommunityForumScreen({super.key});

  @override
  State<CommunityForumScreen> createState() => _CommunityForumScreenState();
}

class _CommunityForumScreenState extends State<CommunityForumScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  // Method to upload image to Firestore
  Future<String?> _uploadImage(File imageFile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      // Convert image to base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      return base64Image;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  // Method to check privacy settings
  Future<Map<String, bool>> _checkPrivacySettings(String userId) async {
    try {
      final privacyDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('settings')
          .doc('privacy')
          .get();

      if (!privacyDoc.exists) {
        return {
          'profileVisibility': true,
          'pregnancyVisibility': true,
          'phoneVisibility': false,
          'addressVisibility': false,
        };
      }

      final data = privacyDoc.data()!;
      return {
        'profileVisibility': data['profileVisibility'] == 'everyone',
        'pregnancyVisibility': data['pregnancyVisibility'] == 'everyone',
        'phoneVisibility': data['phoneVisibility'] == 'everyone',
        'addressVisibility': data['addressVisibility'] == 'everyone',
      };
    } catch (e) {
      debugPrint('Error checking privacy settings: $e');
      return {
        'profileVisibility': true,
        'pregnancyVisibility': true,
        'phoneVisibility': false,
        'addressVisibility': false,
      };
    }
  }

  // Modified method to show user profile with privacy checks
  void _showUserProfile(String userId) async {
    try {
      // Get user data from Firestore
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dadus utilizadór nian la hetan')),
        );
        return;
      }

      final userData = userDoc.data() as Map<String, dynamic>;

      // Get privacy settings
      final privacySettings = await _checkPrivacySettings(userId);

      // Get pregnancy data if visible
      Map<String, dynamic>? pregnancyData;
      if (privacySettings['pregnancyVisibility']!) {
        final pregnancyDoc =
            await _firestore.collection('pregnancyData').doc(userId).get();
        if (pregnancyDoc.exists) {
          pregnancyData = pregnancyDoc.data();
        }
      }

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile Image
                if (privacySettings['profileVisibility']!)
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFF6B57D2),
                    child: ClipOval(
                      child: userData['profileImage'] != null &&
                              userData['profileImage'].toString().isNotEmpty
                          ? Image.memory(
                              base64Decode(userData['profileImage']
                                  .toString()
                                  .split(',')[1]),
                              width: 96,
                              height: 96,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person,
                                      size: 50, color: Colors.white),
                            )
                          : const Icon(Icons.person,
                              size: 50, color: Colors.white),
                    ),
                  ),
                const SizedBox(height: 16),

                // Username
                Text(
                  userData['name'] ?? 'Naran la disponivel',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Email
                Text(
                  userData['email'] ?? 'Email la disponivel',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),

                // Address if visible
                if (privacySettings['addressVisibility']!) ...[
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          userData['address'] ?? 'Enderesu la disponivel',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],

                // Phone if visible
                if (privacySettings['phoneVisibility']!) ...[
                  Row(
                    children: [
                      Icon(Icons.phone_outlined, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        userData['phone'] ?? 'Númeru la disponivel',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],

                // Pregnancy Info if visible
                if (privacySettings['pregnancyVisibility']! &&
                    pregnancyData != null) ...[
                  const Divider(height: 24),
                  Row(
                    children: [
                      Icon(Icons.pregnant_woman, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Idade Gestasionál: ${pregnancyData['currentWeek'] ?? 0} Domingu',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        'HPL: ${pregnancyData['dueDate'] ?? 'La disponivel'}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Taka'),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erru: $e')),
      );
    }
  }

  void _showCreatePostDialog() {
    final TextEditingController postController = TextEditingController();
    File? selectedImage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Text(
                      'Kria Post Foun',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: postController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText:
                        'Fahe ita-boot nia esperiénsia ka pergunta sira...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF6B57D2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Color(0xFF6B57D2), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (selectedImage != null)
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          selectedImage!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: GestureDetector(
                          onTap: () => setState(() => selectedImage = null),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery,
                            maxWidth: 1200,
                            maxHeight: 1200,
                            imageQuality: 85,
                          );

                          if (image != null) {
                            setState(() => selectedImage = File(image.path));
                          }
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.image,
                                color: selectedImage != null
                                    ? const Color(0xFF6B57D2)
                                    : Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Hatama Foto',
                                style: TextStyle(
                                  color: selectedImage != null
                                      ? const Color(0xFF6B57D2)
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        if (postController.text.isNotEmpty ||
                            selectedImage != null) {
                          try {
                            final user = _auth.currentUser;
                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Favor tama uluk'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // Get user data
                            final userDoc = await _firestore
                                .collection('users')
                                .doc(user.uid)
                                .get();
                            final userData = userDoc.data();

                            // Upload image if exists
                            String? imageUrl;
                            if (selectedImage != null) {
                              imageUrl = await _uploadImage(selectedImage!);
                            }

                            await _firestore.collection('forumPosts').add({
                              'userId': user.uid,
                              'username': userData?['name'] ?? 'Uzuáriu',
                              'profileImage': userData?['profileImage'],
                              'content': postController.text,
                              'image': imageUrl,
                              'likes': 0,
                              'comments':
                                  [], // Tambahkan inisialisasi array comments
                              'commentCount': 0,
                              'timestamp': FieldValue.serverTimestamp(),
                            });

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Post kria ho susesu'),
                                backgroundColor: Color(0xFF6B57D2),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('La konsege kria post: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B57D2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Haruka Post'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: const Text(
          'Komunidade Inan Isin-rua sira',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF6B57D2),
        elevation: 0,
      ),
      drawer: BurgerNavBar(
        scaffoldKey: _scaffoldKey,
        currentRoute: '/community',
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('forumPosts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Seidauk iha posting'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final postData = snapshot.data!.docs[index];
              return _buildPost(postData);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePostDialog,
        backgroundColor: const Color(0xFF6B57D2),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPost(QueryDocumentSnapshot postData) {
    final data = postData.data() as Map<String, dynamic>;

    return Card(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => data.containsKey('userId')
                      ? _showUserProfile(data['userId'])
                      : null,
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFF6B57D2),
                    child: data.containsKey('profileImage') &&
                            data['profileImage'] != null &&
                            data['profileImage'].toString().isNotEmpty
                        ? ClipOval(
                            child: Image.memory(
                              base64Decode(data['profileImage'].split(',')[1]),
                              width: 35,
                              height: 35,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person, color: Colors.white),
                            ),
                          )
                        : const Icon(Icons.person, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => data.containsKey('userId')
                        ? _showUserProfile(data['userId'])
                        : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['username'] ?? 'Uzuáriu',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF6B57D2),
                          ),
                        ),
                        Text(
                          _formatTimestamp(data['timestamp']),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => _showPostOptions(postData),
                ),
              ],
            ),
            if (data.containsKey('content') &&
                data['content'] != null &&
                data['content'].toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                data['content'],
                style: const TextStyle(fontSize: 15),
              ),
            ],
            if (data.containsKey('image') &&
                data['image'] != null &&
                data['image'].toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _showFullScreenImage(context, data['image']),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.memory(
                      base64Decode(data['image'].split(',')[1]),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                _buildInteractionButton(
                  icon: Icons.favorite_border,
                  label: '${data['likes'] ?? 0}',
                  color: const Color(0xFF6B57D2),
                  onPressed: () => _handleLike(postData),
                ),
                const SizedBox(width: 24),
                _buildInteractionButton(
                  icon: Icons.comment_outlined,
                  label: '${(data['comments'] as List?)?.length ?? 0}',
                  color: const Color(0xFF6B57D2),
                  onPressed: () => _showComments(context, postData),
                ),
                const SizedBox(width: 24),
                _buildInteractionButton(
                  icon: Icons.share_outlined,
                  label: 'Fahe',
                  color: const Color(0xFF6B57D2),
                  onPressed: () {
                    // Implement share functionality
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String base64Image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.8),
              child: Center(
                child: InteractiveViewer(
                  maxScale: 5.0,
                  child: Image.memory(
                    base64Decode(base64Image.split(',')[1]),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 100,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleLike(QueryDocumentSnapshot postData) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Favor tama uluk'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Get user's liked posts collection
      final likedPostRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('likedPosts')
          .doc(postData.id);

      final likedPost = await likedPostRef.get();

      if (likedPost.exists) {
        // User has already liked this post, remove the like
        await _firestore.collection('forumPosts').doc(postData.id).update({
          'likes': FieldValue.increment(-1),
        });
        await likedPostRef.delete();
      } else {
        // User hasn't liked this post yet, add the like
        await _firestore.collection('forumPosts').doc(postData.id).update({
          'likes': FieldValue.increment(1),
        });
        await likedPostRef.set({
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyukai post: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showComments(BuildContext context, QueryDocumentSnapshot postData) {
    final TextEditingController commentController = TextEditingController();
    final data = postData.data() as Map<String, dynamic>;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Komentariu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: (data['comments'] as List?)?.length ?? 0,
                  itemBuilder: (context, index) {
                    final comment = (data['comments'] as List)[index];
                    return ListTile(
                      leading: GestureDetector(
                        onTap: () => comment['userId'] != null
                            ? _showUserProfile(comment['userId'])
                            : null,
                        child: const CircleAvatar(
                          backgroundColor: Color(0xFF6B57D2),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                      title: GestureDetector(
                        onTap: () => comment['userId'] != null
                            ? _showUserProfile(comment['userId'])
                            : null,
                        child: Text(
                          comment['username'] ?? 'Uzuáriu',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B57D2),
                          ),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment['content'] ?? ''),
                          const SizedBox(height: 4),
                          Text(
                            comment['timestamp'] != null
                                ? _formatTimestamp(comment['timestamp'])
                                : 'Só deit',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'Hakerek komentáriu ida...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: const Color(0xFF6B57D2),
                      onPressed: () async {
                        final commentText = commentController.text.trim();
                        if (commentText.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Komentáriu sira labele mamuk'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        try {
                          final user = _auth.currentUser;
                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Favor tama uluk'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Get user data
                          final userDoc = await _firestore
                              .collection('users')
                              .doc(user.uid)
                              .get();

                          final userData =
                              userDoc.data() as Map<String, dynamic>;
                          final username = userData['name'] ?? 'Pengguna';

                          // Prepare comment data
                          final newComment = {
                            'userId': user.uid,
                            'username': username,
                            'content': commentText,
                            'timestamp': Timestamp.now(), // Use Timestamp.now()
                          };

                          // Update post with new comment
                          await _firestore
                              .collection('forumPosts')
                              .doc(postData.id)
                              .update({
                            'comments': FieldValue.arrayUnion([newComment]),
                            // Ensure comments array exists
                            if (!data.containsKey('comments')) 'comments': [],
                          });

                          // Clear comment field and close bottom sheet
                          commentController.clear();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Komentáriu aumenta ho susesu'),
                              backgroundColor: Color(0xFF6B57D2),
                            ),
                          );
                        } catch (e) {
                          debugPrint('Detailed error: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'La konsege aumenta komentáriu sira: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPostOptions(QueryDocumentSnapshot postData) {
    final currentUser = _auth.currentUser;
    final data = postData.data() as Map<String, dynamic>;
    final isPostOwner =
        currentUser != null && data['userId'] == currentUser.uid;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isPostOwner)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Apaga Post',
                    style: TextStyle(color: Colors.red)),
                onTap: () async {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Hapus Postingan?'),
                        content: const Text(
                            'Ita-boot iha serteza katak ita-boot hakarak atu hamoos post ida-nee? Asaun ida-nee labele halo fali.'),
                        actions: [
                          TextButton(
                            child: const Text('Kanseladu'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: const Text('Hamoos',
                                style: TextStyle(color: Colors.red)),
                            onPressed: () async {
                              try {
                                await _firestore
                                    .collection('forumPosts')
                                    .doc(postData.id)
                                    .delete();

                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Post neebé elimina ho susesu'),
                                    backgroundColor: Color(0xFF6B57D2),
                                  ),
                                );
                              } catch (e) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('La konsege hamoos post: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.report_outlined),
              title: const Text('Relata Post'),
              onTap: () {
                Navigator.pop(context);
                _showReportDialog(postData);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDialog(QueryDocumentSnapshot postData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedReason;
        return AlertDialog(
          title: const Text('Relata Post'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Hili razaun relatóriu ida:'),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedReason,
                    hint: const Text('Hili razaun ida'),
                    items: [
                      'Konteúdu ne ebé la apropriadu',
                      'Korreiu-lixu',
                      'Abuzu',
                      'Informasaun falsu',
                      'Seluk'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedReason = newValue;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('Kanseladu'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Relatóriu'),
              onPressed: () => _handleReport(postData, selectedReason),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleReport(
      QueryDocumentSnapshot postData, String? reason) async {
    if (reason == null) return;

    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Favor tama uluk');
      }

      final data = postData.data() as Map<String, dynamic>;

      await _firestore.collection('reports').add({
        'postId': postData.id,
        'reporterId': user.uid,
        'reason': reason,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
        'postContent': data['content'],
        'postOwner': data['userId'],
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Obrigado ba Ita-boot nia relatóriu'),
          backgroundColor: Color(0xFF6B57D2),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('La konsege relata postu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(dynamic timestampData) {
    if (timestampData == null) {
      return 'Só de it';
    }

    DateTime timestamp;
    try {
      if (timestampData is Timestamp) {
        timestamp = timestampData.toDate();
      } else if (timestampData is DateTime) {
        timestamp = timestampData;
      } else if (timestampData is Map) {
        // Jika timestampData adalah Map dari Firestore
        timestamp = DateTime.fromMillisecondsSinceEpoch(
            (timestampData['seconds'] as int) * 1000);
      } else {
        return 'Só de it';
      }
    } catch (e) {
      return 'Só de it';
    }

    final difference = DateTime.now().difference(timestamp);
    if (difference.inMinutes < 1) {
      return 'Só de it';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutu liubá';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} oras liubá';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} loron hirak liubá';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
