import 'package:flutter/material.dart';
import '../../../../../../widget/burger-navbar.dart';
import 'Meditation-screen.dart'; // Tambahkan import untuk MeditationScreen
import 'MentalHealthTest-screen.dart';
import 'ComplementaryTherapyScreen.dart';
import 'Counseling-screen.dart';

class MentalHealthScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MentalHealthScreen({super.key});

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
          'Terapia Komplementár sira',
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
        currentRoute: '/mental',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildMainContent(context),
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
            'Terapia Mentál no Komplementár sira',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Apoiu ba ita-boot nia moris di ak mentál no emosionál',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSection(
            title: 'Meditasaun no Relaxamentu',
            description:
                'Ezersísiu audio/video atu hamenus stress no ansiedade ba inan isin rua sira.',
            icon: Icons.self_improvement,
            color: Colors.blue,
            targetAudience: 'Inan isin-rua',
            supportText:
                'Ajuda inan isin-rua sira mantein moris di ak mentál durante isin-rua.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeditationScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: 'Teste Saúde Mentál',
            description:
                'Teste sira atu detekta ansiedade ka depresaun iha feto isin-rua sira.',
            icon: Icons.psychology,
            color: Colors.green,
            targetAudience: 'Inan isin-rua',
            supportText:
                'Avalia kondisaun mentál inan isin-rua nian no fó rekomendasaun ba apoiu.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MentalHealthTestScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: 'Terapia Komplementár',
            description:
                'Variedade terapia komplementer sira hanesan akupuntura, yoga no massagem ba inan isin-rua sira.',
            icon: Icons.spa_outlined,
            color: Colors.purple,
            targetAudience: 'Inan isin-rua',
            supportText:
                'Terapi natural no seguru atu hadia kualidade moris durante isin-rua.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComplementaryTherapyScreen(),
                ),
              );
            },
            featured: true,
            featuredInfo: 'Terapia naturál ne\'ebé komprovadu no seguru',
          ),
          const SizedBox(height: 16),
          _buildSection(
            title: 'Sesaun Konsellu Online Sira',
            description:
                'Fasilidade konsulta ho psikólogu ka konselleiru ba apoiu emosionál.',
            icon: Icons.support_agent,
            color: Colors.orange,
            targetAudience: 'Inan isin-rua',
            supportText:
                'Ajuda inan isin-rua sira ne ebé presiza apoiu emosionál no mentál.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CounselingScreen(),
                ),
              );
            },
            featured: true,
            featuredInfo: 'Konsulta profisionál sira disponivel 24/7',
          ),
          const SizedBox(height: 24),
          _buildTipsCard(),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String targetAudience,
    required String supportText,
    required VoidCallback onTap,
    bool featured = false,
    String? featuredInfo,
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
              if (featured && featuredInfo != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: color,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          featuredInfo,
                          style: TextStyle(
                            fontSize: 12,
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipsCard() {
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
                  'Hanoin sira ba Saúde Mentál',
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
                'Halo meditasaun badak ida loron-loron hodi hakalma ita-boot nia hanoin'),
            _buildTipItem(
                'Ko alia kona-ba ita-boot nia sentimentu sira ho ema sira ne ebé besik liu ba ita-boot'),
            _buildTipItem('Mantein padraun toba nian ne ebé regulár'),
            _buildTipItem(
                'Halo atividade sira ne ebé ita-boot gosta atu hamenus estrese'),
            _buildTipItem(
                'Lalika haluha atu buka ajuda profisionál se presiza'),
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
