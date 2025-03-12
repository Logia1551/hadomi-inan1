import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditPasswordSecurityScreen extends StatefulWidget {
  const EditPasswordSecurityScreen({super.key});

  @override
  State<EditPasswordSecurityScreen> createState() =>
      _EditPasswordSecurityScreenState();
}

class _EditPasswordSecurityScreenState
    extends State<EditPasswordSecurityScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Troka Senha',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6B57D2),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildPasswordField(
                  'Password tuan',
                  _oldPasswordController,
                  _obscureOldPassword,
                  () => setState(
                      () => _obscureOldPassword = !_obscureOldPassword),
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  'Senha Foun',
                  _newPasswordController,
                  _obscureNewPassword,
                  () => setState(
                      () => _obscureNewPassword = !_obscureNewPassword),
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  'Konfirma Senha Foun',
                  _confirmPasswordController,
                  _obscureConfirmPassword,
                  () => setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updatePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B57D2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _isLoading ? 'Prosesamentu...' : 'Rai Mudansa sira',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool obscureText,
    VoidCallback onToggle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _updatePassword() async {
    // Input validation
    if (_oldPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showErrorDialog('Kampu hotu-hotu tenke prenxe');
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showErrorDialog('Senha foun no senha ne ebé konfirmadu la hanesan');
      return;
    }

    if (_newPasswordController.text.length < 6) {
      _showErrorDialog('Password foun tenke iha mínimu karakter 6');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Get current user
      final User? user = _auth.currentUser;
      if (user == null) {
        _showErrorDialog('Sesaun login remata ona. Favor tama fali.');
        return;
      }

      // Create credentials with old password
      final AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _oldPasswordController.text,
      );

      // Reauthenticate user
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(_newPasswordController.text);

      // Show success dialog
      if (mounted) {
        _showSuccessDialog();
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'wrong-password':
          message = 'Password tuan la loos';
          break;
        case 'weak-password':
          message = 'Password foun fraku liu';
          break;
        case 'requires-recent-login':
          message = 'Favor halo login fila fali atu muda senha';
          break;
        default:
          message = 'Iha erru ida: ${e.message}';
      }
      _showErrorDialog(message);
    } catch (e) {
      _showErrorDialog('Erru deskoñesidu ida akontese');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erru'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Susesu'),
        content: const Text('Muda ona liafuan-xave ho susesu'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to profile screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
