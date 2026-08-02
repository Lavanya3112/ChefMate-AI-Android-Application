import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiBaseUrl = 'https://chefmate-ai-api.onrender.com';

void main() {
  runApp(const ChefMateApp());
}

class ChefMateApp extends StatelessWidget {
  const ChefMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChefMate AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFFF9800),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const ChefMateHomePage(),
    );
  }
}

class ChefMateHomePage extends StatefulWidget {
  const ChefMateHomePage({super.key});

  @override
  State<ChefMateHomePage> createState() => _ChefMateHomePageState();
}

class _ChefMateHomePageState extends State<ChefMateHomePage> {
  final List<String> topics = const [
    'Dal Tadka',
    'Rice Cooking',
    'Roti Making',
    'Kitchen Safety',
    'Knife Skills',
    'Vegetable Curry',
    'Healthy Cooking',
    'Food Hygiene',
    'Indian Breakfast',
    'Spices & Seasoning',
  ];
  final List<String> levels = const ['Beginner', 'Intermediate', 'Advanced'];

  String selectedTopic = 'Dal Tadka';
  String selectedLevel = 'Beginner';

  final TextEditingController answerController = TextEditingController();
  final TextEditingController questionController = TextEditingController();

  bool isLoading = false;
  String responseTitle = '';
  String responseText = '';

  Future<void> callEndpoint(String endpoint, Map<String, dynamic> body, String title) async {
    setState(() {
      isLoading = true;
      responseTitle = title;
      responseText = '';
    });

    try {
      final res = await http.post(
        Uri.parse('$apiBaseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          responseText = data['response'] ?? data['error'] ?? 'No response received.';
        });
      } else {
        setState(() {
          responseText = 'Error ${res.statusCode}: ${res.body}';
        });
      }
    } catch (e) {
      setState(() {
        responseText = 'Connection error: $e\n\n(Note: the free Render server may take 30-60s to wake up on first request.)';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void explainConcept() => callEndpoint(
        'explain',
        {'topic': selectedTopic, 'level': selectedLevel},
        '📖 Explanation',
      );

  void realLifeExample() => callEndpoint(
        'example',
        {'topic': selectedTopic, 'level': selectedLevel},
        '🍳 Real-life Example',
      );

  void generateQuiz() => callEndpoint(
        'quiz',
        {'topic': selectedTopic, 'level': selectedLevel},
        '❓ Quiz',
      );

  void checkAnswer() {
    if (answerController.text.trim().isEmpty) {
      setState(() {
        responseTitle = '';
        responseText = 'Please enter your answer first.';
      });
      return;
    }
    callEndpoint(
      'evaluate',
      {'topic': selectedTopic, 'student_answer': answerController.text.trim()},
      '✅ Feedback',
    );
  }

  void completeLesson() => callEndpoint(
        'lesson',
        {'topic': selectedTopic, 'level': selectedLevel},
        '🎓 Complete Learning Session',
      );

  void askLavanya() {
    if (questionController.text.trim().isEmpty) {
      setState(() {
        responseTitle = '';
        responseText = 'Please enter a question.';
      });
      return;
    }
    callEndpoint(
      'ask',
      {'question': questionController.text.trim()},
      '💬 Lavanya\'s Answer',
    );
  }

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFFF9800);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🍳 ChefMate AI'),
        backgroundColor: const Color(0xFF18273D),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero section with background image + dark overlay
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  height: 320,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/hero.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🍳 ChefMate AI',
                            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        const Text('Your Personal AI Learning Buddy',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        const Text(
                          'Learn cooking through interactive lessons, real-life examples, AI quizzes, and personalized feedback powered by Gemini AI.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            _heroBadge('📖 Learn'),
                            _heroBadge('🍳 Practice'),
                            _heroBadge('❓ Quiz'),
                            _heroBadge('✅ Feedback'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Topic + Level selectors
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedTopic,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      dropdownColor: const Color(0xFF18273D),
                      decoration: const InputDecoration(
                        labelText: '📚 Topic',
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                      ),
                      items: topics.map((t) => DropdownMenuItem(value: t, child: Text(t, overflow: TextOverflow.ellipsis))).toList(),
                      onChanged: (v) => setState(() => selectedTopic = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedLevel,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      dropdownColor: const Color(0xFF18273D),
                      decoration: const InputDecoration(
                        labelText: '🎯 Level',
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                      ),
                      items: levels.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                      onChanged: (v) => setState(() => selectedLevel = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Action buttons
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _actionButton('📖 Explain Concept', explainConcept, orange),
                  _actionButton('🍳 Real-life Example', realLifeExample, orange),
                  _actionButton('❓ Generate Quiz', generateQuiz, orange),
                  _actionButton('🎓 Complete Lesson', completeLesson, orange),
                ],
              ),

              const SizedBox(height: 20),

              // Answer evaluation
              TextField(
                controller: answerController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: '✍️ Enter your answer for evaluation',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              _actionButton('✅ Check My Answer', checkAnswer, orange, fullWidth: true),

              const SizedBox(height: 24),
              const Divider(color: Colors.white24),
              const SizedBox(height: 12),

              const Text('💬 Ask Lavanya Anything', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: questionController,
                maxLines: 2,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Ask any cooking question',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              _actionButton('Ask Lavanya', askLavanya, orange, fullWidth: true),

              const SizedBox(height: 24),

              // Response area
              if (isLoading)
                const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(color: orange)))
              else if (responseText.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF18273D),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: orange.withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (responseTitle.isNotEmpty) ...[
                        Text(responseTitle, style: const TextStyle(color: orange, fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                      ],
                      Text(responseText, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFF9800),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }

  Widget _actionButton(String label, VoidCallback onPressed, Color color, {bool fullWidth = false}) {
    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label),
    );
    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
