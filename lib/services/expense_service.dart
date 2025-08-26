import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:goldapi/models/Expense.dart';
import 'package:goldapi/utils/constant.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart';

class HiveService extends GetxService{
  final Map<String,Box>_boxes = {};

  Future<HiveService>init({List<int>?encryptionKey}) async{
       await Hive.initFlutter();

       Hive.registerAdapter(ExpenseAdapter());

       _boxes['app'] = await Hive.openBox(
         'app',
         encryptionCipher: encryptionKey !=null ? HiveAesCipher(encryptionKey) : null
       );

       _boxes['expenses'] = await Hive.openBox<Expense>('expenses');
       return this;
  }

  Box _getBox(String boxName){
    if(!_boxes.containsKey(boxName)){
      throw   Exception("Box '$boxName' not initialized. Call openBox first.");
    }
    return _boxes[boxName]!;
  }

  Future<void>openBox(String name, {bool lazy= false})async{
    if(!_boxes.containsKey(name)){
      _boxes[name]=
           await Hive.openBox(name);

    }
  }

  T? get<T>(String key, {String box= 'app', T? defaultValue}){
    final value= _getBox(box).get(key,defaultValue: defaultValue);
    return value is T ? value : defaultValue;
  }

  Future<void>put(
      String key,
      dynamic value, {
        String box = 'app',
        CanelToken? cancelTask,
        void Function(double progress)? onProgress,
      }
      ) async{
    final b = _getBox(box);

    if (value is List || value is Map) {
      final entries = value is List ? value : (value as Map).entries.toList();
      final total = entries.length;
      for (int i = 0; i < total; i++) {
        if (cancelTask?.isCancelled ?? false) throw Exception("Cancelled");
        final entry = value is List ? entries[i] : entries[i];
        await b.put("${key}_$i", entry);
        onProgress?.call((i + 1) / total);
        await Future.delayed(Duration.zero);
      }
    } else {
      await b.put(key, value);
      onProgress?.call(1.0);
    }
  }

  Future<void> delete(String key, {String box = 'app'}) async {
    await _getBox(box).delete(key);
  }

  Future<void> clear({
    String box = 'app',
    CanelToken? cancelTask,
    void Function(double)? onProgress,
  }) async {
    final b = _getBox(box);
    final keys = b.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      if (cancelTask?.isCancelled ?? false) throw Exception("Cancelled");
      await b.delete(keys[i]);
      onProgress?.call((i + 1) / keys.length);
      await Future.delayed(Duration.zero);
    }
  }
  bool contains(String key, {String box = 'app'}) => _getBox(box).containsKey(key);

  Stream<BoxEvent> watch(String key, {String box = 'app'}) {
    return _getBox(box).watch(key: key);
  }

  Map<String, dynamic> exportBox(String box) {
    final b = _getBox(box);
    return Map<String, dynamic>.from(b.toMap());
  }
  Future<void> importBox(String box, Map<String, dynamic> data) async {
    final b = _getBox(box);
    await b.putAll(data);
  }
  Future<void> dispose() async {
    for (final box in _boxes.values) {
      await box.close();
    }
    _boxes.clear();
  }
}