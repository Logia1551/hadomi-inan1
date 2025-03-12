import 'package:flutter/material.dart';

class HealthyRecipesScreen extends StatelessWidget {
  const HealthyRecipesScreen({super.key});

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
          'Reseita Saudavel sira ba Feto Isin-rua sira',
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
            _buildRecipeCategories(),
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
        'Kolesaun reseita ai-han nutritivu no saudavel ba feto isin-rua sira',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildRecipeCategories() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildRecipeCategory(
            title: 'Almosu Nutritivu',
            description: 'Reseita ba almosu ne ebé riku ho nutriente',
            icon: Icons.breakfast_dining,
            color: Colors.orange,
            recipes: [
              Recipe(
                name: 'Oats kalan nian ho ai-fuan',
                ingredients: [
                  '1 kopu oatmeal',
                  '1 kopu susu-been ho bokur ki ik',
                  'ai-fuan fresku',
                  'Meni tuir gostu',
                  'Améndoa'
                ],
                steps: [
                  'Kahur oatmeal ho susu-been',
                  'Husik ida-ne e iha jeleira kalan tomak',
                  'Iha dadeer aumenta ai-fuan no bani-been',
                  'Rega ho amêndoa'
                ],
                nutritionInfo: 'Riku ho fibra, proteina no vitamina',
                cookingTime: '10 mins',
              ),
              Recipe(
                name: 'Sanduíche ho manu-tolun abakate nian',
                ingredients: [
                  'Paun trigu tomak',
                  'Ovu tunu',
                  'Abakate',
                  'Alfase',
                  'Tomate'
                ],
                steps: [
                  'Tunu paun trigu nian',
                  'To os no abakate ne ebé tunu',
                  'Arranja ingrediente sira iha paun leten',
                  'Hatama ai-horis fresku'
                ],
                nutritionInfo: 'Aas iha proteína no ásidu fóliku',
                cookingTime: '15 mins',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRecipeCategory(
            title: 'Almosu Saudavel',
            description: 'Reseita almosu nian ne ebé nutritivu',
            icon: Icons.lunch_dining,
            color: Colors.green,
            recipes: [
              Recipe(
                name: 'Batar Metan ho Ikan Tunu',
                ingredients: [
                  'batar mean',
                  'Snapper',
                  'Brókoli',
                  'Senoura',
                  'Temperu sira'
                ],
                steps: [
                  'Tahu batar-mean',
                  'Ikan tunu ho espesia sira',
                  'Ai-horis tunu',
                  'Serbi hamutuk'
                ],
                nutritionInfo: 'Aas iha omega-3 no fibra',
                cookingTime: '30 mins',
              ),
              Recipe(
                name: 'Sopa Manu-Vejetál',
                ingredients: [
                  'Susun manu-tolun ne ebé magra',
                  'Senoura',
                  'Fehuk-ropa',
                  'Brókoli',
                  'Kaldu manu'
                ],
                steps: [
                  'Ferve manu-tolun',
                  'Tau manu-tolun pedasuk sira',
                  'Hatama ai-horis',
                  'Tahu to o tasak'
                ],
                nutritionInfo: 'Riku ho proteina no vitamina',
                cookingTime: '45 mins',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCookingTips(),
        ],
      ),
    );
  }

  Widget _buildRecipeCategory({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required List<Recipe> recipes,
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
        children:
            recipes.map((recipe) => _buildRecipeItem(recipe, color)).toList(),
      ),
    );
  }

  Widget _buildRecipeItem(Recipe recipe, Color color) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipe.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildRecipeSection('Ingridientes:', recipe.ingredients, color),
          const SizedBox(height: 8),
          _buildRecipeSection('Oinsá atu halo:', recipe.steps, color),
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
                  'Tempu tunu: ${recipe.cookingTime}',
                  style: TextStyle(color: color),
                ),
                const SizedBox(width: 16),
                Icon(Icons.info_outline, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    recipe.nutritionInfo,
                    style: TextStyle(color: color),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeSection(String title, List<String> items, Color color) {
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

  Widget _buildCookingTips() {
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
                  'Dika sira kona-ba tein',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B57D2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTipItem('Fase ai-han sira ho didi ak'),
            _buildTipItem('Tahu hahán to o tasak hotu'),
            _buildTipItem('Evita uza MSG'),
            _buildTipItem('Uza mina ho kuantidade mínimu'),
            _buildTipItem('Rai ai-han iha kontentór taka'),
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

class Recipe {
  final String name;
  final List<String> ingredients;
  final List<String> steps;
  final String nutritionInfo;
  final String cookingTime;

  Recipe({
    required this.name,
    required this.ingredients,
    required this.steps,
    required this.nutritionInfo,
    required this.cookingTime,
  });
}
