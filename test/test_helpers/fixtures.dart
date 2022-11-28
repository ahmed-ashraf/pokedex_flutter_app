import 'dart:convert';
import 'dart:io';

dynamic getJsonFromFile(String filename) {
  var file = File('test_resources/$filename.json');
  return jsonDecode(file.readAsStringSync());
}