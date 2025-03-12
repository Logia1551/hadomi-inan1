import 'package:flutter/material.dart';

class ExerciseGuideScreen extends StatelessWidget {
  const ExerciseGuideScreen({super.key});

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
          'Ezersísiu Fíziku ne ebé Seguru',
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
            _buildExerciseCategories(),
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
        'Matadalan kompletu ba ezersísiu fíziku seguru ba feto isin-rua sira',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildExerciseCategories() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildExerciseCategory(
            title: 'Ezersísiu sira ba halimar',
            description: 'Tékniku halimar nian ba isin-rua no partu',
            icon: Icons.air,
            color: Colors.blue,
            exercises: [
              Exercise(
                name: 'Respirasaun klean',
                duration: '5-10 mins',
                steps: [
                  'Tuur ho konfortavel ka toba iha ita-boot nia sorin',
                  'Iha iis klean liuhosi ita-boot nia inus ba kontajen 4',
                  'Kaer metin ita-boot nia iis ba kontajen 2',
                  'Hasai iis neineik liuhosi ibun ba kontajen 4',
                  'Repete dala 5-10'
                ],
                benefits:
                    'Hakalma hanoin, hamenus estrese, no aumenta oksijenasaun',
                precautions:
                    'Para se ita-boot sente ulun-todan ka la konfortavel',
              ),
              Exercise(
                name: 'Traballu Respirasaun',
                duration: '10-15 mins',
                steps: [
                  'Hahú iha pozisaun tuur ne ebé konfortavel',
                  'Iis badak no lalais liuhosi ita-boot nia inus',
                  'Hasai iis lalais liuhosi ibun',
                  'Halo ho ritmu regulár',
                  'Prátika durante kontrasaun sira'
                ],
                benefits: 'Preparasaun ba kontrasaun sira durante partu',
                precautions: 'Halo neineik no lalika ansi',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildExerciseCategory(
            title: 'Yoga Prenatal',
            description: 'Movimentu yoga ne ebé seguru ba feto isin-rua sira',
            icon: Icons.self_improvement,
            color: Colors.purple,
            exercises: [
              Exercise(
                name: 'Poza Busa no Karau',
                duration: '5-10 mins',
                steps: [
                  'Hahú ho ain haat',
                  'Bainhira ita-boot dada iis, hakru uk ita-boot nia kotuk',
                  'Bainhira ita-boot dada iis, fila ita-boot nia kotuk ba leten',
                  'Muda ulun no kakorok ho kmaan',
                  'Repete dala 5-8'
                ],
                benefits: 'Hamenus moras iha kotuk-laran no relaxa ruin-kotuk',
                precautions: 'Evita movimentu sira ne ebé maka estremu liu',
              ),
              Exercise(
                name: 'Pose ho ain-kruza ne ebé modifikadu',
                duration: '10-15 mins',
                steps: [
                  'Tur ho travesseiru ida iha ita-boot nia pelvis nia okos',
                  'Halo loos ita-boot nia kotuk-laran neineik',
                  'Halo dada iis klean no relaxa ita-boot nia kabas',
                  'Foka ba halimar',
                  'Aumenta alongamentu kmaan se konfortavel'
                ],
                benefits: 'Aumenta fleksibilidade pélviku no hakalma hanoin',
                precautions: 'Uza travesseiru sira ba konfortu',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildExerciseCategory(
            title: 'Andar',
            description: 'Matadalan la o seguru',
            icon: Icons.directions_walk,
            color: Colors.green,
            exercises: [
              Exercise(
                name: 'Light Walk',
                duration: '15-30 mins',
                steps: [
                  'Hili tempu ne ebé malirin (dader/loraik)',
                  'Uza sapatu ne ebé konfortavel',
                  'Hahú ho manas-manas ne ebé kmaan',
                  'La o ho velosidade ne ebé konfortavel',
                  'Remata ho malirin ida'
                ],
                benefits: 'Hadi a estamina no sirkulasaun raan',
                precautions:
                    'Evita la o iha superfísie ne ebé la hanesan ka lis',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildExerciseCategory(
            title: 'Ezersísiu Kegel',
            description: 'Hametin muskulu iha rai-lolon pélviku',
            icon: Icons.fitness_center,
            color: Colors.orange,
            exercises: [
              Exercise(
                name: 'Kegel Báziku',
                duration: '5-10 mins',
                steps: [
                  'Identifikasaun ba múskulu sira iha pélviku',
                  'Aperta ita-boot nia múskulu sira durante segundu 5',
                  'Relaxa ba segundu 5',
                  'Repete dala 10',
                  'Halo set 3 kada loron'
                ],
                benefits: 'Prevene inkontinénsia no prepara ba partu',
                precautions: 'Labele dada iis bainhira halo ezersísiu',
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSafetyTips(),
        ],
      ),
    );
  }

  Widget _buildExerciseCategory({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required List<Exercise> exercises,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color),
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
                    ),
                  ),
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
        children: exercises
            .map((exercise) => _buildExerciseItem(exercise, color))
            .toList(),
      ),
    );
  }

  Widget _buildExerciseItem(Exercise exercise, Color color) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exercise.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.timer, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Durasaun: ${exercise.duration}',
                  style: TextStyle(color: color),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildExerciseSection('Etapa sira:', exercise.steps, color),
          const SizedBox(height: 12),
          _buildBenefitsAndPrecautions(exercise, color),
        ],
      ),
    );
  }

  Widget _buildExerciseSection(String title, List<String> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
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
                    child: Text(item),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildBenefitsAndPrecautions(Exercise exercise, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle_outline, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Benefisiu: ${exercise.benefits}',
                  style: TextStyle(color: color),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Atensaun: ${exercise.precautions}',
                  style: TextStyle(color: color),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSafetyTips() {
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
                  Icons.safety_check,
                  color: Color(0xFF6B57D2),
                ),
                SizedBox(width: 8),
                Text(
                  'Dika sira Seguransa nian',
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
                'Konsulta ho doutór ida molok hahú programa ezersísiu ida'),
            _buildTipItem(
                'Evita desportu sira ho risku atu monu ka hetan impaktu'),
            _buildTipItem(
                'Tau atensaun ba sinál isin nian no keta obriga ita-nia an'),
            _buildTipItem(
                'Asegura katak kuartu ne e iha ventilasaun di ak no temperatura ne ebé konfortavel'),
            _buildTipItem(
                'Hemu bee natoon antes, durante, no depois ezersísiu'),
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

class Exercise {
  final String name;
  final String duration;
  final List<String> steps;
  final String benefits;
  final String precautions;

  Exercise({
    required this.name,
    required this.duration,
    required this.steps,
    required this.benefits,
    required this.precautions,
  });
}
