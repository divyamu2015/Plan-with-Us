import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class MaterialBudgetSuggestionPage extends StatelessWidget {
  final Map<String, dynamic> prediction;

  const MaterialBudgetSuggestionPage({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
    final String plan = prediction['predicted_plan']?.toString() ?? '';
    final double budget = (prediction['total_estimated_budget'] ?? 0).toDouble();
    final Map<String, dynamic> materials = (prediction['materials'] ?? {}) as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8AA9EB),
        elevation: 1,
        title: Text(
          'Material Budget for $plan',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            tooltip: 'Download',
            onPressed: () async {
              String csv = _convertToCSV(plan, budget, materials);
              final directory = await getTemporaryDirectory();
              final file = File('${directory.path}/MaterialBudget_$plan.csv');
              await file.writeAsString(csv);
              await Share.shareXFiles([XFile(file.path)], text: "Material Budget for $plan");
            },
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFF), Color(0xFFE0C3FC), Color(0xFFC2FFD8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            Center(
              child: Text(
                "Material Budget for $plan",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Color(0xFF4A148C),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EAF6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Estimated Total Budget: ₹${budget.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xFF22223B),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Table(
              border: TableBorder.all(color: Colors.grey[300]!),
              defaultColumnWidth: const FlexColumnWidth(),
              children: [
                const TableRow(
                  children: [
                    SizedBox(
                        height: 38,
                        child: Center(child: Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))
                    ),
                    SizedBox(
                        height: 38,
                        child: Center(child: Text('Material', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))
                    ),
                    SizedBox(
                        height: 38,
                        child: Center(child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))
                    ),
                    SizedBox(
                        height: 38,
                        child: Center(child: Text('Rate (₹)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))
                    ),
                    SizedBox(
                        height: 38,
                        child: Center(child: Text('Total (₹)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))
                    ),
                  ],
                ),
                ...materials.entries.expand((cat) {
                  final category = cat.key;
                  final items = cat.value as List<dynamic>;
                  if (items.isEmpty) {
                    return <TableRow>[
                      TableRow(
                        decoration: const BoxDecoration(color: Color(0xFFF1F7FF)),
                        children: [
                          tableCell(category, bold: true, color: Color(0xFF8AA9EB)),
                          tableCell('-', color: Color(0xFFAAAAAA)),
                          tableCell('-', color: Color(0xFFAAAAAA)),
                          tableCell('-', color: Color(0xFFAAAAAA)),
                          tableCell('-', color: Color(0xFFAAAAAA)),
                        ],
                      )
                    ];
                  }
                  return items.map((item) {
                    return TableRow(
                      decoration: items.indexOf(item) % 2 == 0
                          ? const BoxDecoration(color: Color(0xFFF8F9FB))
                          : null,
                      children: [
                        tableCell(category, bold: true, color: Color(0xFF8AA9EB)),
                        tableCell(item['item'].toString()),
                        tableCell(item['quantity'].toString()),
                        tableCell(item['rate'].toString()),
                        tableCell(item['total'].toString()),
                      ],
                    );
                  });
                }),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8AA9EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for table cells
  static Widget tableCell(String text, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
          fontSize: 15,
          color: color ?? Colors.black87,
        ),
      ),
    );
  }

  // CSV Export Helper
  String _convertToCSV(String plan, double budget, Map<String, dynamic> materials) {
    String csv = 'Material Budget for $plan\nEstimated Total Budget,₹${budget.toStringAsFixed(2)}\n\n';
    csv += "Category,Material,Quantity,Rate (₹),Total (₹)\n";
    materials.forEach((cat, items) {
      for (var item in items) {
        csv += '$cat,${item['item']},${item['quantity']},${item['rate']},${item['total']}\n';
      }
    });
    return csv;
  }
}
