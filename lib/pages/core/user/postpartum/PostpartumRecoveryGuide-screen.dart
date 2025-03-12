import 'package:flutter/material.dart';

class PostpartumRecoveryGuide extends StatelessWidget {
  const PostpartumRecoveryGuide({super.key});

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
          'Matadalan ba Rekuperasaun',
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
        'Matadalan kompletu ida ba rekuperasaun fíziku no mentál pós-partu',
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
          _buildRecoverySection(
            title: 'Rekuperasaun Fíziku',
            description: 'Matadalan ida ba kuidadu fíziku hafoin partu',
            icon: Icons.healing,
            color: Colors.blue,
            recommendations: [
              'Hetan deskansa natoon, toba bainhira bebé toba',
              'Halo kuidadu ba kanek ho loloos no beibeik',
              'Mantein área rekuperasaun nian moos',
              'Uza Pensu sanitaria ne e konfortavel no troka bebeik',
              'Halo ezersísiu Kegel neineik'
            ],
            notes:
                'Prosesu rekuperasaun fíziku diferente ba inan ida-idak. Labele obriga an no halo tuir doutór nia konsellu.',
          ),
          const SizedBox(height: 16),
          _buildRecoverySection(
            title: 'Nutrisaun no Dieta',
            description: 'Matadalan nutrisionál ba inan sira ne ebé fó-susu',
            icon: Icons.restaurant_menu,
            color: Colors.green,
            recommendations: [
              'Konsumu ai-han nutritivu ne ebé ekilibradu',
              'Hemu pelumenus bee kopu 8 loron ida',
              'Konsumu ai-han proteina ne ebe rekuperavel',
              'Han ai-horis no ai-fuan ba vitamina',
              'Konsumu suplementu ou ai-moruk tuir doutór nia rekomendasaun'
            ],
            notes:
                'Nutrisaun ne ebé di ak importante ba rekuperasaun no produsaun susubeen inan nian.',
          ),
          const SizedBox(height: 16),
          _buildRecoverySection(
            title: 'Saúde Mentál',
            description: 'Mantein saúde mentál no emosionál',
            icon: Icons.psychology,
            color: Colors.purple,
            recommendations: [
              'Simu tulun husi família no belun sira',
              'Komunika sentimentu sira ho sira ne ebé besik liu ba ita-boot',
              'Halo tempu ba deskansa no relaxamentu',
              'Evita stress ne ebé maka as',
              'Buka apoiu husi maluk inan-feto sira'
            ],
            notes:
                'Labele haluha atu buka ajuda profisionál se ita-boot hetan sintoma sira depresaun pós-natal nian.',
          ),
          const SizedBox(height: 16),
          _buildRecoverySection(
            title: 'Atividade Fízika',
            description: 'Matadalan atividade seguru',
            icon: Icons.directions_walk,
            color: Colors.orange,
            recommendations: [
              'Hahú ho la o kmaan',
              'Halo alongamentu ou streching ne ebé kmaan',
              'Evita hi it sasan  sira ne ebe maka as',
              'Halao atividade sira ho kalma no neneik',
              'Deskansa se ita-boot sente kole'
            ],
            notes:
                'Konsulta ho médiku ida molok hahú ezersísiu fíziku ne ebé maka as liu.',
          ),
          const SizedBox(height: 24),
          _buildWarningSignsCard(),
        ],
      ),
    );
  }

  Widget _buildRecoverySection({
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

  Widget _buildWarningSignsCard() {
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
                  'Sinál Perigu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B57D2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildWarningItem('Isin- manas maka as liu temperatura normal'),
            _buildWarningItem('Ran sai barak liu'),
            _buildWarningItem('Moras iha estómagu maka as'),
            _buildWarningItem('Sentimentu tristeza ho durasaun naruk'),
            _buildWarningItem('Susar atu dada iis ka moras iha hirus-matan'),
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
