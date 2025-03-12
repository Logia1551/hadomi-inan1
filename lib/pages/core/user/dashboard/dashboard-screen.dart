import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import '../../../../widget/burger-navbar.dart';
import 'FetalDevelopmentDetail-screen.dart';
import '../profile/profile-screen.dart';
import 'chat-screen.dart';
import 'notification-screen.dart';
import 'doctor-consultation-screen.dart';
import '../mental/mental-screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _notificationCount = 3;
  Map<String, dynamic> _pregnancyData = {};
  Map<String, dynamic> _fetalData = {};
  String? _profileImageUrl;
  bool _isLoadingImage = true;
  bool _hasShownPromo = false;

  // Add mounted check flag
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true; // Set mounted flag to true
    _loadUserData();
    _initializeUserData();
    _checkUnreadNotifications();
    // Show promotion after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      if (_isMounted && !_hasShownPromo) {
        _showMentalHealthPromotion();
        if (_isMounted) {
          setState(() {
            _hasShownPromo = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _isMounted = false; // Set mounted flag to false
    super.dispose();
  }

  void _showMentalHealthPromotion() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.75), // Darker blur effect
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Add blur effect
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(dialogContext).size.width * 0.9,
                maxHeight: MediaQuery.of(dialogContext).size.height * 0.7,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with image
                  Stack(
                    children: [
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF6B57D2).withOpacity(0.2),
                              const Color(0xFF6B57D2).withOpacity(0.1),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.spa_outlined,
                                size: 80,
                                color: const Color(0xFF6B57D2).withOpacity(0.8),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.grey[700],
                            ),
                          ),
                          onPressed: () => Navigator.of(dialogContext).pop(),
                        ),
                      ),
                    ],
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    child: Column(
                      children: [
                        const Text(
                          'Terapia Komplementár sira',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Esplora serbisu terapia komplementer foun!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () =>
                                    Navigator.of(dialogContext).pop(),
                                style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: const Color(0xFF6B57D2)
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Depois',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF6B57D2),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MentalHealthScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6B57D2),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Esplora Agora',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _initializeUserData() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        final userData = userDoc.data() as Map<String, dynamic>;

        if (userData['isPregnant'] == true &&
            userData.containsKey('pregnancyDate')) {
          final pregnancyDate = DateTime.parse(userData['pregnancyDate']);

          final today = DateTime.now();
          final dueDate = pregnancyDate.add(const Duration(days: 280));
          final differenceInDays = today.difference(pregnancyDate).inDays;
          final currentWeek = (differenceInDays / 7).floor() + 1;

          final pregnancyData = {
            'currentWeek': currentWeek,
            'dueDate': '${dueDate.day}/${dueDate.month}/${dueDate.year}',
            'pregnancyDate': userData['pregnancyDate'],
            'lastUpdate': today,
          };

          await _firestore.collection('pregnancyData').doc(user.uid).set(
                pregnancyData,
                SetOptions(merge: true),
              );

          final fetalData = _getFetalDataForWeek(currentWeek);

          await _firestore.collection('fetalDevelopment').doc(user.uid).set(
            {
              ...fetalData,
              'lastUpdate': today,
            },
            SetOptions(merge: true),
          );

          _setupWeeklyDataUpdate(user.uid);
        }
      }
    } catch (e) {
      debugPrint('Error initializing user data: $e');
    }
  }

  Future<void> _setupWeeklyDataUpdate(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data() as Map<String, dynamic>;

      if (userData['isPregnant'] == true &&
          userData.containsKey('pregnancyDate')) {
        final pregnancyDate = DateTime.parse(userData['pregnancyDate']);
        final today = DateTime.now();
        final differenceInDays = today.difference(pregnancyDate).inDays;
        final currentWeek = (differenceInDays / 7).floor() + 1;

        final pregnancyDoc =
            await _firestore.collection('pregnancyData').doc(userId).get();

        if (pregnancyDoc.exists) {
          final data = pregnancyDoc.data() as Map<String, dynamic>;
          final lastUpdate = (data['lastUpdate'] as Timestamp).toDate();
          final daysSinceUpdate = today.difference(lastUpdate).inDays;

          if (daysSinceUpdate >= 7 && currentWeek < 40) {
            final dueDate = pregnancyDate.add(const Duration(days: 280));
            final updatedPregnancyData = {
              'currentWeek': currentWeek,
              'dueDate': '${dueDate.day}/${dueDate.month}/${dueDate.year}',
              'lastUpdate': today,
            };

            await _firestore
                .collection('pregnancyData')
                .doc(userId)
                .update(updatedPregnancyData);

            final fetalData = _getFetalDataForWeek(currentWeek);
            await _firestore.collection('fetalDevelopment').doc(userId).update({
              ...fetalData,
              'lastUpdate': today,
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Erru iha atualizasaun semanal: $e');
    }
  }

  Map<String, String> _getFetalDataForWeek(int week) {
    final Map<String, Map<String, String>> weeklyData = {
      '4': {
        'size': 'fini amapola',
        'length': '0.4 cm',
        'weight': '1 grama',
        'weightStatus': 'Dezenvolve ho normál',
      },
      '8': {
        'size': 'ervilla',
        'length': ' 1.6 cm',
        'weight': '3 grama',
        'weightStatus': 'Dezenvolve ho normál',
      },
      '12': {
        'size': ' jeruk nipis',
        'length': ' 5.4 cm',
        'weight': '14 grama',
        'weightStatus': 'Dezenvolve ho normál',
      },
      '16': {
        'size': ' alpukat',
        'length': ' 11.6 cm',
        'weight': '100 grama',
        'weightStatus': 'Dezenvolve ho normál',
      },
      '20': {
        'size': 'hudi',
        'length': ' 16.4 cm',
        'weight': '300 grama',
        'weightStatus': 'Dezenvolve ho normál',
      },
      '24': {
        'size': 'papaya',
        'length': ' 30 cm',
        'weight': '600 grama',
        'weightStatus': 'Dezenvolve ho normál',
      },
      '28': {
        'size': 'koko',
        'length': ' 37 cm',
        'weight': '1000 grama',
        'weightStatus': 'Dezenvolve ho normál',
      },
      '32': {
        'size': 'ai-nanas',
        'length': ' 42 cm',
        'weight': '1800 grama',
        'weightStatus': 'Dezenvolve ho normál',
      },
      '36': {
        'size': 'melon',
        'length': ' 47 cm',
        'weight': '2600 grama',
        'weightStatus': 'Dezenvolve ho normál',
      },
      '40': {
        'size': 'melon ki ik',
        'length': ' 51 cm',
        'weight': '3400 grama',
        'weightStatus': 'Dezenvolve ho normál',
      },
    };

    String closestWeek = '4';
    for (final dataWeek in weeklyData.keys) {
      if (week >= int.parse(dataWeek)) {
        closestWeek = dataWeek;
      } else {
        break;
      }
    }

    return weeklyData[closestWeek]!;
  }

  Widget _buildProfileImage() {
    if (_isLoadingImage) {
      return const SizedBox(
        width: 35,
        height: 35,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 2,
        ),
      );
    }

    return Container(
      width: 35,
      height: 35,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: _profileImageUrl != null && _profileImageUrl!.isNotEmpty
            ? _buildProfileImageContent()
            : Icon(
                Icons.person,
                size: 25,
                color: Colors.white,
              ),
      ),
    );
  }

  Widget _buildProfileImageContent() {
    if (_profileImageUrl == null || _profileImageUrl!.isEmpty) {
      return const Icon(
        Icons.person,
        size: 25,
        color: Colors.white,
      );
    }

    try {
      if (_profileImageUrl!.startsWith('data:image')) {
        final base64Data = _profileImageUrl!.split(',').length > 1
            ? _profileImageUrl!.split(',')[1]
            : _profileImageUrl!;

        return Image.memory(
          base64Decode(base64Data),
          width: 35,
          height: 35,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Erru iha karregamentu imajen base64: $error');
            return const Icon(
              Icons.person,
              size: 25,
              color: Colors.white,
            );
          },
        );
      } else if (_profileImageUrl!.startsWith('http')) {
        return Image.network(
          _profileImageUrl!,
          width: 35,
          height: 35,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Erru iha karregamentu imajen rede nian: $error');
            return const Icon(
              Icons.person,
              size: 25,
              color: Colors.white,
            );
          },
        );
      }
      return const Icon(
        Icons.person,
        size: 25,
        color: Colors.white,
      );
    } catch (e) {
      debugPrint(
          'Erru ne ebé la espera bainhira karrega imajen perfil nian: $e');
      return const Icon(
        Icons.person,
        size: 25,
        color: Colors.white,
      );
    }
  }

  Future<void> _loadUserData() async {
    if (!_isMounted) return; // Check if widget is still mounted

    if (_isMounted) {
      setState(() => _isLoadingImage = true);
    }

    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists && _isMounted) {
          final userData = userDoc.data() as Map<String, dynamic>;
          if (_isMounted) {
            setState(() {
              _profileImageUrl = userData['profileImage'] as String?;
            });
          }
        }

        // Load pregnancy data
        final pregnancyDoc =
            await _firestore.collection('pregnancyData').doc(user.uid).get();
        if (pregnancyDoc.exists && _isMounted) {
          setState(() {
            _pregnancyData = pregnancyDoc.data() as Map<String, dynamic>;
          });
        }

        // Load fetal development data
        final fetalDoc =
            await _firestore.collection('fetalDevelopment').doc(user.uid).get();
        if (fetalDoc.exists && _isMounted) {
          setState(() {
            _fetalData = fetalDoc.data() as Map<String, dynamic>;
          });
        }
      }
    } catch (e) {
      debugPrint('Erru iha karregamentu dadus utilizadór nian: $e');
    } finally {
      if (_isMounted) {
        setState(() => _isLoadingImage = false);
      }
    }
  }

  Future<void> _checkUnreadNotifications() async {
    if (!_isMounted) return; // Check if widget is still mounted

    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        int unreadCount = 0;

        // Check unread appointments
        final appointmentsSnapshot = await _firestore
            .collection('appointments')
            .where('userId', isEqualTo: user.uid)
            .where('isRead', isEqualTo: false)
            .get();
        unreadCount += appointmentsSnapshot.docs.length;

        // Check unread online classes
        final onlineClassesSnapshot = await _firestore
            .collection('online_classes')
            .where('isRead', isEqualTo: false)
            .get();
        unreadCount += onlineClassesSnapshot.docs.length;

        // Check unread articles
        final articlesSnapshot = await _firestore
            .collection('articles')
            .where('isRead', isEqualTo: false)
            .get();
        unreadCount += articlesSnapshot.docs.length;

        // Check unread videos
        final videosSnapshot = await _firestore
            .collection('videos')
            .where('isRead', isEqualTo: false)
            .get();
        unreadCount += videosSnapshot.docs.length;

        // Check unread meditations
        final meditationsSnapshot = await _firestore
            .collection('meditations')
            .where('isRead', isEqualTo: false)
            .get();
        unreadCount += meditationsSnapshot.docs.length;

        // Check unread supplements
        final supplementsSnapshot = await _firestore
            .collection('supplements')
            .where('userId', isEqualTo: user.uid)
            .where('isRead', isEqualTo: false)
            .get();
        unreadCount += supplementsSnapshot.docs.length;

        if (_isMounted) {
          setState(() {
            _notificationCount = unreadCount;
          });
        }
      }
    } catch (e) {
      debugPrint('Erru iha verifikasaun notifikasaun sira: $e');
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
          'Hadomi Inan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6B57D2),
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 26,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ),
                  ).then((value) {
                    _checkUnreadNotifications();
                  });
                },
              ),
              if (_notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                ).then((_) => _loadUserData());
              },
              child: _buildProfileImage(),
            ),
          ),
        ],
      ),
      drawer: BurgerNavBar(
        scaffoldKey: _scaffoldKey,
        currentRoute: '/dashboard',
      ),
      floatingActionButton: const FloatingMessageButton(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildMainContent(),
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
            'BENVINDO',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fatin seguru ida ba kura & kreximentu pesoál',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPregnancySummary(),
          const SizedBox(height: 16),
          _buildFetalDevelopment(),
        ],
      ),
    );
  }

  Widget _buildPregnancySummary() {
    final currentWeek = (_pregnancyData['currentWeek'] as num?)?.toInt() ?? 0;
    final dueDate = _pregnancyData['dueDate'] as String? ?? '-';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.favorite,
                  color: Color(0xFF6B57D2),
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Sumáriu Isin-rua nian',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoBox(
                  title: 'Idade Gestasionál',
                  value: '$currentWeek Domingu',
                  icon: Icons.calendar_today,
                  color: Colors.blue,
                ),
                const SizedBox(width: 16),
                _buildInfoBox(
                  title: 'Estimasaun Data Partus',
                  value: dueDate,
                  icon: Icons.child_care,
                  color: Colors.pink,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFetalDevelopment() {
    return Card(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.child_friendly,
                      color: Color(0xFF6B57D2),
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Dezenvolvimentu Fetál',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const FetalDevelopmentDetailScreen(),
                      ),
                    );
                  },
                  child: const Text('Detallus'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDevelopmentDetail(
              'Tamañu',
              _fetalData['size'] ?? '-',
              _fetalData['length'] ?? '-',
              Icons.straighten,
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildDevelopmentDetail(
              'Todan',
              _fetalData['weight'] ?? '-',
              _fetalData['weightStatus'] ?? '-',
              Icons.monitor_weight_outlined,
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
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
    );
  }

  Widget _buildDevelopmentDetail(
    String title,
    String value,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
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

class FloatingMessageButton extends StatelessWidget {
  const FloatingMessageButton({super.key});

  void _showMessageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Servisu Konsultasaun nian',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 20),
            _buildOptionItem(
              context,
              'Konsulta ho Médiku/Parteira',
              'Konversa ho pesoál médiku sira',
              Icons.medical_services_outlined,
              () => _openDoctorConsultation(context),
            ),
            _buildOptionItem(
              context,
              'Konversa ho Asistente AI',
              'Informasaun kona-ba saúde inan no bebé nian',
              Icons.smart_toy_outlined,
              () => _openChatbot(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF6B57D2).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF6B57D2),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D3142),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Color(0xFF6B57D2),
      ),
    );
  }

  void _openDoctorConsultation(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DoctorConsultationScreen(),
      ),
    );
  }

  void _openChatbot(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showMessageOptions(context),
      backgroundColor: const Color(0xFF6B57D2),
      child: const Icon(Icons.message_outlined),
    );
  }
}
