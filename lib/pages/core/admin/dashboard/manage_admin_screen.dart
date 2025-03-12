import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:convert';

class ManageAdminsScreen extends StatefulWidget {
  final AdminManageMode? initialMode;

  const ManageAdminsScreen({super.key, this.initialMode});

  @override
  State<ManageAdminsScreen> createState() => _ManageAdminsScreenState();
}

class _ManageAdminsScreenState extends State<ManageAdminsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _updateAdminEmail(String userId, String newEmail) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Get the current user
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Update email in Firebase Authentication
        await currentUser.updateEmail(newEmail);

        // Update email in Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).update(
            {'email': newEmail, 'lastUpdated': FieldValue.serverTimestamp()});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email atualiza ho susesu')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La hetan utilizadór')),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('La konsege atualiza email: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('La konsege atualiza email: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _changePassword(String userId, String newPassword) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Get admin data from Firestore

      // Get the user associated with the admin doc
      User? adminUser = await FirebaseAuth.instance.currentUser;

      if (adminUser != null) {
        // Update password
        await adminUser.updatePassword(newPassword);

        // Update lastUpdated in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'lastUpdated': FieldValue.serverTimestamp()});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Atualiza ona liafuan-xave ho susesu')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('La konsege atualiza senha: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteAdminAccount(Map<String, dynamic> userData) async {
    try {
      // Show confirmation dialog
      bool? confirmDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Apaga Konta Admin'),
          content: const Text(
              'Ita-boot iha serteza katak ita-boot hakarak atu hamoos konta admin ida-ne e? Asaun ida-ne e labele halo fali.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Kanseladu'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Hamoos'),
            ),
          ],
        ),
      );

      if (confirmDelete == true) {
        setState(() {
          _isLoading = true;
        });

        // Get the user ID
        String userId = userData['id'];

        // First delete the Firestore document
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .delete();

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Konta admin nian hetan eliminasaun ho susesu'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // Handle reauthentication requirement
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Favor tama fali iha sistema antes de hamoos konta'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('La konsege hamoos konta admin: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('La konsege hamoos konta admin: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showEmailEditDialog(Map<String, dynamic> userData) {
    final TextEditingController emailController =
        TextEditingController(text: userData['email']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Troka Email Admin'),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email Foun',
            hintText: 'Hatama email foun ida',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kanseladu'),
          ),
          ElevatedButton(
            onPressed: () {
              if (emailController.text.isNotEmpty &&
                  emailController.text != userData['email']) {
                _updateAdminEmail(userData['id'], emailController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Salva'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(Map<String, dynamic> userData) {
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Troka Senha'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Senha Foun',
              hintText: 'Hatama senha foun',
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
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kanseladu'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                _changePassword(userData['id'], passwordController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Salva'),
          ),
        ],
      ),
    );
  }

  void _showUserDetailsDialog(Map<String, dynamic> userData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            userData['name'] ?? 'Detallu Admin nian',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B57D2),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile Image
                if (userData['profileImage'] != null)
                  Center(
                    child: ClipOval(
                      child: Image.memory(
                        base64Decode(userData['profileImage'].split(',')[1]),
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 120,
                            color: Color(0xFF6B57D2),
                          );
                        },
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // User Details
                _buildDetailRow(
                  icon: Icons.person_outline,
                  label: 'Naran',
                  value: userData['name'] ?? 'La disponivel',
                ),
                _buildDetailRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: userData['email'] ?? 'La disponivel',
                ),
                _buildDetailRow(
                  icon: Icons.phone_outlined,
                  label: 'Númeru telemovel',
                  value: userData['phone'] ?? 'La disponivel',
                ),
                _buildDetailRow(
                  icon: Icons.calendar_today,
                  label: 'Rejistu ona',
                  value: userData['createdAt'] != null
                      ? _formatDate(userData['createdAt'].toDate())
                      : 'La disponivel',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Taka',
                style: TextStyle(color: Color(0xFF6B57D2)),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF6B57D2),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white), // Tambahkan ini
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Jere Admin',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6B57D2),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buka admin...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // Admin List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('role', isEqualTo: 'admin')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData) {
                        return const Center(child: Text('Laiha admin sira'));
                      }

                      // Filter admins based on search query
                      final filteredAdmins = snapshot.data!.docs.where((doc) {
                        final userData = doc.data() as Map<String, dynamic>;
                        final name = (userData['name'] ?? '').toLowerCase();
                        final email = (userData['email'] ?? '').toLowerCase();
                        final username =
                            (userData['username'] ?? '').toLowerCase();

                        return name.contains(_searchQuery) ||
                            email.contains(_searchQuery) ||
                            username.contains(_searchQuery);
                      }).toList();

                      return ListView.builder(
                        itemCount: filteredAdmins.length,
                        itemBuilder: (context, index) {
                          final userData = filteredAdmins[index].data()
                              as Map<String, dynamic>;
                          userData['id'] = filteredAdmins[index].id;

                          return _buildAdminCard(userData);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add admin dialog
          _showAddAdminDialog();
        },
        backgroundColor: const Color(0xFF6B57D2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAdminCard(Map<String, dynamic> userData) {
    return GestureDetector(
      onTap: () => _showUserDetailsDialog(userData),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // User Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B57D2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings,
                      color: Color(0xFF6B57D2),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // User Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData['username'] ?? 'Naran Uzuáriu La Disponivel',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userData['phone'] ?? 'Númeru Telemóvel La Disponivel',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action Buttons
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit_email':
                          _showEmailEditDialog(userData);
                          break;
                        case 'change_password':
                          _showChangePasswordDialog(userData);
                          break;
                        case 'delete_account':
                          _deleteAdminAccount(userData);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'edit_email',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Troka Email'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'change_password',
                        child: Row(
                          children: [
                            Icon(Icons.lock, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Troka Senha'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete_account',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Hamoos konta'),
                          ],
                        ),
                      ),
                    ],
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),

              // Additional User Info
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Registration Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.grey[600],
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Rejistu ona: ${userData['createdAt'] != null ? _formatDate(userData['createdAt'].toDate()) : 'Deskonese'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddAdminDialog() {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
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
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Naran Uzuáriu',
                  hintText: 'Hatama ita-boot nia naran utilizadór',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Naran utilizadór labele mamuk';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Númeru telemovel',
                  hintText: 'Hatama númeru telemovel nian',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Númeru telemovel labele mamuk';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Númeru telemovel sira bele kontein de it númeru sira';
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
                  // Create user in Firebase Authentication
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: emailController.text.trim(),
                    password: passwordController.text,
                  );

                  // Store additional user data in Firestore
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userCredential.user?.uid)
                      .set({
                    'username': usernameController.text,
                    'phone': phoneController.text,
                    'email': emailController.text.trim(),
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
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('La konsege aumenta admin: ${e.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
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
}

// Enum for admin management mode
enum AdminManageMode { view, add }
