import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum VisibilityOption { everyone, nobody }

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = true;

  Map<String, Map<String, dynamic>> privacySettings = {
    'Imajen perfil': {
      'value': VisibilityOption.everyone,
      'icon': Icons.photo_outlined,
      'description': 'Ita-boot nia foto perfil',
      'field': 'profileVisibility'
    },
    'Atualizasaun kona-ba isin-rua': {
      'value': VisibilityOption.everyone,
      'icon': Icons.pregnant_woman_outlined,
      'description': 'Informasaun relasiona ho ita-boot nia isin-rua',
      'field': 'pregnancyVisibility'
    },
    'Númeru telefone': {
      'value': VisibilityOption.nobody,
      'icon': Icons.phone_outlined,
      'description': 'Ita-boot nia númeru kontaktu',
      'field': 'phoneVisibility'
    },
    'Enderessu': {
      'value': VisibilityOption.nobody,
      'icon': Icons.location_on_outlined,
      'description': 'Ita-boot nia enderesu rezidensiál',
      'field': 'addressVisibility'
    },
  };

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
  }

  Future<void> _loadPrivacySettings() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('settings')
            .doc('privacy')
            .get();

        if (doc.exists) {
          final data = doc.data()!;
          setState(() {
            for (var setting in privacySettings.entries) {
              final field = setting.value['field'] as String;
              if (data.containsKey(field)) {
                setting.value['value'] = data[field] == 'everyone'
                    ? VisibilityOption.everyone
                    : VisibilityOption.nobody;
              }
            }
          });
        }
      }
    } catch (e) {
      debugPrint('Erru iha karregamentu ba konfigurasaun privasidade nian: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _savePrivacySettings() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final Map<String, String> data = {};
        for (var setting in privacySettings.entries) {
          final field = setting.value['field'] as String;
          final value = setting.value['value'] as VisibilityOption;
          data[field] =
              value == VisibilityOption.everyone ? 'everyone' : 'nobody';
        }

        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('settings')
            .doc('privacy')
            .set(data, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Konfigurasaun privasidade sira salva ho susesu'),
            backgroundColor: Color(0xFF6B57D2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('La konsege rai konfigurasaun sira: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
          'Konfigurasaun Privasidade',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6B57D2),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _savePrivacySettings,
            child: const Text(
              'Salva',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildInfoCard(),
                      const SizedBox(height: 16),
                      _buildSettingsCard(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF6B57D2),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Column(
        children: [
          Icon(
            Icons.security_outlined,
            color: Colors.white,
            size: 48,
          ),
          SizedBox(height: 16),
          Text(
            'Hatur Ita-boot nia Privasidade Dadus',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Kontrola sé maka bele haree ita-boot nia informasaun pesoál',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B57D2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Color(0xFF6B57D2),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Informasaun Privasidade',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPrivacyLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyLegend() {
    return Column(
      children: [
        _buildLegendItem(
          Icons.public,
          'Ema hotu-hotu',
          'Vizivel ba utilizadór app hotu-hotu',
        ),
        const SizedBox(height: 12),
        _buildLegendItem(
          Icons.lock_outline,
          'Laiha ida',
          'Informasaun ne e sei subar husi uzuáriu sira hotu',
        ),
      ],
    );
  }

  Widget _buildLegendItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B57D2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.tune,
                    color: Color(0xFF6B57D2),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Konfigurasaun Vizibilidade',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...privacySettings.entries.map((entry) {
              return _buildPrivacyOption(
                entry.key,
                entry.value['value'] as VisibilityOption,
                entry.value['icon'] as IconData,
                entry.value['description'] as String,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyOption(
    String title,
    VisibilityOption currentValue,
    IconData icon,
    String description,
  ) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6B57D2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6B57D2),
              size: 24,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getVisibilityText(currentValue),
                style: TextStyle(
                  fontSize: 13,
                  color: _getVisibilityColor(currentValue),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          trailing: Switch(
            value: currentValue == VisibilityOption.everyone,
            onChanged: (bool value) {
              setState(() {
                privacySettings[title]?['value'] =
                    value ? VisibilityOption.everyone : VisibilityOption.nobody;
              });
            },
            activeColor: const Color(0xFF6B57D2),
          ),
        ),
        const Divider(),
      ],
    );
  }

  Color _getVisibilityColor(VisibilityOption visibility) {
    switch (visibility) {
      case VisibilityOption.everyone:
        return Colors.green;
      case VisibilityOption.nobody:
        return Colors.red;
    }
  }

  String _getVisibilityText(VisibilityOption visibility) {
    switch (visibility) {
      case VisibilityOption.everyone:
        return 'Ema hotu-hotu';
      case VisibilityOption.nobody:
        return 'Laiha ida';
    }
  }
}
