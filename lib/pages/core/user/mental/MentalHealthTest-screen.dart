import 'package:flutter/material.dart';

class MentalHealthTestScreen extends StatefulWidget {
  const MentalHealthTestScreen({super.key});

  @override
  State<MentalHealthTestScreen> createState() => _MentalHealthTestScreenState();
}

class _MentalHealthTestScreenState extends State<MentalHealthTestScreen> {
  int _currentQuestionIndex = 0;
  List<int> _answers = [];
  bool _showResult = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question':
          'Dala hira maka ita-boot sente ansi ka preokupadu liu iha semana 2 ikus ne e?',
      'options': [
        'Nunka',
        'Loron balun',
        'Liu loron ida ho balun',
        'Kuaze loron-loron'
      ]
    },
    {
      'question': 'Dala hira maka ita-boot sente susar atu relaxa ka deskansa?',
      'options': [
        'Nunka',
        'Loron balun',
        'Liu loron ida ho balun',
        'Kuaze loron-loron'
      ]
    },
    {
      'question':
          'Ita-boot iha problema atu toba ka mudansa sira iha padraun toba nian?',
      'options': [
        'Nunka',
        'Loron balun',
        'Liu loron ida ho balun',
        'Kuaze loron-loron'
      ]
    },
    {
      'question':
          'Dala hira maka ita-boot sente triste ka la hetan inspirasaun?',
      'options': [
        'Nunka',
        'Loron balun',
        'Liu loron ida ho balun',
        'Kuaze loron-loron'
      ]
    },
    {
      'question':
          'Ita-boot sente hanesan ita-boot lakon interese ka ksolok atu hala o atividade loroloron nian?',
      'options': [
        'Nunka',
        'Loron balun',
        'Liu loron ida ho balun',
        'Kuaze loron-loron'
      ]
    }
  ];

  void _answerQuestion(int score) {
    setState(() {
      _answers.add(score);
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _showResult = true;
      }
    });
  }

  void _restartTest() {
    setState(() {
      _currentQuestionIndex = 0;
      _answers = [];
      _showResult = false;
    });
  }

  Widget _buildResultCard() {
    final totalScore = _answers.reduce((a, b) => a + b);
    String resultText;
    Color resultColor;
    String recommendation;

    if (totalScore <= 5) {
      resultText = 'Risku Ki ik';
      resultColor = Colors.green;
      recommendation =
          'Mantein iha leten ba ita-boot nia saúde mentál hodi envolve iha atividade sira ne ebé di ak no meditasaun regulár.';
    } else if (totalScore <= 10) {
      resultText = 'Risku Médiu';
      resultColor = Colors.orange;
      recommendation =
          'Rekomenda atu ko alia ho ita-boot nia família ka belun sira ne ebé besik liu kona-ba ita-boot nia sentimentu sira no konsulta ho profisionál saúde nian.';
    } else {
      resultText = 'Risku Aas';
      resultColor = Colors.red;
      recommendation =
          'Rekomenda tebes atu konsulta kedas profisionál saúde mentál ida hodi hetan ajuda ne ebé loos.';
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rezultadu Teste nian',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: resultColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                resultText,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: resultColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Rekomendasaun:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              recommendation,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _restartTest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B57D2),
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Repete Teste',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Teste Saúde Mentál',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6B57D2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _showResult
              ? _buildResultCard()
              : Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value:
                              (_currentQuestionIndex + 1) / _questions.length,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF6B57D2),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Pergunta ${_currentQuestionIndex + 1} husi ${_questions.length}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _questions[_currentQuestionIndex]['question'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 30),
                        ...List.generate(
                          _questions[_currentQuestionIndex]['options'].length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ElevatedButton(
                              onPressed: () => _answerQuestion(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF6B57D2),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                    color: Color(0xFF6B57D2),
                                    width: 1,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 20,
                                ),
                              ),
                              child: Text(
                                _questions[_currentQuestionIndex]['options']
                                    [index],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
