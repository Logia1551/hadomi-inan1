import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _meditations = [];
  bool _isLoading = true;
  bool _mounted = true; // Add mounted flag

  @override
  void initState() {
    super.initState();
    _fetchMeditationData();
  }

  @override
  void dispose() {
    _mounted = false; // Set mounted flag to false when disposing
    super.dispose();
  }

  Future<void> _fetchMeditationData() async {
    if (!_mounted) return; // Check if widget is mounted before proceeding

    try {
      // Fetch categories
      final categoriesSnapshot =
          await _firestore.collection('meditation_categories').get();

      // Fetch meditations
      final meditationsSnapshot = await _firestore
          .collection('meditations')
          .orderBy('popularity', descending: true)
          .get();

      // Only call setState if the widget is still mounted
      if (_mounted) {
        setState(() {
          _categories = categoriesSnapshot.docs.map((doc) {
            return {
              ...doc.data(),
              'id': doc.id,
            };
          }).toList();

          _meditations = meditationsSnapshot.docs.map((doc) {
            return {
              ...doc.data(),
              'id': doc.id,
            };
          }).toList();

          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching meditation data: $e');
      // Only call setState if the widget is still mounted
      if (_mounted) {
        setState(() {
          _isLoading = false;
        });

        // Use BuildContext only if mounted
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('La konsege karrega dadus meditasaun nian: $e')),
          );
        }
      }
    }
  }

  void _playMeditation(String youtubeUrl) {
    // Extract video ID from YouTube URL
    final videoId = YoutubePlayer.convertUrlToId(youtubeUrl);

    if (videoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL vídeo nian ne ebé la válidu')),
      );
      return;
    }

    // Create YouTube Player Controller
    final YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );

    // Show YouTube Player in a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: YoutubePlayer(
          controller: controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: const Color(0xFF6B57D2),
          onReady: () {
            // Optional: Add any additional setup when video is ready
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Meditasaun no Relaxamentu',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6B57D2),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
            'Ezersísiu Meditasaun & Relaxamentu',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hetan kalma no dame liuhosi prátika ho orientasaun',
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeaturedMeditation(),
          const SizedBox(height: 24),
          const Text(
            'Kategoria Meditasaun',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 16),
          _buildCategoryGrid(),
          const SizedBox(height: 24),
          const Text(
            'Meditasaun ne ebé popular liu',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 16),
          _buildMeditationList(),
        ],
      ),
    );
  }

  Widget _buildFeaturedMeditation() {
    // Assuming first meditation or a specific featured meditation
    final featuredMeditation =
        _meditations.isNotEmpty ? _meditations.first : null;

    return featuredMeditation != null
        ? Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6B57D2), Color(0xFF8B7DDE)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              featuredMeditation['title'] ??
                                  'Meditasaun Loron-loron',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${featuredMeditation['duration'] ?? '10'} minutu • Orientadu',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () =>
                              _playMeditation(featuredMeditation['videoUrl']),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: () {
              // TODO: Implement category-specific meditation filtering
            },
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    IconData(category['iconCodePoint'] ?? Icons.spa.codePoint,
                        fontFamily: 'MaterialIcons'),
                    color: Color(category['color'] ?? Colors.blue.value),
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['title'] ?? 'Kategoria',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMeditationList() {
    return Column(
      children: _meditations.map((meditation) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: InkWell(
              onTap: () => _playMeditation(meditation['videoUrl']),
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(meditation['color'] ?? Colors.blue.value)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.headphones,
                        color: Color(meditation['color'] ?? Colors.blue.value),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meditation['title'] ?? 'Meditasaun',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${meditation['duration'] ?? '0'} minutu • ${meditation['instructor'] ?? 'Instrutór'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.play_circle_outline,
                      color: Color(meditation['color'] ?? Colors.blue.value),
                      size: 32,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
