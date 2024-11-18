import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class PlotAnalysisService {
  final String apiUrl;

  PlotAnalysisService(this.apiUrl);

  Future<String> analyzePlot(Map<String, dynamic> plotData) async {
    // route expects: 'Rainfall', 'Temperature', 'Nitrogen', 'Phosphorus', 'Potassium', 'pH', 'Humidity', 'plot_size', 'crop', 'price', 'plot_id'
    final response = await http.post(
      Uri.parse('$apiUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'plotData': plotData}),
    );

    if (response.statusCode == 200) {
      return "Predicted yield: ${jsonDecode(response.body)['linear_prediction']}";
    } else {
      log('Failed to analyze plot: ${response.statusCode}: ${response.reasonPhrase}');
      return "Failed to analyze plot";
    }
  }

  // ping the server to check if it's alive
  Future<Map<String, dynamic>> ping() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/ping'));
      log('Response status: ${response.statusCode}');
      if (response.statusCode != 200) {
        throw Exception('Failed to ping server');
      }
      return jsonDecode(response.body);
    } catch (e) {
      log('Error: $e');
      return {'status': 'error', 'message': e.toString()};
    }
  }
}