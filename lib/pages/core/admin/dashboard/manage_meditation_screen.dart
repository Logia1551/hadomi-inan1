import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum MeditationManageMode { view, add }

class ManageMeditationScreen extends StatefulWidget {
  final MeditationManageMode initialMode;

  const ManageMeditationScreen(
      {super.key, this.initialMode = MeditationManageMode.view});

  @override
  State<ManageMeditationScreen> createState() => _ManageMeditationScreenState();
}

class _ManageMeditationScreenState extends State<ManageMeditationScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _meditations = [];
  List<Map<String, dynamic>> _doctors = [];
  bool _isLoading = true;

  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Meditasaun Báziku',
      'iconCodePoint': Icons.spa.codePoint,
      'color': Colors.blue.value
    },
    {
      'title': 'Mindfulness',
      'iconCodePoint': Icons.self_improvement.codePoint,
      'color': Colors.green.value
    },
    {
      'title': 'Relaxamentu',
      'iconCodePoint': Icons.nights_stay.codePoint,
      'color': Colors.purple.value
    },
    {
      'title': 'Meditasaun Toba nian',
      'iconCodePoint': Icons.bedtime.codePoint,
      'color': Colors.indigo.value
    },
    {
      'title': 'Meditasaun dadeer nian',
      'iconCodePoint': Icons.wb_sunny.codePoint,
      'color': Colors.orange.value
    },
  ];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _videoUrlController = TextEditingController();

  String? _selectedCategory;
  String? _selectedDoctor;

  @override
  void initState() {
    super.initState();
    _fetchMeditationData();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    try {
      final doctorsSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'doctor')
          .get();

      setState(() {
        _doctors = doctorsSnapshot.docs.map((doc) {
          return {
            ...doc.data(),
            'id': doc.id,
          };
        }).toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error mengambil data dokter: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _fetchMeditationData() async {
    try {
      final meditationsSnapshot = await _firestore
          .collection('meditations')
          .orderBy('createdAt', descending: true)
          .get();

      setState(() {
        _meditations = meditationsSnapshot.docs.map((doc) {
          return {
            ...doc.data(),
            'id': doc.id,
          };
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAddMeditationDialog() {
    _titleController.clear();
    _durationController.clear();
    _videoUrlController.clear();
    _selectedCategory = null;
    _selectedDoctor = null;

    showDialog(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hatama Meditasaun Foun',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormField(
                            'Títulu Meditasaun nian',
                            TextField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                hintText: 'Hatama títulu meditasaun ida',
                                border: UnderlineInputBorder(),
                              ),
                            ),
                          ),
                          _buildFormField(
                            'Médiku/Parteira',
                            DropdownButtonFormField<String>(
                              value: _selectedDoctor,
                              decoration: const InputDecoration(
                                hintText: 'Hili Médiku/Parteira ida',
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.zero,
                              ),
                              isExpanded: true,
                              items: _doctors
                                  .map<DropdownMenuItem<String>>((doctor) {
                                return DropdownMenuItem<String>(
                                  value: doctor['name'],
                                  child: Text(
                                    doctor['name'],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedDoctor = newValue;
                                });
                              },
                            ),
                          ),
                          _buildFormField(
                            'Durasaun (minutus)',
                            TextField(
                              controller: _durationController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Durasaun meditasaun iha minutu',
                                border: UnderlineInputBorder(),
                              ),
                            ),
                          ),
                          _buildFormField(
                            'URL sira YouTube nian',
                            TextField(
                              controller: _videoUrlController,
                              decoration: const InputDecoration(
                                hintText:
                                    'Ligasaun ba vídeo YouTube ba meditasaun',
                                border: UnderlineInputBorder(),
                              ),
                            ),
                          ),
                          _buildFormField(
                            'Kategoria',
                            DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              decoration: const InputDecoration(
                                hintText: 'Hili kategoria meditasaun ida',
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.zero,
                              ),
                              isExpanded: true,
                              items: categories
                                  .map<DropdownMenuItem<String>>((category) {
                                return DropdownMenuItem<String>(
                                  value: category['title'] as String,
                                  child: Text(category['title'] as String),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCategory = newValue;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Kanseladu',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _saveMeditation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B57D2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Salva',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(String label, Widget field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          field,
        ],
      ),
    );
  }

  Future<void> _saveMeditation() async {
    if (_titleController.text.isEmpty ||
        _selectedDoctor == null ||
        _durationController.text.isEmpty ||
        _videoUrlController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Favor kompleta kampu hotu-hotu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final selectedCategoryData = categories.firstWhere(
        (category) => category['title'] == _selectedCategory,
      );

      await _firestore.collection('meditations').add({
        'title': _titleController.text,
        'instructor': _selectedDoctor,
        'duration': _durationController.text,
        'videoUrl': _videoUrlController.text,
        'category': _selectedCategory,
        'color': selectedCategoryData['color'],
        'iconCodePoint': selectedCategoryData['iconCodePoint'],
        'popularity': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.of(context).pop();
      await _fetchMeditationData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Meditasaun aumenta ho susesu'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('La konsege aumenta meditasaun: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteMeditation(String id) async {
    try {
      await _firestore.collection('meditations').doc(id).delete();
      await _fetchMeditationData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Meditasaun eliminadu ho susesu'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('La konsege hamoos meditasaun: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Jere Meditasaun',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6B57D2),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth > 600 ? 32 : 16,
                      vertical: 16,
                    ),
                    itemCount: _meditations.length,
                    itemBuilder: (context, index) {
                      final meditation = _meditations[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  Color(meditation['color']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              IconData(meditation['iconCodePoint'],
                                  fontFamily: 'MaterialIcons'),
                              color: Color(meditation['color']),
                            ),
                          ),
                          title: Text(
                            meditation['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '${meditation['instructor']} • ${meditation['duration']} minutu',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _deleteMeditation(meditation['id']),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMeditationDialog,
        backgroundColor: const Color(0xFF6B57D2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }
}
