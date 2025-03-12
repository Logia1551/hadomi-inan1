import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import 'dashboard-admin.dart' show DoctorManageMode;

class ManageDoctorsScreen extends StatefulWidget {
  final DoctorManageMode? initialMode;

  const ManageDoctorsScreen({Key? key, this.initialMode}) : super(key: key);

  @override
  State<ManageDoctorsScreen> createState() => _ManageDoctorsScreenState();
}

class _ManageDoctorsScreenState extends State<ManageDoctorsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _specialtyController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _registrationNumberController =
      TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  DoctorManageMode _currentMode = DoctorManageMode.view;
  String? _base64Image;

  @override
  void initState() {
    super.initState();
    if (widget.initialMode != null) {
      _currentMode = widget.initialMode!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _specialtyController.dispose();
    _experienceController.dispose();
    _descriptionController.dispose();
    _passwordController.dispose();
    _hospitalController.dispose();
    _registrationNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final img64 = base64Encode(bytes);

        setState(() {
          _base64Image = img64;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Widget _buildImageDisplay(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return const Icon(
        Icons.person,
        size: 60,
        color: Color(0xFF6B57D2),
      );
    }

    try {
      return ClipOval(
        child: Image.memory(
          base64Decode(base64String),
          fit: BoxFit.cover,
          width: 120,
          height: 120,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.person,
              size: 60,
              color: Color(0xFF6B57D2),
            );
          },
        ),
      );
    } catch (e) {
      return const Icon(
        Icons.person,
        size: 60,
        color: Color(0xFF6B57D2),
      );
    }
  }

  Future<void> _addDoctor() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'specialty': _specialtyController.text.trim(),
        'experience': _experienceController.text.trim(),
        'description': _descriptionController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'isAvailable': true,
        'role': 'doctor',
        'hospital': _hospitalController.text.trim(),
        'registrationNumber': _registrationNumberController.text.trim(),
        'profileImage': _base64Image,
      });

      _resetForm();

      if (mounted) {
        setState(() {
          _currentMode = DoctorManageMode.view;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Dokter ${_nameController.text} aumenta ho susesu')),
        );
      }
    } catch (e) {
      String errorMessage = 'La konsege aumenta doutór';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'Email rejista ona';
            break;
          case 'invalid-email':
            errorMessage = 'Formatu email ne ebé la válidu';
            break;
          case 'weak-password':
            errorMessage = 'Password fraku liu';
            break;
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
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

  void _resetForm() {
    _nameController.clear();
    _emailController.clear();
    _specialtyController.clear();
    _experienceController.clear();
    _descriptionController.clear();
    _passwordController.clear();
    _hospitalController.clear();
    _registrationNumberController.clear();
    setState(() {
      _base64Image = null;
    });
  }

  void _toggleDoctorAvailability(String doctorId, bool isAvailable) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(doctorId)
          .update({'isAvailable': isAvailable});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(isAvailable
                  ? 'Doutór agora disponivel ona'
                  : 'Doutór la disponivel iha tempu ida-ne e')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La konsege atualiza estatutu: $e')),
        );
      }
    }
  }

  void _showEditDoctorDialog(Map<String, dynamic> doctorData) {
    _nameController.text = doctorData['name'] ?? '';
    _specialtyController.text = doctorData['specialty'] ?? '';
    _experienceController.text = doctorData['experience'] ?? '';
    _descriptionController.text = doctorData['description'] ?? '';
    _hospitalController.text = doctorData['hospital'] ?? '';
    _registrationNumberController.text = doctorData['registrationNumber'] ?? '';
    _base64Image = doctorData['profileImage'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edita Doutór'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF6B57D2),
                              width: 2,
                            ),
                          ),
                          child: _buildImageDisplay(_base64Image),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF6B57D2),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration:
                      const InputDecoration(labelText: 'Naran kompletu'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Naran tenke prenxe'
                      : null,
                ),
                TextFormField(
                  controller: _specialtyController,
                  decoration: const InputDecoration(labelText: 'Espesialidade'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Espesialidade sira tenke prenxe iha'
                      : null,
                ),
                TextFormField(
                  controller: _experienceController,
                  decoration:
                      const InputDecoration(labelText: 'Esperiénsia (tinan)'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Esperiénsia tenke prenxe'
                      : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Deskrisaun'),
                  maxLines: 3,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Presiza deskrisaun'
                      : null,
                ),
                TextFormField(
                  controller: _hospitalController,
                  decoration:
                      const InputDecoration(labelText: 'Orijen husi Ospitál'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Tenke prenxe orijen ospitál nian'
                      : null,
                ),
                TextFormField(
                  controller: _registrationNumberController,
                  decoration:
                      const InputDecoration(labelText: 'Númeru Mestre/Rejistu'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Númeru prinsipál tenke prenxe'
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetForm();
            },
            child: const Text('Kanseladu'),
          ),
          ElevatedButton(
            onPressed: () => _updateDoctorDetails(doctorData['id']),
            child: const Text('Salva'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateDoctorDetails(String doctorId) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(doctorId)
          .update({
        'name': _nameController.text.trim(),
        'specialty': _specialtyController.text.trim(),
        'experience': _experienceController.text.trim(),
        'description': _descriptionController.text.trim(),
        'hospital': _hospitalController.text.trim(),
        'registrationNumber': _registrationNumberController.text.trim(),
        'profileImage': _base64Image,
      });

      Navigator.pop(context);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Doutór atualiza ho susesu')),
        );
      }

      _resetForm();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La konsege atualiza doutór: $e')),
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

  void _resetDoctorPassword(String? email) async {
    if (email == null || email.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email la disponivel')),
        );
      }
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Email reset senha nian haruka ona ba $email')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La konsege haruka email reset: $e')),
        );
      }
    }
  }

  void _deleteDoctorConfirmation(String doctorId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hasai Doutór'),
        content: const Text(
            'Ita-boot iha serteza katak ita-boot hakarak hasai doutór ida-ne e?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kanseladu'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteDoctor(doctorId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hamoos'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDoctor(String doctorId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(doctorId)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Doutór konsege hasai ida-ne\'e')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('La konsege hasai doutór: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _currentMode == DoctorManageMode.view
              ? 'Jere Doutór sira'
              : 'Hatama Doutór Foun',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6B57D2),
        actions: [
          if (_currentMode == DoctorManageMode.view)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                setState(() {
                  _currentMode = DoctorManageMode.add;
                });
              },
            ),
        ],
      ),
      body: _currentMode == DoctorManageMode.view
          ? _buildDoctorsList()
          : _buildAddDoctorForm(),
    );
  }

  Widget _buildDoctorsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'doctor')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.medical_services,
                  size: 80,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Seidauk iha médiku sira ne ebé maka lista ona',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doctorData =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            doctorData['id'] = snapshot.data!.docs[index].id;

            return _buildDoctorCard(doctorData);
          },
        );
      },
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctorData) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B57D2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _buildImageDisplay(doctorData['profileImage']),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorData['name'] ?? 'Naran La Disponivel',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctorData['specialty'] ??
                            'Espesialidade La Disponivel',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Esperiênsia: ${doctorData['experience'] ?? 'Tidak diketahui'} tinan',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'RS: ${doctorData['hospital'] ?? 'Tidak diketahui'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Lae. Rejistu: ${doctorData['registrationNumber'] ?? 'Tidak diketahui'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const Text(
                      'Disponivel',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Switch(
                      value: doctorData['isAvailable'] ?? false,
                      onChanged: (bool value) {
                        _toggleDoctorAvailability(doctorData['id'], value);
                      },
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              doctorData['description'] ?? 'Laiha deskrisaun',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.email,
                        color: Colors.grey[600],
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          doctorData['email'] ?? 'Email la disponivel',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _showEditDoctorDialog(doctorData);
                        break;
                      case 'reset_password':
                        _resetDoctorPassword(doctorData['email']);
                        break;
                      case 'delete':
                        _deleteDoctorConfirmation(doctorData['id']);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Edita'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'reset_password',
                      child: Row(
                        children: [
                          Icon(Icons.lock_reset, color: Colors.orange),
                          SizedBox(width: 8),
                          Text('Reset Password'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Hamoos'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddDoctorForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF6B57D2),
                          width: 2,
                        ),
                      ),
                      child: _buildImageDisplay(_base64Image),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF6B57D2),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Espesialidade',
                prefixIcon: const Icon(Icons.medical_services,
                    color: Color(0xFF6B57D2)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              hint: const Text('Hili Espesialidade Médiku nian'),
              items: [
                'Psikólogu Klíniku',
                'Psikólogu Inan nian',
                'Konselleiru ba isin-rua',
                'Psikólogu Labarik nian',
                'Psikólogu Adultu',
                'Psikólogu Idozu',
              ]
                  .map((specialty) => DropdownMenuItem(
                        value: specialty,
                        child: Text(specialty),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Espesialidade sira tenke hili';
                }
                return null;
              },
              onChanged: (value) {
                _specialtyController.text = value ?? '';
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Naran kompletu',
                prefixIcon: const Icon(Icons.person, color: Color(0xFF6B57D2)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Naran kompletu tenke prenxe';
                }
                if (value.trim().length < 2) {
                  return 'Naran badak liu';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email Profisionál',
                prefixIcon: const Icon(Icons.email, color: Color(0xFF6B57D2)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Presiza email';
                }
                final emailRegex = RegExp(
                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                  caseSensitive: false,
                );
                if (!emailRegex.hasMatch(value.trim())) {
                  return 'Formatu email ne ebé la válidu';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _hospitalController,
              decoration: InputDecoration(
                labelText: 'Orijen husi Ospitál',
                prefixIcon:
                    const Icon(Icons.local_hospital, color: Color(0xFF6B57D2)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Tenke prienxe orijen husi ospitál';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _registrationNumberController,
              decoration: InputDecoration(
                labelText: 'Númeru Mestre/Rejistu',
                prefixIcon: const Icon(Icons.numbers, color: Color(0xFF6B57D2)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Númeru prinsipál/rejistu tenke prenxe iha';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Liafuan-xave sira',
                prefixIcon: const Icon(Icons.lock, color: Color(0xFF6B57D2)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF6B57D2),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Tenke hatama senha';
                }
                if (value.trim().length < 8) {
                  return 'Password tenke iha pelumenus karakter 8';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _experienceController,
              decoration: InputDecoration(
                labelText: 'Esperiénsia Prátika (tinan)',
                prefixIcon: const Icon(Icons.workspace_premium,
                    color: Color(0xFF6B57D2)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Esperiénsia tenke prenxe';
                }
                final experience = int.tryParse(value.trim());
                if (experience == null || experience < 0 || experience > 50) {
                  return 'Hatama esperiénsia válidu (tinan 0-50)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Deskrisaun Profisionál',
                prefixIcon:
                    const Icon(Icons.description, color: Color(0xFF6B57D2)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Presiza deskrisaun';
                }
                if (value.trim().length < 20) {
                  return 'Deskrisaun badak liu (mínimu karakter 20)';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _addDoctor,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B57D2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    )
                  : const Text(
                      'Hatama Doutór',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _currentMode = DoctorManageMode.view;
                });
                _resetForm();
              },
              child: const Text(
                'Kanseladu',
                style: TextStyle(
                  color: Color(0xFF6B57D2),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
