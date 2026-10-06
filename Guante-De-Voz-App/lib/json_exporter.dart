import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'models.dart';

class JsonExporter {
  static Future<String?> exportToJson(List<TrainingGesture> gestures) async {
    try {
      final jsonData = jsonEncode({
        'version': 2,
        'exportedAt': DateTime.now().toIso8601String(),
        'gestures': gestures.map((g) => g.toJson()).toList(),
      });

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/beyond_words_signs.json');
      await file.writeAsString(jsonData);

      return file.path;
    } catch (e) {
      return null;
    }
  }

  static Future<List<TrainingGesture>?> importFromJson() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result == null || result.files.single.path == null) return null;

      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;
      final list = data['gestures'] as List;
      return list
          .map((e) =>
              TrainingGesture.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (e) {
      return null;
    }
  }
}
