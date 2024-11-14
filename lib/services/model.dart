import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class PlotAnalysisService {
  final String apiUrl;

  PlotAnalysisService(this.apiUrl);

  Future<Map<String, dynamic>> analyzePlot(String plotData) async {
    final response = await http.post(
      Uri.parse('$apiUrl/analyze'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'plotData': plotData}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to analyze plot');
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