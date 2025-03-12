import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class DoctorEditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> initialData;

  const DoctorEditProfileScreen({Key? key, required this.initialData})
      : super(key: key);

  @override
  _DoctorEditProfileScreenState createState() =>
      _DoctorEditProfileScreenState();
}

class _DoctorEditProfileScreenState extends State<DoctorEditProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _specialtyController;
  late TextEditingController _experienceController;
  late TextEditingController _descriptionController;

  String? _profileImageBase64;
  File? _selectedImageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialData['name'] ?? '');
    _specialtyController =
        TextEditingController(text: widget.initialData['specialty'] ?? '');
    _experienceController = TextEditingController(
        text: (widget.initialData['experience'] ?? 0).toString());
    _descriptionController =
        TextEditingController(text: widget.initialData['description'] ?? '');
    _profileImageBase64 = widget.initialData['profileImage'];
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImageFile = File(image.path);
        _profileImageBase64 = null;
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';
      return base64Image;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _saveProfile() async {
    if (!_validateInputs()) return;

    setState(() => _isLoading = true);

    try {
      final user = _auth.currentUser;
      if (user == null) {
        _showErrorMessage('Utilizadór la autentikadu');
        return;
      }

      // Upload image if a new image is selected
      String? imageUrl;
      if (_selectedImageFile != null) {
        imageUrl = await _uploadImage(_selectedImageFile!);
      } else {
        // Use existing image if no new image is selected
        imageUrl = _profileImageBase64;
      }

      await _firestore.collection('users').doc(user.uid).update({
        'name': _nameController.text.trim(),
        'specialty': _specialtyController.text.trim(),
        'experience': int.parse(_experienceController.text.trim()),
        'description': _descriptionController.text.trim(),
        'profileImage': imageUrl,
      });

      _showSuccessMessage('Perfil atualiza ho susesu');
      Navigator.pop(context);
    } catch (e) {
      _showErrorMessage('La konsege atualiza perfil: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool _validateInputs() {
    if (_nameController.text.trim().isEmpty) {
      _showErrorMessage('Naran labele mamuk');
      return false;
    }

    try {
      int.parse(_experienceController.text.trim());
    } catch (e) {
      _showErrorMessage('Esperiénsia tenke sai númeru ida');
      return false;
    }

    return true;
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hadi a Médiku nia Perfil',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF6B57D2),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Foto Profil
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _selectedImageFile != null
                        ? FileImage(_selectedImageFile!)
                        : (_profileImageBase64 != null
                            ? MemoryImage(base64Decode(
                                _profileImageBase64!.contains(',')
                                    ? _profileImageBase64!.split(',').last
                                    : _profileImageBase64!))
                            : null),
                    child: _selectedImageFile == null &&
                            _profileImageBase64 == null
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFF6B57D2),
                      radius: 20,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 20),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Form Input
            _buildTextField(
              controller: _nameController,
              labelText: 'Naran kompletu',
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _descriptionController,
              labelText: 'Deskrisaun',
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Tombol Simpan
            ElevatedButton(
              onPressed: _isLoading ? null : _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B57D2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Rai Mudansa sira',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    int? maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _experienceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
