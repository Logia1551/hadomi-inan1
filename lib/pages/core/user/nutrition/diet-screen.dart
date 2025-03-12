import 'package:flutter/material.dart';

class DietProgramScreen extends StatelessWidget {
  const DietProgramScreen({super.key});

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
          'Programa Dieta Saudavel',
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
        'Matadalan kompletu kona-ba nutrisaun no ai-han saudavel ba inan isin-rua sira',
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
          _buildExpandedMealSection(
            title: 'Almosu Saudavel',
            description: 'Menu almosu nutritivu ida atu hahú loron',
            icon: Icons.wb_sunny,
            color: Colors.orange,
            recommendations: [
              'Aveia ho ai-fuan fresku no bani-been',
              'Toast trigu tomak ho manu-tolun no abakate',
              'Iogurt ho granola no ai-fuan pedasuk sira',
              'Smoothie ai-horis no ai-fuan ho susubeen ho bokur ki ik',
              'Afarina ho banana no amêndoa',
            ],
            notes:
                'Almosu importante atu hahú loron no fornese enerjia. Hili ai-han sira ne ebé riku ho fibra no proteina.',
          ),
          const SizedBox(height: 16),
          _buildExpandedMealSection(
            title: 'Halo almosu',
            description: 'Opsaun sira menu almosu nian ne ebé ekilibradu',
            icon: Icons.restaurant,
            color: Colors.green,
            recommendations: [
              'Foos mean ho ikan tunu no ai-horis tunu',
              'Sopa ai-horis ho pedasuk manu-tolun',
              'Quinoa ho tofu, tempeh no ai-horis verde',
              'Sanduíche trigu tomak ho proteína vejetál no alface',
              'Gado-gado ho manu-tolun tunu no tofu tempe'
            ],
            notes:
                'Almosu tenke inklui karboidratu kompleksu, proteína, no ai-horis sira ba enerjia sustentável.',
          ),
          const SizedBox(height: 16),
          _buildExpandedMealSection(
            title: 'Han kalan',
            description: 'Menu jantar nian kmaan no nutritivu',
            icon: Icons.nights_stay,
            color: Colors.blue,
            recommendations: [
              'Ikan tunu ho ai-horis tunu',
              'Sopa manu ho ai-horis no batata',
              'Tempeh ka tofu tunu ho ai-horis tunu',
              'Omelete ai-horis ho paun trigu tomak',
              'Salada ho proteína (manu/ikan) no abakate',
            ],
            notes:
                'Hili porsaun ki ik liu ba jantar no evita hahán sira ne ebé maka todan liu ka iha mina.',
          ),
          const SizedBox(height: 16),
          _buildExpandedMealSection(
            title: 'Merenda Saudavel',
            description: 'Opsaun merenda saudavel entre refeisaun sira',
            icon: Icons.apple,
            color: Colors.red,
            recommendations: [
              'Ai-fuan fresku sira (mazeira, pera, laranja)',
              'Noz lahó masin (amêndoa, noz)',
              'Iogurt ho ai-fuan pedasuk sira',
              'Paun trigu ho manteiga kafé',
              'Smoothie susu-been ka ai-fuan',
            ],
            notes:
                'Merenda sira ajuda mantein enerjia no raan nia midar estavel. Hili hahán-kma an sira ne ebé saudavel no evita hahán sira ne ebé iha modo ka masin barak.',
          ),
          const SizedBox(height: 24),
          _buildNutritionTips(),
        ],
      ),
    );
  }

  Widget _buildExpandedMealSection({
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
                    'Rekomendasaun sira ba Menu:',
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

  Widget _buildNutritionTips() {
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
                  'Matadalan Nutrisaun nian',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B57D2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTipItem('Konsumu ai-han ho porsaun ki ik maibé dala barak'),
            _buildTipItem(
                'Asegura katak ita-boot nia konsumu proteína no karboidratu nian iha balansu'),
            _buildTipItem(
                'Hasa e Ita-boot nia konsumu ai-horis no ai-fuan fresku sira'),
            _buildTipItem(
                'Evita hahán sira ne ebé maka tunu no iha bokur barak'),
            _buildTipItem('Hemu pelumenus bee kopu 8 kada loron'),
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
