import 'package:flutter/material.dart';

class SimulationScreen extends StatelessWidget {
  const SimulationScreen({super.key});

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
          'Simulasaun Moris',
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
        'Matadalan ba ezersísiu halimar nian no pozisaun isin nian hodi hasoru partu',
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
          _buildSimulationSection(
            title: 'Ezersísiu Respirasaun Inisiál',
            description:
                'Tékniku báziku sira halimar nian ba kontrasaun kmaan sira',
            icon: Icons.air,
            color: Colors.blue,
            steps: [
              'Tuur ho konfortavel, kotuk loos',
              'Iha dada iis neineik liuhosi ita-boot nia inus ba kontajen 4',
              'Kaer metin ita-boot nia iis ba momentu ida (1-2 kontajen)',
              'Hasai iis neineik liuhosi ita-boot nia ibun ba kontajen 4',
              'Repete ho ritmu hanesan dala 5-10'
            ],
            notes:
                'Ezersísiu ida-ne e ajuda hakalma hanoin no kontrola halimar durante kontrasaun kmaan sira.',
            duration: '5-10min',
            frequency: 'loron ida dala 3-4',
          ),
          const SizedBox(height: 15),
          _buildSimulationSection(
            title: 'Respirasaun Durante Kontrasaun sira',
            description:
                'Tékniku halimar nian hodi ultrapasa kontrasaun maka as sira',
            icon: Icons.healing,
            color: Colors.green,
            steps: [
              'Hahú iha pozisaun ne ebé konfortavel (tuur/toba)',
              'Bainhira kontrasaun sira hahú, dada iis lalais no klean',
              'Foka dada iis iha parte leten',
              'Hasai iis ho lian "huh-huh"',
              'Ajusta velosidade ba intensidade kontrasaun'
            ],
            notes:
                'Tékniku ida-ne e efetivu atu hasoru kontrasaun sira ne ebé maka as liu molok partu.',
            duration: '60 sec',
            frequency: 'Tuir kontrasaun',
          ),
          const SizedBox(height: 16),
          _buildSimulationSection(
            title: 'Pozisaun Traballu Ativu',
            description:
                'Variasaun iha pozisaun sira ne’ebé ajuda prosesu partu',
            icon: Icons.accessibility_new,
            color: Colors.orange,
            steps: [
              'Pozisaun hakru uk ho liman',
              'Pozisaun rasta iha ain-tuur no liman',
              'Toba iha ita-boot nia sorin karuk',
              'Tuur iha bola partu nian',
              'Hamriik hodi sadere ba kompañeiru ida'
            ],
            notes:
                'Pozisaun ida-idak iha ninia benefísiu rasik. Koko no hili ida ne ebé konfortavel liu.',
            duration: '15 min',
            frequency: 'Konfortavel liután',
          ),
          const SizedBox(height: 16),
          _buildSimulationSection(
            title: 'Tékniku sira Relaxamentu nian',
            description: 'Métodu relaxamentu nian atu hamenus tensaun',
            icon: Icons.spa,
            color: Colors.purple,
            steps: [
              'Ajusta pozisaun ida ne ebé konfortavel ho travesseiru ida ne ebé apoia',
              'Taka ita-boot nia matan no foka ba ita-boot nia halimar',
              'Vizualize fatin ida ne ebé kalma',
              'Relaxamentu muskulár husi ulun to o ain',
              'Kombina ho múzika relaxante'
            ],
            notes:
                'Tékniku relaxamentu nian ajuda hamenus ansiedade no tensaun muskulár.',
            duration: '20 min',
            frequency: 'loron ida dala 2-3',
          ),
          const SizedBox(height: 24),
          _buildPracticeCard(),
        ],
      ),
    );
  }

  Widget _buildSimulationSection({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required List<String> steps,
    required String notes,
    required String duration,
    required String frequency,
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
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.timer, color: color, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                'Durasaun:$duration',
                                style: TextStyle(
                                  color: color,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.repeat, color: color, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                frequency,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Etapa sira:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...steps.map((step) => Padding(
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
                                step,
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

  Widget _buildPracticeCard() {
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
                  Icons.tips_and_updates,
                  color: Color(0xFF6B57D2),
                ),
                SizedBox(width: 8),
                Text(
                  'Dika sira ba Treinamentu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B57D2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTipItem('Pratika beibeik atu toman ho ida-ne e'),
            _buildTipItem('Konvida Ita-boot nia parseiru atu pratika hamutuk'),
            _buildTipItem('Uza travesseiru ka kolxaun ba konfortu'),
            _buildTipItem(
                'Hakerek tékniku sira ne ebé funsiona di ak liu ba ita-boot'),
            _buildTipItem(
                'Konsulta ita-boot nia parteira/médiku karik ita-boot iha keixa ruma'),
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
