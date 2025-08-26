import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/ExpenseController.dart';
import '../models/Expense.dart';
import '../utils/responsive.dart';


class ExpenseScreen extends StatelessWidget {
  final ExpenseController controller = Get.find<ExpenseController>();

  ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Expenses",
          style: TextStyle(
            fontSize: Responsive.textSize(context, 18, 22, 26),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        controller.isLoading.value?null:
           const Center(child: CircularProgressIndicator());


        // if (controller.expenses.isEmpty) {
        //   return const Center(child: Text("No expenses yet"));
        // }

        int crossAxisCount = Responsive.isMobile(context)
            ? 1
            : Responsive.isTablet(context)
            ? 2
            : 4;

        return Padding(
          padding: Responsive.pagePadding(context),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3,
            ),
            itemCount: controller.expenses.length,
            itemBuilder: (context, index) {
              final e = controller.expenses[index];
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.title,
                              style: TextStyle(
                                fontSize: Responsive.textSize(context, 14, 16, 18),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "\$${e.amount.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: Responsive.textSize(context, 12, 14, 16),
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _openAddEditDialog(context, e),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(context, e),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddEditDialog(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openAddEditDialog(BuildContext context, Expense? expense) {
    final titleController = TextEditingController(text: expense?.title ?? '');
    final amountController = TextEditingController(
        text: expense != null ? expense.amount.toString() : '');
    final descriptionController = TextEditingController(text: expense?.description ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(expense == null ? "Add Expense" : "Edit Expense"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: "Amount"),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final amount = double.tryParse(amountController.text) ?? 0;
              final description = descriptionController.text.trim();

              if (title.isNotEmpty && amount > 0) {
                final newExpense = Expense(
                  id: expense?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  title: title,
                  amount: amount,
                  description: description,
                  createdAt: expense?.createdAt ?? DateTime.now(),
                  updatedAt: DateTime.now(),
                );

                if (expense == null) {
                  controller.addExpense(newExpense);
                } else {
                  controller.removeExpense(expense.id);
                  controller.addExpense(newExpense);
                }

                Get.back();
              }
            },
            child: Text(expense == null ? "Add" : "Save"),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Expense e) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Expense"),
        content: Text("Are you sure you want to delete '${e.title}'?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              controller.removeExpense(e.id);
              Get.back();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
