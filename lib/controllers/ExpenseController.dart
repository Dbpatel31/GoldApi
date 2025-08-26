// lib/features/expense/expense_controller.dart
import 'package:get/get.dart';

import '../models/Expense.dart';
import '../repository/ExpenseRepositiory.dart';
class ExpenseController extends GetxController {
  final ExpenseRepository _repo = Get.find();
  final expenses = <Expense>[].obs;
  final isLoading = false.obs;

  Future<void> loadAll() async {
    isLoading.value = true;
    expenses.value = (await _repo.getAll()).cast<Expense>();
    isLoading.value = false;
  }

  Future<void> addExpense(Expense e) async {
    await _repo.add(e as Expense);
    await loadAll();
  }

  Future<void> removeExpense(String id) async {
    await _repo.delete(id);
    await loadAll();
  }

  Future<double> monthlyTotal() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    return _repo.totalAmount(from: start, to: end);
  }
}

