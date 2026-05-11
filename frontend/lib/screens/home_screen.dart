import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final pregnanciesController = TextEditingController();
  final glucoseController = TextEditingController();
  final bloodPressureController = TextEditingController();
  final bmiController = TextEditingController();
  final ageController = TextEditingController();

  String result = "";
  double probability = 0;
  String riskLevel = "";
  bool isLoading = false;

  String get apiBaseUrl {
    if (kIsWeb) {
      return "http://127.0.0.1:8000";
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return "http://10.0.2.2:8000";
    }

    return "http://10.87.73.142:8000";
  }

  Widget buildInput({
    required String label,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  double? parseInput(TextEditingController controller) {
    final text = controller.text.trim().replaceAll(',', '.');
    return double.tryParse(text);
  }

  Future<void> predict() async {
    final pregnancies = parseInput(pregnanciesController);
    final glucose = parseInput(glucoseController);
    final bloodPressure = parseInput(bloodPressureController);
    final bmi = parseInput(bmiController);
    final age = parseInput(ageController);

    if (pregnancies == null ||
        glucose == null ||
        bloodPressure == null ||
        bmi == null ||
        age == null) {
      setState(() {
        result = "Please fill all fields with valid numbers";
        probability = 0;
      });
      return;
    }

    setState(() {
      isLoading = true;
      result = "";
      probability = 0;
    });

    try {
      final response = await http.post(
        Uri.parse("$apiBaseUrl/predict"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "Pregnancies": pregnancies,
          "Glucose": glucose,
          "BloodPressure": bloodPressure,
          "BMI": bmi,
          "Age": age,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          result = responseBody["result"] ?? "Prediction completed";
          probability = (responseBody["probability"] as num).toDouble();
          riskLevel = responseBody["risk_level"] ?? "Unknown";
        });
      } else {
        setState(() {
          result = responseBody["detail"]?.toString() ?? "Prediction failed";
          probability = 0;
        });
      }
    } catch (error) {
      setState(() {
        result = "Failed to connect to backend";
        probability = 0;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    pregnanciesController.dispose();
    glucoseController.dispose();
    bloodPressureController.dispose();
    bmiController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Diabetes Detection",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Health Information",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Fill in your health data to predict diabetes risk.",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            buildInput(
              label: "Pregnancies",
              icon: Icons.pregnant_woman_outlined,
              controller: pregnanciesController,
            ),
            buildInput(
              label: "Glucose",
              icon: Icons.monitor_heart_outlined,
              controller: glucoseController,
            ),
            buildInput(
              label: "Blood Pressure",
              icon: Icons.favorite_border,
              controller: bloodPressureController,
            ),
            buildInput(
              label: "BMI",
              icon: Icons.fitness_center_outlined,
              controller: bmiController,
            ),
            buildInput(
              label: "Age",
              icon: Icons.person_outline,
              controller: ageController,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: isLoading ? null : predict,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        "Predict Now",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 35),
            if (result.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      color: Colors.black.withOpacity(0.05),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.analytics_outlined,
                      size: 70,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      result,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (probability >= 0)
                      Text(
                        "Probability: ${(probability * 100).toStringAsFixed(1)}%",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    if (riskLevel.isNotEmpty)
                      Text(
                        "Risk Level: $riskLevel",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: riskLevel == "High"
                              ? Colors.red
                              : riskLevel == "Medium"
                                  ? Colors.orange
                                  : Colors.green,
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
}
