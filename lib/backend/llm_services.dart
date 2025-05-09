import 'dart:convert';
import 'package:http/http.dart' as http;

class MedicalLLMService {
  final String apiKey =
      "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"; // replace securely
  final String baseUrl = "https://api.groq.com/openai/v1/chat/completions";

  Future<String> generateMedicalReport(
      String prediction, String userDescription) async {
    String prompt = """
You are a highly skilled dermatologist assistant. 
Based on the following inputs:
- Predicted Disease: $prediction
- User Description: $userDescription

Generate a detailed and professional medical report in the following structure:

Description: ...
Risk Factors: ...
Symptoms: ...
Diagnosis: ...
Treatment: ...
Outcomes: ...
Complications: ...
Preventions: ...
References: ...

Ensure the content is concise, medically accurate, and easy to understand.
If any section is not applicable based on the input, politely mention it as "Not enough information provided."
""";

    var response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "llama-3.3-70b-versatile",
        "messages": [
          {"role": "system", "content": prompt},
          {"role": "user", "content": "Generate the report now."},
        ],
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      throw Exception('Failed to fetch report from LLM');
    }
  }
}
