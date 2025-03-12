import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart'; // Import package url_launcher
import 'ScheduleAppointment.dart';
import 'ConsultationChat-screen.dart';
import 'dart:convert';

class CounselingScreen extends StatefulWidget {
  const CounselingScreen({super.key});

  @override
  State<CounselingScreen> createState() => _CounselingScreenState();
}

class _CounselingScreenState extends State<CounselingScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _counselors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCounselors();
  }

  Future<void> _loadCounselors() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'doctor')
          .get();

      setState(() {
        _counselors = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id,
            'name': data['name'] ?? 'Unnamed',
            'specialization': data['specialty'] ?? 'General',
            'experience': data['experience'] ?? '0',
            'description': data['description'] ?? '',
            'available': data['isAvailable'] ?? false,
            'profileImage': data['profileImage'],
          };
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading counselors: $e');
      setState(() => _isLoading = false);
    }
  }

  // Fungsi untuk membuka aplikasi telepon
  Future<void> _launchEmergencyCall() async {
    const phoneNumber = 'tel:119'; // Format URL untuk telepon
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      // Tampilkan pesan error jika tidak bisa membuka aplikasi telepon
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Labele loke aplikasaun telefone nian'),
        ),
      );
    }
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF6B57D2),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Konsulta Online',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Konsulta ita-boot nia problema saúde mentál ho psikólogu profisionál ida',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Servisu konsulta disponivel 24/7 ba emerjénsia sira',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounselorCard(
      Map<String, dynamic> counselor, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: counselor['profileImage'] != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(
                        base64
                            .decode(counselor['profileImage'].split(',').last),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.person,
                                size: 40, color: Colors.grey),
                      ),
                    )
                  : const Icon(Icons.person, size: 40, color: Colors.grey),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    counselor['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    counselor['specialization'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 5),
                      Text(
                        '${counselor['experience']} tinan',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: counselor['available']
                  ? () => _showConsultationDialog(context, counselor)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B57D2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: Text(
                counselor['available'] ? 'Konsulta' : 'Sai',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableCounselors(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_counselors.isEmpty) {
      return const Center(
          child: Text('Laiha konselleiru sira ne ebé disponivel'));
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Konselleiru sira ne ebé disponivel',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 15),
          ..._counselors
              .map((counselor) => _buildCounselorCard(counselor, context)),
        ],
      ),
    );
  }

  Widget _buildScheduleSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Oráriu Konsulta nian',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Aranja oráriu konsulta nian tuir oras ne ebé ita-boot hakarak',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Hili Konselleiru ida'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _counselors
                        .where((counselor) => counselor['available'])
                        .map((counselor) => ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(counselor['name']),
                              subtitle: Text(counselor['specialization']),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ScheduleAppointment(
                                      selectedCounselor: counselor,
                                    ),
                                  ),
                                );
                              },
                            ))
                        .toList(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Kanseladu'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.calendar_today),
            label: const Text('Hatur Oráriu ida'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF6B57D2),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Color(0xFF6B57D2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContact() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emergency,
                color: Colors.red[700],
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                'Kontaktu sira Emerjénsia nian',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            'Se ita-boot presiza asisténsia imediata, favór ida liga ba ami nia númeru emerjénsia:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.red.shade200,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.phone,
                  color: Colors.red[700],
                ),
                const SizedBox(width: 10),
                Text(
                  '119',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _launchEmergencyCall, // Panggil fungsi di sini
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Kontaktu ami'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showConsultationDialog(
      BuildContext context, Map<String, dynamic> counselor) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Hahú Konsulta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ita-boot sei hahú ita-boot nia konsulta ho:'),
            const SizedBox(height: 10),
            Text(counselor['name'],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(counselor['specialization']),
            const SizedBox(height: 10),
            Text(counselor['description'],
                style: const TextStyle(fontSize: 14)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kanseladu'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConsultationChatScreen(
                    counselor: counselor,
                    chatId: '',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B57D2),
            ),
            child: const Text('Hahú Konsulta'),
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
          'Sesaun Konsellu Online sira',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6B57D2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .where('role', isEqualTo: 'doctor')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _counselors = snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return {
                'id': doc.id,
                'name': data['name'] ?? 'Unnamed',
                'specialization': data['specialty'] ?? 'General',
                'experience': data['experience'] ?? '0',
                'description': data['description'] ?? '',
                'available': data['isAvailable'] ?? false,
                'profileImage': data['profileImage'],
              };
            }).toList();
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                _buildAvailableCounselors(context),
                _buildScheduleSection(context),
                _buildEmergencyContact(),
              ],
            ),
          );
        },
      ),
    );
  }
}
