import 'package:flutter/material.dart';

class ComplementaryTherapyScreen extends StatelessWidget {
  const ComplementaryTherapyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Terápia Komplementár',
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
            _buildContentSections(context),
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
      child: const Column(
        children: [
          Text(
            'Matadalan terapia komplementár',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Matadalan kompletu ida kona-ba terapia komplementer ne\'ebé seguru no naturál ba inan sira durante isin-rua no hafoin tuur-ahi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContentSections(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSection(
            context: context,
            title: 'Teknik Akupresure',
            description:
                'Akupresure mak terapia tradisionál ida ne\'ebé uza presaun iha pontu espesífiku iha isin lolon atu:\n\n'
                '• Hamenus moras no sintoma sira durante isin-rua\n'
                '• Ajuda redús moras kabun no muta bebeik\n'
                '• Hadi\'a sirkulasaun raan no hakmaan tensaun\n'
                '• Prepara isin ba momentu tuur-ahi\n\n'
                'Teknika ida ne\'e seguru no la presiza medikamentu, bele pratika rasik iha uma.',
            icon: Icons.touch_app,
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildSection(
            context: context,
            title: 'Benefísiu Marunggi Tahan',
            description:
                'Marunggi-tahan oferese benefísiu nutritivu barak ba inan isin-rua:\n\n'
                '• Riku ho vitamina, minerál no antioxidante sira\n'
                '• Ajuda aumenta produsaun susu-inan\n'
                '• Hasa\'e sistema imunidade inan nian\n'
                '• Kontribui ba dezenvolvimentu bebé nian\n\n'
                'Bele konsume hanesan modo ka tee, tuir orientasaun husi profisionál saúde nian.',
            icon: Icons.eco,
            color: Colors.green,
          ),
          const SizedBox(height: 16),
          _buildSection(
            context: context,
            title: 'Masajen Prenatal',
            description:
                'Masajen prenatál ne\'ebé espesiálmente dezeñadu ba inan isin-rua:\n\n'
                '• Hamenus moras kotuk no ain\n'
                '• Hadi\'a kualidade toba\n'
                '• Redús estrese no ansiedade\n'
                '• Mellora sirkulasaun raan\n'
                '• Prepara isin ba momentu tuur-ahi\n\n'
                'Tenke halo ho terapeuta ne\'ebé sertifikadu iha masajen prenatál.',
            icon: Icons.spa,
            color: Colors.orange,
          ),
          const SizedBox(height: 24),
          _buildBenefitsCard(),
          const SizedBox(height: 16),
          _buildTipsCard(),
        ],
      ),
    );
  }

  Widget _buildBenefitsCard() {
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
                  Icons.stars,
                  color: Color(0xFF6B57D2),
                ),
                SizedBox(width: 8),
                Text(
                  'Benefísiu Jerál',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B57D2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildBenefitItem(
              'Hamenus uza ai-moruk ka medikamentu kímiku sira',
              Icons.check_circle_outline,
            ),
            _buildBenefitItem(
              'Hasa\'e bem-estar fíziku no emosionál',
              Icons.check_circle_outline,
            ),
            _buildBenefitItem(
              'Ajuda inan sira iha prosesu naturál',
              Icons.check_circle_outline,
            ),
            _buildBenefitItem(
              'Ekonomikamente asesivel liu',
              Icons.check_circle_outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
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
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF6B57D2),
            size: 20,
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
                  'Dika Importante sira',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B57D2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTipItem(
                'Konsulta ho profisionál saúde molok hahú terapia komplementer ruma'),
            _buildTipItem(
                'Uza de\'it terapia ne\'ebé iha evidénsia sientífika kona-ba ninia seguransa'),
            _buildTipItem(
                'Fó atensaun ba sinál avizu ruma ka mudansa iha kondisaun saúde'),
            _buildTipItem(
                'Uza produtu naturál ne\'ebé ho kualidade no sertifikadu'),
            _buildTipItem(
                'La bele para tratamentu médiku sein konsulta ho doutór'),
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
