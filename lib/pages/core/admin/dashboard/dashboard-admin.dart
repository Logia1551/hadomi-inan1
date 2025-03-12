import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../opening/welcome_page.dart';
import 'manage_doctors_screen.dart';
import 'manage_users_screen.dart';
import 'manage_content_screen.dart';
import 'manage_admin_screen.dart';
import 'manage_online_class_screen.dart';
import 'manage_meditation_screen.dart';

// Define enums
enum DoctorManageMode { view, add }

enum ContentManageMode { view, add }

enum AdminManageMode { view, add }

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _totalUsers = 0;
  int _totalDoctors = 0;
  int _totalAdmins = 0;
  int _totalContent = 0;
  int _totalOnlineClasses = 0;
  int _totalMeditations = 0; // Add meditation counter

  @override
  void initState() {
    super.initState();
    _fetchDashboardStats();
  }

  Future<void> _handleRefresh() async {
    await _fetchDashboardStats();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dadus atualiza ho susesu'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _fetchDashboardStats() async {
    try {
      final usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      final articlesSnapshot =
          await FirebaseFirestore.instance.collection('articles').get();
      final videosSnapshot =
          await FirebaseFirestore.instance.collection('videos').get();
      final onlineClassesSnapshot =
          await FirebaseFirestore.instance.collection('online_classes').get();
      final meditationsSnapshot = await FirebaseFirestore.instance
          .collection('meditations')
          .get(); // Add meditation fetch

      int userCount = 0;
      int doctorCount = 0;
      int adminCount = 0;

      for (var doc in usersSnapshot.docs) {
        final userData = doc.data();
        if (userData['role'] == 'user') {
          userCount++;
        }
        if (userData['role'] == 'doctor') {
          doctorCount++;
        }
        if (userData['role'] == 'admin') {
          adminCount++;
        }
      }

      setState(() {
        _totalUsers = userCount;
        _totalDoctors = doctorCount;
        _totalAdmins = adminCount;
        _totalContent =
            articlesSnapshot.docs.length + videosSnapshot.docs.length;
        _totalOnlineClasses = onlineClassesSnapshot.docs.length;
        _totalMeditations =
            meditationsSnapshot.docs.length; // Set meditation count
      });

      print('Total users: $_totalUsers');
      print('Total doctors: $_totalDoctors');
      print('Total admins: $_totalAdmins');
      print('Total content: $_totalContent');
      print('Total online classes: $_totalOnlineClasses');
      print('Total meditations: $_totalMeditations'); // Log meditation count
    } catch (e) {
      print('Error fetching stats: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching stats: $e')),
        );
      }
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomePage()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: $e')),
        );
      }
    }
  }

  void _showAddAdminDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hatama Admin Foun'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Naran kompletu',
                  hintText: 'Hakerek naran kompletu',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Naran labele mamuk';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Hatama email admin nian',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email labele mamuk';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Formatu email ne ebé la válidu';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Liafuan-xave sira',
                  hintText: 'Hatama senha',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password labele mamuk';
                  }
                  if (value.length < 6) {
                    return 'Password tenke iha pelumenus karakter 6';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Kanseladu'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: emailController.text.trim(),
                    password: passwordController.text,
                  );

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userCredential.user?.uid)
                      .set({
                    'name': nameController.text,
                    'email': emailController.text.trim(),
                    'username': emailController.text.split('@')[0],
                    'role': 'admin',
                    'createdAt': FieldValue.serverTimestamp(),
                    'lastUpdated': FieldValue.serverTimestamp(),
                  });

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Admin aumenta ho susesu'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  _fetchDashboardStats();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('La konsege aumenta admin: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Plus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6B57D2),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStatCard(
                title: 'Totál Utilizadór sira',
                value: _totalUsers.toString(),
                icon: Icons.people,
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageUsersScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                title: 'Totál Médiku no Parteira sira',
                value: _totalDoctors.toString(),
                icon: Icons.medical_services,
                color: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageDoctorsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                title: 'Totál Admin',
                value: _totalAdmins.toString(),
                icon: Icons.admin_panel_settings,
                color: Colors.red,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageAdminsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                title: 'Totál Konteúdu',
                value: _totalContent.toString(),
                icon: Icons.description,
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageContentScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                title: 'Totál Klase Online sira',
                value: _totalOnlineClasses.toString(),
                icon: Icons.video_library,
                color: Colors.purple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageOnlineClassScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                title: 'Meditasaun Totál',
                value: _totalMeditations.toString(),
                icon: Icons.self_improvement,
                color: Colors.teal,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageMeditationScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Asaun Lalais',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildQuickActionButton(
                    title: 'Hatama Doutór',
                    icon: Icons.add_circle,
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageDoctorsScreen(
                            initialMode: DoctorManageMode.add,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildQuickActionButton(
                    title: 'Hatama Konteúdu',
                    icon: Icons.upload_file,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageContentScreen(
                            initialMode: ContentManageMode.add,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildQuickActionButton(
                    title: 'Hatama Klase Online',
                    icon: Icons.video_call,
                    color: Colors.indigo,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageOnlineClassScreen(
                            initialMode: OnlineClassManageMode.add,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildQuickActionButton(
                    title: 'Hatama Admin',
                    icon: Icons.admin_panel_settings,
                    color: Colors.red,
                    onTap: _showAddAdminDialog,
                  ),
                  _buildQuickActionButton(
                    title: 'Hatama Meditasaun',
                    icon: Icons.self_improvement,
                    color: Colors.teal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageMeditationScreen(
                            initialMode: MeditationManageMode.add,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
