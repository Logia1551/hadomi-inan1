import 'package:flutter/material.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

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
          'Matadalan Preparasaun ba Partu',
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
        'Matadalan kompletu kona-ba preparasaun ba partu',
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
            title: 'Téknika Respirasaun',
            description: 'Matadalan ba tékniku halimar nian hodi hamenus moras',
            icon: Icons.air,
            color: Colors.blue,
            recommendations: [
              'Respirasaun klean no lalais durante kontrasaun sira',
              'Respirasaun klean no regulár durante relaxamentu',
              'Kombinasaun halimar ho movimentu isin nian',
              'Ezersísiu respiratóriu diafragmátiku',
              'Tekniku hatun iss ho neneik'
            ],
            notes:
                'Tékniku respirasaun ne ebé loos bele ajuda kontrola moras no fornese oksijéniu ne ebé sufisiente ba inan no bebé.',
          ),
          const SizedBox(height: 16),
          _buildGuideSection(
            title: 'Pozisaun Traballu',
            description: 'Pozisaun oioin ne ebé bele ajuda prosesu partu',
            icon: Icons.accessibility_new,
            color: Colors.green,
            recommendations: [
              'Pozisaun la o ka hamriik',
              'Pozisaun rasta ka hakneak',
              'Pozisaun inklinasaun karuk',
              'Pozisaun tuur metade',
              'Pozisaun squat ho apoiu'
            ],
            notes:
                'Pozisaun ida-idak iha nia benefísiu rasik, hili ida ne ebé konfortavel no apropriadu liu ba kondisaun sira.',
          ),
          const SizedBox(height: 16),
          _buildGuideSection(
            title: 'Sinál sira Traballu nian',
            description: 'Rekoñese sinál dahuluk sira partu nian',
            icon: Icons.medical_information,
            color: Colors.orange,
            recommendations: [
              'Kontraksaun regulár no maka as ba beibeik',
              'Deskarga husi mukus ne ebé kahur ho raan',
              'Ruptura líkidu amniótiku',
              'Moras iha kotuk-laran ne ebé maka as',
              'Sentimentu presaun iha pelvis'
            ],
            notes:
                'Komprende sinál sira-ne e atu hatene bainhira maka atu bá ospitál.',
          ),
          const SizedBox(height: 16),
          _buildGuideSection(
            title: 'Preparasaun Mentál',
            description: 'Hanoin sira atu mantein prontidaun mentál',
            icon: Icons.psychology,
            color: Colors.purple,
            recommendations: [
              'Diskute planu partu nian ho doutór',
              'Tuir klase preparasaun partu nian',
              'Prátika tékniku sira relaxamentu nian',
              'Fahe preokupasaun ho parseiru',
              'Halibur informasaun hosi fonte sira ne ebé fiar'
            ],
            notes:
                'Preparasaun mentál ne ebé di ak sei ajuda ita-boot hasoru prosesu partu ho kalma liu.',
          ),
          const SizedBox(height: 24),
          _buildTipsCard(),
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
                  'Hanoin Importante sira',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B57D2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTipItem('Pratika beibeik tékniku halimar nian molok partu'),
            _buildTipItem('Komunika ita-boot nia hakarak sira ho ekipa médiku'),
            _buildTipItem('Hili kompañeiru partu nian ne ebé bele fó apoiu'),
            _buildTipItem(
                'Prepara múzika relaxante ka atividade distrasaun nian'),
            _buildTipItem(
                'Fiar ba ita-boot nia isin nia abilidade atu hahoris'),
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
