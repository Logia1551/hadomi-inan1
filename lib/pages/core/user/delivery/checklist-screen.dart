import 'package:flutter/material.dart';

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});

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
          'Lista Esensial Partu Nian',
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
        'Lista kompletu kona-ba ekipamentu sira ne ebé presiza atu prepara ba partu',
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
          _buildChecklistSection(
            title: 'Inan nia sasán sira',
            description: 'Inan nia nesesidade pesoál bainhira iha ospitál',
            icon: Icons.pregnant_woman,
            color: Colors.pink,
            items: [
              'Troka roupa (konjuntu 4-5)',
              'Roupa-laran (4-5 pcs)',
              'Pensu sanitária pós-partu (pakote 2-3)',
              'Sutiã ba susu (2-3 pcs)',
              'Daster ka kamizola kalan nian (3-4 pcs)',
              'Toalla ba hariis no hena fase nian',
              'Ekipamentu no sasán hariis-fatin nian',
              'Sandália no sapatu',
            ],
            notes:
                'Hili roupa ne ebé konfortavel no fasil atu uza bainhira fó-susu.',
          ),
          const SizedBox(height: 16),
          _buildChecklistSection(
            title: 'Ekipamentu bebé nian',
            description: 'Nesesidade sira hosi bebé foin moris',
            icon: Icons.child_friendly,
            color: Colors.blue,
            items: [
              'Falda bebé nian (1-2 pakote)',
              'Roupa bebé nian (konjuntu 4-5)',
              'Neras bebe nian ou henan falun bebe (3-4 pcs)',
              'Luvas no ain bebé nian',
              'Xapeu bebé nian (2-3 pcs)',
              'Manta ba bebé',
              'Toalla úmidu liuliu ba bebé sira',
              'Kit kuidadu ba korda umbilikál',
            ],
            notes:
                'Prepara roupa ne ebé ho medida loos ba kosok-oan sira (ukuran bebé foin moris).',
          ),
          const SizedBox(height: 16),
          _buildChecklistSection(
            title: 'Dokumentu Importante sira',
            description: 'Arkivu sira ne ebé presiza',
            icon: Icons.document_scanner,
            color: Colors.green,
            items: [
              'kartaun ID feen ho laen nian',
              'Kartaun família nian',
              'Livru Lizio',
              'Kartaun Seguru',
              'Karta referénsia (Karik Iha)',
              'Rezultadu ultrasonografia ikus liu',
              'Rezultadu laboratóriu nian',
              'Prepara Osan ba Situasaun Emerjensia Sira',
            ],
            notes:
                'Tau dokumentu hotu-hotu iha pasta plástiku ida atu prevene sira atu labele sai bokon ka estraga..',
          ),
          const SizedBox(height: 16),
          _buildChecklistSection(
            title: 'Ekipamentu Adisionál',
            description: 'Sasan sira ne ebé fó apoiu durante partu',
            icon: Icons.medical_services,
            color: Colors.orange,
            items: [
              'Hahán no hemu sira',
              'Kámara ba dokumentasaun',
              'Karregador ba telemovel',
              'Almofada no manta pesoál',
              'Saku plástiku',
              'Nota no boluseira',
              'Múzika relaxamentu',
              'Sanetu sira iha uma laran',
            ],
            notes:
                'Sasan adisionál sira ba konfortu durante partu no rekuperasaun.',
          ),
          const SizedBox(height: 24),
          _buildReminderCard(),
        ],
      ),
    );
  }

  Widget _buildChecklistSection({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required List<String> items,
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
                    'Lista sasán sira:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...items.map((item) => Padding(
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
                                item,
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

  Widget _buildReminderCard() {
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
                  Icons.notifications_active,
                  color: Color(0xFF6B57D2),
                ),
                SizedBox(width: 8),
                Text(
                  'Alarma',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B57D2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildReminderItem(
                'Prepara ita-boot nia saku maternidade semana 2-3 antes ita-boot nia data partu'),
            _buildReminderItem(
                'Haketak dokumentu importante sira iha pasta ketak ida'),
            _buildReminderItem('Verifika sasán sira nia kompletu beibeik'),
            _buildReminderItem('Rai iha fatin ne ebé fasil atu asesu'),
            _buildReminderItem('Fó hatene ba família kona-ba saku nia fatin.'),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderItem(String text) {
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
