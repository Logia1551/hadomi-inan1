import 'package:flutter/material.dart';

class BreastfeedingGuide extends StatelessWidget {
  const BreastfeedingGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Matadalan Fó Susubeen Inan nian',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6B57D2),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildContentSections(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF6B57D2),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: const Text(
        'Matadalan kompletu ba tékniku sira fó-susubeen inan nian no informasaun kona-ba konsulta kona-ba laktasaun',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContentSections() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildGuideSection(
            title: 'Tékniku sira fó-susubeen-inan nian',
            description:
                'Matadalan ba pozisaun no métodu fó susubeen inan nian ne ebé loos',
            icon: Icons.baby_changing_station,
            color: Colors.blue,
            recommendations: [
              'Pozisiona bebé paralelu ho susun',
              'Asegura katak bebé nia ibun nakloke luan',
              'Ibun-been no areola tomak tama iha bebé nia ibun',
              'Bebé nia kidun taka metin ba susun',
              'Bebé nia ibun nakloke'
            ],
            notes:
                'Pozisaun loos sei halo susu-been inan sai konfortavel no efetivu liu.',
          ),
          const SizedBox(height: 16),
          _buildGuideSection(
            title: 'Pozisaun Fó Susubeen Inan',
            description:
                'Pozisaun oioin ne ebé konfortavel hodi fó-susubeen inan',
            icon: Icons.pregnant_woman,
            color: Colors.green,
            recommendations: [
              'Pozisaun kous ho halo toba',
              'Pozisaun kaer futeból',
              'Pozisaun toba iha sorin',
              'Pozisaun tuur ho travesseiru fó-susubeen inan nian',
              'Pozisaun fó-susubeen inan nian ne ebé deskansa'
            ],
            notes: 'Koko pozisaun oioin atu hetan ida ne ebé konfortavel liu.',
          ),
          const SizedBox(height: 16),
          _buildGuideSection(
            title: 'Kuidadu ba Susun',
            description: 'Oinsá kuidadu susun durante fó-susu',
            icon: Icons.healing,
            color: Colors.orange,
            recommendations: [
              'Mantein ó-nia susun moos',
              'Uza sutiã ne ebé konfortavel no suporta',
              'Aplika susubeen inan nian ba susun ne ebé moras',
              'Kompresa manas molok fó susu',
              'Kompresa malirin hodi hamenus bubu'
            ],
            notes:
                'Kuidadu ba inan ne ebé di ak prevene problema sira iha fó-susubeen inan nian.',
          ),
          const SizedBox(height: 16),
          _buildGuideSection(
            title: 'Konsulta Laktasaun',
            description: 'Servisu konsulta ho peritu sira kona-ba laktasaun',
            icon: Icons.medical_services,
            color: Colors.purple,
            recommendations: [
              'Konsultasaun online liuhosi aplikasaun',
              'Vizita konsultór ba uma',
              'Konsulta iha klínika laktasaun nian',
              'Grupu apoiu ba maluk inan sira ne ebé fó susu',
              'Fórum husu no hatán ho peritu sira'
            ],
            notes:
                'Labele baruk atu konsulta karik ita iha difikuldade atu fó susubeen inan ba bebé.',
          ),
          const SizedBox(height: 24),
          _buildCommonIssuesCard(),
        ],
      ),
    );
  }

  Widget _buildGuideSection({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required List<String> recommendations,
    required String notes,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Row(
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
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Guia:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...recommendations.map((recommendation) => Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                recommendation,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF2D3142),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: color,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            notes,
                            style: TextStyle(
                              fontSize: 14,
                              color: color.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommonIssuesCard() {
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
                  Icons.help_outline,
                  color: Color(0xFF6B57D2),
                ),
                SizedBox(width: 8),
                Text(
                  'Problema Komún sira',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B57D2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildIssueItem('Susin-been ne ebé moras ka moras'),
            _buildIssueItem('Susun ne ebé book an'),
            _buildIssueItem('Susubeen inan nian la to o'),
            _buildIssueItem('Bebé iha difikuldade atu susu'),
            _buildIssueItem('Mastite ka inflamasaun iha susun'),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueItem(String text) {
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
