import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../opening/welcome_page.dart';
import 'doctor_edit_profile_screen.dart';

class DoctorSettingsScreen extends StatefulWidget {
  const DoctorSettingsScreen({Key? key}) : super(key: key);

  @override
  _DoctorSettingsScreenState createState() => _DoctorSettingsScreenState();
}

class _DoctorSettingsScreenState extends State<DoctorSettingsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, dynamic> _doctorData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctorData();
  }

  Future<void> _loadDoctorData() async {
    if (!mounted) return;

    try {
      final user = _auth.currentUser;
      if (user != null) {
        final docSnapshot =
            await _firestore.collection('users').doc(user.uid).get();

        if (mounted) {
          // Check if widget is still mounted before setting state
          setState(() {
            _doctorData = docSnapshot.data() ?? {};
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        // Check if widget is still mounted before setting state
        setState(() {
          _isLoading = false;
        });
        _showErrorMessage('La konsege karrega dadus: $e');
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _resetPassword() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _auth.sendPasswordResetEmail(email: user.email!);

        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Reset Password'),
              content: Text(
                'Email reset senha nian haruka ona ba ${user.email}. '
                'Favor verifika ita-boot nia kaixa email.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      _showErrorMessage('La konsege haruka email reset: $e');
    }
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorEditProfileScreen(
          initialData: _doctorData,
        ),
      ),
    ).then((_) => _loadDoctorData());
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomePage()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      _showErrorMessage('La konsege sai: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Konfigurasaun Doutór nian',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF6B57D2),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Profil Dokter Card
                _buildProfileCard(),
                const SizedBox(height: 16),

                // Pengaturan Profil
                _buildSettingsCard(),
              ],
            ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Foto Profil
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[300],
              backgroundImage: _doctorData['profileImage'] != null
                  ? MemoryImage(base64Decode(
                      _doctorData['profileImage'].contains(',')
                          ? _doctorData['profileImage'].split(',').last
                          : _doctorData['profileImage']))
                  : null,
              child: _doctorData['profileImage'] == null
                  ? const Icon(Icons.person, size: 60, color: Colors.grey)
                  : null,
            ),
            const SizedBox(height: 16),

            // Nama dan Spesialisasi
            Text(
              _doctorData['name'] ?? 'Doutór nia naran',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _doctorData['specialty'] ?? 'Espesializasaun',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _buildSettingsItem(
            icon: Icons.edit,
            title: 'Edita Perfil',
            onTap: _navigateToEditProfile,
          ),
          const Divider(),
          _buildSettingsItem(
            icon: Icons.lock,
            title: 'Troka Senha',
            onTap: _resetPassword,
          ),
          const Divider(),
          _buildSettingsItem(
            icon: Icons.logout,
            title: 'Sai sai',
            onTap: _logout,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? const Color(0xFF6B57D2)),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.black,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
