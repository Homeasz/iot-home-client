// // lib/services/api_service.dart
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../models/data_model.dart';
// import '../utils/constants.dart';

// class ApiService {
//   Future<List<DataModel>> fetchData() async {
//     final response = await http.get(Uri.parse('$BASE_URL/data'));

//     if (response.statusCode == 200) {
//       List jsonResponse = jsonDecode(response.body);
//       return jsonResponse.map((data) => DataModel.fromJson(data)).toList();
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   Future<void> setData(DataModel data) async {
//     final response = await http.post(
//       Uri.parse('$BASE_URL/data'),
//       body: jsonEncode(data.toJson()),
//       headers: {'Content-Type': 'application/json'},
//     );

//     if (response.statusCode != 201) {
//       throw Exception('Failed to set data');
//     }
//   }
// }
