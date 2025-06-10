import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class PracticeVerbsScreen extends StatefulWidget {
  final int level;
  const PracticeVerbsScreen({super.key, required this.level});

  @override
  State<PracticeVerbsScreen> createState() => _PracticeVerbsScreenState();
}

class _PracticeVerbsScreenState extends State<PracticeVerbsScreen> {
  Map<String, dynamic>? currentVerb;
  final TextEditingController v1Controller = TextEditingController();
  final TextEditingController v2Controller = TextEditingController();
  final TextEditingController v3Controller = TextEditingController();
  final TextEditingController ingController = TextEditingController();

  bool showAnswer = false;
  String resultMessage = "";

  @override
  void initState() {
    super.initState();
    fetchNewVerb();
  }

  @override
  void dispose() {
    v1Controller.dispose();
    v2Controller.dispose();
    v3Controller.dispose();
    ingController.dispose();
    super.dispose();
  }

  Future<void> fetchNewVerb() async {
    try {
      final data = await ApiService.getRandomVerbByLevel(widget.level);
      setState(() {
        currentVerb = data;
        v1Controller.clear();
        v2Controller.clear();
        v3Controller.clear();
        ingController.clear();
        resultMessage = "";
        showAnswer = false;
      });
    } catch (e) {
      setState(() {
        resultMessage = "Failed to load verb. Please try again.";
      });
    }
  }

  void checkAnswer() {
    if (currentVerb == null) return;
    final v1 = v1Controller.text.trim().toLowerCase();
    final v2 = v2Controller.text.trim().toLowerCase();
    final v3 = v3Controller.text.trim().toLowerCase();
    final ing = ingController.text.trim().toLowerCase();

    final correctV1 = (currentVerb!['v1'] ?? '').toString().toLowerCase();
    final correctV2 = (currentVerb!['v2'] ?? '').toString().toLowerCase();
    final correctV3 = (currentVerb!['v3'] ?? '').toString().toLowerCase();
    final correctING = (currentVerb!['ing'] ?? '').toString().toLowerCase();

    final allCorrect = v1 == correctV1 && v2 == correctV2 && v3 == correctV3 && ing == correctING;

    setState(() {
      resultMessage = allCorrect ? "✅ All forms are correct!" : "❌ Some forms are incorrect. Try again.";
    });
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Practice Verbs - Level ${widget.level}")),
      body: currentVerb == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("🔤 Translate to English:", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Text("🗣️ ${currentVerb!['telugu_meaning'] ?? ''}", style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  buildTextField("Enter V1", v1Controller),
                  buildTextField("Enter V2", v2Controller),
                  buildTextField("Enter V3", v3Controller),
                  buildTextField("Enter ING", ingController),
                  const SizedBox(height: 10),
                  Text(
                    resultMessage,
                    style: TextStyle(
                      fontSize: 16,
                      color: resultMessage.startsWith('✅') ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(onPressed: checkAnswer, child: const Text("Check Answer")),
                      ElevatedButton(onPressed: () => setState(() => showAnswer = true), child: const Text("Reveal Answer")),
                      ElevatedButton(onPressed: fetchNewVerb, child: const Text("Next Verb")),
                    ],
                  ),
                  if (showAnswer) ...[
                    const SizedBox(height: 20),
                    const Divider(),
                    Text("✅ V1: ${currentVerb!['v1']}"),
                    Text("✅ V2: ${currentVerb!['v2']}"),
                    Text("✅ V3: ${currentVerb!['v3']}"),
                    Text("✅ ING: ${currentVerb!['ing']}"),
                    const SizedBox(height: 10),
                    Text("📘 Example (EN): ${currentVerb!['example_english']}"),
                    Text("📗 Example (TE): ${currentVerb!['example_telugu']}"),
                  ],
                ],
              ),
            ),
    );
  }
}
