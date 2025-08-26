import 'dart:math';

import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';

import '../models/Expense.dart';
import '../services/expense_service.dart';

abstract class IExpenseRepository {
  Future<void> add(Expense expense);
  Future<Expense?> getById(String id);
  Future<List<Expense>> getAll();
  Future<List<Expense>> getPaged({int page, int pageSize});
  Future<void> update(Expense expense);
  Future<void> delete(String id);
  Future<void> clear();
  Future<double> totalAmount({DateTime? from, DateTime? to});
}


class ExpenseRepository extends GetxService implements IExpenseRepository {
  static const String boxName = 'expenses';
  final HiveService _hive;

  ExpenseRepository(this._hive);

  Future<ExpenseRepository> init() async {
    await _hive.openBox(boxName);
    return this;
  }

  @override
  Future<void> add(Expense expense) async {
    await _hive.put(expense.id, expense, box: boxName);
  }

  @override
  Future<Expense?> getById(String id) async {
    return _hive.get<Expense>(id, box: boxName);
  }

  @override
  Future<List<Expense>> getAll() async {
    final data = _hive.exportBox(boxName).values;
    return data.whereType<Expense>().toList();
  }

  @override
  Future<List<Expense>> getPaged({int page = 1, int pageSize = 20}) async {
    final all = await getAll();
    all.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // latest first
    final start = (page - 1) * pageSize;
    final end = min(start + pageSize, all.length);
    if (start >= all.length) return [];
    return all.sublist(start, end);
  }

  @override
  Future<void> update(Expense expense) async {
    await _hive.put(expense.id, expense, box: boxName);
  }

  @override
  Future<void> delete(String id) async {
    await _hive.delete(id, box: boxName);
  }

  @override
  Future<void> clear() async {
    await _hive.clear(box: boxName);
  }

  @override
  Future<double> totalAmount({DateTime? from, DateTime? to}) async {
    final all = await getAll();
    return all.where((e) {
      final okFrom = from == null || e.createdAt.isAfter(from) || e.createdAt.isAtSameMomentAs(from);
      final okTo   = to == null   || e.createdAt.isBefore(to) || e.createdAt.isAtSameMomentAs(to);
      return okFrom && okTo;
    }).fold<double>(0.0, (sum, e) => sum + e.amount);
  }
}