import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../data/app_data.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ApiException(this.message, {this.statusCode, this.errors});

  @override
  String toString() => message;
}

class ApiService {
  static const String baseUrl = 'http://192.168.15.52/api-test/public';

  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, dynamic> _decodeResponse(http.Response response) {
    Map<String, dynamic> body = {};
    if (response.body.isNotEmpty) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        body = decoded;
      }
    }

    final bool ok =
        response.statusCode >= 200 &&
        response.statusCode < 300 &&
        (body['success'] ?? true) == true;

    if (!ok) {
      throw ApiException(
        body['message']?.toString() ??
            'Erreur serveur (${response.statusCode})',
        statusCode: response.statusCode,
        errors: body['errors'] is Map<String, dynamic> ? body['errors'] : null,
      );
    }

    return body;
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/accounts/login'),
      headers: _jsonHeaders,
      body: jsonEncode({'email': email.trim(), 'password': password}),
    );
    final decoded = _decodeResponse(response);
    final data = decoded['data'];
    return data is Map<String, dynamic> ? data : decoded;
  }

  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/accounts/register'),
      headers: _jsonHeaders,
      body: jsonEncode({'email': email.trim(), 'password': password}),
    );
    final decoded = _decodeResponse(response);
    final data = decoded['data'];
    return data is Map<String, dynamic> ? data : decoded;
  }

  static Future<List<ApiFamilyMember>> getFamilyMembers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/famille-membres'),
      headers: {'Accept': 'application/json'},
    );
    final decoded = _decodeResponse(response);
    final rawData = decoded['data'];

    List<dynamic> rawItems = [];
    if (rawData is List) {
      rawItems = rawData;
    } else if (rawData is Map<String, dynamic> && rawData['items'] is List) {
      rawItems = rawData['items'];
    }

    final List<ApiFamilyMember> members = [];
    for (final item in rawItems) {
      if (item is Map<String, dynamic>) {
        members.add(ApiFamilyMember.fromJson(item));
      }
    }
    return members;
  }

  static Future<ApiFamilyMember> createFamilyMember({
    required String nom,
    required String postnom,
    required String prenom,
    required String lieuNaissance,
    required String dateNaissance,
    required String parente,
    XFile? imageFile,
  }) async {
    final fields = {
      'nom': nom.trim(),
      'postnom': postnom.trim(),
      'prenom': prenom.trim(),
      'lieu_naissance': lieuNaissance.trim(),
      'date_naissance': dateNaissance.trim(),
      'parente': parente.trim(),
    };

    if (imageFile == null) {
      final response = await http.post(
        Uri.parse('$baseUrl/famille-membres'),
        headers: _jsonHeaders,
        body: jsonEncode(fields),
      );
      final decoded = _decodeResponse(response);
      return ApiFamilyMember.fromJson(decoded['data'] as Map<String, dynamic>);
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/famille-membres'),
    );
    request.fields.addAll(fields);
    final bytes = await imageFile.readAsBytes();
    final filename = imageFile.name.isNotEmpty ? imageFile.name : 'photo.jpg';
    request.files.add(
      http.MultipartFile.fromBytes('image', bytes, filename: filename),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    final decoded = _decodeResponse(response);
    return ApiFamilyMember.fromJson(decoded['data'] as Map<String, dynamic>);
  }

  static Future<ApiFamilyMember> updateFamilyMember({
    required int id,
    required String nom,
    required String postnom,
    required String prenom,
    required String lieuNaissance,
    required String dateNaissance,
    required String parente,
    XFile? newImageFile,
  }) async {
    final fields = {
      'nom': nom.trim(),
      'postnom': postnom.trim(),
      'prenom': prenom.trim(),
      'lieu_naissance': lieuNaissance.trim(),
      'date_naissance': dateNaissance.trim(),
      'parente': parente.trim(),
    };

    if (newImageFile == null) {
      final response = await http.put(
        Uri.parse('$baseUrl/famille-membres/$id'),
        headers: _jsonHeaders,
        body: jsonEncode(fields),
      );
      final decoded = _decodeResponse(response);
      return ApiFamilyMember.fromJson(decoded['data'] as Map<String, dynamic>);
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/famille-membres/$id'),
    );
    request.fields.addAll(fields);
    final bytes = await newImageFile.readAsBytes();
    final filename = newImageFile.name.isNotEmpty
        ? newImageFile.name
        : 'photo.jpg';
    request.files.add(
      http.MultipartFile.fromBytes('image', bytes, filename: filename),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    final decoded = _decodeResponse(response);
    return ApiFamilyMember.fromJson(decoded['data'] as Map<String, dynamic>);
  }

  static Future<void> deleteFamilyMember(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/famille-membres/$id'),
      headers: {'Accept': 'application/json'},
    );
    _decodeResponse(response);
  }
}
