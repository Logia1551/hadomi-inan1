import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatefulWidget {
  final String doctorId;

  const AppointmentScreen({Key? key, required this.doctorId}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TabController _tabController;
  final List<String> _statusFilter = ['pending', 'completed', 'canceled'];
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _tabController.dispose();
    super.dispose();
  }

  void _showSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    if (!_isDisposed && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(fontSize: 16),
          ),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: backgroundColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _updateAppointmentStatus(
      String appointmentId, String status, BuildContext context) async {
    if (!mounted) return;

    try {
      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      _showSnackBar(
        context,
        status == 'completed'
            ? 'Nomeasaun ne e remata ona'
            : 'Nomeasaun ne e kansela tiha ona',
        status == 'completed' ? Colors.green : Colors.red,
      );
    } catch (e) {
      if (!mounted) return;

      _showSnackBar(
        context,
        'Error: $e',
        Colors.red,
      );
    }
  }

  void _showConfirmationDialog(BuildContext context, String appointmentId,
      String status, String patientName) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Use separate context for dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            status == 'completed'
                ? 'Konfirma Kompletu'
                : 'Konfirma Kanselamentu',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B57D2),
            ),
          ),
          content: Text(
            status == 'completed'
                ? 'Ita-boot iha serteza katak ita-boot hakarak marka ita-boot nia konsulta ho $patientName hanesan kompletu ona?'
                : 'Ita-boot iha serteza katak ita-boot hakarak kansela ita-boot nia konsulta ho $patientName?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Lae',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _updateAppointmentStatus(appointmentId, status, context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    status == 'completed' ? Colors.green : Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Sin',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAppointmentCard(
      Map<String, dynamic> appointment, String appointmentId) {
    final DateTime appointmentDate =
        DateFormat('yyyy-MM-dd').parse(appointment['date']);
    final bool isPastAppointment = appointmentDate.isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF6B57D2).withOpacity(0.1),
              radius: 25,
              child: Text(
                appointment['patientName']?[0] ?? '?',
                style: const TextStyle(
                  color: Color(0xFF6B57D2),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            title: Text(
              appointment['patientName'] ?? 'Pasiente deskoñesidu',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd MMMM yyyy').format(appointmentDate),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      appointment['time'],
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(appointment['status'])
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getStatusText(appointment['status']),
                        style: TextStyle(
                          color: _getStatusColor(appointment['status']),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (isPastAppointment && appointment['status'] == 'pending')
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Oráriu liu ona',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            trailing: appointment['status'] == 'pending' && !isPastAppointment
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_circle_outline),
                        color: Colors.green,
                        onPressed: () => _showConfirmationDialog(
                          context,
                          appointmentId,
                          'completed',
                          appointment['patientName'],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel_outlined),
                        color: Colors.red,
                        onPressed: () => _showConfirmationDialog(
                          context,
                          appointmentId,
                          'canceled',
                          appointment['patientName'],
                        ),
                      ),
                    ],
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Hein';
      case 'completed':
        return 'Remata';
      case 'canceled':
        return 'Kanseladu';
      default:
        return 'Deskonese';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Oráriu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6B57D2),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Hein'),
            Tab(text: 'Remata'),
            Tab(text: 'Kanseladu'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _statusFilter.map((status) {
          return StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('appointments')
                .where('doctorId', isEqualTo: widget.doctorId)
                .where('status', isEqualTo: status)
                .orderBy('date', descending: true)
                .orderBy('time')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF6B57D2),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 48, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        status == 'pending'
                            ? Icons.calendar_today
                            : status == 'completed'
                                ? Icons.check_circle
                                : Icons.cancel,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        status == 'pending'
                            ? 'Laiha nomeasaun pendente sira'
                            : status == 'completed'
                                ? 'Laiha konsulta sira ne ebé kompleta ona'
                                : 'Laiha konsulta ruma maka kansela',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final appointment =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  final appointmentId = snapshot.data!.docs[index].id;
                  return _buildAppointmentCard(appointment, appointmentId);
                },
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
