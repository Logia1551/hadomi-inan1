import 'package:flutter/material.dart';

class NewbornCareGuide extends StatelessWidget {
  const NewbornCareGuide({super.key});

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
          'Kuidadu ba Bebé Foin Moris',
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
        'Matadalan kompletu atu kuidadu bebé foin moris ho seguru no konfortavel',
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
          _buildCareSection(
            title: 'Bebe sira ne ebé hariis',
            description: 'Matadalan atu hariis bebé sira ho seguru',
            icon: Icons.bathtub,
            color: Colors.blue,
            recommendations: [
              'Prepara ekipamentu hotu molok hariis',
              'Asegura katak bee nia temperatura manas (36-37°C)',
              'Apoiu bebé nia ulun no kakorok bainhira hariis',
              'Hahú husi parte ne ebé moos liu to o ne ebé fo er liu',
              'Hamaran ho kmaan no hatais kedas'
            ],
            notes: 'Hein to o tali umbilikál monu molok fó bee-moos ba bebé.',
          ),
          const SizedBox(height: 16),
          _buildCareSection(
            title: 'Kuidadu ba tali umbilikál ou husar',
            description: 'Oinsá atu kuidadu tali umbilikál to o nia monu',
            icon: Icons.healing,
            color: Colors.green,
            recommendations: [
              'Mantein área tali umbilikal nian maran no moos',
              'Hamoos ho alkol 70% ka bee estéril',
              'Dobra fralda iha tali umbilikál ou husar nia okos',
              'Evita atu taka área tali umbilikal ou husar nian',
              'Atensaun ho sinais konaba infesaun nian'
            ],
            notes:
                'Tali umbilikal normalmente monu iha loron 5-15 nia laran. Kontaktu doutór karik iha sinál infesaun nian.',
          ),
          const SizedBox(height: 16),
          _buildCareSection(
            title: 'Padraun Toba Bebé nian',
            description: 'Komprende no jere bebé nia padraun toba nian',
            icon: Icons.bedtime,
            color: Colors.purple,
            recommendations: [
              'Bebé foin moris toba oras 16-17 loron ida',
              'Tupina ou toba hateke sae ba area leten',
              'Hatur temperatura ambiente nian ba 24-26°C',
              'Rekoñese sinál sira dukur nian',
              'Distinge entre hakilar kole no hamlaha'
            ],
            notes:
                'Bebé ida-idak iha padraun toba nian ne ebé diferente. Buat ne ebé importante liu maka kualidade toba nian.',
          ),
          const SizedBox(height: 16),
          _buildCareSection(
            title: 'Troka Fralda',
            description: 'Matadalan atu troka fralda ho loloos',
            icon: Icons.child_care,
            color: Colors.orange,
            recommendations: [
              'Troka kedas fralda bainhira bokon/fo er',
              'Moos husi oin ba kotuk',
              'Hamaran ho kmaan área fralda nian',
              'Fó kreme ba erupsaun se presiza',
              'Asegura katak fralda la metin liu'
            ],
            notes:
                'Bebé foin moris sira bele presiza troka fralda dala 8-10 iha loron ida.',
          ),
          const SizedBox(height: 24),
          _buildDangerSignsCard(),
        ],
      ),
    );
  }

  Widget _buildCareSection({
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

  Widget _buildDangerSignsCard() {
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
                  Icons.warning_amber,
                  color: Color(0xFF6B57D2),
                ),
                SizedBox(width: 8),
                Text(
                  'Sinál Perigu sira iha Bebé sira',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B57D2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildWarningItem('Temperatura isin nian aas ka ki ik'),
            _buildWarningItem('Labele hemu ka muta nafatin'),
            _buildWarningItem(
                'Tali umbilikal ou husar mean ka iha fo iss oinseluk'),
            _buildWarningItem(
                'Jaundice ou matan laran no isin kor kinor iha bebé sira'),
            _buildWarningItem('Tanis fraku ka la tanis'),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningItem(String text) {
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
