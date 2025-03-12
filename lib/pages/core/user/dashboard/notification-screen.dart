import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import necessary screens for navigation
import '../reminder/reminder-screen.dart';
import '../education/onlineclass-screen.dart';
import '../education/articlevideo-screen.dart';
import 'doctor-consultation-screen.dart';
import '../mental/meditation-screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  // Helper method to handle different timestamp formats
  DateTime? _getTimestamp(dynamic timestamp) {
    if (timestamp == null) return null;
    try {
      if (timestamp is Timestamp) {
        return timestamp.toDate();
      } else if (timestamp is DateTime) {
        return timestamp;
      } else if (timestamp is String) {
        // Coba parsing berbagai format string
        return DateTime.tryParse(timestamp);
      } else if (timestamp is int) {
        // Untuk timestamp dalam milidetik
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else if (timestamp is Map) {
        // Handle Firestore timestamp map format
        if (timestamp['_seconds'] != null) {
          return DateTime.fromMillisecondsSinceEpoch(
              (timestamp['_seconds'] as int) * 1000);
        }
      }
    } catch (e) {
      print('Error parsing timestamp: $e');
    }
    return null;
  }

  Future<void> _deleteNotification(Map<String, dynamic> notification) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // Delete notification status document
      await _firestore
          .collection('notification_status')
          .doc('${notification['id']}_${user.uid}')
          .delete();

      // For user-specific notifications (supplements and appointments), delete the actual data
      if (notification['type'] == 'supplement') {
        await _firestore
            .collection('supplements')
            .doc(notification['id'])
            .delete();
      } else if (notification['type'] == 'appointment') {
        await _firestore
            .collection('appointments')
            .doc(notification['id'])
            .delete();
      }

      // Create a deleted_notifications collection to track deleted notifications
      await _firestore.collection('deleted_notifications').add({
        'userId': user.uid,
        'notificationId': notification['id'],
        'type': notification['type'],
        'deletedAt': FieldValue.serverTimestamp(),
      });

      // Update local state
      setState(() {
        _notifications.remove(notification);
      });
    } catch (e) {
      print('Error deleting notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La konsege hamoos notifikasaun'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _markNotificationAsRead(
      Map<String, dynamic> notification) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('notification_status')
            .doc('${notification['id']}_${user.uid}')
            .set({
          'notificationId': notification['id'],
          'userId': user.uid,
          'isRead': true,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      setState(() {
        notification['isRead'] = true;
      });
    } catch (e) {
      print('Erru marka notifikasaun hanesan lee ona: $e');
    }
  }

  Future<bool> _checkIfRead(String notificationId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final doc = await _firestore
          .collection('notification_status')
          .doc('${notificationId}_${user.uid}')
          .get();

      return doc.exists && (doc.data()?['isRead'] ?? false);
    } catch (e) {
      print('Erru hodi verifika estatutu lee nian: $e');
      return false;
    }
  }

  Future<void> _fetchNotifications() async {
    try {
      print('Fetching notifications start');
      List<Map<String, dynamic>> notifications = [];
      final user = _auth.currentUser;

      print('Fetching global notifications');
      await _fetchGlobalNotifications(notifications);

      if (user != null) {
        print('Fetching user notifications for ${user.uid}');
        await _fetchUserNotifications(notifications, user.uid);

        final deletedDocs = await _firestore
            .collection('deleted_notifications')
            .where('userId', isEqualTo: user.uid)
            .get();

        final deletedIds = deletedDocs.docs
            .map((doc) => doc.data()['notificationId'] as String)
            .toSet();
        notifications.removeWhere((n) => deletedIds.contains(n['id']));
      }

      // Sorting dengan null check tambahan
      notifications.sort((a, b) {
        final aTime = _getTimestamp(a['timestamp']) ?? DateTime.now();
        final bTime = _getTimestamp(b['timestamp']) ?? DateTime.now();
        return bTime.compareTo(aTime);
      });

      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
      print('Fetched ${notifications.length} notifications');
    } catch (e) {
      print('Error fetching notifications: $e');
      setState(() {
        _notifications = [];
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat notifikasi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchGlobalNotifications(
      List<Map<String, dynamic>> notifications) async {
    // Fetch Online Classes (Global)
    final onlineClassesSnapshot = await _firestore
        .collection('online_classes')
        .orderBy('date', descending: true)
        .limit(3)
        .get();

    for (var doc in onlineClassesSnapshot.docs) {
      final data = doc.data();
      final isRead = await _checkIfRead(doc.id);
      final timestamp = _getTimestamp(data['date']) ?? DateTime.now();

      notifications.add({
        'id': doc.id,
        'type': 'online_class',
        'title': 'Klase Online Foun sira',
        'message': data['title'] ?? 'Klase Foun',
        'icon': Icons.videocam,
        'color': Colors.green,
        'isRead': isRead,
        'timestamp': timestamp,
        'onTap': () {
          _markNotificationAsRead(notifications.last);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OnlineClassScreen()),
          );
        },
      });
    }

    // Fetch Articles (Global)
    final articlesSnapshot = await _firestore
        .collection('articles')
        .orderBy('date', descending: true)
        .limit(3)
        .get();

    for (var doc in articlesSnapshot.docs) {
      final data = doc.data();
      final isRead = await _checkIfRead(doc.id);
      final timestamp = _getTimestamp(data['date']) ?? DateTime.now();

      notifications.add({
        'id': doc.id,
        'type': 'article',
        'title': 'Artikel Terbaru',
        'message': data['title'] ?? 'Artikel Baru',
        'icon': Icons.article,
        'color': Colors.orange,
        'isRead': isRead,
        'timestamp': timestamp,
        'onTap': () {
          _markNotificationAsRead(notifications.last);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ArticleVideoScreen()),
          );
        },
      });
    }

    // Fetch Videos (Global)
    final videosSnapshot = await _firestore
        .collection('videos')
        .orderBy('date', descending: true)
        .limit(3)
        .get();

    for (var doc in videosSnapshot.docs) {
      final data = doc.data();
      final isRead = await _checkIfRead(doc.id);
      final timestamp = _getTimestamp(data['date']) ?? DateTime.now();

      notifications.add({
        'id': doc.id,
        'type': 'video',
        'title': 'Vídeo sira ikus liu',
        'message': data['title'] ?? 'Vídeo Foun sira',
        'icon': Icons.video_library,
        'color': Colors.red,
        'isRead': isRead,
        'timestamp': timestamp,
        'onTap': () {
          _markNotificationAsRead(notifications.last);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ArticleVideoScreen()),
          );
        },
      });
    }

    // Fetch Meditations (Global)
    final meditationsSnapshot = await _firestore
        .collection('meditations')
        .orderBy('createdAt', descending: true)
        .limit(3)
        .get();

    for (var doc in meditationsSnapshot.docs) {
      final data = doc.data();
      final timestamp = _getTimestamp(data['createdAt']) ?? DateTime.now();
      final isRead = await _checkIfRead(doc.id);

      if (DateTime.now().difference(timestamp).inDays <= 7) {
        notifications.add({
          'id': doc.id,
          'type': 'meditation',
          'title': 'Meditasaun Foun',
          'message':
              'Meditasaun foun: ${data['title'] ?? 'La ho títulu'} ho ${data['instructor'] ?? 'Instrutór'}',
          'icon': Icons.self_improvement,
          'color': Colors.teal,
          'isRead': isRead,
          'timestamp': timestamp,
          'onTap': () {
            _markNotificationAsRead(notifications.last);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MeditationScreen()),
            );
          },
        });
      }
    }
  }

  Future<void> _fetchUserNotifications(
      List<Map<String, dynamic>> notifications, String userId) async {
    // Fetch Supplements (User-specific)
    final supplementsSnapshot = await _firestore
        .collection('supplements')
        .where('userId', isEqualTo: userId)
        .get();

    for (var doc in supplementsSnapshot.docs) {
      final data = doc.data();
      final isRead = await _checkIfRead(doc.id);
      final timestamp = _getTimestamp(data['createdAt']) ?? DateTime.now();

      notifications.add({
        'id': doc.id,
        'type': 'supplement',
        'title': 'Lembransa kona-ba Vitamina',
        'message':
            'Tempu atu hemu ${data['name'] ?? 'Vitamin'} tuku ${data['time']?['hour'] ?? '00'}:${data['time']?['minute'] ?? '00'}',
        'icon': Icons.medication,
        'color': Colors.purple,
        'isRead': isRead,
        'timestamp': timestamp,
        'onTap': () {
          _markNotificationAsRead(notifications.last);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReminderScreen()),
          );
        },
      });
    }

    // Fetch Appointments (User-specific)
    final appointmentsSnapshot = await _firestore
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .get();

    for (var doc in appointmentsSnapshot.docs) {
      final data = doc.data();
      final timestamp = _getTimestamp(data['date']) ?? DateTime.now();
      final isRead = await _checkIfRead(doc.id);

      final daysDifference = timestamp.difference(DateTime.now()).inDays;

      notifications.add({
        'id': doc.id,
        'type': 'appointment',
        'title': 'Oráriu Konsulta nian',
        'message':
            'Konsulta ho ${data['doctor'] ?? 'Dotor'} iha laran ${daysDifference + 1} loron',
        'icon': Icons.calendar_today,
        'color': Colors.blue,
        'isRead': isRead,
        'timestamp': timestamp,
        'onTap': () {
          _markNotificationAsRead(notifications.last);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const DoctorConsultationScreen()),
          );
        },
      });
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        for (var notification in _notifications) {
          await _markNotificationAsRead(notification);
        }

        // Refresh notifications
        await _fetchNotifications();
      }
    } catch (e) {
      print('Erru bainhira marka notifikasaun hotu-hotu hanesan lee ona: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('La konsege marka notifikasaun hotu-hotu: $e'),
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
          'Notifikasaun sira',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6B57D2),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text(
              'Mark Read',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_notifications.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: ListView.builder(
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              final notification = _notifications[index];
              return _buildNotificationItem(notification);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF6B57D2),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNotificationStat(
            'Foun',
            _notifications
                .where((n) => !(n['isRead'] ?? false))
                .length
                .toString(),
            Icons.notifications_active,
          ),
          _buildNotificationStat(
            'Totál',
            _notifications.length.toString(),
            Icons.notifications,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationStat(String label, String count, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    return Dismissible(
      key: Key(notification['id']),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Konfirmasaun'),
              content: const Text(
                  'Ita-boot iha serteza katak ita-boot hakarak hamoos notifikasaun ida-ne e?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Kanseladu'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Hamoos'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) async {
        await _deleteNotification(notification);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notifikasaun hasai tiha ona'),
            action: SnackBarAction(
              label: 'Hasai',
              onPressed: () {
                _fetchNotifications();
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: notification['isRead'] == true
              ? Colors.white
              : const Color(0xFFF0EEFF),
          borderRadius: BorderRadius.circular(12),
          border: notification['isRead'] == true
              ? null
              : Border.all(color: const Color(0xFF6B57D2).withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (!(notification['isRead'] ?? false))
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B57D2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                ),
              ),
            ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: notification['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  notification['icon'],
                  color: notification['color'],
                  size: 24,
                ),
              ),
              title: Text(
                notification['title'],
                style: TextStyle(
                  fontWeight: notification['isRead'] == true
                      ? FontWeight.w500
                      : FontWeight.bold,
                  fontSize: 16,
                  color: notification['isRead'] == true
                      ? Colors.black87
                      : const Color(0xFF2D3142),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    notification['message'],
                    style: TextStyle(
                      color: notification['isRead'] == true
                          ? Colors.grey[600]
                          : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (!(notification['isRead'] ?? false))
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B57D2).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Foun',
                            style: TextStyle(
                              color: Color(0xFF6B57D2),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                _markNotificationAsRead(notification);
                notification['onTap']();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Laiha notifikasaun',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ita-boot sei haree notifikasaun ida iha ne e',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
