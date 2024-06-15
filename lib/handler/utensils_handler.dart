import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/utensil.dart';

class UtensilHandler {
  static Future<List<Utensil>> loadUtensils() async {
    final String response = await rootBundle.loadString('lib/data/data.json');
    final data = await json.decode(response) as List<dynamic>;
    return data.map((json) => Utensil.fromJson(json)).toList();
  }
}
