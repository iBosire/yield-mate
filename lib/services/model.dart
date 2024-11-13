import 'dart:convert';
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
}