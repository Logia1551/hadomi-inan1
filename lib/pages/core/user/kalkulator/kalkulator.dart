import 'package:flutter/material.dart';
import '../../../../widget/burger-navbar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class PregnancyCalculatorScreen extends StatefulWidget {
  const PregnancyCalculatorScreen({super.key});

  @override
  State<PregnancyCalculatorScreen> createState() =>
      _PregnancyCalculatorScreenState();
}

class _PregnancyCalculatorScreenState extends State<PregnancyCalculatorScreen> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null); // Tambahkan ini
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? _selectedDate;
  String _estimatedDueDate = '';
  String _currentWeek = '';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6B57D2),
              onPrimary: Colors.white,
              onSurface: Color(0xFF2D3142),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _calculateDueDate();
      });
    }
  }

  void _calculateDueDate() {
    if (_selectedDate != null) {
      // Menghitung perkiraan tanggal kelahiran (40 minggu dari HPHT)
      final dueDate = _selectedDate!.add(const Duration(days: 280));

      // Format tanggal untuk ditampilkan
      final formatter = DateFormat('dd MMMM yyyy', 'id_ID');
      _estimatedDueDate = formatter.format(dueDate);

      // Menghitung usia kehamilan saat ini
      final today = DateTime.now();
      final difference = today.difference(_selectedDate!).inDays;
      final weeks = difference ~/ 7;
      final days = difference % 7;

      setState(() {
        _currentWeek = 'Idade gestasionál: $weeks Domingu $days loron';
      });
    }
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
          'Kalkuladór Isin-rua nian',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6B57D2),
        elevation: 0,
      ),
      drawer: BurgerNavBar(
        scaffoldKey: _scaffoldKey,
        currentRoute: '/calculator',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildCalculator(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
            'Data Moris Estimadu',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kalkula ita-boot nia bebé nia data partu ne ebé kalkula ona',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculator() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tama ba Loron Dahuluk Menstruasaun Ikus nian (HPHT)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF6B57D2).withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Color(0xFF6B57D2),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _selectedDate == null
                                ? 'Hili Data'
                                : DateFormat('dd MMMM yyyy', 'id_ID')
                                    .format(_selectedDate!),
                            style: TextStyle(
                              fontSize: 16,
                              color: _selectedDate == null
                                  ? Colors.grey
                                  : const Color(0xFF2D3142),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (_estimatedDueDate.isNotEmpty) ...[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rezultadu sira Kálkulu nian',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildResultItem(
                      'Data Moris Estimadu',
                      _estimatedDueDate,
                      Icons.child_care,
                    ),
                    const SizedBox(height: 15),
                    _buildResultItem(
                      'Idade Gestasionál',
                      _currentWeek,
                      Icons.calendar_today,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xFF6B57D2),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Rejistu Vitál sira',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Rezultadu husi kalkulasaun sira ne’e hanesan estimativa de’it. Data moris loloos sei determina hosi médiku liuhosi ezame ultrasonografia no ezame fíziku.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF6B57D2).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF6B57D2),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
