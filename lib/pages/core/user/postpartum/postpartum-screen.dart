import 'package:flutter/material.dart';
import '../../../../../../widget/burger-navbar.dart';
import 'PostpartumRecoveryGuide-screen.dart'; // Sesuaikan path sesuai struktur folder
import 'newborncare-screen.dart';
import 'BreastfeedingGuide.dart';

class PostpartumScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PostpartumScreen({super.key});

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
          'Kuidadu Pós-Natal',
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
        currentRoute: '/postpartum',
      ),
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
            'Kuidadu Pós-Natal',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Matadalan kompletu ida ba rekuperasaun no kuidadu pós-partu',
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
    return Builder(
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSection(
                context: context,
                title: 'Matadalan ba Rekuperasaun Pós-Partu',
                description:
                    'Fó informasaun kona-ba isin-lolon nia rekuperasaun hafoin partu.',
                icon: Icons.healing,
                color: Colors.blue,
                targetAudience: 'Inan pós-partu',
                supportText:
                    'Ajuda inan foun sira iha prosesu rekuperasaun fíziku no emosionál hafoin partu.',
                features: [
                  'Rekuperasaun fíziku',
                  'Kuidadu ba kanek',
                  'Nutrisaun inan nian',
                  'saúde mentál',
                ],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PostpartumRecoveryGuide(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildSection(
                context: context,
                title: 'Kuidadu Bebé Foin Moris',
                description:
                    'Matadalan kuidadu ba bebé ne ebé foin moris hanesan fó-susu, hariis, nst.',
                icon: Icons.child_care,
                color: Colors.green,
                targetAudience: 'Inan pós-natal',
                supportText:
                    'Ajuda inan sira hodi tau matan ba bebé foin moris ho dixernimentu no trik prátiku sira.',
                features: [
                  'Oinsá atu hariis',
                  'Kuidadu ba tali umbilikál',
                  'Padraun toba bebé nian',
                  'Sinál sira hosi bebé ne ebé saudavel',
                ],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewbornCareGuide(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildSection(
                context: context,
                title: 'Fó Susubeen Inan no Konsulta Fó Susubeen Inan',
                description:
                    'Ajuda inan sira atu komprende téknika fó-susubeen inan nian ne ebé loos no fornese asesu ba konsultór laktasaun nian.',
                icon: Icons.pregnant_woman,
                color: Colors.orange,
                targetAudience: 'Inan sira ne ebé fó-susu',
                supportText:
                    'Ajuda inan sira iha prosesu fó-susubeen inan nian ho informasaun no apoiu direta hosi peritu sira.',
                features: [
                  'Tékniku sira fó-susubeen inan nian',
                  'Pozisaun loloos',
                  'Konsulta online',
                  'Solusaun ba problema susu-been inan nian',
                ],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BreastfeedingGuide(),
                    ),
                  );
                },
                featured: true,
              ),
              const SizedBox(height: 24),
              _buildRecoveryTipsCard(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection({
    required BuildContext context, // Tambahkan parameter context
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String targetAudience,
    required String supportText,
    required List<String> features,
    required VoidCallback onTap,
    bool featured = false,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: featured
                                ? color.withOpacity(0.1)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            targetAudience,
                            style: TextStyle(
                              fontSize: 12,
                              color: featured ? color : Colors.grey[600],
                              fontWeight: featured
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[400],
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                supportText,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: features
                    .map((feature) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            feature,
                            style: TextStyle(
                              fontSize: 12,
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecoveryTipsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: const Color(0xFF6B57D2).withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFF6B57D2),
                ),
                SizedBox(width: 8),
                Text(
                  'Hanoin sira ba rekuperasaun',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B57D2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTipItem(
                'Hetan deskansa ne ebé sufisiente bainhira bebé toba'),
            _buildTipItem('Han ai-han ne ebé nutritivu no hemu bee barak'),
            _buildTipItem('Halo kuidadu ba kanek beibeik'),
            _buildTipItem(
                'Keta laran rua-rua atu husu ajuda ba ita-boot nia família'),
            _buildTipItem(
                'Haree ba sinál sira infesaun nian ka komplikasaun sira'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '•',
            style: TextStyle(
              color: Color(0xFF6B57D2),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2D3142),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
